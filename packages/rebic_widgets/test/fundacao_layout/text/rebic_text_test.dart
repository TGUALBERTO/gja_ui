import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/golden.dart';

const _long =
    'O pedido de compra 4711 aguarda aprovação do centro de custo antes de ser '
    'enviado ao fornecedor, e a entrega prevista depende da confirmação do '
    'estoque no depósito central.';

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

/// Altura de uma linha de `body` e número de linhas de [text].
Future<(double, int)> _lines(WidgetTester tester, String text) async {
  final height = _paragraph(tester, text).size.height;
  await tester.pumpWidget(_column(240, const RebicText('x')));
  final line = _paragraph(tester, 'x').size.height;
  return (line, (height / line).round());
}

Directory get _repo => Directory.current.parent.parent;

/// Amostra dos goldens e da página: variantes, tons e um texto truncado.
Widget _sample() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final v in RebicTextVariant.values) RebicText(v.name, variant: v),
    for (final t in RebicTextTone.values) RebicText('tom ${t.name}', tone: t),
    const RebicText(_long, maxLines: 2),
  ],
);

void main() {
  setUpAll(loadRebicFonts);

  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Uso mínimo', (tester) async {
      final handle = tester.ensureSemantics();
      final theme = RebicThemeData.light();
      await tester.pumpWidget(
        RebicApp(
          themeMode: RebicThemeMode.light,
          home: const Center(child: RebicText('Pedido 4711')),
        ),
      );
      final style = _style(tester, 'Pedido 4711');
      expect(style.fontSize, theme.typography.body.fontSize);
      expect(style.color, theme.colors.text);
      final text = tester.widget<Text>(find.text('Pedido 4711'));
      expect(text.maxLines, isNull);
      expect(text.softWrap, isTrue);
      expect(
        tester.getSemantics(find.text('Pedido 4711')),
        isNot(matchesSemantics(isHeader: true)),
      );
      handle.dispose();
    });

    test('[API] Propriedades — Linhas inválidas', () {
      expect(
        () => RebicText('x', maxLines: int.parse('0')),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('"maxLines"'),
          ),
        ),
      );
    });
  });

  testWidgets('[API] Callbacks e controlador — Sem ação', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_themed(const Center(child: RebicText('Total'))));
    await tester.tap(find.text('Total'));
    await tester.pump();
    final data = tester.getSemantics(find.text('Total')).getSemanticsData();
    expect(data.hasAction(SemanticsAction.tap), isFalse);
    handle.dispose();
  });

  group('[Comportamento] Limite de linhas', () {
    testWidgets('[Comportamento] Limite de linhas — Texto truncado', (
      tester,
    ) async {
      await tester.pumpWidget(_column(240, const RebicText(_long)));
      final (lineHeight, lines) = await _lines(tester, _long);
      expect(lines, greaterThanOrEqualTo(4));

      await tester.pumpWidget(
        _column(240, const RebicText(_long, maxLines: 2)),
      );
      final cut = _paragraph(tester, _long);
      expect(cut.didExceedMaxLines, isTrue);
      expect(cut.size.height, closeTo(lineHeight * 2, 0.5));
      expect(
        tester.widget<Text>(find.text(_long)).overflow,
        TextOverflow.ellipsis,
      );
    });

    testWidgets('[Comportamento] Limite de linhas — Texto livre', (
      tester,
    ) async {
      await tester.pumpWidget(_column(240, const RebicText(_long)));
      expect(_paragraph(tester, _long).didExceedMaxLines, isFalse);
      final (_, lines) = await _lines(tester, _long);
      expect(lines, greaterThanOrEqualTo(4));
    });
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Troca de tema', (
      tester,
    ) async {
      final light = RebicThemeData.light();
      final dark = RebicThemeData.dark();
      Widget app(RebicThemeData theme) => _themed(
        const Center(child: RebicText('Falhou', tone: RebicTextTone.error)),
        theme: theme,
      );
      await tester.pumpWidget(app(light));
      expect(
        _style(tester, 'Falhou').color,
        light.colors.stateColors(RebicValueState.error).foreground,
      );
      await tester.pumpWidget(app(dark));
      await tester.pumpAndSettle();
      expect(
        _style(tester, 'Falhou').color,
        dark.colors.stateColors(RebicValueState.error).foreground,
      );
    });

    testWidgets('[Aparência] Tokens de componente — Variantes e tons', (
      tester,
    ) async {
      final theme = RebicThemeData.light();
      final c = theme.colors;
      final toneColors = {
        RebicTextTone.standard: c.text,
        RebicTextTone.muted: c.label,
        RebicTextTone.success: c
            .stateColors(RebicValueState.success)
            .foreground,
        RebicTextTone.warning: c
            .stateColors(RebicValueState.warning)
            .foreground,
        RebicTextTone.error: c.stateColors(RebicValueState.error).foreground,
        RebicTextTone.information: c
            .stateColors(RebicValueState.information)
            .foreground,
      };
      for (final variant in RebicTextVariant.values) {
        for (final tone in RebicTextTone.values) {
          final label = '${variant.name}/${tone.name}';
          await tester.pumpWidget(
            _themed(RebicText(label, variant: variant, tone: tone)),
          );
          final expected = theme.typography.styles[variant.name]!;
          final style = _style(tester, label);
          expect(style.fontSize, expected.fontSize, reason: label);
          expect(style.height, expected.height, reason: label);
          expect(style.fontWeight, expected.fontWeight, reason: label);
          expect(style.color, toneColors[tone], reason: label);
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
            const RebicText('Entre os dois'),
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
      const RebicApp(home: Center(child: RebicText('Somente leitura'))),
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
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets('[Acessibilidade] Semântica e contraste — Leitor de tela', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      const text = 'Pedidos em aberto';
      await tester.pumpWidget(
        _column(
          60,
          const RebicText(text, variant: RebicTextVariant.title, maxLines: 1),
        ),
      );
      expect(_paragraph(tester, text).didExceedMaxLines, isTrue);
      expect(
        tester.getSemantics(find.text(text)),
        matchesSemantics(label: text, isHeader: true),
      );
      handle.dispose();
    });

    // "Contraste dos tons" fica em rebic_text_contrast_test.dart, sem a
    // fonte real: a diretriz de contraste mede pixels e precisa dos glifos
    // sólidos da fonte de teste padrão.

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Escala de texto 2,0',
      (tester) async {
        final theme = RebicThemeData.light();
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: _column(320, const RebicText(_long)),
          ),
        );
        expect(tester.takeException(), isNull);
        final paragraph = _paragraph(tester, _long);
        expect(
          paragraph.textScaler.scale(theme.typography.body.fontSize!),
          theme.typography.body.fontSize! * 2,
        );
      },
    );
  });

  testWidgets(
    '[Responsividade] Tamanhos de tela e densidade — Densidade compacta',
    (tester) async {
      await tester.pumpWidget(
        _themed(
          const Row(
            children: [
              RebicText('confortável'),
              RebicTheme.density(
                density: RebicDensity.compact,
                child: RebicText('compacta'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_style(tester, 'compacta'), _style(tester, 'confortável'));
    },
  );

  testWidgets('[Integração] Dependências — Funciona sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      RebicApp(
        home: ListView(
          children: [
            for (final v in RebicTextVariant.values)
              RebicText(v.name, variant: v),
          ],
        ),
      ),
    );
    expect(find.byType(RebicText), findsNWidgets(8));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    testWidgets('[Testes] Cobertura exigida — Goldens das variantes', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_text_$name',
          theme: theme,
          child: _sample(),
        );
      }
    }, tags: ['golden']);

    test('[Testes] Cobertura exigida — Rastreabilidade', () {
      const id = 'rebic/widgets/rebic-text';
      final spec = [
        File('${_repo.path}/openspec/specs/$id/spec.md'),
        File('${_repo.path}/openspec/changes/add-rebic-text/specs/$id/spec.md'),
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

  test('[Restrições] Fora do escopo — Sem cor arbitrária', () {
    final source = File(
      'lib/src/fundacao_layout/text/rebic_text.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicText\((.*?)\)\s*:',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    for (final type in ['Color', 'TextStyle', 'TextSpan']) {
      expect(ctor, isNot(contains(type)), reason: type);
    }
    final fields = RegExp(
      r'^  final (\w+\??) ',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!.replaceAll('?', ''));
    for (final type in ['Color', 'TextStyle', 'TextSpan']) {
      expect(fields, isNot(contains(type)), reason: type);
    }
  });
}
