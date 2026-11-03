import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';
import 'package:rebic_widgets/src/exibicao_dados/progress_indicator/rebic_progress_view.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

/// Monta [child] centralizado, sob [theme] e [direction], sem `RebicApp`.
Widget _host(
  Widget child, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Center(child: child),
  ),
);

/// Fundo pintado do botão (de [index], quando há vários).
Finder _box([int index = 0]) => find
    .descendant(
      of: find.byType(RebicButton).at(index),
      matching: find.byType(DecoratedBox),
    )
    .first;

BoxDecoration _decoration(WidgetTester tester, [int index = 0]) =>
    tester.widget<DecoratedBox>(_box(index)).decoration as BoxDecoration;

Text _label(WidgetTester tester) => tester.widget<Text>(
  find.descendant(of: find.byType(RebicButton), matching: find.byType(Text)),
);

final _light = RebicThemeData.light();

RebicControlColors _family(RebicControlFamily family) =>
    RebicControlColors.of(family, _light.colors);

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Botão mínimo', (tester) async {
      await tester.pumpWidget(
        _host(RebicButton(label: 'Salvar', onPressed: () {})),
      );
      final box = tester.getRect(_box());
      expect(box.height, _light.density.controlHeight);
      final normal = _family(RebicControlFamily.standard).normal;
      expect(_decoration(tester).color, normal.background);
      expect(
        tester.getCenter(find.text('Salvar')).dx,
        closeTo(box.center.dx, 0.5),
      );
    });

    testWidgets('[API] Propriedades — Botão com ícone', (tester) async {
      await tester.pumpWidget(
        _host(
          RebicButton(
            label: 'Salvar',
            icon: RebicIcons.accept,
            onPressed: () {},
          ),
        ),
      );
      final icon = tester.getRect(find.byType(Icon));
      final text = tester.getRect(find.text('Salvar'));
      expect(text.left - icon.right, closeTo(_light.spacing.xs, 0.01));
    });
  });

  test('[API] Rótulo válido — Rótulo vazio', () {
    for (final label in ['']) {
      expect(
        () => RebicButton(label: label, onPressed: () {}),
        throwsAssertionError,
      );
    }
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Pressionar', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        _host(RebicButton(label: 'Salvar', onPressed: () => calls++)),
      );
      await tester.tap(find.byType(RebicButton));
      await tester.pump();
      expect(calls, 1);
    });

    testWidgets('[API] Callbacks e controlador — Botão desabilitado', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const RebicButton(label: 'Salvar', onPressed: null)),
      );
      await tester.tap(find.byType(RebicButton), warnIfMissed: false);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(RebicButton),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        _light.interaction.disabledOpacity,
      );
    });
  });

  testWidgets('[Comportamento] Estado ocupado — Botão ocupado', (tester) async {
    var calls = 0;
    Widget button(bool busy) => _host(
      RebicButton(
        label: 'Enviar',
        icon: RebicIcons.upload,
        busy: busy,
        onPressed: () => calls++,
      ),
    );
    await tester.pumpWidget(button(false));
    final width = tester.getSize(_box()).width;
    await tester.pumpWidget(button(true));
    expect(find.byType(Icon), findsNothing);
    expect(find.byType(RebicProgressView), findsOneWidget);
    expect(tester.getSize(_box()).width, width);
    await tester.tap(find.byType(RebicButton));
    await tester.pump();
    expect(calls, 0);
    // Para a animação do indicador antes de encerrar.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('[Comportamento] Ativação pelo teclado — Enter e Espaço', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      RebicApp(
        home: Center(
          child: RebicButton(label: 'Salvar', onPressed: () => calls++),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(calls, 2);
  });

  testWidgets('[Aparência] Cores por tipo — Cores por tipo', (tester) async {
    for (final (type, family) in [
      (RebicButtonType.standard, RebicControlFamily.standard),
      (RebicButtonType.emphasized, RebicControlFamily.emphasized),
      (RebicButtonType.transparent, RebicControlFamily.transparent),
      (RebicButtonType.accept, RebicControlFamily.accept),
      (RebicButtonType.reject, RebicControlFamily.reject),
      (RebicButtonType.attention, RebicControlFamily.attention),
    ]) {
      await tester.pumpWidget(
        _host(RebicButton(label: type.name, type: type, onPressed: () {})),
      );
      final normal = _family(family).normal;
      final decoration = _decoration(tester);
      expect(decoration.color, normal.background, reason: type.name);
      expect(decoration.border!.top.color, normal.border, reason: type.name);
      expect(_label(tester).style!.color, normal.text, reason: type.name);
    }
  });

  testWidgets(
    '[Aparência] Tokens de componente — Medidas da densidade compacta',
    (tester) async {
      final compact = RebicThemeData.light(density: RebicDensity.compact);
      await tester.pumpWidget(
        _host(
          theme: compact,
          RebicButton(label: 'Salvar', onPressed: () {}),
        ),
      );
      final box = tester.getRect(_box());
      expect(box.height, compact.density.controlHeight);
      expect(
        tester.getRect(find.text('Salvar')).left - box.left,
        closeTo(compact.spacing.m, 0.5),
      );
    },
  );

  group('[Estados] Interação', () {
    testWidgets('[Estados] Interação — Hover e pressionado', (tester) async {
      await tester.pumpWidget(
        _host(RebicButton(label: 'Salvar', onPressed: () {})),
      );
      final standard = _family(RebicControlFamily.standard);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byType(RebicButton)));
      await tester.pump();
      expect(_decoration(tester).color, standard.hover.background);
      await mouse.down(tester.getCenter(find.byType(RebicButton)));
      await tester.pump();
      expect(_decoration(tester).color, standard.active.background);
      await mouse.up();
      await tester.pump();
    });

    testWidgets('[Estados] Interação — Foco pelo teclado', (tester) async {
      bool ringVisible() => tester
          .widget<RebicFocusRing>(
            find.descendant(
              of: find.byType(RebicButton),
              matching: find.byType(RebicFocusRing),
            ),
          )
          .visible;
      await tester.pumpWidget(
        RebicApp(
          home: Center(
            child: RebicButton(label: 'Salvar', onPressed: () {}),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(ringVisible(), isTrue);

      await tester.pumpWidget(
        RebicApp(
          key: const Key('touch'),
          home: Center(
            child: RebicButton(label: 'Salvar', onPressed: () {}),
          ),
        ),
      );
      await tester.tap(find.byType(RebicButton));
      await tester.pump();
      expect(ringVisible(), isFalse);
    });
  });

  group('[Acessibilidade] Semântica', () {
    testWidgets('[Acessibilidade] Semântica — Semântica do botão', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RebicButton(label: 'Salvar', onPressed: () {}),
              const RebicButton(label: 'Excluir', onPressed: null),
            ],
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(RebicButton).at(0)),
        containsSemantics(
          isButton: true,
          label: 'Salvar',
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.byType(RebicButton).at(1)),
        containsSemantics(
          isButton: true,
          label: 'Excluir',
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('[Acessibilidade] Semântica — Semântica do ocupado', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(RebicButton(label: 'Enviar', busy: true, onPressed: () {})),
      );
      expect(
        tester.getSemantics(find.byType(RebicButton)),
        containsSemantics(label: 'Enviar', value: 'Carregando'),
      );
      handle.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('[Responsividade] Largura e direção', () {
    testWidgets('[Responsividade] Largura e direção — Botão em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          direction: TextDirection.rtl,
          RebicButton(
            label: 'Salvar',
            icon: RebicIcons.accept,
            onPressed: () {},
          ),
        ),
      );
      expect(
        tester.getRect(find.byType(Icon)).left,
        greaterThanOrEqualTo(tester.getRect(find.text('Salvar')).right),
      );
    });

    testWidgets('[Responsividade] Largura e direção — Rótulo longo', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: RebicButton(
              label: 'Encaminhar para aprovação do gestor',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(RebicButton)).width,
        lessThanOrEqualTo(120),
      );
      final label = _label(tester);
      expect(label.maxLines, 1);
      expect(label.overflow, TextOverflow.ellipsis);
      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byType(RebicButton),
          matching: find.byType(RichText),
        ),
      );
      expect(paragraph.didExceedMaxLines, isTrue);
    });
  });

  testWidgets(
    '[Integração] Dependências do núcleo e de widgets — Botão sem Material',
    (tester) async {
      await tester.pumpWidget(
        RebicApp(
          home: Column(
            children: [
              for (final type in RebicButtonType.values)
                RebicButton(label: type.name, type: type, onPressed: () {}),
              const RebicButton(label: 'Desabilitado', onPressed: null),
              RebicButton(label: 'Ocupado', busy: true, onPressed: () {}),
            ],
          ),
        ),
      );
      for (final finder in find.byType(RebicButton).evaluate().toList()) {
        await tester.tap(find.byWidget(finder.widget), warnIfMissed: false);
      }
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    '[Integração] Dependências de fundamentos — Botão pelo tema da subárvore',
    (tester) async {
      final dark = RebicThemeData.dark();
      await tester.pumpWidget(
        RebicApp(
          home: RebicTheme(
            data: dark,
            child: Center(
              child: RebicButton(
                label: 'Salvar',
                type: RebicButtonType.emphasized,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_decoration(tester).color, dark.colors.brand);
    },
  );

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do botão', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-button',
        'add-rebic-button',
      );
      expect(names, hasLength(23));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do botão', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_button_$name',
          theme: theme,
          size: const Size(480, 420),
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: RebicVBox(
              gap: RebicSpace.s,
              items: [
                for (final type in RebicButtonType.values)
                  RebicHBox(
                    items: [
                      RebicButton(
                        label: type.name,
                        type: type,
                        onPressed: () {},
                      ),
                      RebicButton(
                        label: type.name,
                        type: type,
                        icon: RebicIcons.accept,
                        onPressed: () {},
                      ),
                    ],
                  ),
                RebicHBox(
                  items: [
                    const RebicButton(label: 'Desabilitado', onPressed: null),
                    RebicButton(
                      label: 'Enviando',
                      type: RebicButtonType.emphasized,
                      icon: RebicIcons.upload,
                      busy: true,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Botão sem valor literal', () {
    final source = File(
      'lib/src/acoes_navegacao/button/rebic_button.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(
        type,
        isNot(
          anyOf(
            'double',
            'double?',
            'Color',
            'Color?',
            'Duration',
            'Duration?',
          ),
        ),
      );
    }
  });
}
