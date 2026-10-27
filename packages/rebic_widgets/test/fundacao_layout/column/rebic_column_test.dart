import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/traceability.dart';

Widget _sq(String key) => SizedBox(key: Key(key), width: 20, height: 20);

/// Monta [child] sob [theme], na direção [direction], numa área fixa.
Widget _themed(
  Widget child, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
  double? width,
  double? height,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, height: height, child: child),
    ),
  ),
);

RebicSpacingTokens get _comfortable => RebicThemeData.light().spacing;

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

void main() {
  testWidgets('[API] Propriedades — Coluna mínima', (tester) async {
    await tester.pumpWidget(
      RebicApp(
        density: RebicDensity.comfortable,
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            key: const Key('box'),
            width: 200,
            height: 200,
            child: RebicColumn(children: [_sq('a'), _sq('b')]),
          ),
        ),
      ),
    );
    final a = _rect(tester, 'a');
    final box = _rect(tester, 'box');
    expect(_rect(tester, 'b').top - a.bottom, _comfortable.stackGap);
    expect(a.topLeft, box.topLeft);
  });

  testWidgets('[API] Callbacks e controlador — Coluna sem ação', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(RebicColumn(gap: RebicSpace.xl, children: [_sq('a'), _sq('b')])),
    );
    await tester.tapAt(Offset(10, _rect(tester, 'a').bottom + 2));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(RebicColumn),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets(
    '[Comportamento] Espaço entre filhos — Espaço só entre filhos da coluna',
    (tester) async {
      await tester.pumpWidget(
        _themed(
          RebicColumn(
            key: const Key('col'),
            gap: RebicSpace.l,
            shrinkWrap: true,
            children: [_sq('a'), _sq('b'), _sq('c')],
          ),
        ),
      );
      final col = _rect(tester, 'col');
      expect(col.height, 60 + 2 * _comfortable.l);
      expect(_rect(tester, 'a').top, col.top);
      expect(_rect(tester, 'c').bottom, col.bottom);
    },
  );

  group('[Comportamento] Alinhamento', () {
    testWidgets(
      '[Comportamento] Alinhamento — Alinhamento principal da coluna',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            RebicColumn(
              key: const Key('col'),
              mainAlignment: RebicMainAlignment.spaceBetween,
              children: [_sq('a'), _sq('b')],
            ),
            height: 200,
          ),
        );
        final col = _rect(tester, 'col');
        expect(_rect(tester, 'a').top, col.top);
        expect(_rect(tester, 'b').bottom, col.bottom);
      },
    );

    testWidgets('[Comportamento] Alinhamento — Alinhamento cruzado da coluna', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const RebicColumn(
            crossAlignment: RebicCrossAlignment.stretch,
            children: [SizedBox(key: Key('a'), height: 20)],
          ),
          width: 200,
          height: 100,
        ),
      );
      expect(_rect(tester, 'a').width, 200);
    });
  });

  testWidgets(
    '[Comportamento] Filhos expansíveis — Filho expandido na coluna',
    (tester) async {
      await tester.pumpWidget(
        _themed(
          RebicColumn(
            gap: RebicSpace.m,
            children: [
              _sq('a'),
              const Expanded(child: SizedBox(key: Key('e'), width: 20)),
            ],
          ),
          height: 200,
        ),
      );
      expect(_rect(tester, 'e').height, 200 - 20 - _comfortable.m);
    },
  );

  testWidgets(
    '[Aparência] Tokens de componente — Troca de densidade da coluna',
    (tester) async {
      Widget app(RebicDensity density) => _themed(
        RebicColumn(gap: RebicSpace.l, children: [_sq('a'), _sq('b')]),
        theme: RebicThemeData.light(density: density),
      );
      double gap() => _rect(tester, 'b').top - _rect(tester, 'a').bottom;
      await tester.pumpWidget(app(RebicDensity.comfortable));
      expect(gap(), _comfortable.l);
      await tester.pumpWidget(app(RebicDensity.compact));
      await tester.pumpAndSettle();
      expect(
        gap(),
        RebicThemeData.light(density: RebicDensity.compact).spacing.l,
      );
      expect(
        find.descendant(
          of: find.byType(RebicColumn),
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
        home: RebicColumn(
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

  testWidgets('[Estados] Sem estados visuais — Coluna não recebe foco', (
    tester,
  ) async {
    final nodes = await pumpFocusables(tester, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(nodes[1].hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na coluna', (
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
    '[Acessibilidade] Semântica e escala — Semântica da coluna inalterada',
    (tester) async {
      final handle = tester.ensureSemantics();
      List<String> labels() => [
        for (final t in ['Pedido', 'Aberto'])
          tester.getSemantics(find.text(t)).label,
      ];
      await tester.pumpWidget(
        _themed(
          const Column(children: [RebicText('Pedido'), RebicText('Aberto')]),
        ),
      );
      final native = labels();
      await tester.pumpWidget(
        _themed(
          const RebicColumn(
            children: [RebicText('Pedido'), RebicText('Aberto')],
          ),
        ),
      );
      expect(labels(), native);
      handle.dispose();
    },
  );

  group('[Responsividade] Direção e densidade', () {
    testWidgets('[Responsividade] Direção e densidade — Coluna em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          RebicColumn(key: const Key('col'), children: [_sq('a')]),
          direction: TextDirection.rtl,
          width: 200,
          height: 100,
        ),
      );
      expect(_rect(tester, 'a').right, _rect(tester, 'col').right);
    });

    testWidgets(
      '[Responsividade] Direção e densidade — Densidade compacta na coluna',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RebicColumn(
                  gap: RebicSpace.l,
                  shrinkWrap: true,
                  children: [_sq('a'), _sq('b')],
                ),
                RebicTheme.density(
                  density: RebicDensity.compact,
                  child: RebicColumn(
                    gap: RebicSpace.l,
                    shrinkWrap: true,
                    children: [_sq('c'), _sq('d')],
                  ),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          _rect(tester, 'b').top - _rect(tester, 'a').bottom,
          _comfortable.l,
        );
        expect(
          _rect(tester, 'd').top - _rect(tester, 'c').bottom,
          RebicThemeData.light(density: RebicDensity.compact).spacing.l,
        );
      },
    );
  });

  testWidgets('[Integração] Dependências — Coluna sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      const RebicApp(
        home: RebicColumn(children: [RebicText('a'), RebicText('b')]),
      ),
    );
    expect(find.byType(RebicColumn), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('[Testes] Cobertura exigida — Rastreabilidade da coluna', () {
    final names = scenarioNames(
      'rebic/widgets/rebic-column',
      'add-rebic-row-column',
    );
    expect(names, hasLength(16));
    expect(untestedScenarios(names), isEmpty);
  });

  test('[Restrições] Fora do escopo — Coluna sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/column/rebic_column.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicColumn\((.*?)\}\);',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    expect(ctor, isNot(contains('double')));
    expect(ctor, isNot(contains('EdgeInsets')));
  });
}
