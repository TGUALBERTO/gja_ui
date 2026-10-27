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

const _d = Key('divider');
final _line = const BorderSide().width;

/// Monta [child] sob [theme], na direção [direction], numa coluna de 300.
Widget _themed(
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
      child: SizedBox(width: 300, child: child),
    ),
  ),
);

RebicSpacingTokens get _comfortable => RebicThemeData.light().spacing;

/// Retângulo da linha pintada (o `ColoredBox`) do divisor de chave [_d].
Rect _stroke(WidgetTester tester) => tester.getRect(
  find.descendant(of: find.byKey(_d), matching: find.byType(ColoredBox)),
);

Color _color(WidgetTester tester) => tester
    .widget<ColoredBox>(
      find.descendant(of: find.byKey(_d), matching: find.byType(ColoredBox)),
    )
    .color;

/// Amostra dos goldens: lista com divisores sutis, bloco com divisor forte e
/// barra com divisores verticais.
Widget _sample() => const RebicColumn(
  gap: RebicSpace.l,
  children: [
    RebicColumn(
      gap: RebicSpace.none,
      children: [
        RebicText('Item 1'),
        RebicDivider(spacing: RebicSpace.s),
        RebicText('Item 2'),
        RebicDivider(spacing: RebicSpace.s),
        RebicText('Item 3'),
      ],
    ),
    RebicColumn(
      gap: RebicSpace.none,
      children: [
        RebicText('Cabeçalho', variant: RebicTextVariant.title),
        RebicDivider(
          tone: RebicDividerTone.strong,
          spacing: RebicSpace.s,
          indent: RebicSpace.l,
        ),
        RebicText('Conteúdo'),
      ],
    ),
    SizedBox(
      height: 32,
      child: RebicRow(
        crossAlignment: RebicCrossAlignment.stretch,
        children: [
          Center(child: RebicText('Salvar')),
          RebicDivider.vertical(),
          Center(child: RebicText('Copiar')),
          RebicDivider.vertical(tone: RebicDividerTone.strong),
          Center(child: RebicText('Excluir')),
        ],
      ),
    ),
  ],
);

void main() {
  setUpAll(loadRebicFonts);

  testWidgets('[API] Propriedades — Divisor mínimo', (tester) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 300, child: RebicDivider(key: _d)),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(_d)), Size(300, _line));
    expect(_color(tester), RebicThemeData.light().colors.separator);
  });

  testWidgets('[API] Callbacks e controlador — Divisor sem ação', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(const RebicDivider(key: _d, spacing: RebicSpace.l)),
    );
    await tester.tapAt(tester.getCenter(find.byKey(_d)));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byKey(_d),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('[Comportamento] Orientação — Divisor vertical numa linha', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const SizedBox(
          height: 40,
          child: RebicRow(
            crossAlignment: RebicCrossAlignment.stretch,
            children: [
              RebicText('a'),
              RebicDivider.vertical(key: _d, spacing: RebicSpace.s),
              RebicText('b'),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byKey(_d)),
      Size(_line + 2 * _comfortable.s, 40),
    );
  });

  testWidgets('[Comportamento] Recuo direcional — Recuo em LTR e RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(const RebicDivider(key: _d, indent: RebicSpace.l)),
    );
    final ltr = _stroke(tester);
    expect(ltr.left, _comfortable.l);
    expect(ltr.width, 300 - _comfortable.l);

    await tester.pumpWidget(
      _themed(
        const RebicDivider(key: _d, indent: RebicSpace.l),
        direction: TextDirection.rtl,
      ),
    );
    final rtl = _stroke(tester);
    expect(rtl.right, 300 - _comfortable.l);
    expect(rtl.width, 300 - _comfortable.l);
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Troca de tema do divisor', (
      tester,
    ) async {
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        await tester.pumpWidget(
          _themed(
            const RebicDivider(key: _d, tone: RebicDividerTone.strong),
            theme: theme,
          ),
        );
        await tester.pumpAndSettle();
        expect(_color(tester), theme.colors.fieldBorder);
      }
    });

    testWidgets('[Aparência] Tokens de componente — Tons do divisor', (
      tester,
    ) async {
      final c = RebicThemeData.light().colors;
      for (final (tone, color) in [
        (RebicDividerTone.subtle, c.separator),
        (RebicDividerTone.strong, c.fieldBorder),
      ]) {
        await tester.pumpWidget(_themed(RebicDivider(key: _d, tone: tone)));
        expect(_color(tester), color, reason: tone.name);
      }
    });
  });

  testWidgets('[Estados] Sem estados de interação — Divisor não recebe foco', (
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
            const RebicDivider(),
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

  testWidgets(
    '[Acessibilidade] Teclado e foco — Teclas ignoradas pelo divisor',
    (tester) async {
      await tester.pumpWidget(
        const RebicApp(home: Center(child: RebicDivider())),
      );
      for (final key in [
        LogicalKeyboardKey.tab,
        LogicalKeyboardKey.enter,
        LogicalKeyboardKey.space,
      ]) {
        await tester.sendKeyEvent(key);
        await tester.pump();
      }
      expect(find.byType(RebicDivider), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Divisor fora da semântica',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _themed(
            const Column(
              children: [
                RebicText('Antes'),
                RebicDivider(key: _d),
                RebicText('Depois'),
              ],
            ),
          ),
        );
        final labels = <String>[];
        bool visit(SemanticsNode node) {
          if (node.label.isNotEmpty) labels.add(node.label);
          node.visitChildren(visit);
          return true;
        }

        visit(
          tester
              .binding
              .renderViews
              .first
              .owner!
              .semanticsOwner!
              .rootSemanticsNode!,
        );
        expect(labels.join('\n').split('\n'), ['Antes', 'Depois']);
        expect(
          find.descendant(
            of: find.byKey(_d),
            matching: find.byType(ExcludeSemantics),
          ),
          findsOneWidget,
        );
        handle.dispose();
      },
    );

    test('[Acessibilidade] Semântica e contraste — Contraste do tom forte', () {
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        final c = theme.colors;
        for (final ground in [c.base, c.background]) {
          expect(
            rebicContrastRatioOver(c.fieldBorder, ground),
            greaterThanOrEqualTo(3),
            reason: theme.brightness.name,
          );
        }
      }
    });
  });

  testWidgets('[Responsividade] Densidade — Densidade compacta do divisor', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const Column(
          children: [
            RebicDivider(key: Key('comfortable'), spacing: RebicSpace.l),
            RebicTheme.density(
              density: RebicDensity.compact,
              child: RebicDivider(key: Key('compact'), spacing: RebicSpace.l),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final compact = RebicThemeData.light(density: RebicDensity.compact).spacing;
    expect(
      tester.getSize(find.byKey(const Key('comfortable'))).height,
      _line + 2 * _comfortable.l,
    );
    expect(
      tester.getSize(find.byKey(const Key('compact'))).height,
      _line + 2 * compact.l,
    );
  });

  testWidgets('[Integração] Dependências — Divisor sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Column(
          children: [
            RebicDivider(),
            RebicDivider(tone: RebicDividerTone.strong),
            SizedBox(
              height: 40,
              child: RebicRow(
                crossAlignment: RebicCrossAlignment.stretch,
                children: [
                  RebicDivider.vertical(),
                  RebicDivider.vertical(tone: RebicDividerTone.strong),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    expect(find.byType(RebicDivider), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    testWidgets('[Testes] Cobertura exigida — Goldens do divisor', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_divider_$name',
          theme: theme,
          child: SizedBox(width: 360, child: _sample()),
          size: const Size(420, 320),
        );
      }
    }, tags: ['golden']);

    test('[Testes] Cobertura exigida — Rastreabilidade do divisor', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-divider',
        'add-rebic-divider',
      );
      expect(names, hasLength(16));
      expect(untestedScenarios(names), isEmpty);
    });
  });

  test('[Restrições] Fora do escopo — Divisor sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/divider/rebic_divider.dart',
    ).readAsStringSync();
    final ctors = RegExp(
      r'const RebicDivider(?:\.\w+)?\((.*?)\)\s*:',
      dotAll: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(ctors, hasLength(2));
    for (final ctor in ctors) {
      for (final type in ['Color', 'double', 'EdgeInsets']) {
        expect(ctor, isNot(contains(type)), reason: type);
      }
    }
  });
}
