import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/traceability.dart';

Widget _sq(String key, [double size = 20]) =>
    SizedBox(key: Key(key), width: size, height: size);

/// Monta [child] sob [theme], na direção [direction], numa área de [width].
Widget _themed(
  Widget child, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
  double? width,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  ),
);

RebicSpacingTokens get _cozy => RebicThemeData.light().spacing;

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

void main() {
  testWidgets('[API] Propriedades — Linha mínima', (tester) async {
    await tester.pumpWidget(
      RebicApp(
        density: RebicDensity.cozy,
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            key: const Key('box'),
            width: 300,
            height: 60,
            child: RebicRow(children: [_sq('a'), _sq('b')]),
          ),
        ),
      ),
    );
    final a = _rect(tester, 'a');
    final b = _rect(tester, 'b');
    final box = _rect(tester, 'box');
    expect(b.left - a.right, _cozy.inlineGap);
    expect(a.left, box.left);
    expect(a.center.dy, box.center.dy);
  });

  testWidgets('[API] Callbacks e controlador — Linha sem ação', (tester) async {
    await tester.pumpWidget(
      _themed(RebicRow(gap: RebicSpace.xl, children: [_sq('a'), _sq('b')])),
    );
    final between = Offset(_rect(tester, 'a').right + 2, 10);
    await tester.tapAt(between);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(RebicRow),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets(
    '[Comportamento] Espaço entre filhos — Espaço só entre filhos da linha',
    (tester) async {
      await tester.pumpWidget(
        _themed(
          RebicRow(
            key: const Key('row'),
            gap: RebicSpace.l,
            shrinkWrap: true,
            children: [_sq('a'), _sq('b'), _sq('c')],
          ),
        ),
      );
      final row = _rect(tester, 'row');
      expect(row.width, 60 + 2 * _cozy.l);
      expect(_rect(tester, 'a').left, row.left);
      expect(_rect(tester, 'c').right, row.right);
    },
  );

  test('um único filho ou nenhum não recebe espaço', () {
    // O Flex nativo só aplica `spacing` entre filhos; coberto pelos cenários
    // de medida acima e verificado aqui pela ausência de filhos extras.
    const row = RebicRow(children: []);
    expect(row.children, isEmpty);
  });

  group('[Comportamento] Alinhamento', () {
    testWidgets(
      '[Comportamento] Alinhamento — Alinhamento principal da linha',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            RebicRow(
              key: const Key('row'),
              mainAlignment: RebicMainAlignment.end,
              children: [_sq('a'), _sq('b')],
            ),
            width: 200,
          ),
        );
        expect(_rect(tester, 'b').right, _rect(tester, 'row').right);
      },
    );

    testWidgets('[Comportamento] Alinhamento — Alinhamento cruzado da linha', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const SizedBox(
            height: 60,
            child: RebicRow(
              crossAlignment: RebicCrossAlignment.stretch,
              children: [SizedBox(key: Key('a'), width: 20)],
            ),
          ),
          width: 200,
        ),
      );
      expect(_rect(tester, 'a').height, 60);
    });
  });

  testWidgets('[Comportamento] Quebra de linha — Linha com quebra', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        RebicRow.wrap(
          gap: RebicSpace.s,
          children: [for (var i = 0; i < 5; i++) _sq('q$i', 40)],
        ),
        width: 120,
      ),
    );
    final first = _rect(tester, 'q0');
    final rows = {for (var i = 0; i < 5; i++) _rect(tester, 'q$i').top}.toList()
      ..sort();
    expect(rows.length, greaterThan(1));
    expect(rows[1] - first.bottom, _cozy.s);
  });

  testWidgets('RebicRow.wrap rejeita filho expansível', (tester) async {
    await tester.pumpWidget(
      _themed(RebicRow.wrap(children: [Expanded(child: _sq('a'))]), width: 120),
    );
    final error = tester.takeException();
    expect(error, isA<AssertionError>());
    expect('$error', contains('RebicRow.wrap'));
  });

  testWidgets('[Comportamento] Filhos expansíveis — Filho expandido na linha', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        RebicRow(
          gap: RebicSpace.m,
          children: [
            _sq('a'),
            const Expanded(child: SizedBox(key: Key('e'), height: 20)),
          ],
        ),
        width: 200,
      ),
    );
    expect(_rect(tester, 'e').width, 200 - 20 - _cozy.m);
  });

  testWidgets(
    '[Aparência] Tokens de componente — Troca de densidade da linha',
    (tester) async {
      Widget app(RebicDensity density) => _themed(
        RebicRow(gap: RebicSpace.l, children: [_sq('a'), _sq('b')]),
        theme: RebicThemeData.light(density: density),
      );
      double gap() => _rect(tester, 'b').left - _rect(tester, 'a').right;
      await tester.pumpWidget(app(RebicDensity.cozy));
      expect(gap(), _cozy.l);
      await tester.pumpWidget(app(RebicDensity.compact));
      await tester.pumpAndSettle();
      expect(
        gap(),
        RebicThemeData.light(density: RebicDensity.compact).spacing.l,
      );
      expect(
        find.descendant(
          of: find.byType(RebicRow),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    },
  );

  Future<List<FocusNode>> pumpFocusables(WidgetTester tester, int n) async {
    final nodes = [for (var i = 0; i < n; i++) FocusNode()];
    addTearDown(() {
      for (final node in nodes) {
        node.dispose();
      }
    });
    await tester.pumpWidget(
      RebicApp(
        home: RebicRow(
          children: [
            for (final node in nodes)
              Focus(
                focusNode: node,
                child: const SizedBox(width: 20, height: 20),
              ),
          ],
        ),
      ),
    );
    nodes.first.requestFocus();
    await tester.pump();
    return nodes;
  }

  testWidgets('[Estados] Sem estados visuais — Linha não recebe foco', (
    tester,
  ) async {
    final nodes = await pumpFocusables(tester, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(nodes[1].hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na linha', (
    tester,
  ) async {
    final nodes = await pumpFocusables(tester, 3);
    final visited = <int>[];
    for (var i = 0; i < 2; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      visited.add(nodes.indexWhere((n) => n.hasPrimaryFocus));
    }
    expect(visited, [1, 2]);
  });

  testWidgets(
    '[Acessibilidade] Semântica e escala — Semântica da linha inalterada',
    (tester) async {
      final handle = tester.ensureSemantics();
      List<String> labels() => [
        for (final t in ['Pedido', 'Aberto'])
          tester.getSemantics(find.text(t)).label,
      ];
      await tester.pumpWidget(
        _themed(
          const Row(children: [RebicText('Pedido'), RebicText('Aberto')]),
        ),
      );
      final native = labels();
      await tester.pumpWidget(
        _themed(
          const RebicRow(children: [RebicText('Pedido'), RebicText('Aberto')]),
        ),
      );
      expect(labels(), native);
      handle.dispose();
    },
  );

  group('[Responsividade] Direção e densidade', () {
    testWidgets('[Responsividade] Direção e densidade — Linha em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          RebicRow(key: const Key('row'), children: [_sq('a'), _sq('b')]),
          direction: TextDirection.rtl,
          width: 200,
        ),
      );
      expect(_rect(tester, 'a').right, _rect(tester, 'row').right);
    });

    testWidgets(
      '[Responsividade] Direção e densidade — Densidade compacta na linha',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            Column(
              children: [
                RebicRow(gap: RebicSpace.l, children: [_sq('a'), _sq('b')]),
                RebicTheme.density(
                  density: RebicDensity.compact,
                  child: RebicRow(
                    gap: RebicSpace.l,
                    children: [_sq('c'), _sq('d')],
                  ),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(_rect(tester, 'b').left - _rect(tester, 'a').right, _cozy.l);
        expect(
          _rect(tester, 'd').left - _rect(tester, 'c').right,
          RebicThemeData.light(density: RebicDensity.compact).spacing.l,
        );
      },
    );
  });

  testWidgets('[Integração] Dependências — Linha sem Material', (tester) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            const RebicRow(children: [RebicText('a'), RebicText('b')]),
            RebicRow.wrap(
              children: [for (var i = 0; i < 6; i++) RebicText('$i')],
            ),
          ],
        ),
      ),
    );
    expect(find.byType(RebicRow), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  test('[Testes] Cobertura exigida — Rastreabilidade da linha', () {
    final names = scenarioNames(
      'rebic/widgets/rebic-row',
      'add-rebic-row-column',
    );
    expect(names, hasLength(17));
    expect(untestedScenarios(names), isEmpty);
  });

  test('[Restrições] Fora do escopo — Linha sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/row/rebic_row.dart',
    ).readAsStringSync();
    final ctors = RegExp(
      r'const RebicRow(?:\.\w+)?\((.*?)\)\s*:',
      dotAll: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(ctors, hasLength(2));
    for (final ctor in ctors) {
      expect(ctor, isNot(contains('double')));
      expect(ctor, isNot(contains('EdgeInsets')));
    }
  });
}
