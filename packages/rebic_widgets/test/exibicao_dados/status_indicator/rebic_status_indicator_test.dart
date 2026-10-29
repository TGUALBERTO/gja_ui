import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

/// Monta [child] centralizado, sob [direction] e escala de texto, sem
/// `RebicApp`.
Widget _host(
  Widget child, {
  TextDirection direction = TextDirection.ltr,
  double textScale = 1,
}) => RebicTheme(
  data: RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Center(child: child),
      ),
    ),
  ),
);

/// Texto do valor (o último `Text` do status de [index]).
Text _value(WidgetTester tester, String text) => tester.widget<Text>(
  find.descendant(
    of: find.byType(RebicStatusIndicator),
    matching: find.text(text),
  ),
);

const _long = 'Aguardando aprovação do gestor do centro de custo';

final _light = RebicThemeData.light();

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Status mínimo', (tester) async {
      await tester.pumpWidget(
        _host(
          const RebicStatusIndicator(
            text: 'Aprovado',
            state: RebicValueState.success,
          ),
        ),
      );
      final style = _value(tester, 'Aprovado').style!;
      expect(
        style.color,
        _light.colors.stateColors(RebicValueState.success).foreground,
      );
      expect(style.fontSize, _light.typography.base.fontSize);
      expect(
        find.descendant(
          of: find.byType(RebicStatusIndicator),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });

    testWidgets('[API] Propriedades — Status com título e ícone', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const RebicStatusIndicator(
            title: 'Situação',
            icon: RebicIcons.success,
            text: 'Aprovado',
            state: RebicValueState.success,
          ),
        ),
      );
      final title = tester.getRect(find.text('Situação:'));
      final icon = tester.getRect(find.byType(RebicIcon));
      final text = tester.getRect(find.text('Aprovado'));
      expect(title.right, lessThanOrEqualTo(icon.left));
      expect(icon.right, lessThanOrEqualTo(text.left));
      expect(
        tester.widget<RebicText>(find.byType(RebicText)).tone,
        RebicTextTone.muted,
      );
    });
  });

  test('[API] Conteúdo válido — Status vazio', () {
    for (final text in [null, '']) {
      expect(() => RebicStatusIndicator(text: text), throwsAssertionError);
    }
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Status ativo', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        RebicApp(
          home: Center(
            child: RebicStatusIndicator(
              text: '3 pendências',
              state: RebicValueState.warning,
              onPressed: () => calls++,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(RebicStatusIndicator));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(calls, 2);
    });

    testWidgets('[API] Callbacks e controlador — Status inativo', (
      tester,
    ) async {
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
              const RebicStatusIndicator(text: 'Aprovado'),
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
      expect(
        find.descendant(
          of: find.byType(RebicStatusIndicator),
          matching: find.byType(RebicInteractable),
        ),
        findsNothing,
      );
    });
  });

  testWidgets('[Comportamento] Quebra do texto — Texto longo quebra', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 160,
          child: RebicStatusIndicator(
            icon: RebicIcons.clock,
            text: _long,
            state: RebicValueState.information,
          ),
        ),
      ),
    );
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(of: find.text(_long), matching: find.byType(RichText)),
    );
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(
      paragraph.size.height,
      greaterThan(paragraph.preferredLineHeight * 1.5),
    );
    final text = tester.getRect(find.text(_long));
    final icon = tester.getRect(find.byType(RebicIcon));
    // O ícone fica na faixa da primeira linha.
    expect(icon.top, greaterThanOrEqualTo(text.top));
    expect(
      icon.bottom,
      lessThanOrEqualTo(text.top + paragraph.preferredLineHeight + 0.5),
    );
  });

  testWidgets('[Aparência] Cores por estado — Cores do status por estado', (
    tester,
  ) async {
    for (final state in RebicValueState.values) {
      await tester.pumpWidget(
        _host(
          RebicStatusIndicator(
            key: ValueKey(state),
            icon: RebicIcons.info,
            text: state.name,
            state: state,
          ),
        ),
      );
      final expected = state == RebicValueState.none
          ? _light.colors.text
          : _light.colors.stateColors(state).foreground;
      expect(_value(tester, state.name).style!.color, expected);
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(RebicIcon),
          matching: find.byType(Icon),
        ),
      );
      expect(icon.color, expected, reason: state.name);
    }
  });

  testWidgets('[Aparência] Status invertido — Status invertido', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const RebicStatusIndicator(
          text: 'Rejeitado',
          state: RebicValueState.error,
          inverted: true,
        ),
      ),
    );
    final error = _light.colors.stateColors(RebicValueState.error);
    final decoration =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(RebicStatusIndicator),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    expect(decoration.color, error.background);
    expect(decoration.border!.top.color, error.border);
    expect(decoration.borderRadius, BorderRadius.circular(_light.radius.s));
    expect(_value(tester, 'Rejeitado').style!.color, error.foreground);
  });

  testWidgets(
    '[Aparência] Tokens de componente — Ícone acompanha a escala de texto',
    (tester) async {
      await tester.pumpWidget(
        _host(
          textScale: 2,
          const RebicStatusIndicator(icon: RebicIcons.info, text: 'Em análise'),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(Icon)).width,
        greaterThan(_light.icons.inline),
      );
    },
  );

  testWidgets('[Estados] Interação do status ativo — Status ativo em hover', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(RebicStatusIndicator(text: '3 pendências', onPressed: () {})),
    );
    TextDecoration? decoration() =>
        _value(tester, '3 pendências').style!.decoration;
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byType(RebicStatusIndicator)));
    await tester.pump();
    expect(decoration(), TextDecoration.underline);
    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(decoration(), TextDecoration.none);
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do status', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const RebicStatusIndicator(
              title: 'Situação',
              icon: RebicIcons.success,
              text: 'Aprovado',
            ),
            RebicStatusIndicator(text: 'Atrasado', onPressed: () {}),
          ],
        ),
      ),
    );
    final plain = tester.getSemantics(find.byType(RebicStatusIndicator).at(0));
    expect(
      plain,
      containsSemantics(label: 'Situação: Aprovado', isButton: false),
    );
    expect(
      tester.getSemantics(find.byType(RebicStatusIndicator).at(1)),
      containsSemantics(label: 'Atrasado', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('[Responsividade] Direção — Status em RTL', (tester) async {
    await tester.pumpWidget(
      _host(
        direction: TextDirection.rtl,
        const RebicStatusIndicator(icon: RebicIcons.info, text: 'Em análise'),
      ),
    );
    expect(
      tester.getRect(find.byType(RebicIcon)).left,
      greaterThanOrEqualTo(tester.getRect(find.text('Em análise')).right),
    );
  });

  testWidgets('[Integração] Dependências — Status sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            const RebicStatusIndicator(text: 'Normal'),
            const RebicStatusIndicator(
              text: 'Invertido',
              state: RebicValueState.error,
              inverted: true,
            ),
            RebicStatusIndicator(text: 'Ativo', onPressed: () {}),
          ],
        ),
      ),
    );
    for (final element
        in find.byType(RebicStatusIndicator).evaluate().toList()) {
      await tester.tap(find.byWidget(element.widget), warnIfMissed: false);
    }
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do status', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-status-indicator',
        'add-rebic-status-indicator',
      );
      expect(names, hasLength(18));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do status', (
      tester,
    ) async {
      const icons = {
        RebicValueState.none: RebicIcons.info,
        RebicValueState.success: RebicIcons.success,
        RebicValueState.warning: RebicIcons.warning,
        RebicValueState.error: RebicIcons.error,
        RebicValueState.information: RebicIcons.info,
      };
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_status_indicator_$name',
          theme: theme,
          size: const Size(480, 320),
          child: RebicColumn(
            children: [
              for (final state in RebicValueState.values)
                RebicRow(
                  gap: RebicSpace.l,
                  children: [
                    RebicStatusIndicator(
                      icon: icons[state],
                      text: state.name,
                      state: state,
                    ),
                    RebicStatusIndicator(
                      text: state.name,
                      state: state,
                      inverted: true,
                    ),
                  ],
                ),
              const RebicStatusIndicator(
                title: 'Situação',
                icon: RebicIcons.success,
                text: 'Aprovado',
                state: RebicValueState.success,
              ),
              RebicStatusIndicator(
                icon: RebicIcons.warning,
                text: '3 pendências',
                state: RebicValueState.warning,
                onPressed: () {},
              ),
            ],
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Status sem valor literal', () {
    final source = File(
      'lib/src/exibicao_dados/status_indicator/rebic_status_indicator.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(
        type.replaceAll('?', ''),
        isNot(isIn(['double', 'Color', 'TextStyle'])),
      );
    }
  });
}
