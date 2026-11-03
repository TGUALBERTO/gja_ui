import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/golden.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

const _homeKey = Key('home');
const _extraKey = Key('extra');

/// Barra com todos os elementos; [log] registra os eventos.
RebicShellBar _full({List<String>? log, int notifications = 0}) =>
    RebicShellBar(
      title: 'Compras',
      secondTitle: 'Pedidos de compra',
      homeIcon: const RebicIcon(RebicIcons.home, key: _homeKey),
      showNavButton: true,
      showMenuButton: true,
      showSearch: true,
      showNotifications: true,
      notificationsNumber: notifications,
      showProductSwitcher: true,
      profile: const RebicAvatar(initials: 'TA'),
      additionalContent: const [
        SizedBox(key: _extraKey, width: 24, height: 24),
      ],
      onNavButtonPressed: () => log?.add('nav'),
      onMenuButtonPressed: () => log?.add('menu'),
      onHomeIconPressed: () => log?.add('home'),
      onSearchButtonPressed: () => log?.add('search'),
      onNotificationsPressed: () => log?.add('notifications'),
      onAvatarPressed: () => log?.add('avatar'),
      onProductSwitcherPressed: () => log?.add('products'),
    );

/// Monta [bar] no topo de uma área de largura [width], sob [theme].
Widget _host(
  Widget bar, {
  double width = 1200,
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicTheme(
  data: theme ?? _light,
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(width: width, child: bar),
    ),
  ),
);

void _view(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1300, 600);
  addTearDown(tester.view.reset);
}

Finder _button(IconData icon) =>
    find.ancestor(of: find.byIcon(icon), matching: find.byType(RebicButton));

Finder get _bar => find.byType(RebicShellBar);

/// Tamanho desenhado do botão de [icon], sem a área de toque extra.
Size _visible(WidgetTester tester, IconData icon) => tester.getSize(
  find.descendant(of: _button(icon), matching: find.byType(DecoratedBox)),
);

BoxDecoration _barDecoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find
                  .descendant(of: _bar, matching: find.byType(DecoratedBox))
                  .first,
            )
            .decoration
        as BoxDecoration;

void main() {
  setUpAll(loadRebicFonts);

  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Barra completa', (tester) async {
      _view(tester);
      await tester.pumpWidget(_host(_full()));
      final order = [
        _button(RebicIcons.navBack),
        _button(RebicIcons.menu2),
        find.byKey(_homeKey),
        find.text('Compras'),
        find.text('Pedidos de compra'),
        _button(RebicIcons.search),
        _button(RebicIcons.bell),
        find.byKey(_extraKey),
        find.byType(RebicAvatar),
        _button(RebicIcons.grid),
      ];
      for (var i = 1; i < order.length; i++) {
        expect(
          tester.getRect(order[i - 1]).right,
          lessThanOrEqualTo(tester.getRect(order[i]).left),
          reason: '$i',
        );
      }
      final margin = _light.spacing.xxxl;
      expect(
        tester.getRect(_button(RebicIcons.grid)).right,
        closeTo(tester.getRect(_bar).right - margin, 0.5),
      );
    });

    testWidgets('[API] Propriedades — Barra só com título', (tester) async {
      _view(tester);
      await tester.pumpWidget(_host(const RebicShellBar(title: 'Compras')));
      expect(find.text('Compras'), findsOneWidget);
      expect(find.byType(RebicButton), findsNothing);
      expect(find.byType(RebicInteractable), findsNothing);
    });
  });

  test('[API] Botões da barra — Contador negativo', () {
    expect(
      () => RebicShellBar(notificationsNumber: int.parse('-1')),
      throwsA(
        isA<AssertionError>().having(
          (e) => e.message,
          'message',
          contains('"notificationsNumber"'),
        ),
      ),
    );
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Botões avisam a aplicação', (
      tester,
    ) async {
      _view(tester);
      final log = <String>[];
      await tester.pumpWidget(_host(_full(log: log)));
      for (final target in [
        _button(RebicIcons.navBack),
        _button(RebicIcons.menu2),
        find.byKey(_homeKey),
        _button(RebicIcons.search),
        _button(RebicIcons.bell),
        find.byType(RebicAvatar),
        _button(RebicIcons.grid),
      ]) {
        await tester.tap(target);
        await tester.pump();
      }
      expect(log, [
        'nav',
        'menu',
        'home',
        'search',
        'notifications',
        'avatar',
        'products',
      ]);
    });

    testWidgets('[API] Callbacks e controlador — Botão sem callback', (
      tester,
    ) async {
      _view(tester);
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(const RebicShellBar(showSearch: true)));
      final search = tester.widget<RebicButton>(_button(RebicIcons.search));
      expect(search.enabled, isFalse);
      expect(
        tester.getSemantics(
          find.descendant(
            of: _button(RebicIcons.search),
            matching: find.byType(RebicInteractable),
          ),
        ),
        containsSemantics(hasEnabledState: true, isEnabled: false),
      );
      handle.dispose();
    });
  });

  testWidgets(
    '[Comportamento] Contador de notificações — Notificações com contador',
    (tester) async {
      _view(tester);
      await tester.pumpWidget(
        _host(
          RebicShellBar(
            showNotifications: true,
            notificationsNumber: 4,
            onNotificationsPressed: () {},
          ),
        ),
      );
      final badge = tester.widget<RebicBadge>(find.byType(RebicBadge));
      expect(badge.count, 4);
      expect(badge.state, RebicValueState.error);
      expect(find.text('4'), findsOneWidget);

      await tester.pumpWidget(
        _host(
          RebicShellBar(showNotifications: true, onNotificationsPressed: () {}),
        ),
      );
      expect(find.text('0'), findsNothing);
    },
  );

  testWidgets('[Comportamento] Espaço insuficiente — Títulos truncados', (
    tester,
  ) async {
    _view(tester);
    await tester.pumpWidget(
      _host(
        width: 360,
        RebicShellBar(
          title: 'Compras e suprimentos corporativos',
          secondTitle: 'Pedidos de compra em aberto no período',
          showNavButton: true,
          showMenuButton: true,
          showNotifications: true,
          profile: const RebicAvatar(initials: 'TA'),
          onNavButtonPressed: () {},
          onMenuButtonPressed: () {},
          onNotificationsPressed: () {},
          onAvatarPressed: () {},
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final second = tester.renderObject<RenderParagraph>(
      find.text('Pedidos de compra em aberto no período'),
    );
    expect(second.didExceedMaxLines, isTrue);
    final bar = tester.getRect(_bar);
    for (final target in [
      _button(RebicIcons.navBack),
      _button(RebicIcons.menu2),
      _button(RebicIcons.bell),
      find.byType(RebicAvatar),
    ]) {
      final rect = tester.getRect(target);
      expect(rect.left, greaterThanOrEqualTo(bar.left));
      expect(rect.right, lessThanOrEqualTo(bar.right));
      expect(rect.width, greaterThan(0));
    }
    expect(
      _visible(tester, RebicIcons.bell).width,
      _light.density.controlHeight,
    );
  });

  group('[Aparência] Superfície e margem', () {
    testWidgets('[Aparência] Superfície e margem — Aparência da barra', (
      tester,
    ) async {
      _view(tester);
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        await tester.pumpWidget(
          _host(
            theme: theme,
            KeyedSubtree(key: ValueKey(theme), child: _full()),
          ),
        );
        final decoration = _barDecoration(tester);
        expect(decoration.color, theme.colors.shell);
        expect(decoration.boxShadow, hasLength(theme.shadows.header.length));
        expect(decoration.boxShadow, isNotEmpty);
        expect(tester.getSize(_bar).height, theme.spacing.xxxl);
        final title = tester.widget<Text>(find.text('Compras')).style!;
        expect(title.fontSize, theme.typography.header5.fontSize);
        expect(title.fontWeight, theme.typography.header5.fontWeight);
        expect(title.color, theme.colors.text);
      }
    });

    testWidgets('[Aparência] Superfície e margem — Margem por largura', (
      tester,
    ) async {
      _view(tester);
      final spacing = _light.spacing;
      for (final (width, margin) in [
        (500.0, spacing.pageMargin),
        (800.0, spacing.xxl),
        (1200.0, spacing.xxxl),
      ]) {
        await tester.pumpWidget(
          _host(
            width: width,
            RebicShellBar(
              key: ValueKey(width),
              showMenuButton: true,
              onMenuButtonPressed: () {},
            ),
          ),
        );
        expect(
          tester.getRect(_button(RebicIcons.menu2)).left -
              tester.getRect(_bar).left,
          margin,
          reason: '$width',
        );
      }
    });
  });

  testWidgets('[Aparência] Títulos e botões — Ícones dos botões', (
    tester,
  ) async {
    _view(tester);
    await tester.pumpWidget(_host(_full()));
    for (final icon in [
      RebicIcons.navBack,
      RebicIcons.menu2,
      RebicIcons.search,
      RebicIcons.bell,
      RebicIcons.grid,
    ]) {
      expect(
        tester.widget<RebicButton>(_button(icon)).type,
        RebicButtonType.transparent,
      );
    }
    final second = tester.widget<Text>(find.text('Pedidos de compra')).style!;
    expect(second.fontSize, _light.typography.small.fontSize);
    expect(second.color, _light.colors.text);
    expect(
      tester.widget<RebicAvatar>(find.byType(RebicAvatar)).size,
      RebicAvatarSize.xs,
    );
  });

  testWidgets('[Estados] Estados dos botões — Botão da barra em hover', (
    tester,
  ) async {
    _view(tester);
    await tester.pumpWidget(
      _host(RebicShellBar(showMenuButton: true, onMenuButtonPressed: () {})),
    );
    final menu = _button(RebicIcons.menu2);
    Color? background() =>
        (tester
                    .widget<DecoratedBox>(
                      find.descendant(
                        of: menu,
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
    await mouse.moveTo(tester.getCenter(menu));
    await tester.pump();
    expect(background(), transparent.hover.background);
  });

  group('[Acessibilidade] Teclado e foco', () {
    testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na barra', (
      tester,
    ) async {
      _view(tester);
      await tester.pumpWidget(
        RebicApp(
          home: Align(
            alignment: Alignment.topCenter,
            child: RebicShellBar(
              showNavButton: true,
              showMenuButton: true,
              showSearch: true,
              profile: const RebicAvatar(initials: 'TA'),
              onNavButtonPressed: () {},
              onMenuButtonPressed: () {},
              onSearchButtonPressed: () {},
              onAvatarPressed: () {},
            ),
          ),
        ),
      );
      Rect focused() => tester.getRect(
        find.byWidget(FocusManager.instance.primaryFocus!.context!.widget),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final visited = [focused()];
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        visited.add(focused());
      }
      expect(visited.map((r) => r.center), [
        tester.getCenter(_button(RebicIcons.navBack)),
        tester.getCenter(_button(RebicIcons.menu2)),
        tester.getCenter(_button(RebicIcons.search)),
        tester.getCenter(find.byType(RebicAvatar)),
      ]);
    });

    testWidgets('[Acessibilidade] Teclado e foco — Menu pelo teclado', (
      tester,
    ) async {
      _view(tester);
      var pressed = 0;
      await tester.pumpWidget(
        RebicApp(
          home: Align(
            alignment: Alignment.topCenter,
            child: RebicShellBar(
              showMenuButton: true,
              onMenuButtonPressed: () => pressed++,
            ),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(pressed, 1);
    });
  });

  testWidgets('[Acessibilidade] Semântica — Semântica da barra', (
    tester,
  ) async {
    _view(tester);
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      RebicApp(
        locale: const Locale('pt', 'BR'),
        home: Align(
          alignment: Alignment.topCenter,
          child: _full(notifications: 4),
        ),
      ),
    );
    expect(
      tester.getSemantics(_bar),
      containsSemantics(label: 'Barra de shell'),
    );
    final title = tester.getSemantics(find.text('Compras')).getSemanticsData();
    expect(title.hasFlag(SemanticsFlag.isHeader), isTrue);
    expect(title.headingLevel, 1);
    String label(IconData icon) => tester
        .getSemantics(
          find.descendant(
            of: _button(icon),
            matching: find.byType(RebicInteractable),
          ),
        )
        .getSemanticsData()
        .label;
    expect(label(RebicIcons.navBack), 'Voltar');
    expect(label(RebicIcons.menu2), 'Menu');
    expect(label(RebicIcons.search), 'Pesquisar');
    expect(label(RebicIcons.grid), 'Meus produtos');
    final notifications = label(RebicIcons.bell);
    expect(notifications, contains('Notificações'));
    expect(notifications, contains('4'));
    handle.dispose();
  });

  // "Contraste e alvo na barra" fica em rebic_shell_bar_a11y_test.dart, sem
  // a fonte real: a diretriz de contraste mede pixels e precisa dos glifos
  // sólidos da fonte de teste padrão.

  group('[Responsividade] Largura, densidade e direção', () {
    testWidgets(
      '[Responsividade] Largura, densidade e direção — Barra em RTL',
      (tester) async {
        _view(tester);
        await tester.pumpWidget(
          _host(
            direction: TextDirection.rtl,
            RebicShellBar(
              title: 'Compras',
              showNavButton: true,
              profile: const RebicAvatar(initials: 'TA'),
              onNavButtonPressed: () {},
              onAvatarPressed: () {},
            ),
          ),
        );
        final bar = tester.getRect(_bar);
        final margin = _light.spacing.xxxl;
        expect(
          tester.getRect(_button(RebicIcons.navBack)).right,
          closeTo(bar.right - margin, 0.5),
        );
        expect(
          tester.getRect(find.byType(RebicAvatar)).left,
          closeTo(bar.left + margin, 0.5),
        );
        expect(
          tester.getRect(find.text('Compras')).right,
          lessThanOrEqualTo(tester.getRect(_button(RebicIcons.navBack)).left),
        );
        expect(RebicIcons.navBack.matchTextDirection, isTrue);
        final icon = tester.widget<Icon>(find.byIcon(RebicIcons.navBack));
        expect(
          Directionality.of(tester.element(find.byWidget(icon))),
          TextDirection.rtl,
        );
      },
    );

    testWidgets(
      '[Responsividade] Largura, densidade e direção — Barra na densidade compacta',
      (tester) async {
        _view(tester);
        final compact = _light.withDensity(RebicDensity.compact);
        await tester.pumpWidget(
          _host(
            theme: compact,
            RebicShellBar(showMenuButton: true, onMenuButtonPressed: () {}),
          ),
        );
        expect(tester.getSize(_bar).height, compact.spacing.xxxl);
        expect(
          _visible(tester, RebicIcons.menu2).height,
          compact.density.controlHeight,
        );
      },
    );
  });

  testWidgets(
    '[Integração] Dependências de widgets e núcleo — Barra sem Material',
    (tester) async {
      _view(tester);
      await tester.pumpWidget(
        RebicApp(
          home: Align(alignment: Alignment.topCenter, child: _full()),
        ),
      );
      await tester.tap(_button(RebicIcons.menu2));
      await tester.tap(find.byType(RebicAvatar));
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    '[Integração] Dependências de fundamentos — Barra pelo tema da subárvore',
    (tester) async {
      _view(tester);
      final dark = RebicThemeData.dark();
      await tester.pumpWidget(
        RebicApp(
          themeMode: RebicThemeMode.light,
          home: RebicTheme(
            data: dark,
            child: const Align(
              alignment: Alignment.topCenter,
              child: RebicShellBar(title: 'Compras'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_barDecoration(tester).color, dark.colors.shell);
    },
  );

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade da barra', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-shell-bar',
        'update-rebic-scaffold-fiori-tool-page',
      );
      expect(names, hasLength(23));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens da barra', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await expectGolden(
          tester,
          name: 'rebic_shell_bar_$name',
          theme: theme,
          size: const Size(1100, 200),
          child: Column(
            spacing: 24,
            children: [
              _full(notifications: 4),
              const RebicShellBar(title: 'Compras'),
            ],
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Barra sem valor literal', () {
    // Só a classe pública; os auxiliares privados vêm depois dela.
    final file = File(
      'lib/src/fundacao_layout/shell_bar/rebic_shell_bar.dart',
    ).readAsStringSync();
    final source = file.substring(0, file.indexOf('enum _TitleSlot'));
    final ctor = RegExp(
      r'const RebicShellBar\(\{(.*?)\}\)',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    for (final name in ['menu', 'searchManager', 'showCopilot']) {
      expect(ctor, isNot(contains('this.$name,')), reason: name);
    }
    for (final field in RegExp(
      r'^  final (\S+) \w+;$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!)) {
      expect(field, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
