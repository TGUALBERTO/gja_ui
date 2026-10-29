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

/// Ajusta a janela de teste para [width] × [height].
void _view(WidgetTester tester, double width, [double height = 800]) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
}

/// Monta [child] sob [theme] e [direction], sem `RebicApp`.
Widget _host(
  Widget child, {
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
        child: child,
      ),
    ),
  ),
);

/// Navegação de teste: 240 expandida e 64 recolhida, pelo estado do scaffold.
class _Nav extends StatelessWidget {
  const _Nav({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final expanded = RebicScaffold.navigationExpandedOf(context)!;
    return SizedBox(
      key: const Key('nav'),
      width: expanded ? 240 : 64,
      child: Align(alignment: Alignment.topLeft, child: child),
    );
  }
}

/// Corpo que registra o estado da navegação a cada construção.
class _Probe extends StatelessWidget {
  const _Probe(this.seen);

  final List<bool?> seen;

  @override
  Widget build(BuildContext context) {
    seen.add(RebicScaffold.navigationExpandedOf(context));
    return const SizedBox.expand(key: Key('body'));
  }
}

/// Corpo com estado: um contador incrementado por toque.
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    key: const Key('counter'),
    onTap: () => setState(() => count++),
    child: SizedBox.expand(child: RebicText('contador $count')),
  );
}

Finder get _bar => find.byWidgetPredicate(
  (w) => w is RebicContainer && w.surface == RebicSurface.shell,
);

/// Área de navegação: o contêiner `base` do scaffold.
Finder get _side => find.byWidgetPredicate(
  (w) => w is RebicContainer && w.surface == RebicSurface.base,
);

Finder get _button => find.descendant(
  of: find.byType(RebicScaffold),
  matching: find.byType(RebicInteractable),
);

/// Visual do botão de navegação, dentro da área de interação (que tem o alvo
/// mínimo da densidade).
Finder get _buttonBox => find
    .descendant(
      of: find.byType(RebicIconButton),
      matching: find.byType(DecoratedBox),
    )
    .first;

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

Widget _box(String key) => SizedBox(key: Key(key), width: 20, height: 20);

final _light = RebicThemeData.light();

void main() {
  testWidgets('[API] Propriedades — Barra completa', (tester) async {
    _view(tester, 1200);
    await tester.pumpWidget(
      _host(
        RebicScaffold(
          logo: _box('logo'),
          title: 'Compras',
          actions: [_box('a1'), _box('a2')],
          navigation: const _Nav(),
          body: const SizedBox.expand(),
        ),
      ),
    );
    final button = tester.getRect(_button);
    final logo = _rect(tester, 'logo');
    final title = tester.getRect(find.text('Compras'));
    expect(button.left, lessThan(logo.left));
    expect(logo.right, lessThanOrEqualTo(title.left));
    expect(_rect(tester, 'a1').right, lessThan(_rect(tester, 'a2').left));
    expect(
      _rect(tester, 'a2').right,
      closeTo(tester.getRect(_bar).right - _light.spacing.m, 0.01),
    );
  });

  testWidgets('[API] Barra condicional — Scaffold mínimo', (tester) async {
    _view(tester, 1200);
    await tester.pumpWidget(
      _host(const RebicScaffold(body: SizedBox.expand(key: Key('body')))),
    );
    expect(_bar, findsNothing);
    expect(_button, findsNothing);
    expect(_rect(tester, 'body'), const Rect.fromLTWH(0, 0, 1200, 800));
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Navegação controlada', (
      tester,
    ) async {
      _view(tester, 1200);
      final values = <bool>[];
      Widget scaffold(bool expanded) => _host(
        RebicScaffold(
          navigationExpanded: expanded,
          onNavigationExpandedChanged: values.add,
          navigation: const _Nav(),
          body: const SizedBox.expand(),
        ),
      );
      await tester.pumpWidget(scaffold(false));
      await tester.tap(_button);
      await tester.pumpAndSettle();
      expect(values, [true]);
      expect(_rect(tester, 'nav').width, 64);
      await tester.pumpWidget(scaffold(true));
      await tester.pumpAndSettle();
      expect(_rect(tester, 'nav').width, 240);
    });

    testWidgets(
      '[API] Callbacks e controlador — Navegação automática alternada',
      (tester) async {
        _view(tester, 1200);
        final values = <bool>[];
        final seen = <bool?>[];
        await tester.pumpWidget(
          _host(
            RebicScaffold(
              onNavigationExpandedChanged: values.add,
              navigation: const _Nav(),
              body: _Probe(seen),
            ),
          ),
        );
        expect(seen.last, isTrue);
        await tester.tap(_button);
        await tester.pumpAndSettle();
        expect(seen.last, isFalse);
        expect(values, [false]);
      },
    );
  });

  group('[Comportamento] Estado automático por classe', () {
    testWidgets(
      '[Comportamento] Estado automático por classe — Estado inicial em cada classe',
      (tester) async {
        final states = <bool?>[];
        for (final width in [500.0, 800.0, 1200.0, 1500.0]) {
          _view(tester, width);
          final seen = <bool?>[];
          await tester.pumpWidget(
            _host(
              RebicScaffold(
                key: ValueKey(width),
                navigation: const _Nav(),
                body: _Probe(seen),
              ),
            ),
          );
          states.add(seen.last);
        }
        expect(states, [false, false, true, true]);
      },
    );

    testWidgets(
      '[Comportamento] Estado automático por classe — Troca de classe restaura o padrão',
      (tester) async {
        _view(tester, 1200);
        final seen = <bool?>[];
        await tester.pumpWidget(
          _host(RebicScaffold(navigation: const _Nav(), body: _Probe(seen))),
        );
        await tester.tap(_button);
        await tester.pumpAndSettle();
        expect(seen.last, isFalse);
        _view(tester, 1500);
        await tester.pumpAndSettle();
        expect(seen.last, isTrue);
      },
    );
  });

  testWidgets(
    '[Comportamento] Navegação ao lado do corpo — Navegação recolhida ao lado',
    (tester) async {
      _view(tester, 800);
      await tester.pumpWidget(
        _host(
          const RebicScaffold(
            navigation: _Nav(),
            body: SizedBox.expand(key: Key('body')),
          ),
        ),
      );
      final nav = _rect(tester, 'nav');
      final body = _rect(tester, 'body');
      expect(nav.left, 0);
      expect(nav.width, 64);
      expect(nav.top, tester.getRect(_bar).bottom);
      expect(body.left, closeTo(nav.right + const BorderSide().width, 0.01));
      expect(body.right, 800);
    },
  );

  group('[Comportamento] Navegação na tela small', () {
    testWidgets(
      '[Comportamento] Navegação na tela small — Navegação expandida cobre o corpo',
      (tester) async {
        _view(tester, 500);
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _host(
            const RebicScaffold(
              navigationExpanded: true,
              navigation: _Nav(),
              body: RebicText('Corpo da página'),
            ),
          ),
        );
        final nav = tester.getRect(_side);
        expect(nav.left, 0);
        expect(nav.width, 500);
        expect(nav.top, tester.getRect(_bar).bottom);
        expect(nav.bottom, 800);
        expect(find.text('Corpo da página'), findsNothing);
        expect(find.bySemanticsLabel('Corpo da página'), findsNothing);
        handle.dispose();
      },
    );

    testWidgets(
      '[Comportamento] Navegação na tela small — Estado do corpo preservado',
      (tester) async {
        _view(tester, 500);
        Widget scaffold(bool expanded) => _host(
          RebicScaffold(
            navigationExpanded: expanded,
            navigation: const _Nav(),
            body: const _Counter(),
          ),
        );
        await tester.pumpWidget(scaffold(false));
        for (var i = 0; i < 3; i++) {
          await tester.tap(find.byKey(const Key('counter')));
          await tester.pump();
        }
        await tester.pumpWidget(scaffold(true));
        expect(find.text('contador 3'), findsNothing);
        await tester.pumpWidget(scaffold(false));
        expect(find.text('contador 3'), findsOneWidget);
      },
    );
  });

  testWidgets(
    '[Aparência] Tokens de componente — Cores da barra e da navegação',
    (tester) async {
      _view(tester, 1200);
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        await tester.pumpWidget(
          _host(
            theme: theme,
            RebicScaffold(
              key: ValueKey(theme.brightness),
              title: 'Compras',
              navigation: const _Nav(),
              body: const SizedBox.expand(),
            ),
          ),
        );
        BoxDecoration decoration(Finder of) =>
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: of,
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration;
        final bar = decoration(_bar);
        expect(bar.color, theme.colors.shell);
        expect(bar.boxShadow, hasLength(theme.shadows.header.length));
        expect(bar.boxShadow, isNotEmpty);
        final nav = decoration(_side);
        expect(nav.color, theme.colors.base);
      }
    },
  );

  testWidgets(
    '[Aparência] Movimento da navegação — Largura sem animação no movimento reduzido',
    (tester) async {
      _view(tester, 1200);
      await tester.pumpWidget(
        _host(
          reduceMotion: true,
          const RebicScaffold(navigation: _Nav(), body: SizedBox.expand()),
        ),
      );
      expect(tester.getSize(_side).width, 240);
      await tester.tap(_button);
      await tester.pump();
      expect(tester.getSize(_side).width, 64);
    },
  );

  testWidgets('[Estados] Botão de navegação — Botão em hover', (tester) async {
    _view(tester, 1200);
    await tester.pumpWidget(
      _host(const RebicScaffold(navigation: _Nav(), body: SizedBox.expand())),
    );
    Color? background() =>
        (tester
                    .widget<DecoratedBox>(
                      find.descendant(
                        of: _button,
                        matching: find.byType(DecoratedBox),
                      ),
                    )
                    .decoration
                as BoxDecoration)
            .color;
    final transparent = RebicControlColors.of(
      RebicControlFamily.transparent,
      _light.colors,
    );
    expect(background(), transparent.normal.background);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(_button));
    await tester.pump();
    expect(background(), transparent.hover.background);
    expect(background(), _light.colors.hoverBackground);
  });

  group('[Acessibilidade] Teclado e foco', () {
    testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco no scaffold', (
      tester,
    ) async {
      _view(tester, 1200);
      final action = FocusNode();
      final item = FocusNode();
      final content = FocusNode();
      addTearDown(() {
        action.dispose();
        item.dispose();
        content.dispose();
      });
      Widget focusable(FocusNode node) =>
          Focus(focusNode: node, child: const SizedBox(width: 20, height: 20));
      await tester.pumpWidget(
        RebicApp(
          home: RebicScaffold(
            title: 'Compras',
            actions: [focusable(action)],
            navigation: _Nav(child: focusable(item)),
            body: Align(
              alignment: Alignment.topLeft,
              child: focusable(content),
            ),
          ),
        ),
      );
      final visited = <String>[];
      for (var i = 0; i < 4; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final focus = FocusManager.instance.primaryFocus;
        visited.add(switch (focus) {
          _ when focus == action => 'ação',
          _ when focus == item => 'navegação',
          _ when focus == content => 'corpo',
          _
              when focus?.context
                      ?.findAncestorWidgetOfExactType<RebicInteractable>() !=
                  null =>
            'botão',
          _ => '?',
        });
      }
      expect(visited, ['botão', 'ação', 'navegação', 'corpo']);
    });

    testWidgets('[Acessibilidade] Teclado e foco — Botão pelo teclado', (
      tester,
    ) async {
      _view(tester, 1200);
      final seen = <bool?>[];
      await tester.pumpWidget(
        RebicApp(
          home: RebicScaffold(navigation: const _Nav(), body: _Probe(seen)),
        ),
      );
      expect(seen.last, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(seen.last, isFalse);
    });
  });

  testWidgets('[Responsividade] Tela e direção — Scaffold em RTL', (
    tester,
  ) async {
    _view(tester, 1200);
    await tester.pumpWidget(
      _host(
        direction: TextDirection.rtl,
        RebicScaffold(
          actions: [_box('action')],
          navigation: const _Nav(),
          body: const SizedBox.expand(),
        ),
      ),
    );
    final m = _light.spacing.m;
    expect(_rect(tester, 'nav').right, 1200);
    expect(tester.getRect(_button).right, closeTo(1200 - m, 0.01));
    expect(_rect(tester, 'action').left, closeTo(m, 0.01));
  });

  testWidgets(
    '[Integração] Dependências de widgets e núcleo — Scaffold sem Material',
    (tester) async {
      await tester.pumpWidget(
        const RebicApp(
          home: RebicScaffold(
            title: 'Compras',
            navigation: _Nav(),
            body: RebicText('Pedidos'),
          ),
        ),
      );
      expect(find.byType(RebicScaffold), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    '[Integração] Dependências de fundamentos — Barra pelo tema da subárvore',
    (tester) async {
      _view(tester, 1200);
      final dark = RebicThemeData.dark(density: RebicDensity.compact);
      await tester.pumpWidget(
        RebicApp(
          density: RebicDensity.cozy,
          home: RebicTheme(
            data: dark,
            child: const RebicScaffold(
              navigation: _Nav(),
              body: SizedBox.expand(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final bar =
          tester
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: _bar,
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(bar.color, dark.colors.shell);
      expect(
        tester.getSize(_buttonBox),
        Size.square(dark.density.controlHeight),
      );
    },
  );

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do scaffold', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-scaffold',
        'add-rebic-scaffold',
      );
      expect(names, hasLength(23));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do scaffold', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_scaffold_$name',
          theme: theme,
          size: const Size(1200, 480),
          surface: RebicSurface.background,
          child: const _GoldenScaffold(),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Scaffold sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/scaffold/rebic_scaffold.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicScaffold\(\{(.*?)\}\)',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    expect(ctor, contains('this.body'));
    for (final field in RegExp(
      r'^  final (\S+) \w+;$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!)) {
      expect(field, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}

/// Amostra dos goldens: barra completa, navegação expandida e corpo.
class _GoldenScaffold extends StatelessWidget {
  const _GoldenScaffold();

  @override
  Widget build(BuildContext context) {
    Widget item(BuildContext context, IconData icon, String label) =>
        RebicSpacing.padding(
          horizontal: RebicSpace.m,
          vertical: RebicSpace.s,
          child: RebicRow(
            children: [
              RebicIcon(icon),
              if (RebicScaffold.navigationExpandedOf(context)!)
                RebicText(label),
            ],
          ),
        );
    return RebicScaffold(
      logo: const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
      title: 'Compras',
      actions: const [
        RebicIcon(RebicIcons.notification),
        RebicIcon(RebicIcons.user),
      ],
      navigation: SizedBox(
        width: 240,
        child: Builder(
          builder: (context) => RebicColumn(
            gap: RebicSpace.none,
            children: [
              item(context, RebicIcons.home, 'Início'),
              item(context, RebicIcons.file, 'Pedidos'),
              item(context, RebicIcons.settings, 'Configurações'),
            ],
          ),
        ),
      ),
      body: const RebicSpacing.padding(
        all: RebicSpace.l,
        child: RebicText(
          'Pedidos em aberto',
          variant: RebicTextVariant.headline,
        ),
      ),
    );
  }
}
