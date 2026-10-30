import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/golden.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

const _leftKey = Key('left');
const _middleKey = Key('middle');
const _rightKey = Key('right');

/// Monta [child] no topo de uma área de largura [width], sob [theme].
Widget _host(
  Widget child, {
  double width = 800,
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicTheme(
  data: theme ?? _light,
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Widget _box(Key key, double width) =>
    SizedBox(key: key, width: width, height: 20);

BoxDecoration _decoration(WidgetTester tester, [Finder? bar]) =>
    tester
            .widget<DecoratedBox>(
              find
                  .descendant(
                    of: bar ?? find.byType(RebicBar),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .decoration
        as BoxDecoration;

void main() {
  setUpAll(loadRebicFonts);

  testWidgets('[API] Propriedades — Barra com as três áreas', (tester) async {
    await tester.pumpWidget(
      _host(
        RebicBar(
          contentLeft: [_box(_leftKey, 40)],
          contentMiddle: [_box(_middleKey, 100)],
          contentRight: [_box(_rightKey, 40)],
        ),
      ),
    );
    final edge = _light.spacing.s;
    final left = tester.getRect(find.byKey(_leftKey));
    final middle = tester.getRect(find.byKey(_middleKey));
    final right = tester.getRect(find.byKey(_rightKey));
    expect(left.left, edge);
    expect(right.right, 800 - edge);
    expect(middle.left, greaterThan(left.right));
    expect(middle.right, lessThan(right.left));
  });

  test('[API] Desenhos e alinhamentos — Valores dos enums da barra', () {
    expect(RebicBarDesign.values.map((d) => d.name), [
      'auto',
      'header',
      'subHeader',
      'footer',
      'floatingFooter',
    ]);
    expect(RebicTitleAlignment.values.map((a) => a.name), [
      'none',
      'start',
      'center',
      'auto',
    ]);
  });

  testWidgets('[API] Callbacks e controlador — Barra sem ação própria', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const RebicBar(contentMiddle: [RebicText('Pedidos')])),
    );
    await tester.tap(find.byType(RebicBar));
    await tester.pump();
    expect(
      tester
          .getSemantics(find.text('Pedidos'))
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      isFalse,
    );
    handle.dispose();
  });

  group('[Comportamento] Alinhamento do conteúdo central', () {
    testWidgets(
      '[Comportamento] Alinhamento do conteúdo central — Conteúdo central centrado',
      (tester) async {
        await tester.pumpWidget(
          _host(
            RebicBar(
              contentLeft: [_box(_leftKey, 40)],
              contentMiddle: [_box(_middleKey, 200)],
            ),
          ),
        );
        expect(tester.getCenter(find.byKey(_middleKey)).dx, 400);
      },
    );

    testWidgets(
      '[Comportamento] Alinhamento do conteúdo central — Conteúdo central no início',
      (tester) async {
        await tester.pumpWidget(
          _host(
            RebicBar(
              titleAlignment: RebicTitleAlignment.start,
              contentLeft: [_box(_leftKey, 40)],
              contentMiddle: [_box(_middleKey, 200)],
            ),
          ),
        );
        expect(
          tester.getRect(find.byKey(_middleKey)).left,
          tester.getRect(find.byKey(_leftKey)).right + _light.spacing.xs,
        );
      },
    );
  });

  group('[Comportamento] Desenho automático', () {
    testWidgets(
      '[Comportamento] Desenho automático — Barra automática no rodapé',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 600);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _host(
            const SizedBox(
              height: 600,
              child: RebicPage(
                title: 'Pedidos',
                footer: RebicBar(key: _rightKey),
              ),
            ),
          ),
        );
        final footer = _decoration(tester, find.byKey(_rightKey));
        expect(footer.border, isA<Border>());
        expect((footer.border! as Border).top.color, _light.colors.separator);
        expect(footer.boxShadow, isNull);
      },
    );

    testWidgets(
      '[Comportamento] Desenho automático — Barra automática fora da página',
      (tester) async {
        await tester.pumpWidget(_host(const RebicBar()));
        final decoration = _decoration(tester);
        expect(decoration.boxShadow, isNotEmpty);
        expect(decoration.border, isNull);
      },
    );
  });

  testWidgets('[Comportamento] Espaço insuficiente — Título longo no meio', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        width: 320,
        RebicBar(
          contentLeft: [
            RebicIconButton(
              icon: RebicIcons.navBack,
              tooltip: 'Voltar',
              onPressed: () {},
            ),
          ],
          contentMiddle: const [
            RebicTitle('Pedidos de compra em aberto aguardando aprovação'),
          ],
          contentRight: [
            RebicIconButton(
              icon: RebicIcons.edit,
              tooltip: 'Editar',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final title = tester.renderObject<RenderParagraph>(
      find.text('Pedidos de compra em aberto aguardando aprovação'),
    );
    expect(title.didExceedMaxLines, isTrue);
    for (final icon in [RebicIcons.navBack, RebicIcons.edit]) {
      final rect = tester.getRect(find.byIcon(icon));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(320));
    }
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Desenhos da barra', (
      tester,
    ) async {
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        for (final design in [
          RebicBarDesign.header,
          RebicBarDesign.subHeader,
          RebicBarDesign.footer,
          RebicBarDesign.floatingFooter,
        ]) {
          await tester.pumpWidget(
            _host(
              theme: theme,
              RebicBar(
                key: ValueKey((theme.brightness, design)),
                design: design,
              ),
            ),
          );
          final d = _decoration(tester);
          final reason = '${theme.brightness} ${design.name}';
          expect(d.color, theme.colors.base, reason: reason);
          switch (design) {
            case RebicBarDesign.header:
              expect(
                d.boxShadow,
                hasLength(theme.shadows.header.length),
                reason: reason,
              );
            case RebicBarDesign.subHeader:
              expect(d.boxShadow, isNull, reason: reason);
              expect(d.border, isNull, reason: reason);
            case RebicBarDesign.footer:
              final border = d.border! as Border;
              expect(border.top.color, theme.colors.separator, reason: reason);
              expect(border.bottom, BorderSide.none, reason: reason);
            case RebicBarDesign.floatingFooter:
              final border = d.border! as Border;
              expect(border.bottom.color, theme.colors.separator);
              expect(
                d.borderRadius,
                BorderRadius.circular(theme.radius.s),
                reason: reason,
              );
            case RebicBarDesign.auto:
          }
        }
      }
    });

    testWidgets('[Aparência] Tokens de componente — Altura por densidade', (
      tester,
    ) async {
      for (final (density, height) in [
        (RebicDensity.cozy, 48.0),
        (RebicDensity.compact, 32.0),
      ]) {
        final theme = _light.withDensity(density);
        await tester.pumpWidget(
          _host(theme: theme, RebicBar(key: ValueKey(density))),
        );
        expect(theme.density.barHeight, height);
        expect(tester.getSize(find.byType(RebicBar)).height, height);
      }
    });
  });

  testWidgets('[Estados] Sem estados próprios — Barra não recebe foco', (
    tester,
  ) async {
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            Focus(
              focusNode: first,
              child: const SizedBox(width: 20, height: 20),
            ),
            const RebicBar(contentMiddle: [RebicText('Pedidos')]),
            Focus(
              focusNode: second,
              child: const SizedBox(width: 20, height: 20),
            ),
          ],
        ),
      ),
    );
    first.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na barra', (
    tester,
  ) async {
    final nodes = List.generate(3, (_) => FocusNode());
    addTearDown(() {
      for (final node in nodes) {
        node.dispose();
      }
    });
    Widget focusable(int i) => Focus(
      focusNode: nodes[i],
      child: const SizedBox(width: 20, height: 20),
    );
    await tester.pumpWidget(
      RebicApp(
        home: Align(
          alignment: Alignment.topCenter,
          child: RebicBar(
            contentLeft: [focusable(0)],
            contentMiddle: [focusable(1)],
            contentRight: [focusable(2)],
          ),
        ),
      ),
    );
    nodes[0].requestFocus();
    await tester.pump();
    final visited = <int>[];
    for (var i = 0; i < 2; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      visited.add(nodes.indexWhere((n) => n.hasPrimaryFocus));
    }
    expect(visited, [1, 2]);
  });

  // "Contraste na barra" fica em rebic_bar_contrast_test.dart, sem a fonte
  // real: a diretriz de contraste mede pixels e precisa dos glifos sólidos da
  // fonte de teste padrão.

  testWidgets('[Responsividade] Largura, densidade e direção — Barra em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        direction: TextDirection.rtl,
        RebicBar(
          contentLeft: [_box(_leftKey, 40)],
          contentRight: [_box(_rightKey, 40)],
        ),
      ),
    );
    final edge = _light.spacing.s;
    expect(tester.getRect(find.byKey(_leftKey)).right, 800 - edge);
    expect(tester.getRect(find.byKey(_rightKey)).left, edge);
  });

  testWidgets('[Integração] Dependências — Barra sem Material', (tester) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            for (final design in RebicBarDesign.values)
              RebicBar(design: design, contentMiddle: [RebicText(design.name)]),
          ],
        ),
      ),
    );
    expect(find.byType(RebicBar), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test(
      '[Testes] Cobertura exigida — Rastreabilidade da barra de três áreas',
      () {
        final names = scenarioNames(
          'rebic/widgets/rebic-bar',
          'update-rebic-page-fiori-page-bar',
        );
        expect(names, hasLength(19));
        expect(untestedScenarios(names), isEmpty);
      },
    );

    testWidgets(
      '[Testes] Cobertura exigida — Goldens da barra de três áreas',
      (tester) async {
        for (final (name, theme) in goldenThemes) {
          await expectGolden(
            tester,
            name: 'rebic_bar_$name',
            theme: theme,
            size: const Size(640, 360),
            surface: RebicSurface.background,
            child: Column(
              spacing: 24,
              children: [
                for (final design in [
                  RebicBarDesign.header,
                  RebicBarDesign.subHeader,
                  RebicBarDesign.footer,
                  RebicBarDesign.floatingFooter,
                ])
                  RebicBar(
                    design: design,
                    contentLeft: [
                      RebicIconButton(
                        icon: RebicIcons.navBack,
                        tooltip: 'Voltar',
                        onPressed: () {},
                      ),
                    ],
                    contentMiddle: [RebicTitle(design.name)],
                    contentRight: [
                      RebicIconButton(
                        icon: RebicIcons.edit,
                        tooltip: 'Editar',
                        onPressed: () {},
                      ),
                    ],
                  ),
              ],
            ),
          );
        }
      },
      tags: ['golden'],
    );
  });

  test('[Restrições] Fora do escopo — Barra sem valor literal', () {
    final file = File(
      'lib/src/fundacao_layout/bar/rebic_bar.dart',
    ).readAsStringSync();
    final source = file.substring(
      file.indexOf('class RebicBar '),
      file.indexOf('class RebicBarScope'),
    );
    for (final field in RegExp(
      r'^  final (\S+) \w+;$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!)) {
      expect(field, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
