import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/traceability.dart';

/// Ajusta a janela de teste para [width] × [height].
void _view(WidgetTester tester, double width, [double height = 1200]) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
}

/// Monta [child] numa área de [width], sob [theme] e [direction].
Widget _area(
  double width,
  Widget child, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(key: const Key('area'), width: width, child: child),
    ),
  ),
);

Widget _item(int i) => SizedBox(key: Key('i$i'), height: 20);

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

/// Itens por linha: quantos itens têm o mesmo topo do primeiro.
int _perRow(WidgetTester tester, int count) {
  final top = _rect(tester, 'i0').top;
  return [
    for (var i = 0; i < count; i++) _rect(tester, 'i$i').top,
  ].where((t) => t == top).length;
}

RebicSpacingTokens get _spacing => RebicThemeData.light().spacing;

void main() {
  testWidgets('[API] Propriedades — Grade mínima', (tester) async {
    _view(tester, 1300);
    await tester.pumpWidget(
      RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 1200,
            child: RebicGrid(children: [for (var i = 0; i < 6; i++) _item(i)]),
          ),
        ),
      ),
    );
    expect(_perRow(tester, 6), 3);
    final g = _spacing.l;
    final column = (1200 - 11 * g) / 12;
    expect(_rect(tester, 'i0').width, closeTo(4 * column + 3 * g, 0.01));
    expect(_rect(tester, 'i3').top, greaterThan(_rect(tester, 'i0').top));
  });

  testWidgets('[API] Span válido — Span inválido', (tester) async {
    await tester.pumpWidget(
      _area(
        500,
        RebicGrid.cells(
          defaultSpan: const RebicResponsiveValue(small: 13),
          cells: [RebicGridCell(child: _item(0))],
        ),
      ),
    );
    final error = tester.takeException();
    expect(error, isA<AssertionError>());
    expect('$error', contains('13'));
  });

  testWidgets('[API] Callbacks e controlador — Grade sem ação', (tester) async {
    await tester.pumpWidget(
      _area(1200, RebicGrid(children: [_item(0), _item(1)])),
    );
    final between = Offset(_rect(tester, 'i0').right + 2, 10);
    await tester.tapAt(between);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(RebicGrid),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('[Comportamento] Largura das colunas — Larguras de span 4 e 8', (
    tester,
  ) async {
    _view(tester, 1300);
    await tester.pumpWidget(
      _area(
        1200,
        RebicGrid.cells(
          cells: [
            RebicGridCell(child: _item(0)),
            RebicGridCell(
              child: _item(1),
              span: const RebicResponsiveValue(small: 8),
            ),
          ],
        ),
      ),
    );
    final a = _rect(tester, 'i0');
    final b = _rect(tester, 'i1');
    expect(b.top, a.top);
    expect(b.left - a.right, closeTo(_spacing.l, 0.01));
    expect(b.right, closeTo(_rect(tester, 'area').right, 0.01));
  });

  testWidgets('[Comportamento] Fluxo em linhas — Quebra quando não cabe', (
    tester,
  ) async {
    _view(tester, 1300);
    RebicGridCell cell(int i, int span) => RebicGridCell(
      child: _item(i),
      span: RebicResponsiveValue(small: span),
    );
    await tester.pumpWidget(
      _area(1200, RebicGrid.cells(cells: [cell(0, 6), cell(1, 4), cell(2, 6)])),
    );
    expect(_rect(tester, 'i1').top, _rect(tester, 'i0').top);
    expect(
      _rect(tester, 'i2').top - _rect(tester, 'i0').bottom,
      closeTo(_spacing.l, 0.01),
    );
    expect(_rect(tester, 'i2').left, _rect(tester, 'i0').left);
  });

  group('[Comportamento] Span por classe e por item', () {
    testWidgets(
      '[Comportamento] Span por classe e por item — Item com span próprio',
      (tester) async {
        _view(tester, 1300);
        await tester.pumpWidget(
          _area(
            1200,
            RebicGrid.cells(
              cells: [
                RebicGridCell(
                  child: _item(0),
                  span: const RebicResponsiveValue(small: 12, large: 8),
                ),
                RebicGridCell(child: _item(1)),
              ],
            ),
          ),
        );
        final g = _spacing.l;
        final column = (1200 - 11 * g) / 12;
        expect(_rect(tester, 'i0').width, closeTo(8 * column + 7 * g, 0.01));
        expect(_rect(tester, 'i1').width, closeTo(4 * column + 3 * g, 0.01));
      },
    );

    testWidgets(
      '[Comportamento] Span por classe e por item — Grade em cada classe',
      (tester) async {
        _view(tester, 2000);
        final perRow = <int>[];
        for (final width in [500.0, 800.0, 1200.0, 1500.0]) {
          await tester.pumpWidget(
            _area(
              width,
              RebicGrid(children: [for (var i = 0; i < 8; i++) _item(i)]),
            ),
          );
          perRow.add(_perRow(tester, 8));
        }
        expect(perRow, [1, 2, 3, 4]);
      },
    );
  });

  testWidgets(
    '[Aparência] Tokens de componente — Espaço da densidade compacta',
    (tester) async {
      _view(tester, 1300);
      await tester.pumpWidget(
        _area(
          1200,
          RebicTheme.density(
            density: RebicDensity.compact,
            child: RebicGrid(children: [_item(0), _item(1)]),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final compact = RebicThemeData.light(
        density: RebicDensity.compact,
      ).spacing;
      expect(
        _rect(tester, 'i1').left - _rect(tester, 'i0').right,
        closeTo(compact.l, 0.01),
      );
      expect(
        find.descendant(
          of: find.byType(RebicGrid),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    },
  );

  Future<List<FocusNode>> pumpFocusables(WidgetTester tester, int n) async {
    _view(tester, 1300);
    final nodes = [for (var i = 0; i < n; i++) FocusNode()];
    addTearDown(() {
      for (final node in nodes) {
        node.dispose();
      }
    });
    await tester.pumpWidget(
      RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 800,
            child: RebicGrid(
              children: [
                for (final node in nodes)
                  Focus(focusNode: node, child: const SizedBox(height: 20)),
              ],
            ),
          ),
        ),
      ),
    );
    nodes.first.requestFocus();
    await tester.pump();
    return nodes;
  }

  testWidgets('[Estados] Sem estados de interação — Grade não recebe foco', (
    tester,
  ) async {
    final nodes = await pumpFocusables(tester, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(nodes[1].hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na grade', (
    tester,
  ) async {
    final nodes = await pumpFocusables(tester, 4);
    final visited = <int>[];
    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      visited.add(nodes.indexWhere((n) => n.hasPrimaryFocus));
    }
    expect(visited, [1, 2, 3]);
  });

  testWidgets(
    '[Acessibilidade] Semântica e escala — Semântica da grade inalterada',
    (tester) async {
      final handle = tester.ensureSemantics();
      const texts = ['Pedido', 'Fornecedor', 'Valor'];
      List<String> labels() => [
        for (final t in texts) tester.getSemantics(find.text(t)).label,
      ];
      await tester.pumpWidget(
        _area(500, Column(children: [for (final t in texts) RebicText(t)])),
      );
      final native = labels();
      await tester.pumpWidget(
        _area(500, RebicGrid(children: [for (final t in texts) RebicText(t)])),
      );
      expect(labels(), native);
      handle.dispose();
    },
  );

  testWidgets('[Responsividade] Base e direção — Grade em RTL', (tester) async {
    _view(tester, 1300);
    await tester.pumpWidget(
      _area(
        1200,
        RebicGrid(
          defaultSpan: const RebicResponsiveValue(small: 6),
          children: [_item(0), _item(1)],
        ),
        direction: TextDirection.rtl,
      ),
    );
    final area = _rect(tester, 'area');
    expect(_rect(tester, 'i0').right, closeTo(area.right, 0.01));
    expect(_rect(tester, 'i0').left, greaterThan(area.center.dx));
  });

  testWidgets('[Integração] Dependências — Grade sem Material', (tester) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            RebicGrid(children: [_item(0), _item(1)]),
            RebicGrid.cells(
              basis: RebicLayoutBasis.screen,
              cells: [RebicGridCell(child: _item(2))],
            ),
          ],
        ),
      ),
    );
    expect(find.byType(RebicGrid), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  test('[Testes] Cobertura exigida — Rastreabilidade da grade', () {
    final names = scenarioNames('rebic/widgets/rebic-grid', 'add-rebic-grid');
    expect(names, hasLength(16));
    expect(untestedScenarios(names), isEmpty);
  });

  test('[Restrições] Fora do escopo — Grade sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/grid/rebic_grid.dart',
    ).readAsStringSync();
    final ctors = RegExp(
      r'(?:const )?RebicGrid(?:Cell|\.cells)?\(\{(.*?)\}\)',
      dotAll: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(ctors, hasLength(3));
    for (final ctor in ctors) {
      expect(ctor, isNot(contains('double')));
      expect(ctor, isNot(contains('columns')));
    }
  });
}
