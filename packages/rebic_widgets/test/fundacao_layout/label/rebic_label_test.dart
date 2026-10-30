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

const _long = 'Fornecedor responsável pela entrega no depósito central';

/// Monta [child] sob [theme] em LTR, sem `RebicApp`.
Widget _themed(Widget child, {RebicThemeData? theme}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(textDirection: TextDirection.ltr, child: child),
);

/// Monta [child] numa coluna de largura [width], alinhada ao topo.
Widget _column(double width, Widget child, {RebicThemeData? theme}) => _themed(
  Align(
    alignment: Alignment.topLeft,
    child: SizedBox(width: width, child: child),
  ),
  theme: theme,
);

RenderParagraph _paragraph(WidgetTester tester, String text) =>
    tester.renderObject<RenderParagraph>(find.text(text));

TextStyle _style(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

SemanticsData _semantics(WidgetTester tester) =>
    tester.getSemantics(find.byType(RebicLabel)).getSemanticsData();

/// Amostra dos goldens: os dois desenhos com e sem sinais, e um truncado.
Widget _sample() => const SizedBox(
  width: 240,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      RebicLabel('Fornecedor'),
      RebicLabel('Fornecedor', showColon: true, required: true),
      RebicLabel('Fornecedor', design: RebicLabelDesign.bold),
      RebicLabel(
        'Fornecedor',
        design: RebicLabelDesign.bold,
        showColon: true,
        required: true,
      ),
      RebicLabel(_long, showColon: true, required: true),
    ],
  ),
);

void main() {
  setUpAll(loadRebicFonts);

  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Uso mínimo', (tester) async {
      final theme = RebicThemeData.light();
      await tester.pumpWidget(
        RebicApp(
          themeMode: RebicThemeMode.light,
          home: const Center(child: RebicLabel('Fornecedor')),
        ),
      );
      final style = _style(tester, 'Fornecedor');
      expect(style.fontSize, theme.typography.base.fontSize);
      expect(style.color, theme.colors.label);
      expect(tester.widget<Text>(find.text('Fornecedor')).maxLines, 1);
      expect(find.text(':'), findsNothing);
      expect(find.text('*'), findsNothing);
    });

    test('[API] Propriedades — Desenhos do rótulo', () {
      expect(RebicLabelDesign.values.map((d) => d.name), ['standard', 'bold']);
    });
  });

  testWidgets('[API] Callbacks e controlador — Rótulo sem ação', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_themed(const Center(child: RebicLabel('Total'))));
    await tester.tap(find.text('Total'));
    await tester.pump();
    expect(_semantics(tester).hasAction(SemanticsAction.tap), isFalse);
    handle.dispose();
  });

  group('[Comportamento] Dois-pontos e obrigatório', () {
    testWidgets(
      '[Comportamento] Dois-pontos e obrigatório — Rótulo com dois-pontos e obrigatório',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            const Center(
              child: RebicLabel('Fornecedor', showColon: true, required: true),
            ),
          ),
        );
        final text = tester.getRect(find.text('Fornecedor'));
        final colon = tester.getRect(find.text(':'));
        final asterisk = tester.getRect(find.text('*'));
        expect(text.right, lessThanOrEqualTo(colon.left));
        expect(colon.right, lessThanOrEqualTo(asterisk.left));
      },
    );

    testWidgets(
      '[Comportamento] Dois-pontos e obrigatório — Sinais com texto truncado',
      (tester) async {
        await tester.pumpWidget(
          _column(
            160,
            const RebicLabel(_long, showColon: true, required: true),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(_paragraph(tester, _long).didExceedMaxLines, isTrue);
        expect(
          tester.widget<Text>(find.text(_long)).overflow,
          TextOverflow.ellipsis,
        );
        final asterisk = tester.getRect(find.text('*'));
        expect(tester.getRect(find.text(':')).width, greaterThan(0));
        expect(asterisk.width, greaterThan(0));
        expect(asterisk.right, lessThanOrEqualTo(160));
      },
    );
  });

  group('[Comportamento] Quebra de linhas', () {
    testWidgets('[Comportamento] Quebra de linhas — Rótulo truncado', (
      tester,
    ) async {
      await tester.pumpWidget(_column(160, const RebicLabel('x')));
      final line = _paragraph(tester, 'x').size.height;
      await tester.pumpWidget(_column(160, const RebicLabel(_long)));
      final cut = _paragraph(tester, _long);
      expect(cut.didExceedMaxLines, isTrue);
      expect(cut.size.height, closeTo(line, 0.5));
      expect(
        tester.widget<Text>(find.text(_long)).overflow,
        TextOverflow.ellipsis,
      );
    });

    testWidgets('[Comportamento] Quebra de linhas — Rótulo com quebra', (
      tester,
    ) async {
      await tester.pumpWidget(_column(160, const RebicLabel('x')));
      final line = _paragraph(tester, 'x').size.height;
      await tester.pumpWidget(
        _column(160, const RebicLabel(_long, wrapping: true)),
      );
      final paragraph = _paragraph(tester, _long);
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(paragraph.size.height, greaterThanOrEqualTo(line * 2 - 0.5));
    });
  });

  group('[Aparência] Estilo e cor', () {
    testWidgets('[Aparência] Estilo e cor — Desenhos e sinais', (tester) async {
      final theme = RebicThemeData.light();
      for (final design in RebicLabelDesign.values) {
        final expected = switch (design) {
          RebicLabelDesign.standard => theme.typography.base,
          RebicLabelDesign.bold => theme.typography.baseBold,
        };
        for (final wrapping in [false, true]) {
          await tester.pumpWidget(
            _themed(
              RebicLabel(
                'Fornecedor',
                key: ValueKey((design, wrapping)),
                design: design,
                required: true,
                wrapping: wrapping,
              ),
            ),
          );
          // Com quebra, o texto e o asterisco ficam no mesmo parágrafo; sem
          // quebra, em parágrafos separados.
          TextStyle styleOf(String text) {
            final paragraph = tester
                .renderObjectList<RenderParagraph>(find.byType(RichText))
                .firstWhere((p) => p.text.toPlainText().contains(text));
            TextStyle? found;
            paragraph.text.visitChildren((span) {
              if (span is TextSpan && span.text == text) {
                found = span.style;
              }
              return found == null;
            });
            return (paragraph.text.style ?? const TextStyle()).merge(found);
          }

          final reason = '${design.name}, wrapping: $wrapping';
          final text = styleOf('Fornecedor');
          expect(text.fontSize, expected.fontSize, reason: reason);
          expect(text.fontWeight, expected.fontWeight, reason: reason);
          expect(text.color, theme.colors.label, reason: reason);
          final asterisk = styleOf('*');
          expect(asterisk.fontWeight, expected.fontWeight, reason: reason);
          expect(asterisk.color, theme.colors.required, reason: reason);
        }
      }
    });

    testWidgets('[Aparência] Estilo e cor — Troca de tema do rótulo', (
      tester,
    ) async {
      final light = RebicThemeData.light();
      final dark = RebicThemeData.dark();
      Widget app(RebicThemeData theme) => _themed(
        const Center(child: RebicLabel('Fornecedor', required: true)),
        theme: theme,
      );
      await tester.pumpWidget(app(light));
      expect(_style(tester, 'Fornecedor').color, light.colors.label);
      expect(_style(tester, '*').color, light.colors.required);
      await tester.pumpWidget(app(dark));
      await tester.pumpAndSettle();
      expect(_style(tester, 'Fornecedor').color, dark.colors.label);
      expect(_style(tester, '*').color, dark.colors.required);
    });
  });

  testWidgets('[Estados] Sem estados de interação — Rótulo não recebe foco', (
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
            const RebicLabel('Entre os dois', required: true),
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
    '[Acessibilidade] Teclado e foco — Teclas ignoradas pelo rótulo',
    (tester) async {
      await tester.pumpWidget(
        const RebicApp(home: Center(child: RebicLabel('Somente leitura'))),
      );
      for (final key in [
        LogicalKeyboardKey.tab,
        LogicalKeyboardKey.enter,
        LogicalKeyboardKey.space,
      ]) {
        await tester.sendKeyEvent(key);
        await tester.pump();
      }
      expect(find.text('Somente leitura'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Leitor de tela no rótulo',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          const RebicApp(
            locale: Locale('pt', 'BR'),
            home: Center(
              child: RebicLabel('Fornecedor', showColon: true, required: true),
            ),
          ),
        );
        final data = _semantics(tester);
        expect(data.label, 'Fornecedor:, Obrigatório');
        expect(data.hasFlag(SemanticsFlag.isHeader), isFalse);
        handle.dispose();
      },
    );

    // "Contraste do rótulo" fica em rebic_label_contrast_test.dart, sem a
    // fonte real: a diretriz de contraste mede pixels e precisa dos glifos
    // sólidos da fonte de teste padrão.

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Rótulo com escala de texto 2,0',
      (tester) async {
        final theme = RebicThemeData.light();
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: _column(
              320,
              const RebicLabel(_long, wrapping: true, required: true),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        final size = theme.typography.base.fontSize!;
        final paragraph = tester.renderObject<RenderParagraph>(
          find.byType(RichText),
        );
        expect(paragraph.textScaler.scale(size), size * 2);
      },
    );
  });

  testWidgets(
    '[Responsividade] Tamanhos de tela e densidade — Rótulo na densidade compacta',
    (tester) async {
      await tester.pumpWidget(
        _themed(
          const Row(
            children: [
              RebicLabel('confortável'),
              RebicTheme.density(
                density: RebicDensity.compact,
                child: RebicLabel('compacta'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_style(tester, 'compacta'), _style(tester, 'confortável'));
    },
  );

  testWidgets('[Integração] Dependências — Rótulo sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(RebicApp(home: ListView(children: [_sample()])));
    expect(find.byType(RebicLabel), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    testWidgets('[Testes] Cobertura exigida — Goldens do rótulo', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_label_$name',
          theme: theme,
          child: _sample(),
        );
      }
    }, tags: ['golden']);

    test('[Testes] Cobertura exigida — Rastreabilidade do rótulo', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-label',
        'update-rebic-text-fiori-title-text-label',
      );
      expect(names, hasLength(20));
      expect(untestedScenarios(names), isEmpty);
    });
  });

  test('[Restrições] Fora do escopo — Rótulo sem cor arbitrária', () {
    final source = File(
      'lib/src/fundacao_layout/label/rebic_label.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicLabel\((.*?)\);',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    for (final name in ['Color', 'TextStyle', 'maxLines', 'labelFor']) {
      expect(ctor, isNot(contains(name)), reason: name);
    }
    final fields = RegExp(
      r'^  final (\w+\??) ',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!.replaceAll('?', ''));
    for (final type in ['Color', 'TextStyle', 'Widget', 'int']) {
      expect(fields, isNot(contains(type)), reason: type);
    }
  });
}
