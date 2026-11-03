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

Widget _app(
  Widget home, {
  TextDirection direction = TextDirection.ltr,
  double width = 600,
}) => RebicApp(
  builder: (context, child) =>
      Directionality(textDirection: direction, child: child!),
  home: Center(
    child: SizedBox(width: width, child: home),
  ),
);

Finder _box([int index = 0]) => find
    .descendant(
      of: find.byType(RebicToolbar).at(index),
      matching: find.byType(DecoratedBox),
    )
    .first;

BoxDecoration _decoration(WidgetTester tester, [int index = 0]) =>
    tester.widget<DecoratedBox>(_box(index)).decoration as BoxDecoration;

void main() {
  testWidgets('[API] Propriedades — Barra mínima', (tester) async {
    await tester.pumpWidget(
      _app(
        RebicToolbar(
          content: [
            const RebicText('Pedidos'),
            const Spacer(),
            RebicButton(text: 'Novo', onPress: () {}),
          ],
        ),
      ),
    );
    final bar = tester.getRect(find.byType(RebicToolbar));
    expect(bar.height, _light.density.barHeight);
    expect(
      tester.getRect(find.text('Pedidos')).left,
      closeTo(bar.left + _light.spacing.s, 0.5),
    );
    expect(
      tester.getRect(find.byType(RebicButton)).right,
      closeTo(bar.right - _light.spacing.s, 0.5),
    );
  });

  testWidgets('[API] Callbacks e controlador — Barra acionável', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _app(
        RebicToolbar(
          design: RebicToolbarDesign.info,
          semanticLabel: '2 filtros ativos',
          onPress: () => calls++,
          content: const [RebicText('2 filtros ativos')],
        ),
      ),
    );
    await tester.tap(find.byType(RebicToolbar));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(calls, 2);
  });

  testWidgets('[Comportamento] Disposição dos itens — Barra estreita', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        width: 200,
        RebicToolbar(
          content: [
            for (var i = 0; i < 5; i++)
              RebicButton(text: 'Ação $i', onPress: () {}),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final bar = tester.getRect(find.byType(RebicToolbar));
    expect(tester.getRect(find.text('Ação 4')).left, greaterThan(bar.right));
  });

  testWidgets('[Aparência] Desenhos e estilos — Desenhos da barra', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RebicToolbar(content: [RebicText('a')]),
            RebicToolbar(
              design: RebicToolbarDesign.solid,
              content: [RebicText('b')],
            ),
            RebicToolbar(
              design: RebicToolbarDesign.info,
              content: [RebicText('c')],
            ),
            RebicToolbar(
              style: RebicToolbarStyle.clear,
              content: [RebicText('d')],
            ),
          ],
        ),
      ),
    );
    expect(_decoration(tester).color, isNull);
    expect(_decoration(tester, 1).color, _light.colors.base);
    expect(
      _decoration(tester, 2).color,
      _light.colors.stateColors(RebicValueState.information).background,
    );
    for (final i in [0, 1, 2]) {
      expect(
        (_decoration(tester, i).border! as Border).bottom.color,
        _light.colors.separator,
      );
    }
    expect(_decoration(tester, 3).border, isNull);
  });

  testWidgets(
    '[Estados] Interação da barra acionável — Hover na barra acionável',
    (tester) async {
      await tester.pumpWidget(
        _app(
          RebicToolbar(
            onPress: () {},
            semanticLabel: 'h',
            content: const [RebicText('Filtros')],
          ),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(RebicToolbar)));
      await tester.pump();
      expect(_decoration(tester).color, _light.colors.hoverBackground);
    },
  );

  group('[Acessibilidade] Semântica e teclado', () {
    testWidgets(
      '[Acessibilidade] Semântica e teclado — Ordem de foco na barra',
      (tester) async {
        final start = FocusNode();
        addTearDown(start.dispose);
        await tester.pumpWidget(
          _app(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Focus(
                  focusNode: start,
                  child: const SizedBox.square(dimension: 8),
                ),
                RebicToolbar(
                  content: [
                    for (final t in ['a', 'b', 'c'])
                      RebicButton(text: t, onPress: () {}),
                  ],
                ),
              ],
            ),
          ),
        );
        start.requestFocus();
        await tester.pump();
        final seen = <String?>[];
        for (var i = 0; i < 3; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          seen.add(
            FocusManager.instance.primaryFocus?.context
                ?.findAncestorWidgetOfExactType<RebicButton>()
                ?.text,
          );
        }
        expect(seen, ['a', 'b', 'c']);
      },
    );

    testWidgets(
      '[Acessibilidade] Semântica e teclado — Semântica da barra acionável',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _app(
            RebicToolbar(
              design: RebicToolbarDesign.info,
              semanticLabel: '2 filtros ativos',
              onPress: () {},
              content: const [RebicText('2 filtros ativos')],
            ),
          ),
        );
        expect(
          tester.getSemantics(find.byType(RebicToolbar)),
          containsSemantics(
            isButton: true,
            label: '2 filtros ativos\n2 filtros ativos',
            hasTapAction: true,
          ),
        );
        handle.dispose();
      },
    );
  });

  testWidgets('[Responsividade] Direção e densidade — Barra em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        direction: TextDirection.rtl,
        RebicToolbar(
          content: [
            const RebicText('Pedidos'),
            const Spacer(),
            RebicButton(text: 'Novo', onPress: () {}),
          ],
        ),
      ),
    );
    expect(
      tester.getCenter(find.text('Pedidos')).dx,
      greaterThan(tester.getCenter(find.byType(RebicButton)).dx),
    );
  });

  testWidgets('[Integração] Dependências — Barra sem Material', (tester) async {
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final design in RebicToolbarDesign.values)
              RebicToolbar(
                design: design,
                content: [
                  const RebicText('Título'),
                  const Spacer(),
                  RebicButton(text: 'a', onPress: () {}),
                  const RebicSeparator.vertical(),
                  RebicButton(text: 'b', onPress: () {}),
                ],
              ),
            RebicToolbar(
              onPress: () {},
              semanticLabel: 'x',
              content: const [RebicText('Acionável')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Acionável'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade da barra', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-toolbar',
        'add-rebic-toolbar',
      );
      expect(names, hasLength(13));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens da barra', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_toolbar_$name',
          theme: theme,
          size: const Size(520, 340),
          child: SizedBox(
            width: 480,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => RebicVBox(
                    gap: RebicSpace.s,
                    alignItems: RebicFlexAlignItems.stretch,
                    items: [
                      for (final design in RebicToolbarDesign.values)
                        RebicToolbar(
                          design: design,
                          content: [
                            RebicTitle(
                              design.name,
                              titleStyle: RebicTitleLevel.h5,
                            ),
                            const Spacer(),
                            RebicButton(
                              icon: RebicIcons.add,
                              tooltip: 'Novo',
                              type: RebicButtonType.transparent,
                              onPress: () {},
                            ),
                            const RebicSeparator.vertical(),
                            RebicButton(
                              icon: RebicIcons.filter,
                              tooltip: 'Filtrar',
                              type: RebicButtonType.transparent,
                              onPress: () {},
                            ),
                          ],
                        ),
                      const RebicToolbar(
                        style: RebicToolbarStyle.clear,
                        content: [RebicText('clear')],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Barra sem valor literal', () {
    final source = File(
      'lib/src/acoes_navegacao/toolbar/rebic_toolbar.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicToolbar\(\{(.*?)\}\);',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    expect(ctor, isNot(contains('double')));
    expect(ctor, isNot(contains('Color')));
  });
}
