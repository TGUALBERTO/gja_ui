import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

Widget _app(Widget home, {TextDirection direction = TextDirection.ltr}) =>
    RebicApp(
      builder: (context, child) =>
          Directionality(textDirection: direction, child: child!),
      home: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(width: 400, child: home),
      ),
    );

/// Painel expansível que guarda o próprio estado e registra cada `onExpand`.
Widget _stateful(
  List<bool> log, {
  bool initial = false,
  String headerText = 'Pagamento',
  List<Widget> content = const [RebicText('Detalhes')],
}) {
  var expanded = initial;
  return StatefulBuilder(
    builder: (context, setState) => RebicPanel(
      headerText: headerText,
      expandable: true,
      expanded: expanded,
      onExpand: (value) {
        log.add(value);
        setState(() => expanded = value);
      },
      content: content,
    ),
  );
}

Color? _headerColor(WidgetTester tester, String text) =>
    (tester
                .widget<DecoratedBox>(
                  find
                      .ancestor(
                        of: find.text(text),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration)
        .color;

void main() {
  testWidgets('[API] Propriedades — Painel mínimo', (tester) async {
    await tester.pumpWidget(
      _app(
        const RebicPanel(
          headerText: 'Endereço',
          content: [RebicText('Rua A, 10')],
        ),
      ),
    );
    expect(
      tester.getTopLeft(find.text('Rua A, 10')).dy,
      greaterThan(tester.getBottomLeft(find.text('Endereço')).dy),
    );
    expect(find.byIcon(RebicIcons.slimArrowRight), findsNothing);
    expect(find.text('Rua A, 10').hitTestable(), findsOneWidget);
  });

  testWidgets(
    '[API] Título obrigatório no expansível — Painel expansível sem título',
    (tester) async {
      await tester.pumpWidget(
        _app(const RebicPanel(expandable: true, content: [RebicText('a')])),
      );
      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets('[API] Callbacks e controlador — Expandir o painel', (
    tester,
  ) async {
    final log = <bool>[];
    await tester.pumpWidget(_app(_stateful(log)));
    expect(find.text('Detalhes').hitTestable(), findsNothing);
    await tester.tap(find.text('Pagamento'));
    await tester.pumpAndSettle();
    expect(log, [true]);
    expect(find.text('Detalhes').hitTestable(), findsOneWidget);
  });

  group('[Comportamento] Conteúdo recolhido', () {
    testWidgets('[Comportamento] Conteúdo recolhido — Painel recolhido', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(_stateful([])));
      expect(
        tester.getSize(find.byType(RebicPanel)).height,
        _light.density.listItemHeight,
      );
      expect(find.semantics.byLabel('Detalhes'), findsNothing);
      expect(find.text('Detalhes', skipOffstage: false), findsOneWidget);
      handle.dispose();
    });

    testWidgets('[Comportamento] Conteúdo recolhido — Teclado no painel', (
      tester,
    ) async {
      final log = <bool>[];
      await tester.pumpWidget(_app(_stateful(log)));
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(log, [true]);
    });
  });

  testWidgets('[Aparência] Tokens de componente — Cabeçalho do painel', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_stateful([], initial: true)));
    final header = find
        .ancestor(of: find.text('Pagamento'), matching: find.byType(SizedBox))
        .first;
    expect(tester.getSize(header).height, _light.density.listItemHeight);
    expect(
      tester.widget<Text>(find.text('Pagamento')).style?.fontSize,
      _light.typography.header6.fontSize,
    );
    final panel = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(RebicPanel),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect((panel.decoration as BoxDecoration).color, _light.colors.base);
  });

  testWidgets('[Estados] Interação — Cabeçalho em hover', (tester) async {
    await tester.pumpWidget(_app(_stateful([])));
    expect(_headerColor(tester, 'Pagamento'), isNull);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: tester.getCenter(find.text('Pagamento')));
    addTearDown(mouse.removePointer);
    await tester.pump();
    expect(_headerColor(tester, 'Pagamento'), _light.colors.hoverBackground);
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Semântica do painel',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(_app(_stateful([])));
        expect(
          tester.getSemantics(find.text('Pagamento')),
          containsSemantics(
            isButton: true,
            hasExpandedState: true,
            isExpanded: false,
            label: 'Pagamento',
          ),
        );
        handle.dispose();
      },
    );

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Contraste e alvo do painel',
      (tester) async {
        final handle = tester.ensureSemantics();
        for (final (_, theme) in goldenThemes) {
          await tester.pumpWidget(
            RebicApp(
              key: ValueKey(theme),
              theme: theme,
              darkTheme: theme,
              density: theme.density.density,
              home: RebicContainer(
                surface: RebicSurface.background,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 400,
                    child: RebicVBox(
                      alignItems: RebicFlexAlignItems.stretch,
                      items: [
                        _stateful([], initial: true),
                        _stateful([], headerText: 'Entrega'),
                        const RebicPanel(
                          headerText: 'Endereço',
                          content: [RebicText('Rua A, 10')],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await expectLater(
            tester,
            meetsGuideline(
              MinimumTapTargetGuideline(
                size: Size.square(
                  RebicAccessibility.minTargetSize(theme.density),
                ),
                link: RebicAccessibility.targetSizeLink,
              ),
            ),
          );
        }
        handle.dispose();
      },
    );
  });

  testWidgets('[Responsividade] Largura e direção — Painel em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(_app(direction: TextDirection.rtl, _stateful([])));
    expect(
      tester.getCenter(find.byIcon(RebicIcons.slimArrowRight)).dx,
      greaterThan(tester.getCenter(find.text('Pagamento')).dx),
    );
    expect(tester.getSize(find.byType(RebicPanel)).width, 400);
  });

  testWidgets('[Integração] Dependências — Painel sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        _stateful(
          [],
          content: [RebicInput(placeholder: 'Observação', onChange: (_) {})],
        ),
      ),
    );
    await tester.tap(find.text('Pagamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pagamento'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do painel', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-panel',
        'add-rebic-panel',
      );
      expect(names, hasLength(15));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do painel', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_panel_$name',
          theme: theme,
          size: const Size(440, 360),
          child: SizedBox(
            width: 400,
            child: RebicVBox(
              gap: RebicSpace.l,
              alignItems: RebicFlexAlignItems.stretch,
              items: [
                const RebicPanel(
                  headerText: 'Endereço',
                  content: [RebicText('Rua A, 10 — Centro')],
                ),
                RebicPanel(
                  headerText: 'Pagamento',
                  expandable: true,
                  expanded: true,
                  onExpand: (_) {},
                  content: const [RebicText('Boleto em 30 dias')],
                ),
                RebicPanel(
                  headerText: 'Entrega',
                  expandable: true,
                  onExpand: (_) {},
                  content: const [RebicText('Transportadora')],
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Painel sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/panel/rebic_panel.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(type, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
