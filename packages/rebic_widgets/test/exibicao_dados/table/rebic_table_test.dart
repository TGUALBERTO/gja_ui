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

const _columns = [
  RebicColumn(header: 'Produto', flex: 2),
  RebicColumn(header: 'Quantidade', hAlign: RebicColumnHAlign.end),
];

List<RebicColumnListItem<String>> _items({
  RebicListType type = RebicListType.inactive,
}) => [
  RebicColumnListItem(
    key: 'teclado',
    type: type,
    cells: const [RebicText('Teclado'), RebicText('12')],
  ),
  RebicColumnListItem(
    key: 'mouse',
    type: type,
    cells: const [RebicText('Mouse'), RebicText('30')],
  ),
  RebicColumnListItem(
    key: 'monitor',
    type: type,
    cells: const [RebicText('Monitor'), RebicText('4')],
  ),
];

Widget _app(
  Widget home, {
  double width = 600,
  TextDirection direction = TextDirection.ltr,
}) => RebicApp(
  locale: const Locale('pt', 'BR'),
  builder: (context, child) =>
      Directionality(textDirection: direction, child: child!),
  home: Align(
    alignment: Alignment.topCenter,
    child: SizedBox(width: width, child: home),
  ),
);

/// Tabela que guarda a própria seleção e registra cada evento.
Widget _stateful({
  required RebicListMode mode,
  List<Set<String>>? selections,
  List<String>? presses,
  List<RebicColumnListItem<String>>? items,
  Set<String> initial = const {},
}) {
  var keys = initial;
  return StatefulBuilder(
    builder: (context, setState) => RebicTable<String>(
      columns: _columns,
      items: items ?? _items(),
      mode: mode,
      selectedKeys: keys,
      onItemPress: presses?.add,
      onSelectionChange: (value) {
        selections?.add(value);
        setState(() => keys = value);
      },
    ),
  );
}

Finder _rowOf(String text) => find
    .ancestor(of: find.text(text), matching: find.byType(DecoratedBox))
    .first;

Color? _color(WidgetTester tester, Finder box) =>
    (tester.widget<DecoratedBox>(box).decoration as BoxDecoration).color;

void main() {
  testWidgets('[API] Propriedades — Tabela mínima', (tester) async {
    await tester.pumpWidget(
      _app(RebicTable<String>(columns: _columns, items: _items())),
    );
    final header = tester.getRect(find.text('Produto'));
    final cell = tester.getRect(find.text('Teclado'));
    expect(cell.top, greaterThan(header.bottom));
    expect(cell.left, closeTo(header.left, 1));
    expect(
      tester.getRect(find.text('12')).right,
      closeTo(tester.getRect(find.text('Quantidade')).right, 1),
    );
  });

  testWidgets('[API] Colunas e linhas válidas — Linha com células a menos', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const RebicTable<String>(
          columns: _columns,
          items: [
            RebicColumnListItem(key: 'a', cells: [RebicText('A')]),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isA<AssertionError>());
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Acionar uma linha', (
      tester,
    ) async {
      final presses = <String>[];
      await tester.pumpWidget(
        _app(
          RebicTable<String>(
            columns: _columns,
            items: _items(type: RebicListType.navigation),
            onItemPress: presses.add,
          ),
        ),
      );
      await tester.tap(find.text('Teclado'));
      await tester.pump();
      expect(presses, ['teclado']);
      expect(find.byIcon(RebicIcons.slimArrowRight), findsNWidgets(3));
    });

    testWidgets('[API] Callbacks e controlador — Seleção única', (
      tester,
    ) async {
      final selections = <Set<String>>[];
      await tester.pumpWidget(
        _app(
          _stateful(
            mode: RebicListMode.singleSelectMaster,
            selections: selections,
            initial: {'teclado'},
          ),
        ),
      );
      await tester.tap(find.text('Mouse'));
      await tester.pump();
      expect(selections, [
        {'mouse'},
      ]);
      expect(
        _color(
          tester,
          find
              .ancestor(
                of: find.text('Mouse'),
                matching: find.byType(DecoratedBox),
              )
              .last,
        ),
        _light.colors.selectionBackground,
      );
    });
  });

  group('[Comportamento] Seleção múltipla e tabela vazia', () {
    testWidgets(
      '[Comportamento] Seleção múltipla e tabela vazia — Seleção múltipla',
      (tester) async {
        final selections = <Set<String>>[];
        await tester.pumpWidget(
          _app(
            _stateful(mode: RebicListMode.multiSelect, selections: selections),
          ),
        );
        final boxes = find.byType(RebicCheckBox);
        expect(boxes, findsNWidgets(4));
        await tester.tap(boxes.at(2));
        await tester.pump();
        expect(selections.last, {'mouse'});
        expect(
          tester.widget<RebicCheckBox>(boxes.first).partiallySelected,
          isTrue,
        );
        await tester.tap(boxes.first);
        await tester.pump();
        expect(selections.last, {'teclado', 'mouse', 'monitor'});
      },
    );

    testWidgets(
      '[Comportamento] Seleção múltipla e tabela vazia — Tabela vazia',
      (tester) async {
        await tester.pumpWidget(
          _app(const RebicTable<String>(columns: _columns, items: [])),
        );
        expect(
          tester.getTopLeft(find.text('Sem dados')).dy,
          greaterThan(tester.getBottomLeft(find.text('Produto')).dy),
        );
      },
    );
  });

  testWidgets('[Comportamento] Teclado — Setas na tabela', (tester) async {
    final presses = <String>[];
    await tester.pumpWidget(
      _app(
        RebicTable<String>(
          columns: _columns,
          items: _items(type: RebicListType.active).sublist(0, 2),
          onItemPress: presses.add,
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(presses, ['mouse']);
  });

  testWidgets('[Aparência] Tokens de componente — Linha da tabela', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(RebicTable<String>(columns: _columns, items: _items())),
    );
    expect(
      tester.getSize(_rowOf('Teclado')).height,
      _light.density.listItemHeight,
    );
    expect(
      tester.widget<Text>(find.text('Produto')).style?.color,
      _light.colors.label,
    );
    expect(_color(tester, _rowOf('Teclado')), _light.colors.base);
  });

  testWidgets('[Estados] Interação — Linha em hover', (tester) async {
    await tester.pumpWidget(
      _app(
        RebicTable<String>(
          columns: _columns,
          items: [
            const RebicColumnListItem(
              key: 'a',
              type: RebicListType.active,
              cells: [RebicText('Ativa'), RebicText('1')],
            ),
            const RebicColumnListItem(
              key: 'b',
              cells: [RebicText('Inativa'), RebicText('2')],
            ),
          ],
          onItemPress: (_) {},
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: tester.getCenter(find.text('Ativa')));
    await tester.pump();
    expect(_color(tester, _rowOf('Ativa')), _light.colors.hoverBackground);
    await mouse.moveTo(tester.getCenter(find.text('Inativa')));
    await tester.pump();
    expect(_color(tester, _rowOf('Ativa')), isNull);
    expect(_color(tester, _rowOf('Inativa')), _light.colors.base);
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Semântica da tabela',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _app(
            _stateful(
              mode: RebicListMode.singleSelectMaster,
              initial: {'teclado'},
            ),
          ),
        );
        expect(
          tester.getSemantics(find.text('Teclado')),
          containsSemantics(
            isButton: true,
            isSelected: true,
            label: 'Teclado\n12',
          ),
        );
        handle.dispose();
      },
    );

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Contraste e alvo da tabela',
      (tester) async {
        final handle = tester.ensureSemantics();
        for (final (_, theme) in goldenThemes) {
          for (final mode in [
            RebicListMode.multiSelect,
            RebicListMode.singleSelectMaster,
          ]) {
            await tester.pumpWidget(
              RebicApp(
                key: ValueKey((theme, mode)),
                theme: theme,
                darkTheme: theme,
                density: theme.density.density,
                home: RebicContainer(
                  surface: RebicSurface.background,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 600,
                      child: _stateful(mode: mode, initial: {'mouse'}),
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
        }
        handle.dispose();
      },
    );
  });

  group('[Responsividade] Popin e direção', () {
    testWidgets('[Responsividade] Popin e direção — Colunas em popin', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          width: 400,
          const RebicTable<String>(
            columns: [
              RebicColumn(header: 'Produto'),
              RebicColumn(
                header: 'Preço',
                minScreenWidth: RebicSizeClass.medium,
                demandPopin: true,
              ),
              RebicColumn(
                header: 'Estoque',
                minScreenWidth: RebicSizeClass.medium,
              ),
            ],
            items: [
              RebicColumnListItem(
                key: 'a',
                cells: [
                  RebicText('Teclado'),
                  RebicText('R\$ 120,00'),
                  RebicText('12'),
                ],
              ),
            ],
          ),
        ),
      );
      expect(find.text('Preço'), findsNothing);
      expect(find.text('Estoque'), findsNothing);
      expect(find.text('12'), findsNothing);
      final label = tester.getRect(find.text('Preço:'));
      expect(
        label.top,
        greaterThan(tester.getRect(find.text('Teclado')).bottom),
      );
      expect(
        tester.getRect(find.text('R\$ 120,00')).left,
        greaterThan(label.right),
      );
    });

    testWidgets('[Responsividade] Popin e direção — Tabela em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          direction: TextDirection.rtl,
          RebicTable<String>(columns: _columns, items: _items()),
        ),
      );
      expect(
        tester.getCenter(find.text('Produto')).dx,
        greaterThan(tester.getCenter(find.text('Quantidade')).dx),
      );
    });
  });

  testWidgets('[Integração] Dependências — Tabela sem Material', (
    tester,
  ) async {
    final presses = <String>[];
    await tester.pumpWidget(
      _app(
        _stateful(
          mode: RebicListMode.multiSelect,
          presses: presses,
          items: _items(type: RebicListType.navigation),
        ),
      ),
    );
    await tester.tap(find.text('Mouse'));
    await tester.tap(find.byType(RebicCheckBox).at(1));
    await tester.pumpAndSettle();
    expect(presses, ['mouse']);
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade da tabela', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-table',
        'add-rebic-table',
      );
      expect(names, hasLength(18));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens da tabela', (
      tester,
    ) async {
      const columns = [
        RebicColumn(header: 'Produto', flex: 2),
        RebicColumn(
          header: 'Preço',
          hAlign: RebicColumnHAlign.end,
          minScreenWidth: RebicSizeClass.medium,
          demandPopin: true,
        ),
        RebicColumn(header: 'Estoque', hAlign: RebicColumnHAlign.end),
      ];
      final items = [
        for (final (key, name, price, stock) in [
          ('a', 'Teclado', 'R\$ 120,00', '12'),
          ('b', 'Mouse', 'R\$ 45,00', '30'),
        ])
          RebicColumnListItem(
            key: key,
            type: RebicListType.navigation,
            cells: [RebicText(name), RebicText(price), RebicText(stock)],
          ),
      ];
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_table_$name',
          theme: theme,
          size: const Size(1040, 360),
          child: SizedBox(
            width: 1000,
            child: RebicHBox(
              gap: RebicSpace.l,
              alignItems: RebicFlexAlignItems.start,
              items: [
                SizedBox(
                  width: 620,
                  child: RebicVBox(
                    gap: RebicSpace.l,
                    alignItems: RebicFlexAlignItems.stretch,
                    items: [
                      RebicTable<String>(
                        headerText: 'Produtos',
                        columns: columns,
                        items: items,
                        mode: RebicListMode.multiSelect,
                        selectedKeys: const {'b'},
                        onSelectionChange: (_) {},
                        onItemPress: (_) {},
                      ),
                      const RebicTable<String>(columns: columns, items: []),
                    ],
                  ),
                ),
                SizedBox(
                  width: 340,
                  child: RebicTable<String>(
                    columns: columns,
                    items: items,
                    onItemPress: (_) {},
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Tabela sem valor literal', () {
    final source = File(
      'lib/src/exibicao_dados/table/rebic_table.dart',
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
