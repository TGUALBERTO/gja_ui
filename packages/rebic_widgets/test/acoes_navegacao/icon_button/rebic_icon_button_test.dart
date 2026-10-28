import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

/// Aplicação de teste com [home] centralizado (a dica precisa do `Overlay`).
Widget _app(
  Widget home, {
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
  double textScale = 1,
}) => RebicApp(
  theme: theme,
  darkTheme: theme,
  density: theme?.density.density,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: Directionality(textDirection: direction, child: child!),
  ),
  home: Center(child: home),
);

Finder _box([int index = 0]) => find
    .descendant(
      of: find.byType(RebicIconButton).at(index),
      matching: find.byType(DecoratedBox),
    )
    .first;

BoxDecoration _decoration(WidgetTester tester, [int index = 0]) =>
    tester.widget<DecoratedBox>(_box(index)).decoration as BoxDecoration;

/// Nó interativo do botão de [index], que tem a semântica.
Finder _interactable(int index) => find.descendant(
  of: find.byType(RebicIconButton).at(index),
  matching: find.byType(RebicInteractable),
);

Icon _icon(WidgetTester tester) => tester.widget<Icon>(
  find.descendant(
    of: find.byType(RebicIconButton),
    matching: find.byType(Icon),
  ),
);

final _light = RebicThemeData.light();

RebicControlColors _family(RebicControlFamily family) =>
    RebicControlColors.of(family, _light.colors);

void main() {
  testWidgets('[API] Propriedades — Botão de ícone mínimo', (tester) async {
    await tester.pumpWidget(
      _app(
        RebicIconButton(
          icon: RebicIcons.edit,
          tooltip: 'Editar',
          onPressed: () {},
        ),
      ),
    );
    final box = tester.getRect(_box());
    expect(box.size, Size.square(_light.density.controlHeight));
    final normal = _family(RebicControlFamily.transparent).normal;
    expect(_decoration(tester).color, normal.background);
    expect(_icon(tester).size, _light.icons.control);
    expect(tester.getCenter(find.byType(Icon)), box.center);
  });

  test('[API] Dica obrigatória — Dica vazia', () {
    for (final tooltip in ['']) {
      expect(
        () => RebicIconButton(
          icon: RebicIcons.edit,
          tooltip: tooltip,
          onPressed: () {},
        ),
        throwsAssertionError,
      );
    }
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Pressionar o botão de ícone', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        _app(
          RebicIconButton(
            icon: RebicIcons.edit,
            tooltip: 'Editar',
            onPressed: () => calls++,
          ),
        ),
      );
      await tester.tap(find.byType(RebicIconButton));
      await tester.pump();
      expect(calls, 1);
    });

    testWidgets('[API] Callbacks e controlador — Botão de ícone desabilitado', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const RebicIconButton(
            icon: RebicIcons.delete,
            tooltip: 'Excluir',
            onPressed: null,
          ),
        ),
      );
      await tester.tap(find.byType(RebicIconButton), warnIfMissed: false);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(RebicIconButton),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        _light.interaction.disabledOpacity,
      );
    });
  });

  testWidgets('[Comportamento] Dica — Dica no hover', (tester) async {
    await tester.pumpWidget(
      _app(
        RebicIconButton(
          icon: RebicIcons.edit,
          tooltip: 'Editar pedido',
          onPressed: () {},
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byType(RebicIconButton)));
    await tester.pump(_light.motion.long);
    await tester.pump();
    expect(find.text('Editar pedido'), findsOneWidget);
  });

  testWidgets(
    '[Comportamento] Ativação pelo teclado — Enter e Espaço no botão de ícone',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        _app(
          RebicIconButton(
            icon: RebicIcons.edit,
            tooltip: 'Editar',
            onPressed: () => calls++,
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(calls, 2);
    },
  );

  testWidgets('[Aparência] Cores por tipo — Cores do botão de ícone por tipo', (
    tester,
  ) async {
    for (final (type, family) in [
      (RebicButtonType.standard, RebicControlFamily.standard),
      (RebicButtonType.emphasized, RebicControlFamily.emphasized),
      (RebicButtonType.transparent, RebicControlFamily.transparent),
      (RebicButtonType.accept, RebicControlFamily.accept),
      (RebicButtonType.reject, RebicControlFamily.reject),
      (RebicButtonType.attention, RebicControlFamily.attention),
    ]) {
      await tester.pumpWidget(
        _app(
          RebicIconButton(
            key: ValueKey(type),
            icon: RebicIcons.edit,
            tooltip: type.name,
            type: type,
            onPressed: () {},
          ),
        ),
      );
      final normal = _family(family).normal;
      final decoration = _decoration(tester);
      expect(decoration.color, normal.background, reason: type.name);
      expect(decoration.border!.top.color, normal.border, reason: type.name);
      expect(_icon(tester).color, normal.text, reason: type.name);
    }
  });

  testWidgets(
    '[Aparência] Tokens de componente — Botão de ícone na densidade compacta',
    (tester) async {
      final compact = RebicThemeData.light(density: RebicDensity.compact);
      await tester.pumpWidget(
        _app(
          theme: compact,
          textScale: 2,
          RebicIconButton(
            icon: RebicIcons.edit,
            tooltip: 'Editar',
            onPressed: () {},
          ),
        ),
      );
      expect(
        tester.getSize(_box()),
        Size.square(compact.density.controlHeight),
      );
      expect(
        tester.getSize(find.byType(Icon)),
        Size.square(compact.icons.control),
      );
    },
  );

  group('[Estados] Interação', () {
    testWidgets('[Estados] Interação — Hover e pressionado no botão de ícone', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          RebicIconButton(
            icon: RebicIcons.edit,
            tooltip: 'Editar',
            onPressed: () {},
          ),
        ),
      );
      final transparent = _family(RebicControlFamily.transparent);
      final center = tester.getCenter(find.byType(RebicIconButton));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(center);
      await tester.pump();
      expect(_decoration(tester).color, transparent.hover.background);
      await mouse.down(center);
      // O toque longo da dica compete com o toque: o pressionado vem após
      // kPressTimeout.
      await tester.pump(kPressTimeout);
      expect(_decoration(tester).color, transparent.active.background);
      await mouse.up();
      // A dica do hover abre e fecha com os atrasos.
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('[Estados] Interação — Foco pelo teclado no botão de ícone', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          RebicIconButton(
            icon: RebicIcons.edit,
            tooltip: 'Editar pedido',
            onPressed: () {},
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(
        tester
            .widget<RebicFocusRing>(
              find.descendant(
                of: find.byType(RebicIconButton),
                matching: find.byType(RebicFocusRing),
              ),
            )
            .visible,
        isTrue,
      );
      expect(find.text('Editar pedido'), findsOneWidget);
    });
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do botão de ícone', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RebicIconButton(
              icon: RebicIcons.edit,
              tooltip: 'Editar',
              onPressed: () {},
            ),
            const RebicIconButton(
              icon: RebicIcons.delete,
              tooltip: 'Excluir',
              onPressed: null,
            ),
          ],
        ),
      ),
    );
    final edit = tester.getSemantics(_interactable(0));
    expect(
      edit,
      containsSemantics(
        isButton: true,
        label: 'Editar',
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    expect(edit.tooltip, isEmpty);
    final delete = tester.getSemantics(_interactable(1));
    expect(
      delete,
      containsSemantics(
        isButton: true,
        label: 'Excluir',
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    expect(delete.tooltip, isEmpty);
    expect(find.bySemanticsLabel('Editar'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('[Responsividade] Direção — Ícone direcional em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        direction: TextDirection.rtl,
        RebicIconButton(
          icon: RebicIcons.arrowLeft,
          tooltip: 'Voltar',
          onPressed: () {},
        ),
      ),
    );
    final icon = _icon(tester);
    expect(icon.icon!.matchTextDirection, isTrue);
    expect(
      Directionality.of(tester.element(find.byType(Icon))),
      TextDirection.rtl,
    );
  });

  group('[Integração] Dependências', () {
    testWidgets('[Integração] Dependências — Botão de ícone sem Material', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final type in RebicButtonType.values)
                RebicIconButton(
                  icon: RebicIcons.edit,
                  tooltip: type.name,
                  type: type,
                  onPressed: () {},
                ),
              const RebicIconButton(
                icon: RebicIcons.edit,
                tooltip: 'Desabilitado',
                onPressed: null,
              ),
            ],
          ),
        ),
      );
      for (final element in find.byType(RebicIconButton).evaluate().toList()) {
        await tester.tap(find.byWidget(element.widget), warnIfMissed: false);
      }
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      '[Integração] Dependências — Scaffold e página usam o botão de ícone',
      (tester) async {
        await tester.pumpWidget(
          RebicApp(
            locale: const Locale('pt', 'BR'),
            home: RebicScaffold(
              navigation: const SizedBox(width: 64),
              body: RebicPage(
                title: 'Pedidos',
                onBack: () {},
                body: const SizedBox.shrink(),
              ),
            ),
          ),
        );
        final tooltips = tester
            .widgetList<RebicIconButton>(find.byType(RebicIconButton))
            .map((b) => b.tooltip)
            .toSet();
        expect(tooltips, {'Navegação', 'Voltar'});
      },
    );
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do botão de ícone', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-icon-button',
        'add-rebic-icon-button',
      );
      expect(names, hasLength(19));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do botão de ícone', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_icon_button_$name',
          theme: theme,
          size: const Size(480, 160),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => RebicRow(
                  children: [
                    for (final type in RebicButtonType.values)
                      RebicIconButton(
                        icon: RebicIcons.edit,
                        tooltip: type.name,
                        type: type,
                        onPressed: () {},
                      ),
                    const RebicIconButton(
                      icon: RebicIcons.edit,
                      tooltip: 'Desabilitado',
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Botão de ícone sem valor literal', () {
    final source = File(
      'lib/src/acoes_navegacao/icon_button/rebic_icon_button.dart',
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
          isIn([
            'double',
            'double?',
            'Color',
            'Color?',
            'Duration',
            'Duration?',
            'Widget',
            'Widget?',
          ]),
        ),
      );
    }
  });
}
