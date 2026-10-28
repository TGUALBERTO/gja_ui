import 'dart:io';
import 'dart:ui' show SemanticsFlag;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
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

/// Elemento de 40 × 40 sob o contador.
Widget _target([VoidCallback? onTap]) => GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: onTap,
  child: const SizedBox(key: Key('target'), width: 40, height: 40),
);

/// Pílula do contador (de [index], quando há vários).
Finder _pill([int index = 0]) => find
    .descendant(
      of: find.byType(RebicBadge).at(index),
      matching: find.byType(DecoratedBox),
    )
    .first;

BoxDecoration _decoration(WidgetTester tester, [int index = 0]) =>
    tester.widget<DecoratedBox>(_pill(index)).decoration as BoxDecoration;

final _light = RebicThemeData.light();

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Contador avulso', (tester) async {
      await tester.pumpWidget(_host(const RebicBadge(count: 5)));
      expect(find.text('5'), findsOneWidget);
      final text = tester.widget<RebicText>(find.byType(RebicText));
      expect(text.variant, RebicTextVariant.label);
      final error = _light.colors.stateColors(RebicValueState.error);
      expect(_decoration(tester).color, error.background);
      expect(_decoration(tester).border!.top.color, error.border);
    });

    testWidgets('[API] Propriedades — Contador sobre um elemento', (
      tester,
    ) async {
      await tester.pumpWidget(_host(RebicBadge(count: 3, child: _target())));
      expect(tester.getSize(find.byType(RebicBadge)), const Size(40, 40));
      final target = tester.getRect(find.byKey(const Key('target')));
      final center = tester.getCenter(_pill());
      expect(center.dx, closeTo(target.right, 0.01));
      expect(center.dy, closeTo(target.top, 0.01));
    });
  });

  test('[API] Limite válido — Limite inválido', () {
    for (final max in [0]) {
      expect(
        () => RebicBadge(count: 3, max: max),
        throwsA(
          isA<AssertionError>().having(
            (e) => '${e.message}',
            'message',
            contains('0'),
          ),
        ),
      );
    }
  });

  testWidgets(
    '[API] Callbacks e controlador — Toque no elemento com contador',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(RebicBadge(count: 3, child: _target(() => taps++))),
      );
      final target = tester.getRect(find.byKey(const Key('target')));
      // Um ponto da pílula dentro do elemento, junto ao canto.
      await tester.tapAt(target.topRight + const Offset(-2, 2));
      await tester.pump();
      expect(taps, 1);
    },
  );

  group('[Comportamento] Limite e zero', () {
    testWidgets('[Comportamento] Limite e zero — Valor acima do limite', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const RebicBadge(count: 1500)));
      expect(find.text('999+'), findsOneWidget);
    });

    testWidgets('[Comportamento] Limite e zero — Contador zero oculto', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [RebicBadge(key: Key('alone'), count: 0)],
          ),
        ),
      );
      expect(find.byType(RebicText), findsNothing);
      expect(tester.getSize(find.byKey(const Key('alone'))), Size.zero);
      await tester.pumpWidget(_host(RebicBadge(count: 0, child: _target())));
      expect(find.byType(RebicText), findsNothing);
      expect(find.byKey(const Key('target')), findsOneWidget);
    });
  });

  testWidgets('[Aparência] Estados de valor — Cores do contador por estado', (
    tester,
  ) async {
    for (final state in RebicValueState.values) {
      await tester.pumpWidget(
        _host(RebicBadge(key: ValueKey(state), count: 7, state: state)),
      );
      final colors = _light.colors.stateColors(state);
      expect(_decoration(tester).color, colors.background, reason: state.name);
      expect(
        _decoration(tester).border!.top.color,
        colors.border,
        reason: state.name,
      );
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(RebicText),
          matching: find.byType(Text),
        ),
      );
      expect(
        text.style!.color,
        state == RebicValueState.none ? _light.colors.text : colors.foreground,
        reason: state.name,
      );
    }
  });

  testWidgets('[Aparência] Tokens de componente — Forma do contador', (
    tester,
  ) async {
    // Larguras reais dos dígitos: a fonte de teste padrão tem glifos quadrados.
    await loadRebicFonts();
    await tester.pumpWidget(
      _host(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [RebicBadge(count: 7), RebicBadge(count: 128)],
        ),
      ),
    );
    final one = tester.getSize(_pill(0));
    expect(one.width, one.height);
    expect(one.width, greaterThanOrEqualTo(_light.icons.small));
    expect(
      _decoration(tester, 0).borderRadius,
      BorderRadius.circular(_light.radius.full),
    );
    final three = tester.getSize(_pill(1));
    expect(three.width, greaterThan(three.height));
  });

  testWidgets('[Estados] Sem estados de interação — Contador não recebe foco', (
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
            const RebicBadge(count: 3),
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
  });

  group('[Acessibilidade] Semântica', () {
    testWidgets('[Acessibilidade] Semântica — Semântica do contador avulso', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RebicBadge(count: 1500),
              RebicBadge(count: 3, semanticLabel: '3 notificações'),
            ],
          ),
        ),
      );
      expect(find.bySemanticsLabel('999+'), findsOneWidget);
      expect(find.bySemanticsLabel('3 notificações'), findsOneWidget);
      expect(find.bySemanticsLabel('3'), findsNothing);
      handle.dispose();
    });

    testWidgets('[Acessibilidade] Semântica — Contador sobre um botão', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        RebicApp(
          home: Center(
            child: RebicBadge(
              count: 3,
              semanticLabel: '3 novas',
              child: RebicIconButton(
                icon: RebicIcons.notification,
                tooltip: 'Notificações',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      final data = tester
          .getSemantics(
            find.descendant(
              of: find.byType(RebicIconButton),
              matching: find.byType(RebicInteractable),
            ),
          )
          .getSemanticsData();
      expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(data.label, contains('Notificações'));
      expect(data.label, contains('3 novas'));
      expect(
        data.label.indexOf('Notificações'),
        lessThan(data.label.indexOf('3 novas')),
      );
      handle.dispose();
    });
  });

  group('[Responsividade] Direção e escala', () {
    testWidgets('[Responsividade] Direção e escala — Contador em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          direction: TextDirection.rtl,
          RebicBadge(count: 3, child: _target()),
        ),
      );
      final target = tester.getRect(find.byKey(const Key('target')));
      final center = tester.getCenter(_pill());
      expect(center.dx, closeTo(target.left, 0.01));
      expect(center.dy, closeTo(target.top, 0.01));
    });

    testWidgets(
      '[Responsividade] Direção e escala — Contador com escala de texto 2,0',
      (tester) async {
        await tester.pumpWidget(_host(RebicBadge(count: 3, child: _target())));
        final normal = tester.getSize(_pill());
        await tester.pumpWidget(
          _host(textScale: 2, RebicBadge(count: 3, child: _target())),
        );
        expect(tester.takeException(), isNull);
        expect(tester.getSize(_pill()).height, greaterThan(normal.height));
        expect(tester.getSize(find.byType(RebicBadge)), const Size(40, 40));
      },
    );
  });

  testWidgets('[Integração] Dependências — Contador sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            const RebicBadge(count: 12),
            RebicBadge(
              count: 3,
              child: RebicIconButton(
                icon: RebicIcons.notification,
                tooltip: 'Notificações',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
    expect(find.byType(RebicBadge), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do contador', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-badge',
        'add-rebic-badge',
      );
      expect(names, hasLength(19));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do contador', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_badge_$name',
          theme: theme,
          size: const Size(480, 240),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => RebicColumn(
                  gap: RebicSpace.xxl,
                  children: [
                    RebicRow(
                      children: [
                        for (final state in RebicValueState.values) ...[
                          RebicBadge(count: 7, state: state),
                          RebicBadge(count: 128, state: state),
                        ],
                        const RebicBadge(count: 1500),
                      ],
                    ),
                    RebicRow(
                      gap: RebicSpace.xxl,
                      children: [
                        for (final (icon, count) in [
                          (RebicIcons.notification, 3),
                          (RebicIcons.file, 42),
                          (RebicIcons.user, 1500),
                        ])
                          RebicBadge(
                            count: count,
                            child: RebicIconButton(
                              icon: icon,
                              tooltip: '$count',
                              onPressed: () {},
                            ),
                          ),
                      ],
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

  test('[Restrições] Fora do escopo — Contador sem valor literal', () {
    final source = File(
      'lib/src/exibicao_dados/badge/rebic_badge.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(
        type.replaceAll('?', ''),
        isNot(isIn(['double', 'Color', 'Offset', 'Alignment'])),
      );
    }
  });
}
