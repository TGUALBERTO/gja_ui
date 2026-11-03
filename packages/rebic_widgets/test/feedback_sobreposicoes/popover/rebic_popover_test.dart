import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/golden.dart';
import '../../support/traceability.dart';

const _long =
    'Mostra apenas os pedidos em aberto do período escolhido, com os itens '
    'ainda não faturados e as entregas previstas para as próximas semanas.';

/// Aplicação de teste com [home] sob [theme], na direção [direction] e com a
/// escala de texto [textScale].
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
    child: Directionality(
      textDirection: direction,
      child: RepaintBoundary(key: const Key('golden'), child: child!),
    ),
  ),
  home: home,
);

/// [popover] a [inset] do canto superior inicial.
Widget _anchored(Widget popover, {double inset = 40}) => Padding(
  padding: EdgeInsetsDirectional.only(start: inset, top: 40),
  child: Align(alignment: AlignmentDirectional.topStart, child: popover),
);

Widget _box(String key) => SizedBox(key: Key(key), width: 24, height: 24);

const _anchor = SizedBox(key: Key('anchor'), width: 40, height: 24);

RebicPopoverController _controller() {
  final controller = RebicPopoverController();
  addTearDown(controller.dispose);
  return controller;
}

/// Superfície do popover aberto.
Finder _panel() => find
    .ancestor(
      of: find.byKey(const Key('content')),
      matching: find.byType(RebicContainer),
    )
    .first;

Rect _rect(WidgetTester tester, String key) =>
    tester.getRect(find.byKey(Key(key)));

final _light = RebicThemeData.light();

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Popover com cabeçalho e rodapé', (
      tester,
    ) async {
      final controller = _controller();
      await tester.pumpWidget(
        _app(
          _anchored(
            RebicPopover(
              controller: controller,
              title: 'Filtros',
              content: _box('content'),
              actions: [
                RebicButton(label: 'Aplicar', onPressed: () {}),
                RebicButton(label: 'Cancelar', onPressed: () {}),
              ],
              child: _anchor,
            ),
          ),
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      final panel = tester.getRect(_panel());
      final title = tester.getRect(find.text('Filtros'));
      final separators = find.byType(RebicSeparator);
      expect(separators, findsNWidgets(2));
      final top = tester.getRect(separators.first);
      final bottom = tester.getRect(separators.last);
      final content = _rect(tester, 'content');
      final apply = tester.getRect(find.byType(RebicButton).first);
      final cancel = tester.getRect(find.byType(RebicButton).last);
      expect(title.bottom, lessThanOrEqualTo(top.top));
      expect(top.bottom, lessThanOrEqualTo(content.top));
      expect(content.bottom, lessThanOrEqualTo(bottom.top));
      expect(bottom.bottom, lessThanOrEqualTo(apply.top));
      expect(apply.right, lessThanOrEqualTo(cancel.left));
      expect(cancel.right, closeTo(panel.right - _light.spacing.s, 0.01));
    });

    testWidgets('[API] Propriedades — Popover só com conteúdo', (tester) async {
      final controller = _controller();
      await tester.pumpWidget(
        _app(
          _anchored(
            RebicPopover(
              controller: controller,
              semanticLabel: 'Detalhes',
              content: _box('content'),
              child: _anchor,
            ),
          ),
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      expect(find.byType(RebicSeparator), findsNothing);
      expect(find.byType(RebicTitle), findsNothing);
      expect(
        _rect(tester, 'content').top - tester.getRect(_panel()).top,
        closeTo(_light.spacing.l, 0.01),
      );
    });
  });

  test('[API] Rótulo obrigatório — Popover sem rótulo', () {
    final controller = RebicPopoverController();
    addTearDown(controller.dispose);
    expect(
      () => RebicPopover(
        controller: controller,
        content: const SizedBox(),
        child: const SizedBox(),
      ),
      throwsAssertionError,
    );
  });

  group('[API] Callbacks e controlador', () {
    testWidgets(
      '[API] Callbacks e controlador — Abrir e fechar pelo controlador',
      (tester) async {
        final controller = _controller();
        var dismissed = 0;
        var notified = 0;
        controller.addListener(() => notified++);
        await tester.pumpWidget(
          _app(
            _anchored(
              RebicPopover(
                controller: controller,
                title: 'Filtros',
                onDismiss: () => dismissed++,
                content: _box('content'),
                child: _anchor,
              ),
            ),
          ),
        );
        controller.toggle();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
        expect(find.byKey(const Key('content')), findsOneWidget);
        controller.close();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);
        expect(find.byKey(const Key('content')), findsNothing);
        expect(dismissed, 0);
        expect(notified, 2);
      },
    );

    testWidgets('[API] Callbacks e controlador — Dispensa avisada', (
      tester,
    ) async {
      final controller = _controller();
      var dismissed = 0;
      await tester.pumpWidget(
        _app(
          _anchored(
            RebicPopover(
              controller: controller,
              title: 'Filtros',
              onDismiss: () => dismissed++,
              content: _box('content'),
              child: _anchor,
            ),
          ),
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(780, 580));
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);
      expect(find.byKey(const Key('content')), findsNothing);
      expect(dismissed, 1);
    });
  });

  testWidgets('[API] Posição e largura — Popover largo', (tester) async {
    final controller = _controller();
    await tester.pumpWidget(
      _app(
        _anchored(
          RebicPopover(
            controller: controller,
            title: 'Pedidos',
            width: RebicPopoverWidth.wide,
            content: _box('content'),
            child: _anchor,
          ),
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    expect(
      tester.getRect(_panel()).width,
      closeTo(_light.spacing.xxxl * 12, 0.01),
    );
  });

  testWidgets('[API] Posição e largura — Popover na largura da âncora', (
    tester,
  ) async {
    for (final steps in [10, 1]) {
      final controller = _controller();
      final width = _light.spacing.xxxl * steps;
      await tester.pumpWidget(
        _app(
          _anchored(
            RebicPopover(
              key: ValueKey(steps),
              controller: controller,
              semanticLabel: 'Lista',
              width: RebicPopoverWidth.anchor,
              content: _box('content'),
              child: SizedBox(width: width, height: 24),
            ),
          ),
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      expect(
        tester.getRect(_panel()).width,
        closeTo(_light.spacing.xxxl * (steps == 10 ? 10 : 6), 0.01),
      );
    }
  });

  group('[Comportamento] Posição, largura e rolagem', () {
    testWidgets(
      '[Comportamento] Posição, largura e rolagem — Popover abaixo da âncora',
      (tester) async {
        final controller = _controller();
        await tester.pumpWidget(
          _app(
            _anchored(
              RebicPopover(
                controller: controller,
                title: 'Filtros',
                content: _box('content'),
                child: _anchor,
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        final anchor = _rect(tester, 'anchor');
        final panel = tester.getRect(_panel());
        expect(panel.top, closeTo(anchor.bottom + _light.spacing.xs, 0.01));
        expect(panel.left, closeTo(anchor.left, 0.01));
      },
    );

    testWidgets('[Comportamento] Posição, largura e rolagem — Largura padrão', (
      tester,
    ) async {
      Future<(Rect, double)> open(String text) async {
        final controller = _controller();
        await tester.pumpWidget(
          _app(
            _anchored(
              RebicPopover(
                key: ValueKey(text),
                controller: controller,
                semanticLabel: 'Texto',
                content: RebicText(text, key: const Key('content')),
                child: _anchor,
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        final panel = tester.getRect(_panel());
        return (panel, tester.getSize(find.text(text)).height);
      }

      final (short, oneLine) = await open('Ok');
      expect(short.width, closeTo(_light.spacing.xxxl * 8, 0.01));
      final (long, height) = await open(_long);
      expect(long.width, closeTo(_light.spacing.xxxl * 8, 0.01));
      expect(height, greaterThan(oneLine * 1.5));
    });

    testWidgets(
      '[Comportamento] Posição, largura e rolagem — Âncora mais larga que o popover',
      (tester) async {
        final controller = _controller();
        final width = _light.spacing.xxxl * 10;
        await tester.pumpWidget(
          _app(
            _anchored(
              RebicPopover(
                controller: controller,
                title: 'Filtros',
                content: _box('content'),
                child: SizedBox(
                  key: const Key('anchor'),
                  width: width,
                  height: 24,
                ),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(tester.getRect(_panel()).width, closeTo(width, 0.01));
        expect(_rect(tester, 'anchor').width, closeTo(width, 0.01));
      },
    );

    testWidgets(
      '[Comportamento] Posição, largura e rolagem — Conteúdo rolável',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 400);
        addTearDown(tester.view.reset);
        final controller = _controller();
        await tester.pumpWidget(
          _app(
            _anchored(
              RebicPopover(
                controller: controller,
                title: 'Filtros',
                actions: [RebicButton(label: 'Aplicar', onPressed: () {})],
                content: Column(
                  key: const Key('content'),
                  children: [
                    for (var i = 1; i <= 30; i++) RebicText('Linha $i'),
                  ],
                ),
                child: _anchor,
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.text('Linha 2'), const Offset(0, -2000));
        await tester.pumpAndSettle();
        final title = tester.getRect(find.text('Filtros'));
        final last = tester.getRect(find.text('Linha 30'));
        final apply = tester.getRect(find.byType(RebicButton));
        expect(title.top, greaterThanOrEqualTo(0));
        expect(last.top, greaterThanOrEqualTo(title.bottom));
        expect(last.bottom, lessThanOrEqualTo(apply.top));
        expect(apply.bottom, lessThanOrEqualTo(400));
      },
    );
  });

  testWidgets(
    '[Aparência] Superfície, cabeçalho e rodapé — Superfície do popover',
    (tester) async {
      for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
        final controller = _controller();
        await tester.pumpWidget(
          _app(
            theme: theme,
            _anchored(
              RebicPopover(
                key: ValueKey(theme.brightness),
                controller: controller,
                title: 'Filtros',
                content: _box('content'),
                child: _anchor,
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        final container = tester.widget<RebicContainer>(_panel());
        expect(container.surface, RebicSurface.base);
        expect(container.border, isFalse);
        expect(container.radius, RebicRadius.popover);
        expect(container.shadow, RebicShadow.popover);
        final decoration =
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: _panel(),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration;
        expect(decoration.color, theme.colors.base);
        expect(decoration.border, isNull);
        expect(decoration.boxShadow, hasLength(theme.shadows.popover.length));
      }
    },
  );

  testWidgets('[Estados] Aberto e fechado — Popover fechado', (tester) async {
    final controller = _controller();
    var pressed = 0;
    await tester.pumpWidget(
      _app(
        _anchored(
          RebicPopover(
            controller: controller,
            title: 'Filtros',
            content: _box('content'),
            child: RebicButton(label: 'Abrir', onPressed: () => pressed++),
          ),
        ),
      ),
    );
    expect(find.byKey(const Key('content')), findsNothing);
    await tester.tap(find.text('Abrir'));
    await tester.pump();
    expect(pressed, 1);
    expect(controller.isOpen, isFalse);
  });

  testWidgets('[Acessibilidade] Teclado — Popover pelo teclado', (
    tester,
  ) async {
    final controller = _controller();
    final anchor = FocusNode();
    final first = FocusNode();
    final second = FocusNode();
    for (final node in [anchor, first, second]) {
      addTearDown(node.dispose);
    }
    await tester.pumpWidget(
      _app(
        _anchored(
          RebicPopover(
            controller: controller,
            title: 'Filtros',
            content: Column(
              key: const Key('content'),
              children: [
                Focus(focusNode: first, child: _box('first')),
                Focus(focusNode: second, child: _box('second')),
              ],
            ),
            child: Focus(focusNode: anchor, child: _anchor),
          ),
        ),
      ),
    );
    anchor.requestFocus();
    await tester.pump();
    controller.open();
    await tester.pumpAndSettle();
    expect(first.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(first.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
    expect(anchor.hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do popover', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final controller = _controller();
    await tester.pumpWidget(
      _app(
        _anchored(
          RebicPopover(
            controller: controller,
            title: 'Filtros',
            content: _box('content'),
            actions: [RebicButton(label: 'Aplicar', onPressed: () {})],
            child: _anchor,
          ),
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    final routes = [
      for (final element in find.bySemanticsLabel('Filtros').evaluate())
        tester.getSemantics(
          find.byElementPredicate((candidate) => candidate == element),
        ),
    ].where((node) => node.hasFlag(SemanticsFlag.namesRoute)).toSet();
    expect(routes, hasLength(1));
    final route = routes.single;
    expect(route.hasFlag(SemanticsFlag.scopesRoute), isTrue);
    expect(route.label, 'Filtros');
    var inside = false;
    for (
      SemanticsNode? node = tester.getSemantics(
        find.bySemanticsLabel('Aplicar'),
      );
      node != null;
      node = node.parent
    ) {
      if (node == route) inside = true;
    }
    expect(inside, isTrue);
    handle.dispose();
  });

  group('[Responsividade] Direção e escala', () {
    testWidgets('[Responsividade] Direção e escala — Popover em RTL', (
      tester,
    ) async {
      final controller = _controller();
      await tester.pumpWidget(
        _app(
          direction: TextDirection.rtl,
          _anchored(
            RebicPopover(
              controller: controller,
              title: 'Filtros',
              content: _box('content'),
              actions: [
                RebicButton(label: 'Aplicar', onPressed: () {}),
                RebicButton(label: 'Cancelar', onPressed: () {}),
              ],
              child: _anchor,
            ),
          ),
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      final anchor = _rect(tester, 'anchor');
      final panel = tester.getRect(_panel());
      final cancel = tester.getRect(find.byType(RebicButton).last);
      expect(anchor.right, greaterThan(400));
      expect(panel.right, closeTo(anchor.right, 0.01));
      expect(cancel.left, closeTo(panel.left + _light.spacing.s, 0.01));
    });

    testWidgets(
      '[Responsividade] Direção e escala — Popover com escala de texto 2,0',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(400, 400);
        addTearDown(tester.view.reset);
        final controller = _controller();
        await tester.pumpWidget(
          _app(
            textScale: 2,
            _anchored(
              RebicPopover(
                controller: controller,
                title: 'Filtros',
                content: const RebicText(_long, key: Key('content')),
                actions: [
                  RebicButton(label: 'Aplicar', onPressed: () {}),
                  RebicButton(label: 'Cancelar', onPressed: () {}),
                ],
                child: _anchor,
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final panel = tester.getRect(_panel());
        expect(panel.left, greaterThanOrEqualTo(0));
        expect(panel.top, greaterThanOrEqualTo(0));
        expect(panel.right, lessThanOrEqualTo(400));
        expect(panel.bottom, lessThanOrEqualTo(400));
      },
    );
  });

  testWidgets('[Integração] Dependências — Popover sem Material', (
    tester,
  ) async {
    final controller = _controller();
    await tester.pumpWidget(
      _app(
        _anchored(
          RebicPopover(
            controller: controller,
            title: 'Filtros',
            content: const RebicText('Status: em aberto', key: Key('content')),
            actions: [
              RebicButton(label: 'Fechar', onPressed: controller.close),
            ],
            child: RebicButton(label: 'Filtrar', onPressed: controller.toggle),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Filtrar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('content')), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('content')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do popover', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-popover',
        'add-rebic-popover',
      );
      expect(names, hasLength(23));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do popover', (
      tester,
    ) async {
      await loadRebicFonts();
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(960, 400);
      addTearDown(tester.view.reset);
      for (final (name, theme) in goldenThemes) {
        // Cada captura parte de uma aplicação nova: trocar o tema da mesma
        // RebicApp anima a densidade, e a sobreposição abriria com a âncora
        // no meio da transição.
        await tester.pumpWidget(const SizedBox());
        final filters = _controller();
        final details = _controller();
        await tester.pumpWidget(
          _app(
            theme: theme,
            // O fundo da aplicação fica fora da captura; a amostra o pinta.
            RebicContainer(
              key: ValueKey(name),
              surface: RebicSurface.background,
              child: Stack(
                children: [
                  _anchored(
                    RebicPopover(
                      controller: filters,
                      title: 'Filtros',
                      content: const RebicVBox(
                        gap: RebicSpace.s,
                        items: [
                          RebicText('Status: em aberto'),
                          RebicText('Período: últimos 30 dias'),
                        ],
                      ),
                      actions: [
                        RebicButton(
                          label: 'Aplicar',
                          type: RebicButtonType.emphasized,
                          onPressed: () {},
                        ),
                        RebicButton(
                          label: 'Cancelar',
                          type: RebicButtonType.transparent,
                          onPressed: () {},
                        ),
                      ],
                      child: RebicButton(label: 'Filtrar', onPressed: () {}),
                    ),
                  ),
                  _anchored(
                    inset: 480,
                    RebicPopover(
                      controller: details,
                      semanticLabel: 'Detalhes do pedido',
                      content: const RebicText(
                        'Pedido 4711, criado em 12/10 por Maria Barros.',
                      ),
                      child: const RebicIcon(RebicIcons.information),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        filters.open();
        details.open();
        await tester.pumpAndSettle();
        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/rebic_popover_$name.png'),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Popover sem valor literal', () {
    final source = File(
      'lib/src/feedback_sobreposicoes/popover/rebic_popover.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(
        type.replaceAll('?', ''),
        isNot(isIn(['double', 'Color', 'EdgeInsets'])),
      );
    }
  });
}
