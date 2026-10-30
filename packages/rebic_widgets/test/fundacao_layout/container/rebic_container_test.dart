import 'dart:io';
import 'package:flutter/foundation.dart' show Diagnosticable;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/golden.dart';

const _c = Key('container');
const _box = SizedBox(width: 20, height: 20);

/// Monta [child] sob [theme], alinhado ao topo, em LTR.
Widget _themed(Widget child, {RebicThemeData? theme}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Align(alignment: Alignment.topLeft, child: child),
  ),
);

/// Decoração pintada pelo [RebicContainer] de chave [_c].
BoxDecoration _decoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find
                  .descendant(
                    of: find.byKey(_c),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .decoration
        as BoxDecoration;

Finder _clip() =>
    find.descendant(of: find.byKey(_c), matching: find.byType(ClipRRect));

Set<String> _diagnosticNames(Diagnosticable tokens) =>
    tokens.toDiagnosticsNode().getProperties().map((p) => p.name!).toSet();

Directory get _repo => Directory.current.parent.parent;

/// Amostra dos goldens: superfícies, borda, raios, sombras e um cartão.
Widget _sample() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        for (final s in [
          RebicSurface.background,
          RebicSurface.base,
          RebicSurface.header,
          RebicSurface.shell,
        ])
          RebicSpacing.padding(
            end: RebicSpace.s,
            child: RebicContainer(
              surface: s,
              border: true,
              padding: RebicSpace.m,
              // Tamanho `small`, como nos goldens de referência.
              child: Builder(
                builder: (context) {
                  final theme = RebicThemeData.of(context);
                  return Text(
                    's',
                    style: theme.typography.small.copyWith(
                      color: theme.colors.text,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    ),
    RebicSpacing.vertical(RebicSpace.l),
    Row(
      children: [
        for (final r in [
          RebicRadius.button,
          RebicRadius.tile,
          RebicRadius.full,
        ])
          RebicSpacing.padding(
            end: RebicSpace.s,
            child: RebicContainer(
              surface: RebicSurface.base,
              border: true,
              radius: r,
              padding: RebicSpace.l,
            ),
          ),
      ],
    ),
    RebicSpacing.vertical(RebicSpace.l),
    Row(
      children: [
        for (final e in [
          RebicShadow.card,
          RebicShadow.popover,
          RebicShadow.dialog,
          RebicShadow.dragged,
          RebicShadow.header,
        ])
          RebicSpacing.padding(
            end: RebicSpace.l,
            child: RebicContainer(
              surface: RebicSurface.base,
              radius: RebicRadius.button,
              shadow: e,
              padding: RebicSpace.l,
            ),
          ),
      ],
    ),
    RebicSpacing.vertical(RebicSpace.xl),
    RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.tile,
      shadow: RebicShadow.card,
      padding: RebicSpace.l,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RebicTitle('Pedido 4711', titleStyle: RebicTitleLevel.h3),
          RebicSpacing.vertical(RebicSpace.xs),
          RebicLabel('Aguardando aprovação'),
        ],
      ),
    ),
  ],
);

void main() {
  setUpAll(loadRebicFonts);

  testWidgets('[API] Propriedades — Uso mínimo', (tester) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: RebicContainer(key: _c, child: _box),
        ),
      ),
    );
    final d = _decoration(tester);
    expect(d.color, isNull);
    expect(d.border, isNull);
    expect(d.boxShadow, isEmpty);
    expect(tester.getSize(find.byKey(_c)), const Size(20, 20));
    expect(_clip(), findsNothing);
  });

  test('[API] Valores dos papéis — Papéis do fundamento', () {
    final radius = _diagnosticNames(const RebicRadiusTokens.fallback());
    for (final r in RebicRadius.values) {
      expect(radius, contains(r.name), reason: r.name);
    }
    final shadow = _diagnosticNames(const RebicShadowTokens.fallback());
    for (final e in RebicShadow.values) {
      expect(shadow, contains(e.name), reason: e.name);
    }
    expect(RebicSurface.values.map((s) => s.name), [
      'none',
      'background',
      'base',
      'header',
      'shell',
    ]);
  });

  testWidgets('[API] Callbacks e controlador — Sem ação', (tester) async {
    await tester.pumpWidget(
      _themed(
        const RebicContainer(
          key: _c,
          surface: RebicSurface.base,
          padding: RebicSpace.xl,
          child: _box,
        ),
      ),
    );
    await tester.tapAt(tester.getTopLeft(find.byKey(_c)) + const Offset(2, 2));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byKey(_c),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  group('[Comportamento] Recorte nos cantos', () {
    testWidgets('[Comportamento] Recorte nos cantos — Filho recortado', (
      tester,
    ) async {
      final theme = RebicThemeData.light();
      await tester.pumpWidget(
        _themed(
          const RebicContainer(
            key: _c,
            radius: RebicRadius.tile,
            child: ColoredBox(
              color: Color(0xFF000000),
              child: SizedBox(width: 80, height: 40),
            ),
          ),
        ),
      );
      final clip = tester.widget<ClipRRect>(_clip());
      expect(clip.borderRadius, BorderRadius.circular(theme.radius.tile));
    });

    testWidgets('[Comportamento] Recorte nos cantos — Sem raio, sem recorte', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(const RebicContainer(key: _c, child: _box)),
      );
      expect(_clip(), findsNothing);
      expect(_decoration(tester).borderRadius, isNull);
    });
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Troca de tema', (
      tester,
    ) async {
      Widget app(RebicThemeData theme) => _themed(
        const RebicContainer(
          key: _c,
          surface: RebicSurface.base,
          border: true,
          shadow: RebicShadow.card,
          child: _box,
        ),
        theme: theme,
      );
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        await tester.pumpWidget(app(theme));
        await tester.pumpAndSettle();
        final d = _decoration(tester);
        final reason = theme.brightness.name;
        expect(d.color, theme.colors.base, reason: reason);
        expect(
          (d.border! as Border).top.color,
          theme.colors.separator,
          reason: reason,
        );
        expect(
          d.boxShadow,
          theme.shadows.boxShadows(theme.shadows.card, theme.colors.shadow),
          reason: reason,
        );
      }
    });

    testWidgets('[Aparência] Tokens de componente — Superfícies', (
      tester,
    ) async {
      final c = RebicThemeData.light().colors;
      final expected = {
        RebicSurface.none: null,
        RebicSurface.background: c.background,
        RebicSurface.base: c.base,
        RebicSurface.header: c.headerBackground,
        RebicSurface.shell: c.shell,
      };
      for (final MapEntry(key: surface, value: color) in expected.entries) {
        await tester.pumpWidget(
          _themed(RebicContainer(key: _c, surface: surface, child: _box)),
        );
        expect(_decoration(tester).color, color, reason: surface.name);
      }
      expect(expected.keys, RebicSurface.values);
    });

    testWidgets('[Aparência] Tokens de componente — Raio e sombra', (
      tester,
    ) async {
      final theme = RebicThemeData.light();
      final radius = <RebicRadius, double>{
        RebicRadius.xs: theme.radius.xs,
        RebicRadius.s: theme.radius.s,
        RebicRadius.m: theme.radius.m,
        RebicRadius.l: theme.radius.l,
        RebicRadius.xl: theme.radius.xl,
        RebicRadius.full: theme.radius.full,
        RebicRadius.button: theme.radius.button,
        RebicRadius.field: theme.radius.field,
        RebicRadius.popover: theme.radius.popover,
        RebicRadius.element: theme.radius.element,
        RebicRadius.tile: theme.radius.tile,
      };
      for (final MapEntry(key: r, value: v) in radius.entries) {
        await tester.pumpWidget(
          _themed(RebicContainer(key: _c, radius: r, child: _box)),
        );
        expect(
          _decoration(tester).borderRadius,
          BorderRadius.circular(v),
          reason: r.name,
        );
      }
      final e = theme.shadows;
      final shadows = {
        RebicShadow.none: e.none,
        RebicShadow.card: e.card,
        RebicShadow.popover: e.popover,
        RebicShadow.dialog: e.dialog,
        RebicShadow.dragged: e.dragged,
        RebicShadow.header: e.header,
      };
      for (final MapEntry(key: role, value: layers) in shadows.entries) {
        await tester.pumpWidget(
          _themed(RebicContainer(key: _c, shadow: role, child: _box)),
        );
        expect(
          _decoration(tester).boxShadow,
          e.boxShadows(layers, theme.colors.shadow),
          reason: role.name,
        );
      }
    });
  });

  testWidgets('[Estados] Sem estados de interação — Não recebe foco', (
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
            const RebicContainer(surface: RebicSurface.base, child: _box),
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

  testWidgets('[Acessibilidade] Teclado e foco — Ordem preservada', (
    tester,
  ) async {
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(
      RebicApp(
        home: RebicContainer(
          surface: RebicSurface.base,
          radius: RebicRadius.tile,
          padding: RebicSpace.m,
          child: Column(
            children: [
              Focus(focusNode: first, child: _box),
              Focus(focusNode: second, child: _box),
            ],
          ),
        ),
      ),
    );
    first.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Semântica e contraste — Semântica inalterada', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    SemanticsData data() =>
        tester.getSemantics(find.text('Pedido')).getSemanticsData();
    await tester.pumpWidget(_themed(const RebicText('Pedido')));
    final plain = data();
    await tester.pumpWidget(
      _themed(
        const RebicContainer(
          surface: RebicSurface.base,
          border: true,
          radius: RebicRadius.tile,
          shadow: RebicShadow.card,
          padding: RebicSpace.l,
          child: RebicText('Pedido'),
        ),
      ),
    );
    final wrapped = data();
    expect(wrapped.label, plain.label);
    expect(wrapped.flags, plain.flags);
    handle.dispose();
  });

  // "Texto sobre as superfícies" fica em rebic_container_contrast_test.dart,
  // sem a fonte real: a diretriz de contraste mede pixels.

  testWidgets('[Responsividade] Densidade — Densidade compacta', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RebicContainer(
              key: Key('cozy'),
              radius: RebicRadius.tile,
              shadow: RebicShadow.card,
              padding: RebicSpace.l,
              child: _box,
            ),
            RebicTheme.density(
              density: RebicDensity.compact,
              child: RebicContainer(
                key: Key('compact'),
                radius: RebicRadius.tile,
                shadow: RebicShadow.card,
                padding: RebicSpace.l,
                child: _box,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cozy = RebicThemeData.light().spacing.l;
    final compact = RebicThemeData.light(
      density: RebicDensity.compact,
    ).spacing.l;
    expect(
      tester.getSize(find.byKey(const Key('cozy'))),
      Size.square(20 + cozy * 2),
    );
    expect(
      tester.getSize(find.byKey(const Key('compact'))),
      Size.square(20 + compact * 2),
    );
    // Como no Fiori, a densidade não muda o espaçamento.
    expect(compact, cozy);
    BoxDecoration deco(String key) =>
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byKey(Key(key)),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    expect(deco('compact').borderRadius, deco('cozy').borderRadius);
    expect(deco('compact').boxShadow, deco('cozy').boxShadow);
  });

  testWidgets('[Integração] Dependências — Funciona sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            for (final s in RebicSurface.values)
              RebicContainer(
                surface: s,
                border: true,
                radius: RebicRadius.button,
                shadow: RebicShadow.card,
                padding: RebicSpace.s,
                child: RebicText(s.name),
              ),
          ],
        ),
      ),
    );
    expect(find.byType(RebicContainer), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    testWidgets('[Testes] Cobertura exigida — Goldens das superfícies', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_container_$name',
          theme: theme,
          surface: RebicSurface.background,
          child: _sample(),
          size: const Size(520, 420),
        );
      }
    }, tags: ['golden']);

    test('[Testes] Cobertura exigida — Rastreabilidade', () {
      const id = 'rebic/widgets/rebic-container';
      final spec = [
        File('${_repo.path}/openspec/specs/$id/spec.md'),
        File(
          '${_repo.path}/openspec/changes/add-rebic-container/specs/$id/spec.md',
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
      expect(names, hasLength(18));
      expect([
        for (final name in names)
          if (!tests.contains("'$name'")) name,
      ], isEmpty);
    });
  });

  test('[Restrições] Fora do escopo — Sem valores literais', () {
    final source = File(
      'lib/src/fundacao_layout/container/rebic_container.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicContainer\((.*?)\}\);',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    final fields = RegExp(
      r'^  final (\w+)\?? ',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toSet();
    for (final type in [
      'Color',
      'double',
      'BorderRadius',
      'BoxShadow',
      'EdgeInsets',
      'BoxDecoration',
    ]) {
      expect(ctor, isNot(contains(type)), reason: type);
      expect(fields, isNot(contains(type)), reason: type);
    }
  });
}
