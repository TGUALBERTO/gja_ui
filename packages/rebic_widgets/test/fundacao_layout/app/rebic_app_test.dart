import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/traceability.dart';

/// Página que guarda o contexto e o tema lidos a cada build.
class _Page extends StatelessWidget {
  const _Page(this.probe, {this.child});

  final _Probe probe;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    probe
      ..context = context
      ..theme = RebicTheme.of(context)
      ..texts = RebicLocalizations.of(context);
    return child ?? const SizedBox.expand();
  }
}

class _Probe {
  late BuildContext context;
  late RebicThemeData theme;
  late RebicLocalizations texts;
}

/// Página com estado, para provar que a navegação não é reconstruída.
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  static int created = 0;

  @override
  void initState() {
    super.initState();
    created++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

class _Delegate extends RouterDelegate<Object> with ChangeNotifier {
  _Delegate(this.page);

  final Widget page;

  @override
  Widget build(BuildContext context) => page;

  @override
  Future<bool> popRoute() => SynchronousFuture(false);

  @override
  Future<void> setNewRoutePath(Object configuration) => SynchronousFuture(null);
}

void main() {
  final light = RebicThemeData.light();
  final dark = RebicThemeData.dark();

  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Uso mínimo', (tester) async {
      final probe = _Probe();
      await tester.pumpWidget(RebicApp(home: _Page(probe)));
      final recommended = RebicResponsive.recommendedDensity();
      expect(probe.theme, light.withDensity(recommended));
      // O ambiente de teste é en-US: os textos são os de en.
      expect(probe.texts.cancel, 'Cancel');
    });

    testWidgets('[API] Propriedades — Aplicação com Router', (tester) async {
      final probe = _Probe();
      final config = RouterConfig<Object>(
        routerDelegate: _Delegate(_Page(probe)),
      );
      await tester.pumpWidget(RebicApp.router(routerConfig: config));
      expect(find.byType(_Page), findsOneWidget);
      expect(probe.theme.colors, light.colors);
      expect(probe.texts.cancel, 'Cancel');
    });
  });

  testWidgets('[API] Tema, densidade e idioma — Valores padrão', (
    tester,
  ) async {
    final probe = _Probe();
    await tester.pumpWidget(RebicApp(home: _Page(probe)));
    expect(probe.theme.colors, light.colors);
    final app = tester.widget<WidgetsApp>(find.byType(WidgetsApp));
    expect(app.supportedLocales, RebicLocalizations.supportedLocales);
  });

  testWidgets('[API] Callbacks e controlador — Navegação nativa', (
    tester,
  ) async {
    final probe = _Probe();
    await tester.pumpWidget(
      RebicApp(
        home: _Page(probe),
        routes: {'/detalhe': (_) => const Text('detalhe')},
      ),
    );
    unawaited(Navigator.pushNamed(probe.context, '/detalhe'));
    await tester.pumpAndSettle();
    expect(find.text('detalhe'), findsOneWidget);
    Navigator.pop(tester.element(find.text('detalhe')));
    await tester.pumpAndSettle();
    expect(find.text('detalhe'), findsNothing);
  });

  group('[Comportamento] Tema e modo do sistema', () {
    testWidgets('[Comportamento] Tema e modo do sistema — Modo do sistema', (
      tester,
    ) async {
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      final probe = _Probe();
      _CounterState.created = 0;
      await tester.pumpWidget(
        RebicApp(
          density: RebicDensity.cozy,
          home: _Page(probe, child: const _Counter()),
        ),
      );
      expect(probe.theme.colors, light.colors);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pumpAndSettle();
      expect(probe.theme, dark);
      // A página não foi recriada: a navegação continua a mesma.
      expect(_CounterState.created, 1);
    });

    testWidgets('[Comportamento] Tema e modo do sistema — Modo fixo', (
      tester,
    ) async {
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      final probe = _Probe();
      await tester.pumpWidget(
        RebicApp(themeMode: RebicThemeMode.light, home: _Page(probe)),
      );
      expect(probe.theme.colors, light.colors);
    });
  });

  group('[Comportamento] Densidade da aplicação', () {
    testWidgets(
      '[Comportamento] Densidade da aplicação — Densidade recomendada',
      (tester) async {
        final probe = _Probe();
        await tester.pumpWidget(RebicApp(home: _Page(probe)));
        final expected = switch (defaultTargetPlatform) {
          TargetPlatform.windows ||
          TargetPlatform.macOS ||
          TargetPlatform.linux => RebicDensity.compact,
          _ => RebicDensity.cozy,
        };
        expect(probe.theme.density.density, expected);
      },
      variant: const TargetPlatformVariant({
        TargetPlatform.windows,
        TargetPlatform.android,
      }),
    );

    testWidgets(
      '[Comportamento] Densidade da aplicação — Densidade informada',
      (tester) async {
        final probe = _Probe();
        await tester.pumpWidget(
          RebicApp(density: RebicDensity.cozy, home: _Page(probe)),
        );
        expect(probe.theme.density.density, RebicDensity.cozy);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.windows),
    );
  });

  testWidgets('[Comportamento] Localização da aplicação — Idioma fixado', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('pt', 'BR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final probe = _Probe();
    await tester.pumpWidget(
      RebicApp(locale: const Locale('en'), home: _Page(probe)),
    );
    expect(probe.texts.cancel, 'Cancel');
  });

  group('[Comportamento] Transição de página', () {
    Future<void> openDetail(
      WidgetTester tester, {
      TextDirection? direction,
      RebicThemeData? theme,
    }) async {
      final probe = _Probe();
      await tester.pumpWidget(
        RebicApp(
          theme: theme,
          density: RebicDensity.cozy,
          builder: direction == null
              ? null
              : (context, child) =>
                    Directionality(textDirection: direction, child: child!),
          home: _Page(probe),
          routes: {
            '/detalhe': (_) => const SizedBox.expand(key: Key('detalhe')),
          },
        ),
      );
      unawaited(Navigator.pushNamed(probe.context, '/detalhe'));
    }

    testWidgets('[Comportamento] Transição de página — Meio da transição', (
      tester,
    ) async {
      final half = light.motion.medium ~/ 2;
      for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
        await openDetail(tester, direction: direction);
        await tester.pump();
        await tester.pump(half);
        final left = tester.getTopLeft(find.byKey(const Key('detalhe'))).dx;
        if (direction == TextDirection.ltr) {
          expect(left, inExclusiveRange(0, 800), reason: '$direction');
        } else {
          expect(left, inExclusiveRange(-800, 0), reason: '$direction');
        }
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(find.byKey(const Key('detalhe'))).dx, 0);
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('[Comportamento] Transição de página — Movimento reduzido', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await openDetail(tester);
      await tester.pump();
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(const Key('detalhe'))).dx, 0);
    });

    testWidgets('transição imediata com o modo de animação none do tema', (
      tester,
    ) async {
      await openDetail(
        tester,
        theme: light.copyWith(animationMode: RebicAnimationMode.none),
      );
      await tester.pump();
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(const Key('detalhe'))).dx, 0);
    });
  });

  testWidgets('[Aparência] Fundo da aplicação — Troca de tema', (tester) async {
    Finder background(RebicThemeData theme) => find.byWidgetPredicate(
      (w) => w is ColoredBox && w.color == theme.colors.background,
    );
    final probe = _Probe();
    await tester.pumpWidget(
      RebicApp(themeMode: RebicThemeMode.light, home: _Page(probe)),
    );
    expect(background(light), findsOneWidget);
    await tester.pumpWidget(
      RebicApp(themeMode: RebicThemeMode.dark, home: _Page(probe)),
    );
    await tester.pumpAndSettle();
    expect(background(dark), findsOneWidget);
    expect(
      tester.widget<WidgetsApp>(find.byType(WidgetsApp)).color,
      dark.colors.brand,
    );
  });

  testWidgets('[Estados] Sem estados visuais — Não recebe foco', (
    tester,
  ) async {
    final nodes = [FocusNode(), FocusNode()];
    addTearDown(() {
      for (final n in nodes) {
        n.dispose();
      }
    });
    await tester.pumpWidget(
      RebicApp(
        home: Column(
          children: [
            for (final n in nodes)
              Focus(focusNode: n, child: const SizedBox(width: 20, height: 20)),
          ],
        ),
      ),
    );
    nodes.first.requestFocus();
    await tester.pump();
    final visited = <int>[];
    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      visited.add(nodes.indexWhere((n) => n.hasPrimaryFocus));
    }
    expect(visited, [1, 0, 1]);
  });

  testWidgets('[Acessibilidade] Teclado e foco — Esc dispensa um modal', (
    tester,
  ) async {
    final probe = _Probe();
    await tester.pumpWidget(RebicApp(home: _Page(probe)));
    unawaited(
      RebicModal.show<void>(probe.context, builder: (_) => const Text('modal')),
    );
    await tester.pumpAndSettle();
    expect(find.text('modal'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('modal'), findsNothing);
  });

  testWidgets(
    '[Acessibilidade] Semântica, escala e movimento — Escala de texto preservada',
    (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final probe = _Probe();
      await tester.pumpWidget(RebicApp(title: 'Pedidos', home: _Page(probe)));
      expect(MediaQuery.textScalerOf(probe.context).scale(1), 2);
      expect(
        tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
        'Pedidos',
      );
    },
  );

  testWidgets(
    '[Responsividade] Escopo de tela e plataformas — Densidade compacta',
    (tester) async {
      final probe = _Probe();
      await tester.pumpWidget(
        RebicApp(
          density: RebicDensity.compact,
          home: _Page(
            probe,
            child: Align(
              alignment: Alignment.topLeft,
              child: RebicInteractable(
                key: const Key('target'),
                onPressed: () {},
                builder: (context, states) =>
                    const SizedBox(width: 8, height: 8),
              ),
            ),
          ),
        ),
      );
      final compact = light.withDensity(RebicDensity.compact);
      expect(
        tester.getSize(find.byKey(const Key('target'))),
        Size.square(compact.density.minTargetSize),
      );
      expect(find.byType(RebicScreenSizeScope), findsOneWidget);
      expect(
        RebicResponsive.screenSizeClassOf(probe.context),
        compact.breakpoints.classify(800),
      );
    },
  );

  testWidgets('[Integração] Dependências — Funciona sem Material', (
    tester,
  ) async {
    final probe = _Probe();
    await tester.pumpWidget(
      RebicApp(
        home: _Page(
          probe,
          child: Column(
            children: [
              const Text('Pedido'),
              RebicInteractable(
                onPressed: () {},
                builder: (context, states) => const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Enviar'));
    unawaited(
      RebicModal.show<void>(probe.context, builder: (_) => const Text('modal')),
    );
    await tester.pumpAndSettle();
    expect(find.text('modal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('[Restrições] Fora do escopo — Sem estrutura de página', (
    tester,
  ) async {
    await tester.pumpWidget(const RebicApp(home: SizedBox.expand()));
    expect(find.byType(Text), findsNothing);
    expect(find.byType(RebicInteractable), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('[Testes] Cobertura exigida — Rastreabilidade', () {
    final names = scenarioNames('rebic/widgets/rebic-app', 'add-rebic-app');
    expect(names, hasLength(21));
    expect(untestedScenarios(names), isEmpty);
  });
}
