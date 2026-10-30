import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

/// Ajusta a janela de teste para [width] × [height].
void _view(WidgetTester tester, [double width = 800, double height = 600]) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
}

/// Monta [child] sob [theme] e [direction], sem `RebicApp`.
Widget _host(
  Widget child, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(textDirection: direction, child: child),
);

/// Contêineres `base` da página: a área de título e, se houver, o rodapé.
Finder get _base => find.byWidgetPredicate(
  (w) => w is RebicContainer && w.surface == RebicSurface.base,
);

Finder get _back => find.descendant(
  of: find.byType(RebicPage),
  matching: find.byType(RebicInteractable),
);

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

Widget _box(String key) => SizedBox(key: Key(key), width: 20, height: 20);

BoxDecoration _decoration(WidgetTester tester, Finder of) =>
    tester
            .widget<DecoratedBox>(
              find
                  .descendant(of: of, matching: find.byType(DecoratedBox))
                  .first,
            )
            .decoration
        as BoxDecoration;

final _light = RebicThemeData.light();
final _line = const BorderSide().width;

/// Margem de página de [theme] para uma página de largura [width].
double _margin(RebicThemeData theme, [double width = 800]) =>
    theme.spacing.pageMarginFor(theme.breakpoints.classify(width));

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Página mínima', (tester) async {
      _view(tester);
      await tester.pumpWidget(
        _host(
          const RebicPage(
            title: 'Pedidos',
            body: SizedBox(key: Key('body'), height: 100),
          ),
        ),
      );
      final titleArea = tester.getRect(_base);
      expect(tester.getRect(find.text('Pedidos')).top, greaterThan(0));
      expect(titleArea.top, 0);
      expect(_rect(tester, 'body').top, greaterThan(titleArea.bottom));
      expect(_back, findsNothing);
      expect(_base, findsOneWidget);
    });

    testWidgets('[API] Propriedades — Página completa', (tester) async {
      _view(tester);
      await tester.pumpWidget(
        _host(
          RebicPage(
            title: 'Pedido 4711',
            subtitle: 'Aguardando aprovação',
            onBack: () {},
            actions: [_box('a1'), _box('a2')],
            footerActions: [_box('f1'), _box('f2')],
            body: const SizedBox.shrink(),
          ),
        ),
      );
      final back = tester.getRect(_back);
      final title = tester.getRect(find.text('Pedido 4711'));
      final subtitle = tester.getRect(find.text('Aguardando aprovação'));
      expect(back.right, lessThanOrEqualTo(title.left));
      expect(subtitle.top, greaterThanOrEqualTo(title.bottom));
      expect(subtitle.left, title.left);
      expect(title.right, lessThanOrEqualTo(_rect(tester, 'a1').left));
      expect(_rect(tester, 'a1').right, lessThan(_rect(tester, 'a2').left));
      final m = _margin(_light);
      expect(_rect(tester, 'a2').right, closeTo(800 - m, 0.01));
      final footer = tester.getRect(_base.last);
      expect(_rect(tester, 'f1').top, greaterThan(footer.top));
      expect(_rect(tester, 'f1').right, lessThan(_rect(tester, 'f2').left));
      expect(_rect(tester, 'f2').right, closeTo(800 - m, 0.01));
    });
  });

  testWidgets('[API] Rodapé condicional — Página sem rodapé', (tester) async {
    _view(tester);
    await tester.pumpWidget(
      _host(
        const RebicPage(
          title: 'Pedidos',
          padded: false,
          scrollable: false,
          body: SizedBox.expand(key: Key('body')),
        ),
      ),
    );
    expect(_base, findsOneWidget);
    expect(_rect(tester, 'body').bottom, 600);
  });

  testWidgets('[API] Callbacks e controlador — Voltar', (tester) async {
    _view(tester);
    var calls = 0;
    await tester.pumpWidget(
      _host(
        RebicPage(
          title: 'Pedidos',
          onBack: () => calls++,
          body: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.tap(_back);
    await tester.pump();
    expect(calls, 1);
  });

  group('[Comportamento] Rolagem do conteúdo', () {
    testWidgets('[Comportamento] Rolagem do conteúdo — Conteúdo longo rola', (
      tester,
    ) async {
      _view(tester, 800, 800);
      await tester.pumpWidget(
        _host(
          RebicPage(
            title: 'Pedidos',
            footerActions: [_box('f1')],
            body: const SizedBox(key: Key('body'), height: 3000),
          ),
        ),
      );
      final title = tester.getRect(_base.first);
      final footer = tester.getRect(_base.last);
      final top = _rect(tester, 'body').top;
      // Passa a tolerância de arraste, arrasta 500 e solta parado, sem
      // lançamento.
      final gesture = await tester.startGesture(const Offset(400, 400));
      await gesture.moveBy(const Offset(0, -kDragSlopDefault));
      await gesture.moveBy(const Offset(0, -500));
      await tester.pump(const Duration(seconds: 1));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(top - _rect(tester, 'body').top, closeTo(500, kDragSlopDefault));
      expect(tester.getRect(_base.first), title);
      expect(tester.getRect(_base.last), footer);
    });

    testWidgets(
      '[Comportamento] Rolagem do conteúdo — Conteúdo com rolagem própria',
      (tester) async {
        _view(tester);
        double? maxHeight;
        await tester.pumpWidget(
          _host(
            RebicPage(
              title: 'Pedidos',
              scrollable: false,
              footerActions: [_box('f1')],
              body: LayoutBuilder(
                builder: (context, constraints) {
                  maxHeight = constraints.maxHeight;
                  return const SizedBox.expand(key: Key('body'));
                },
              ),
            ),
          ),
        );
        final title = tester.getRect(_base.first);
        final footer = tester.getRect(_base.last);
        final m = _margin(_light);
        expect(maxHeight!.isFinite, isTrue);
        expect(
          maxHeight,
          closeTo(footer.top - title.bottom - 2 * _line - 2 * m, 0.01),
        );
        expect(_rect(tester, 'body').height, closeTo(maxHeight!, 0.01));
      },
    );
  });

  testWidgets('[Comportamento] Margem do conteúdo — Conteúdo sem margem', (
    tester,
  ) async {
    _view(tester);
    await tester.pumpWidget(
      _host(
        const RebicPage(
          title: 'Pedidos',
          padded: false,
          body: SizedBox(key: Key('body'), height: 50),
        ),
      ),
    );
    final body = _rect(tester, 'body');
    expect(body.left, 0);
    expect(body.top, closeTo(tester.getRect(_base).bottom + _line, 0.01));
  });

  testWidgets(
    '[Comportamento] Margem do conteúdo — Margem pela largura da página',
    (tester) async {
      for (final (width, expected) in [
        (400.0, 16.0),
        (800.0, 32.0),
        (1200.0, 32.0),
        (1600.0, 48.0),
      ]) {
        _view(tester, width);
        await tester.pumpWidget(
          _host(
            const RebicPage(
              title: 'Pedidos',
              body: SizedBox(key: Key('body'), height: 50),
            ),
          ),
        );
        expect(
          _rect(tester, 'body').left,
          closeTo(expected, 0.01),
          reason: '$width',
        );
        expect(_margin(_light, width), expected, reason: '$width');
      }
    },
  );

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Cores da página', (
      tester,
    ) async {
      _view(tester);
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        await tester.pumpWidget(
          _host(
            theme: theme,
            RebicPage(
              key: ValueKey(theme.brightness),
              title: 'Pedidos',
              footerActions: [_box('f1')],
              body: const SizedBox(key: Key('body'), height: 50),
            ),
          ),
        );
        expect(_decoration(tester, _base.first).color, theme.colors.base);
        expect(_decoration(tester, _base.last).color, theme.colors.base);
        expect(
          find.ancestor(
            of: find.byKey(const Key('body')),
            matching: find.byType(RebicContainer),
          ),
          findsNothing,
        );
      }
    });

    testWidgets(
      '[Aparência] Tokens de componente — Margem da densidade compacta',
      (tester) async {
        _view(tester);
        final compact = RebicThemeData.light(density: RebicDensity.compact);
        await tester.pumpWidget(
          _host(
            theme: compact,
            const RebicPage(
              title: 'Pedidos',
              body: SizedBox(key: Key('body'), height: 50),
            ),
          ),
        );
        final m = _margin(compact);
        final body = _rect(tester, 'body');
        expect(body.left, closeTo(m, 0.01));
        expect(
          body.top,
          closeTo(tester.getRect(_base).bottom + _line + m, 0.01),
        );
      },
    );
  });

  testWidgets('[Estados] Botão de voltar — Botão de voltar em hover', (
    tester,
  ) async {
    _view(tester);
    await tester.pumpWidget(
      _host(
        RebicPage(
          title: 'Pedidos',
          onBack: () {},
          body: const SizedBox.shrink(),
        ),
      ),
    );
    final transparent = RebicControlColors.of(
      RebicControlFamily.transparent,
      _light.colors,
    );
    expect(_decoration(tester, _back).color, transparent.normal.background);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(_back));
    await tester.pump();
    expect(_decoration(tester, _back).color, transparent.hover.background);
  });

  group('[Acessibilidade] Teclado e foco', () {
    testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na página', (
      tester,
    ) async {
      _view(tester);
      final action = FocusNode();
      final item = FocusNode();
      final footer = FocusNode();
      addTearDown(() {
        action.dispose();
        item.dispose();
        footer.dispose();
      });
      Widget focusable(FocusNode node) =>
          Focus(focusNode: node, child: const SizedBox(width: 20, height: 20));
      await tester.pumpWidget(
        RebicApp(
          home: RebicPage(
            title: 'Pedidos',
            onBack: () {},
            actions: [focusable(action)],
            footerActions: [focusable(footer)],
            body: Align(alignment: Alignment.topLeft, child: focusable(item)),
          ),
        ),
      );
      final visited = <String>[];
      for (var i = 0; i < 4; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final focus = FocusManager.instance.primaryFocus;
        visited.add(switch (focus) {
          _ when focus == action => 'ação',
          _ when focus == item => 'conteúdo',
          _ when focus == footer => 'rodapé',
          _
              when focus?.context
                      ?.findAncestorWidgetOfExactType<RebicInteractable>() !=
                  null =>
            'voltar',
          _ => '?',
        });
      }
      expect(visited, ['voltar', 'ação', 'conteúdo', 'rodapé']);
    });

    testWidgets('[Acessibilidade] Teclado e foco — Foco revela o conteúdo', (
      tester,
    ) async {
      _view(tester);
      final item = FocusNode();
      addTearDown(item.dispose);
      await tester.pumpWidget(
        RebicApp(
          home: RebicPage(
            title: 'Pedidos',
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2000),
                Focus(
                  focusNode: item,
                  child: const SizedBox(
                    key: Key('item'),
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(item.hasPrimaryFocus, isTrue);
      final rect = _rect(tester, 'item');
      expect(rect.top, greaterThanOrEqualTo(tester.getRect(_base).bottom));
      expect(rect.bottom, lessThanOrEqualTo(600));
    });
  });

  testWidgets('[Responsividade] Largura e direção — Página em RTL', (
    tester,
  ) async {
    _view(tester);
    await tester.pumpWidget(
      _host(
        direction: TextDirection.rtl,
        RebicPage(
          title: 'Pedidos',
          onBack: () {},
          actions: [_box('action')],
          footerActions: [_box('f1')],
          body: const SizedBox.shrink(),
        ),
      ),
    );
    final m = _margin(_light);
    expect(tester.getRect(_back).right, closeTo(800 - m, 0.01));
    expect(_rect(tester, 'action').left, closeTo(m, 0.01));
    expect(_rect(tester, 'f1').left, closeTo(m, 0.01));
    expect(RebicIcons.navBack.matchTextDirection, isTrue);
  });

  testWidgets(
    '[Integração] Dependências de widgets e hospedeiro — Página na página de ferramentas',
    (tester) async {
      _view(tester, 1200, 800);
      await tester.pumpWidget(
        RebicApp(
          home: RebicToolPage(
            header: const RebicShellBar(title: 'Compras'),
            mainContents: [
              RebicPage(
                title: 'Pedidos',
                footerActions: [_box('f1')],
                body: const RebicText('Pedidos em aberto'),
              ),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final bar = tester.getRect(
        find.byWidgetPredicate(
          (w) => w is RebicContainer && w.surface == RebicSurface.shell,
        ),
      );
      expect(tester.getRect(_base.first).top, closeTo(bar.bottom, 0.01));
      expect(tester.getRect(_base.last).bottom, 800);
    },
  );

  testWidgets(
    '[Integração] Dependências de núcleo e fundamentos — Página pelo tema da subárvore',
    (tester) async {
      _view(tester);
      final dark = RebicThemeData.dark();
      await tester.pumpWidget(
        RebicApp(
          home: RebicTheme(
            data: dark,
            child: const RebicPage(title: 'Pedidos', body: SizedBox.shrink()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_decoration(tester, _base).color, dark.colors.base);
    },
  );

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade da página', () {
      final names = scenarioNames('rebic/widgets/rebic-page', 'add-rebic-page');
      expect(names, hasLength(22));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens da página', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_page_$name',
          theme: theme,
          size: const Size(800, 600),
          surface: RebicSurface.background,
          child: RebicPage(
            title: 'Pedido 4711',
            subtitle: 'Aguardando aprovação',
            onBack: () {},
            actions: const [
              RebicIcon(RebicIcons.edit, tone: RebicIconTone.brand),
              RebicIcon(RebicIcons.overflow, tone: RebicIconTone.brand),
            ],
            footerActions: const [RebicLabel('Cancelar'), RebicText('Salvar')],
            body: const RebicColumn(
              children: [
                RebicTitle('Itens', titleStyle: RebicTitleLevel.h3),
                RebicText('3 itens, total de R\$ 1.250,00.'),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Página sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/page/rebic_page.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) \w+;$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final field in fields) {
      expect(field, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
