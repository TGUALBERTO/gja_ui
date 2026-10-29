import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/golden.dart';

/// Monta [child] sob [theme], na direção [direction].
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

Icon _icon(WidgetTester tester, [Finder? within]) => tester.widget<Icon>(
  within == null
      ? find.byType(Icon)
      : find.descendant(of: within, matching: find.byType(Icon)),
);

/// Se o glifo de [finder] é desenhado espelhado no eixo horizontal.
bool _mirrored(WidgetTester tester, Finder finder) {
  final transforms = tester.widgetList<Transform>(
    find.descendant(of: finder, matching: find.byType(Transform)),
  );
  return transforms.any((t) => t.transform.storage[0] == -1);
}

Directory get _repo => Directory.current.parent.parent;

Color _toneColor(RebicColorTokens c, RebicIconTone tone) => switch (tone) {
  RebicIconTone.standard => c.text,
  RebicIconTone.muted => c.label,
  RebicIconTone.brand => c.brand,
  RebicIconTone.success => c.stateColors(RebicValueState.success).foreground,
  RebicIconTone.warning => c.stateColors(RebicValueState.warning).foreground,
  RebicIconTone.error => c.stateColors(RebicValueState.error).foreground,
  RebicIconTone.information =>
    c.stateColors(RebicValueState.information).foreground,
};

double _tokenSize(RebicIconTokens t, RebicIconSize size) =>
    t.values[size.name]!;

/// Amostra dos goldens: tamanhos, tons e um direcional em LTR e RTL.
Widget _sample() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        for (final s in RebicIconSize.values)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RebicIcon(RebicIcons.search, size: s),
          ),
      ],
    ),
    const SizedBox(height: 16),
    Row(
      children: [
        for (final t in RebicIconTone.values)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RebicIcon(
              RebicIcons.info,
              size: RebicIconSize.large,
              tone: t,
            ),
          ),
      ],
    ),
    const SizedBox(height: 16),
    const Row(
      children: [
        RebicIcon(RebicIcons.chevronRight, size: RebicIconSize.large),
        SizedBox(width: 16),
        Directionality(
          textDirection: TextDirection.rtl,
          child: RebicIcon(RebicIcons.chevronRight, size: RebicIconSize.large),
        ),
      ],
    ),
  ],
);

void main() {
  setUpAll(loadRebicFonts);

  testWidgets('[API] Propriedades — Uso mínimo', (tester) async {
    final handle = tester.ensureSemantics();
    final theme = RebicThemeData.light();
    await tester.pumpWidget(
      RebicApp(
        themeMode: RebicThemeMode.light,
        density: RebicDensity.cozy,
        home: const Center(
          child: RebicIcon(RebicIcons.search, key: Key('icon')),
        ),
      ),
    );
    final icon = _icon(tester);
    expect(icon.size, theme.icons.control);
    expect(icon.color, theme.colors.text);
    expect(
      tester.getSize(find.byKey(const Key('icon'))),
      Size.square(theme.icons.control),
    );
    expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
    handle.dispose();
  });

  testWidgets('[API] Callbacks e controlador — Sem ação', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _themed(const RebicIcon(RebicIcons.info, semanticLabel: 'Detalhes')),
    );
    await tester.tap(find.byType(RebicIcon));
    await tester.pump();
    final data = tester
        .getSemantics(find.bySemanticsLabel('Detalhes'))
        .getSemanticsData();
    expect(data.hasAction(SemanticsAction.tap), isFalse);
    handle.dispose();
  });

  testWidgets('[Comportamento] Espelhamento em RTL — Direcional em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const Row(
          children: [
            RebicIcon(RebicIcons.chevronRight, key: Key('chevron')),
            RebicIcon(RebicIcons.check, key: Key('check')),
          ],
        ),
        direction: TextDirection.rtl,
      ),
    );
    expect(_mirrored(tester, find.byKey(const Key('chevron'))), isTrue);
    expect(_mirrored(tester, find.byKey(const Key('check'))), isFalse);

    await tester.pumpWidget(
      _themed(const RebicIcon(RebicIcons.chevronRight, key: Key('chevron'))),
    );
    expect(_mirrored(tester, find.byKey(const Key('chevron'))), isFalse);
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Troca de tema', (
      tester,
    ) async {
      final light = RebicThemeData.light();
      final dark = RebicThemeData.dark();
      Widget app(RebicThemeData theme) => _themed(
        const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
        theme: theme,
      );
      await tester.pumpWidget(app(light));
      expect(_icon(tester).color, light.colors.brand);
      await tester.pumpWidget(app(dark));
      await tester.pumpAndSettle();
      expect(_icon(tester).color, dark.colors.brand);
    });

    testWidgets('[Aparência] Tokens de componente — Tamanhos e tons', (
      tester,
    ) async {
      final theme = RebicThemeData.light();
      for (final size in RebicIconSize.values) {
        for (final tone in RebicIconTone.values) {
          final reason = '${size.name}/${tone.name}';
          await tester.pumpWidget(
            _themed(
              RebicIcon(
                RebicIcons.add,
                key: const Key('i'),
                size: size,
                tone: tone,
              ),
            ),
          );
          final expected = _tokenSize(theme.icons, size);
          expect(
            tester.getSize(find.byKey(const Key('i'))),
            Size.square(expected),
            reason: reason,
          );
          expect(
            _icon(tester).color,
            _toneColor(theme.colors, tone),
            reason: reason,
          );
        }
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
            Focus(
              focusNode: first,
              child: const SizedBox(width: 20, height: 20),
            ),
            const RebicIcon(RebicIcons.info),
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

  testWidgets('[Acessibilidade] Teclado e foco — Teclas ignoradas', (
    tester,
  ) async {
    await tester.pumpWidget(
      const RebicApp(home: Center(child: RebicIcon(RebicIcons.info))),
    );
    for (final key in [
      LogicalKeyboardKey.tab,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.space,
    ]) {
      await tester.sendKeyEvent(key);
      await tester.pump();
    }
    expect(find.byType(RebicIcon), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets('[Acessibilidade] Semântica e contraste — Ícone decorativo', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_themed(const RebicIcon(RebicIcons.search)));
      final node = tester.getSemantics(find.byType(RebicIcon));
      // O ícone decorativo não cria nó próprio: o nó encontrado é o da raiz,
      // sem rótulo nem papel de imagem.
      expect(node.label, isEmpty);
      expect(node.getSemanticsData().hasFlag(SemanticsFlag.isImage), isFalse);
      handle.dispose();
    });

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Ícone com significado',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _themed(
            const RebicIcon(
              RebicIcons.warning,
              tone: RebicIconTone.warning,
              semanticLabel: 'Aviso',
            ),
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('Aviso')),
          matchesSemantics(label: 'Aviso', isImage: true),
        );
        handle.dispose();
      },
    );

    test('[Acessibilidade] Semântica e contraste — Contraste dos tons', () {
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        final c = theme.colors;
        for (final tone in RebicIconTone.values) {
          for (final (name, ground) in [
            ('base', c.base),
            ('background', c.background),
          ]) {
            expect(
              rebicContrastRatioOver(_toneColor(c, tone), ground),
              greaterThanOrEqualTo(3),
              reason: '${theme.brightness.name}/${tone.name}/$name',
            );
          }
        }
      }
    });
  });

  group('[Responsividade] Escala de texto e densidade', () {
    testWidgets(
      '[Responsividade] Escala de texto e densidade — Escala de texto 2,0',
      (tester) async {
        final theme = RebicThemeData.light();
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: _themed(
              const Row(
                children: [
                  RebicIcon(
                    RebicIcons.info,
                    key: Key('inline'),
                    size: RebicIconSize.inline,
                  ),
                  RebicIcon(RebicIcons.info, key: Key('control')),
                ],
              ),
            ),
          ),
        );
        expect(
          tester.getSize(find.byKey(const Key('inline'))),
          Size.square(theme.icons.inline * 2),
        );
        expect(
          tester.getSize(find.byKey(const Key('control'))),
          Size.square(theme.icons.control),
        );
      },
    );

    testWidgets(
      '[Responsividade] Escala de texto e densidade — Densidade compacta',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            const Row(
              children: [
                RebicIcon(RebicIcons.info, key: Key('cozy')),
                RebicTheme.density(
                  density: RebicDensity.compact,
                  child: RebicIcon(RebicIcons.info, key: Key('compact')),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byKey(const Key('compact'))),
          tester.getSize(find.byKey(const Key('cozy'))),
        );
      },
    );
  });

  testWidgets('[Integração] Dependências — Funciona sem Material', (
    tester,
  ) async {
    final icons = [
      RebicIcons.add,
      RebicIcons.close,
      RebicIcons.search,
      RebicIcons.check,
      RebicIcons.chevronRight,
      RebicIcons.warning,
      RebicIcons.info,
      RebicIcons.home,
    ];
    await tester.pumpWidget(
      RebicApp(home: Wrap(children: [for (final i in icons) RebicIcon(i)])),
    );
    expect(find.byType(RebicIcon), findsNWidgets(icons.length));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    testWidgets('[Testes] Cobertura exigida — Goldens dos tamanhos e tons', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_icon_$name',
          theme: theme,
          child: _sample(),
          size: const Size(480, 240),
        );
      }
    }, tags: ['golden']);

    test('[Testes] Cobertura exigida — Rastreabilidade', () {
      const id = 'rebic/widgets/rebic-icon';
      final spec = [
        File('${_repo.path}/openspec/specs/$id/spec.md'),
        File('${_repo.path}/openspec/changes/add-rebic-icon/specs/$id/spec.md'),
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
  });

  test('[Restrições] Fora do escopo — Sem tamanho nem cor arbitrários', () {
    final source = File(
      'lib/src/fundacao_layout/icon/rebic_icon.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\w+\??) ',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!.replaceAll('?', '')).toSet();
    expect(fields, isNot(contains('double')));
    expect(fields, isNot(contains('Color')));
    final ctor = RegExp(
      r'const RebicIcon\((.*?)\}\);',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    expect(ctor, isNot(contains('double')));
    expect(ctor, isNot(contains('Color')));
  });
}
