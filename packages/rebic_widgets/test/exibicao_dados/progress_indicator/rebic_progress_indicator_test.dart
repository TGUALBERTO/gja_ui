import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';
import 'package:rebic_widgets/src/exibicao_dados/progress_indicator/rebic_progress_painter.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

/// Monta [child] numa área de [width], sob [theme] e [direction].
Widget _host(
  Widget child, {
  double width = 400,
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
  bool reduceMotion = false,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(key: const Key('area'), width: width, child: child),
        ),
      ),
    ),
  ),
);

RebicProgressPainter _painter(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byType(RebicProgressIndicator),
                matching: find.byType(CustomPaint),
              ),
            )
            .painter!
        as RebicProgressPainter;

/// Largura do preenchimento da barra, em pixels.
double _fillWidth(WidgetTester tester) {
  final (start, end) = _painter(tester).linearSegment;
  return (end - start) *
      tester.getSize(find.byType(RebicProgressIndicator)).width;
}

final _light = RebicThemeData.light();

void main() {
  testWidgets('[API] Propriedades da barra — Barra determinada', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const RebicProgressIndicator(percentValue: 45)),
    );
    expect(tester.getSize(find.byType(RebicProgressIndicator)).width, 400);
    expect(_painter(tester).linearSegment, (0, 0.45));
    expect(_fillWidth(tester), closeTo(180, 0.01));
  });

  test('[API] Valor válido — Valor fora do intervalo', () {
    for (final value in [120.0]) {
      expect(
        () => RebicProgressIndicator(percentValue: value),
        throwsA(
          isA<AssertionError>().having(
            (e) => '${e.message}',
            'message',
            contains('120'),
          ),
        ),
      );
    }
  });

  testWidgets('[API] Callbacks e controlador — Indicador sem ação', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const RebicProgressIndicator(percentValue: 45)),
    );
    await tester.tap(find.byType(RebicProgressIndicator));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(RebicProgressIndicator),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  group('[Comportamento] Valor animado', () {
    testWidgets('[Comportamento] Valor animado — Valor atualizado', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const RebicProgressIndicator(percentValue: 45)),
      );
      await tester.pumpWidget(
        _host(const RebicProgressIndicator(percentValue: 80)),
      );
      await tester.pump(_light.motion.short ~/ 2);
      final halfway = _fillWidth(tester);
      expect(halfway, greaterThan(180));
      expect(halfway, lessThan(320));
      await tester.pumpAndSettle();
      expect(_fillWidth(tester), closeTo(320, 0.01));
    });

    testWidgets('[Comportamento] Valor animado — Valor sem animação', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          reduceMotion: true,
          const RebicProgressIndicator(percentValue: 45),
        ),
      );
      await tester.pumpWidget(
        _host(
          reduceMotion: true,
          const RebicProgressIndicator(percentValue: 80),
        ),
      );
      await tester.pump();
      expect(_fillWidth(tester), closeTo(320, 0.01));
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });

  group('[Aparência] Tokens de componente', () {
    testWidgets('[Aparência] Tokens de componente — Cores por estado', (
      tester,
    ) async {
      for (final state in RebicValueState.values) {
        await tester.pumpWidget(
          _host(RebicProgressIndicator(percentValue: 45, state: state)),
        );
        final painter = _painter(tester);
        expect(
          painter.fill,
          state == RebicValueState.none
              ? _light.colors.brand
              : _light.colors.stateColors(state).foreground,
          reason: state.name,
        );
        expect(painter.track, _light.colors.separator);
      }
    });

    testWidgets(
      '[Aparência] Tokens de componente — Espessura da densidade compacta',
      (tester) async {
        final compact = RebicThemeData.light(density: RebicDensity.compact);
        await tester.pumpWidget(
          _host(theme: compact, const RebicProgressIndicator(percentValue: 45)),
        );
        expect(
          tester.getSize(find.byType(RebicProgressIndicator)).height,
          compact.spacing.xs,
        );
      },
    );
  });

  testWidgets(
    '[Estados] Sem estados de interação — Indicador não recebe foco',
    (tester) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(() {
        first.dispose();
        second.dispose();
      });
      await tester.pumpWidget(
        RebicApp(
          home: Column(
            children: [
              Focus(focusNode: first, child: const SizedBox(height: 20)),
              const RebicProgressIndicator(percentValue: 45),
              Focus(focusNode: second, child: const SizedBox(height: 20)),
            ],
          ),
        ),
      );
      first.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(second.hasPrimaryFocus, isTrue);
    },
  );

  testWidgets('[Acessibilidade] Semântica da barra — Semântica do valor', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const RebicProgressIndicator(percentValue: 45.6)),
    );
    expect(
      tester.getSemantics(find.byType(RebicProgressIndicator)),
      matchesSemantics(label: 'Carregando', value: '46%'),
    );
    handle.dispose();
  });

  test('[Acessibilidade] Contraste — Contraste do preenchimento', () {
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      final c = theme.colors;
      for (final state in RebicValueState.values) {
        final fill = state == RebicValueState.none
            ? c.brand
            : c.stateColors(state).foreground;
        for (final surface in [c.base, c.background]) {
          expect(
            rebicContrastRatioOver(fill, surface),
            greaterThanOrEqualTo(RebicAccessibility.minNonTextContrast),
            reason: '${theme.brightness.name}/${state.name}',
          );
        }
      }
    }
  });

  testWidgets('[Responsividade] Largura e direção — Barra em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        direction: TextDirection.rtl,
        const RebicProgressIndicator(percentValue: 25),
      ),
    );
    final painter = _painter(tester);
    expect(painter.textDirection, TextDirection.rtl);
    expect(_fillWidth(tester), closeTo(100, 0.01));
    // Em RTL o segmento (0, 0.25) é desenhado a partir da borda direita.
    final (start, end) = painter.linearSegment;
    final rect = tester.getRect(find.byType(RebicProgressIndicator));
    expect(rect.right - start * rect.width, rect.right);
    expect(rect.right - end * rect.width, closeTo(rect.right - 100, 0.01));
  });

  testWidgets('[Integração] Dependências — Indicador sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Column(
          children: [
            RebicProgressIndicator(percentValue: 0),
            RebicProgressIndicator(percentValue: 45),
            RebicProgressIndicator(percentValue: 100),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(RebicProgressIndicator), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do indicador', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-progress-indicator',
        'add-rebic-progress-indicator',
      );
      expect(names, hasLength(16));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do indicador', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_progress_indicator_$name',
          theme: theme,
          size: const Size(480, 320),
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: SizedBox(
              width: 400,
              child: RebicVBox(
                items: [
                  for (final state in RebicValueState.values)
                    RebicProgressIndicator(percentValue: 45, state: state),
                  const RebicProgressIndicator(percentValue: 0),
                  const RebicProgressIndicator(percentValue: 100),
                ],
              ),
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Indicador sem valor literal', () {
    final source = File(
      'lib/src/exibicao_dados/progress_indicator/rebic_progress_indicator.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => (m.group(1)!, m.group(2)!)).toList();
    expect(fields, isNotEmpty);
    for (final (type, name) in fields) {
      if (type.startsWith('double')) expect(name, 'percentValue');
      expect(type, isNot(anyOf('Color', 'Color?', 'Duration', 'Duration?')));
    }
  });
}
