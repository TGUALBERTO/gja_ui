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

/// Monta [child] numa área de [width], sob [direction] e escala de texto, sem
/// `RebicApp`.
Widget _host(
  Widget child, {
  double width = 360,
  TextDirection direction = TextDirection.ltr,
  double textScale = 1,
  RebicThemeData? theme,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

Widget _box(String key) => SizedBox(key: Key(key), width: 24, height: 24);

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

/// Fundo pintado no cabeçalho acionável, ou nulo quando transparente.
Color? _headerBackground(WidgetTester tester) {
  final boxes = find.descendant(
    of: find.byType(RebicInteractable),
    matching: find.byType(ColoredBox),
  );
  return boxes.evaluate().isEmpty
      ? null
      : tester.widget<ColoredBox>(boxes.first).color;
}

final _light = RebicThemeData.light();

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Cartão com cabeçalho', (tester) async {
      await tester.pumpWidget(
        _host(
          RebicCard(
            leading: _box('leading'),
            title: 'Pedidos pendentes',
            subtitle: 'Compras',
            status: '3 de 5',
            child: _box('content'),
          ),
        ),
      );
      final leading = _rect(tester, 'leading');
      final title = tester.getRect(find.text('Pedidos pendentes'));
      final subtitle = tester.getRect(find.text('Compras'));
      final status = tester.getRect(find.text('3 de 5'));
      final divider = tester.getRect(find.byType(RebicDivider));
      expect(leading.right, lessThanOrEqualTo(title.left));
      expect(subtitle.top, greaterThanOrEqualTo(title.bottom));
      expect(title.right, lessThanOrEqualTo(status.left));
      expect(
        _rect(tester, 'content').top,
        greaterThanOrEqualTo(divider.bottom),
      );
    });

    testWidgets('[API] Propriedades — Cartão sem cabeçalho', (tester) async {
      await tester.pumpWidget(_host(RebicCard(child: _box('content'))));
      expect(find.byType(RebicDivider), findsNothing);
      final card = tester.getRect(find.byType(RebicCard));
      expect(
        _rect(tester, 'content').top - card.top,
        closeTo(_light.spacing.l, 0.01),
      );
    });
  });

  test('[API] Cabeçalho válido — Subtítulo sem título', () {
    for (final subtitle in ['Compras']) {
      expect(
        () => RebicCard(subtitle: subtitle, child: const SizedBox()),
        throwsAssertionError,
      );
    }
  });

  testWidgets('[API] Callbacks e controlador — Cabeçalho acionável', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _host(
        RebicCard(
          title: 'Pedidos',
          onHeaderPressed: () => calls++,
          child: const SizedBox(key: Key('content'), height: 80),
        ),
      ),
    );
    await tester.tap(find.text('Pedidos'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('content')), warnIfMissed: false);
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets(
    '[Comportamento] Largura e texto — Cartão na largura disponível',
    (tester) async {
      const long =
          'Pedidos pendentes de aprovação do gestor do centro de custo da '
          'unidade de compras corporativas';
      await tester.pumpWidget(
        _host(
          width: 300,
          RebicCard(title: long, status: '3 de 5', child: _box('content')),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(RebicCard)).width, 300);
      expect(
        tester.widget<RebicText>(find.widgetWithText(RebicText, long)).maxLines,
        2,
      );
    },
  );

  group('[Aparência] Superfície e cabeçalho', () {
    testWidgets('[Aparência] Superfície e cabeçalho — Superfície do cartão', (
      tester,
    ) async {
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        await tester.pumpWidget(
          _host(
            theme: theme,
            RebicCard(
              key: ValueKey(theme.brightness),
              title: 'Pedidos',
              child: _box('content'),
            ),
          ),
        );
        final container = tester.widget<RebicContainer>(
          find
              .descendant(
                of: find.byType(RebicCard),
                matching: find.byType(RebicContainer),
              )
              .first,
        );
        expect(container.surface, RebicSurface.base);
        expect(container.border, isTrue);
        expect(container.radius, RebicRadius.tile);
        expect(container.shadow, RebicShadow.card);
        final decoration =
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: find.byType(RebicCard),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration;
        expect(decoration.color, theme.colors.base);
        expect(decoration.border!.top.color, theme.colors.separator);
        expect(decoration.boxShadow, hasLength(theme.shadows.card.length));
      }
    });

    testWidgets('[Aparência] Superfície e cabeçalho — Conteúdo sem margem', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RebicCard(
            title: 'Pedidos',
            padded: false,
            child: const SizedBox(key: Key('content'), height: 40),
          ),
        ),
      );
      final card = tester.getRect(find.byType(RebicCard));
      final content = _rect(tester, 'content');
      final divider = tester.getRect(find.byType(RebicDivider));
      // A borda fina do contêiner é a única distância às laterais.
      final line = const BorderSide().width;
      expect(content.left, closeTo(card.left + line, line + 0.01));
      expect(content.right, closeTo(card.right - line, line + 0.01));
      expect(content.top, closeTo(divider.bottom, 0.01));
    });
  });

  group('[Estados] Interação do cabeçalho', () {
    testWidgets('[Estados] Interação do cabeçalho — Cabeçalho em hover', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RebicCard(
            title: 'Pedidos',
            onHeaderPressed: () {},
            child: _box('content'),
          ),
        ),
      );
      expect(_headerBackground(tester), isNull);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text('Pedidos')));
      await tester.pump();
      expect(_headerBackground(tester), _light.colors.hoverBackground);
      await mouse.moveTo(const Offset(5, 900));
      await tester.pump();
      expect(_headerBackground(tester), isNull);
    });

    testWidgets(
      '[Estados] Interação do cabeçalho — Cartão sem ação não recebe foco',
      (tester) async {
        final first = FocusNode();
        final second = FocusNode();
        addTearDown(() {
          first.dispose();
          second.dispose();
        });
        await tester.pumpWidget(
          RebicApp(
            home: Column(
              children: [
                Focus(focusNode: first, child: const SizedBox(height: 20)),
                const RebicCard(title: 'Pedidos', child: SizedBox(height: 20)),
                Focus(focusNode: second, child: const SizedBox(height: 20)),
              ],
            ),
          ),
        );
        first.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(second.hasPrimaryFocus, isTrue);
      },
    );
  });

  testWidgets('[Acessibilidade] Teclado — Cabeçalho pelo teclado', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 360,
            child: RebicCard(
              title: 'Pedidos',
              onHeaderPressed: () => calls++,
              child: const SizedBox(height: 40),
            ),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do cartão', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        RebicCard(
          title: 'Pedidos',
          subtitle: 'Compras',
          onHeaderPressed: () {},
          child: const RebicText('3 pedidos aguardando aprovação'),
        ),
      ),
    );
    expect(
      tester.getSemantics(
        find.descendant(
          of: find.byType(RebicCard),
          matching: find.byType(RebicInteractable),
        ),
      ),
      containsSemantics(
        label: 'Pedidos, Compras',
        isButton: true,
        hasTapAction: true,
      ),
    );
    expect(
      find.bySemanticsLabel('3 pedidos aguardando aprovação'),
      findsOneWidget,
    );
    handle.dispose();
  });

  group('[Responsividade] Direção e escala', () {
    testWidgets('[Responsividade] Direção e escala — Cartão em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          direction: TextDirection.rtl,
          RebicCard(
            leading: _box('leading'),
            title: 'Pedidos',
            status: '3 de 5',
            child: _box('content'),
          ),
        ),
      );
      final card = tester.getRect(find.byType(RebicCard));
      final m = _light.spacing.l;
      expect(_rect(tester, 'leading').right, closeTo(card.right - m, 1.01));
      expect(
        tester.getRect(find.text('3 de 5')).left,
        closeTo(card.left + m, 1.01),
      );
    });

    testWidgets(
      '[Responsividade] Direção e escala — Cartão com escala de texto 2,0',
      (tester) async {
        await tester.pumpWidget(
          _host(
            width: 300,
            textScale: 2,
            RebicCard(
              leading: _box('leading'),
              title: 'Pedidos pendentes',
              subtitle: 'Compras',
              status: '3 de 5',
              child: const RebicText('3 pedidos aguardando aprovação'),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  testWidgets('[Integração] Dependências — Cartões numa grade sem Material', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      RebicApp(
        home: RebicGrid(
          children: [
            RebicCard(
              title: 'Pedidos',
              onHeaderPressed: () => calls++,
              child: const RebicText('3 pedidos'),
            ),
            const RebicCard(title: 'Notas', child: RebicText('2 notas')),
            const RebicCard(child: RebicText('Sem cabeçalho')),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Pedidos'));
    await tester.pump();
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do cartão', () {
      final names = scenarioNames('rebic/widgets/rebic-card', 'add-rebic-card');
      expect(names, hasLength(19));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do cartão', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_card_$name',
          theme: theme,
          size: const Size(720, 360),
          surface: RebicSurface.background,
          child: SizedBox(
            width: 672,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                const Expanded(
                  child: RebicCard(
                    leading: RebicAvatar(
                      initials: 'MB',
                      size: RebicAvatarSize.xs,
                    ),
                    title: 'Pedidos pendentes',
                    subtitle: 'Compras',
                    status: '3 de 5',
                    child: RebicText('3 pedidos aguardando aprovação.'),
                  ),
                ),
                const Expanded(
                  child: RebicCard(
                    child: RebicText('Cartão sem cabeçalho, só conteúdo.'),
                  ),
                ),
                Expanded(
                  child: RebicCard(
                    title: 'Últimas notas',
                    padded: false,
                    child: RebicColumn(
                      gap: RebicSpace.none,
                      children: [
                        for (final (i, nota) in [
                          'NF 1021',
                          'NF 1022',
                          'NF 1023',
                        ].indexed) ...[
                          if (i > 0) const RebicDivider(),
                          RebicSpacing.padding(
                            all: RebicSpace.m,
                            child: RebicText(nota),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Cartão sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/card/rebic_card.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(
        type.replaceAll('?', ''),
        isNot(isIn(['double', 'Color', 'EdgeInsets'])),
      );
    }
  });
}
