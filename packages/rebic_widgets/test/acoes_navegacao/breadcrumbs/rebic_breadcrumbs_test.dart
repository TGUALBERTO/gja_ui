import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

Widget _app(
  Widget home, {
  TextDirection direction = TextDirection.ltr,
  double width = 600,
}) => RebicApp(
  builder: (context, child) =>
      Directionality(textDirection: direction, child: child!),
  home: Center(
    child: SizedBox(width: width, child: home),
  ),
);

RebicBreadcrumbs _trail({
  VoidCallback? onOrders,
  RebicBreadcrumbsSeparator separator = RebicBreadcrumbsSeparator.slash,
}) => RebicBreadcrumbs(
  separatorStyle: separator,
  links: [
    RebicLink(text: 'Início', onPress: () {}),
    RebicLink(text: 'Pedidos', onPress: onOrders ?? () {}),
  ],
  currentLocationText: '4711',
);

void main() {
  testWidgets('[API] Propriedades — Trilha mínima', (tester) async {
    await tester.pumpWidget(_app(_trail()));
    final start = tester.getRect(find.text('Início'));
    final orders = tester.getRect(find.text('Pedidos'));
    final current = tester.getRect(find.text('4711'));
    expect(start.left, lessThan(orders.left));
    expect(orders.left, lessThan(current.left));
    expect(start.center.dy, closeTo(current.center.dy, 0.5));
    expect(find.text('/'), findsNWidgets(2));
  });

  testWidgets('[API] Callbacks e controlador — Trilha vazia', (tester) async {
    await tester.pumpWidget(_app(const RebicBreadcrumbs(links: [])));
    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('[Comportamento] Navegação pelos links — Voltar pelo link', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(_app(_trail(onOrders: () => calls++)));
    await tester.tap(find.text('Pedidos'));
    await tester.tap(find.text('4711'));
    expect(calls, 1);
  });

  testWidgets('[Aparência] Tokens de componente — Separador da trilha', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(_trail(separator: RebicBreadcrumbsSeparator.greaterThan)),
    );
    final separators = tester.widgetList<Text>(find.text('>')).toList();
    expect(separators, hasLength(2));
    expect(separators.first.style?.color, _light.colors.label);
    expect(
      tester.widget<Text>(find.text('4711')).style?.color,
      _light.colors.text,
    );
  });

  testWidgets('[Estados] Sem estados próprios — Foco só nos links', (
    tester,
  ) async {
    final start = FocusNode();
    final after = FocusNode();
    addTearDown(start.dispose);
    addTearDown(after.dispose);
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Focus(focusNode: start, child: const SizedBox.square(dimension: 8)),
            _trail(),
            Focus(focusNode: after, child: const SizedBox.square(dimension: 8)),
          ],
        ),
      ),
    );
    start.requestFocus();
    await tester.pump();
    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }
    expect(after.hasPrimaryFocus, isTrue);
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Semântica da trilha',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(_app(_trail()));
        expect(
          tester.getSemantics(find.text('Início')),
          containsSemantics(isLink: true),
        );
        expect(
          tester.getSemantics(find.text('Pedidos')),
          containsSemantics(isLink: true),
        );
        expect(find.semantics.byLabel('4711'), findsOneWidget);
        expect(find.semantics.byLabel('/'), findsNothing);
        handle.dispose();
      },
    );

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Contraste da trilha',
      (tester) async {
        final handle = tester.ensureSemantics();
        for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
          await tester.pumpWidget(
            RebicApp(
              key: ValueKey(theme.brightness),
              theme: theme,
              darkTheme: theme,
              home: RebicContainer(
                surface: RebicSurface.background,
                child: Center(child: _trail()),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        handle.dispose();
      },
    );
  });

  group('[Responsividade] Quebra e direção', () {
    testWidgets('[Responsividade] Quebra e direção — Trilha estreita', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          width: 200,
          RebicBreadcrumbs(
            links: [
              for (final t in ['Início', 'Vendas', 'Pedidos', 'Itens', 'Lotes'])
                RebicLink(text: t, onPress: () {}),
            ],
            currentLocationText: 'Lote 7',
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getTopLeft(find.text('Lote 7')).dy,
        greaterThan(tester.getTopLeft(find.text('Início')).dy),
      );
    });

    testWidgets('[Responsividade] Quebra e direção — Trilha em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(_app(direction: TextDirection.rtl, _trail()));
      expect(
        tester.getCenter(find.text('Início')).dx,
        greaterThan(tester.getCenter(find.text('4711')).dx),
      );
    });
  });

  testWidgets('[Integração] Dependências — Trilha sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in RebicBreadcrumbsSeparator.values)
              _trail(separator: s),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Pedidos').first);
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade da trilha', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-breadcrumbs',
        'add-rebic-breadcrumbs',
      );
      expect(names, hasLength(14));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens da trilha', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_breadcrumbs_$name',
          theme: theme,
          size: const Size(420, 420),
          child: RebicVBox(
            gap: RebicSpace.s,
            items: [
              for (final s in RebicBreadcrumbsSeparator.values)
                _trail(separator: s),
            ],
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Trilha sem valor literal', () {
    final source = File(
      'lib/src/acoes_navegacao/breadcrumbs/rebic_breadcrumbs.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicBreadcrumbs\(\{(.*?)\}\);',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    expect(ctor, isNot(contains('double')));
    expect(ctor, isNot(contains('Color')));
  });
}
