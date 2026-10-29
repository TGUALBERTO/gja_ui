import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

const _a = Key('a');
const _b = Key('b');
const _box = SizedBox(width: 20, height: 20);

/// Monta [child] sob [theme], na direção [direction], alinhado ao topo.
Widget _themed(
  Widget child, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Align(alignment: Alignment.topLeft, child: child),
  ),
);

RebicSpacingTokens get _cozy => RebicThemeData.light().spacing;
RebicSpacingTokens get _compact =>
    RebicThemeData.light(density: RebicDensity.compact).spacing;

Directory get _repo => Directory.current.parent.parent;

/// Distâncias do filho [_a] às bordas do [RebicSpacing.padding] que o envolve.
EdgeInsets _insets(WidgetTester tester) {
  final outer = tester.getRect(find.byType(RebicSpacing));
  final inner = tester.getRect(find.byKey(_a));
  return EdgeInsets.fromLTRB(
    inner.left - outer.left,
    inner.top - outer.top,
    outer.right - inner.right,
    outer.bottom - inner.bottom,
  );
}

void main() {
  testWidgets('[API] Propriedades — Uso mínimo', (tester) async {
    await tester.pumpWidget(
      RebicApp(
        density: RebicDensity.cozy,
        home: const Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(key: _a, width: 20, height: 20),
              RebicSpacing.vertical(RebicSpace.m, key: Key('gap')),
              SizedBox(key: _b, width: 20, height: 20),
            ],
          ),
        ),
      ),
    );
    final gap =
        tester.getTopLeft(find.byKey(_b)).dy -
        tester.getBottomLeft(find.byKey(_a)).dy;
    expect(gap, _cozy.m);
    expect(tester.getSize(find.byKey(const Key('gap'))).width, 0);
  });

  test('[API] Valores de espaço — Valores do fundamento', () {
    final names = RebicSpacingTokens.fallback()
        .toDiagnosticsNode()
        .getProperties()
        .map((p) => p.name)
        .toList();
    expect(RebicSpace.values.map((v) => v.name).toList(), names);
  });

  testWidgets('[API] Callbacks e controlador — Sem ação', (tester) async {
    await tester.pumpWidget(
      _themed(const RebicSpacing.padding(all: RebicSpace.xl, child: _box)),
    );
    await tester.tapAt(
      tester.getTopLeft(find.byType(RebicSpacing)) + const Offset(2, 2),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(GestureDetector), findsNothing);
  });

  testWidgets('[Comportamento] Separadores — Separador numa linha', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const Row(
          key: Key('row'),
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(key: _a, width: 20, height: 20),
            RebicSpacing.horizontal(RebicSpace.inlineGap),
            SizedBox(key: _b, width: 20, height: 20),
          ],
        ),
      ),
    );
    final gap =
        tester.getTopLeft(find.byKey(_b)).dx -
        tester.getTopRight(find.byKey(_a)).dx;
    expect(gap, _cozy.inlineGap);
    expect(tester.getSize(find.byKey(const Key('row'))).height, 20);
  });

  group('[Comportamento] Padding direcional', () {
    testWidgets('[Comportamento] Padding direcional — Precedência dos lados', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const RebicSpacing.padding(
            all: RebicSpace.s,
            horizontal: RebicSpace.l,
            start: RebicSpace.xl,
            child: SizedBox(key: _a, width: 20, height: 20),
          ),
        ),
      );
      final s = _cozy;
      expect(_insets(tester), EdgeInsets.fromLTRB(s.xl, s.s, s.l, s.s));
    });

    testWidgets('[Comportamento] Padding direcional — Início em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const RebicSpacing.padding(
            start: RebicSpace.l,
            child: SizedBox(key: _a, width: 20, height: 20),
          ),
          direction: TextDirection.rtl,
        ),
      );
      expect(_insets(tester), EdgeInsets.only(right: _cozy.l));
    });
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Troca de densidade', (
      tester,
    ) async {
      Widget app(RebicDensity density) => _themed(
        const RebicSpacing.vertical(RebicSpace.sectionGap, key: _a),
        theme: RebicThemeData.light(density: density),
      );
      await tester.pumpWidget(app(RebicDensity.cozy));
      expect(tester.getSize(find.byKey(_a)).height, _cozy.sectionGap);
      await tester.pumpWidget(app(RebicDensity.compact));
      await tester.pumpAndSettle();
      // Como no Fiori, a densidade não muda o espaçamento.
      expect(tester.getSize(find.byKey(_a)).height, _cozy.sectionGap);
      final base = RebicThemeData.light();
      final other = base.copyWith(
        density: base.density.copyWith(
          spacing: base.spacing.copyWith(sectionGap: 48),
        ),
      );
      await tester.pumpWidget(
        _themed(
          const RebicSpacing.vertical(RebicSpace.sectionGap, key: _a),
          theme: other,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(_a)).height, 48);
      expect(
        find.descendant(of: find.byKey(_a), matching: find.byType(CustomPaint)),
        findsNothing,
      );
    });

    testWidgets('[Aparência] Tokens de componente — Todos os passos e papéis', (
      tester,
    ) async {
      for (final space in RebicSpace.values) {
        await tester.pumpWidget(_themed(RebicSpacing.vertical(space, key: _a)));
        expect(
          tester.getSize(find.byKey(_a)).height,
          RebicSpacing.resolve(_cozy, space),
          reason: space.name,
        );
      }
      expect(
        [for (final v in RebicSpace.values) RebicSpacing.resolve(_cozy, v)],
        [
          _cozy.none,
          _cozy.xxs,
          _cozy.xs,
          _cozy.s,
          _cozy.m,
          _cozy.l,
          _cozy.xl,
          _cozy.xxl,
          _cozy.xxxl,
          _cozy.inlineGap,
          _cozy.stackGap,
          _cozy.sectionGap,
          _cozy.pageMargin,
        ],
      );
    });
  });

  testWidgets('[Estados] Sem estados visuais — Não recebe foco', (
    tester,
  ) async {
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(
      RebicApp(
        home: Row(
          children: [
            Focus(focusNode: first, child: _box),
            const RebicSpacing.horizontal(RebicSpace.l),
            Focus(focusNode: second, child: _box),
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

  testWidgets('[Acessibilidade] Teclado e foco — Ordem preservada no padding', (
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
            Focus(focusNode: first, child: _box),
            RebicSpacing.padding(
              all: RebicSpace.m,
              child: Focus(focusNode: second, child: _box),
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

  group('[Acessibilidade] Semântica e escala', () {
    testWidgets('[Acessibilidade] Semântica e escala — Semântica inalterada', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      SemanticsData data() =>
          tester.getSemantics(find.text('Pedido')).getSemanticsData();
      await tester.pumpWidget(_themed(const RebicText('Pedido')));
      final plain = data();
      await tester.pumpWidget(
        _themed(
          const RebicSpacing.padding(
            all: RebicSpace.l,
            child: RebicText('Pedido'),
          ),
        ),
      );
      final padded = data();
      expect(padded.label, plain.label);
      expect(padded.flags, plain.flags);
      handle.dispose();
    });

    testWidgets('[Acessibilidade] Semântica e escala — Escala de texto 2,0', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: _themed(const RebicSpacing.vertical(RebicSpace.m, key: _a)),
        ),
      );
      expect(tester.getSize(find.byKey(_a)).height, _cozy.m);
    });
  });

  testWidgets('[Responsividade] Densidade — Densidade compacta', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RebicSpacing.horizontal(RebicSpace.l, key: _a),
            RebicTheme.density(
              density: RebicDensity.compact,
              child: RebicSpacing.horizontal(RebicSpace.l, key: _b),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_a)).width, _cozy.l);
    expect(tester.getSize(find.byKey(_b)).width, _cozy.l);
    expect(_compact.l, _cozy.l);
  });

  testWidgets('[Integração] Dependências — Funciona sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Column(
          children: [
            RebicSpacing.vertical(RebicSpace.m),
            Row(
              children: [
                RebicText('a'),
                RebicSpacing.horizontal(RebicSpace.s),
                RebicText('b'),
              ],
            ),
            RebicSpacing.padding(all: RebicSpace.l, child: RebicText('c')),
          ],
        ),
      ),
    );
    expect(find.byType(RebicSpacing), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  test('[Testes] Cobertura exigida — Rastreabilidade', () {
    const id = 'rebic/widgets/rebic-spacing';
    final spec = [
      File('${_repo.path}/openspec/specs/$id/spec.md'),
      File(
        '${_repo.path}/openspec/changes/add-rebic-spacing/specs/$id/spec.md',
      ),
    ].firstWhere((f) => f.existsSync());
    final names = <String>[];
    String? requirement;
    for (final line in spec.readAsLinesSync()) {
      final req = RegExp(r'^### Requirement: (.+)$').firstMatch(line);
      if (req != null) requirement = req.group(1)!.trim();
      final scen = RegExp(r'^#### Scenario: (.+)$').firstMatch(line);
      if (scen != null) names.add('$requirement — ${scen.group(1)!.trim()}');
    }
    final tests = [
      for (final dir in [
        Directory('${_repo.path}/packages/rebic_widgets/test'),
        Directory('${_repo.path}/apps/rebic_gallery/test'),
      ])
        for (final f in dir.listSync(recursive: true).whereType<File>())
          if (f.path.endsWith('_test.dart')) f.readAsStringSync(),
    ].join('\n');
    expect(names, hasLength(17));
    expect([
      for (final name in names)
        if (!tests.contains("'$name'")) name,
    ], isEmpty);
  });

  test('[Restrições] Fora do escopo — Sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/spacing/rebic_spacing.dart',
    ).readAsStringSync();
    final ctors = RegExp(
      r'const RebicSpacing\.\w+\((.*?)\)\s*:',
      dotAll: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(ctors, hasLength(3));
    for (final ctor in ctors) {
      for (final type in ['double', 'int', 'EdgeInsets']) {
        expect(ctor, isNot(contains(type)), reason: type);
      }
    }
  });
}
