import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

const _items = [
  RebicNavigationListItem(key: 'inicio', text: 'Início', icon: RebicIcons.home),
  RebicNavigationListItem(
    key: 'pedidos',
    text: 'Pedidos',
    icon: RebicIcons.document,
  ),
  RebicNavigationListItem(
    key: 'clientes',
    text: 'Clientes',
    icon: RebicIcons.personPlaceholder,
  ),
];

const _nested = [
  RebicNavigationListItem(key: 'inicio', text: 'Início', icon: RebicIcons.home),
  RebicNavigationListItem(
    key: 'vendas',
    text: 'Vendas',
    icon: RebicIcons.document,
    items: [
      RebicNavigationListItem(key: 'pedidos', text: 'Pedidos'),
      RebicNavigationListItem(key: 'faturas', text: 'Faturas'),
    ],
  ),
  RebicNavigationListItem(
    key: 'relatorios',
    text: 'Relatórios',
    icon: RebicIcons.folderBlank,
    enabled: false,
  ),
];

const _fixed = [
  RebicNavigationListItem(
    key: 'ajuda',
    text: 'Ajuda',
    icon: RebicIcons.sysHelp,
  ),
];

Widget _app(Widget home, {TextDirection direction = TextDirection.ltr}) =>
    RebicApp(
      builder: (context, child) =>
          Directionality(textDirection: direction, child: child!),
      home: Align(
        alignment: AlignmentDirectional.topStart,
        child: SizedBox(height: 600, child: home),
      ),
    );

/// Navegação que guarda o próprio item e registra cada `onItemSelect`.
Widget _stateful(
  List<String> log, {
  String? initial,
  List<RebicNavigationListItem<String>> items = _items,
  List<RebicNavigationListItem<String>> fixedItems = const [],
  bool expanded = true,
}) {
  var key = initial;
  return StatefulBuilder(
    builder: (context, setState) => RebicSideNavigation<String>(
      items: items,
      fixedItems: fixedItems,
      selectedKey: key,
      expanded: expanded,
      onItemSelect: (value) {
        log.add(value);
        setState(() => key = value);
      },
    ),
  );
}

Color? _textColor(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style?.color;

String? _focused() => FocusManager.instance.primaryFocus?.context
    ?.findAncestorWidgetOfExactType<RebicInteractable>()
    ?.semanticLabel;

void main() {
  testWidgets('[API] Propriedades — Navegação mínima', (tester) async {
    await tester.pumpWidget(_app(_stateful([], fixedItems: _fixed)));
    final top = tester.getTopLeft(find.text('Início')).dy;
    expect(tester.getTopLeft(find.text('Pedidos')).dy, greaterThan(top));
    expect(
      tester.getTopLeft(find.text('Clientes')).dy,
      greaterThan(tester.getTopLeft(find.text('Pedidos')).dy),
    );
    expect(top, lessThan(_light.density.listItemHeight));
    expect(tester.getBottomLeft(find.text('Ajuda')).dy, greaterThan(550));
    expect(find.byType(RebicSeparator), findsOneWidget);
  });

  testWidgets('[API] Itens válidos — Navegação com chave repetida', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const RebicSideNavigation<String>(
          items: [
            RebicNavigationListItem(key: 'a', text: 'A'),
            RebicNavigationListItem(key: 'a', text: 'B'),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('[API] Callbacks e controlador — Escolher um item', (
    tester,
  ) async {
    final log = <String>[];
    await tester.pumpWidget(_app(_stateful(log, initial: 'inicio')));
    await tester.tap(find.text('Clientes'));
    await tester.pump();
    expect(log, ['clientes']);
    expect(_textColor(tester, 'Clientes'), _light.colors.brand);
    expect(_textColor(tester, 'Início'), _light.colors.text);
  });

  testWidgets('[Comportamento] Subitens — Abrir subitens', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(
      _app(_stateful(log, initial: 'inicio', items: _nested)),
    );
    expect(find.text('Faturas'), findsNothing);
    await tester.tap(find.text('Vendas'));
    await tester.pump();
    expect(
      tester.getTopLeft(find.text('Faturas')).dx,
      tester.getTopLeft(find.text('Vendas')).dx,
    );
    expect(find.byIcon(RebicIcons.slimArrowDown), findsOneWidget);
    await tester.tap(find.text('Faturas'));
    await tester.pump();
    expect(log, ['vendas', 'faturas']);
  });

  testWidgets('[Comportamento] Modo recolhido — Navegação recolhida', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(_stateful([], items: _nested, expanded: false, initial: 'pedidos')),
    );
    expect(
      tester.getSize(find.byType(RebicSideNavigation<String>)).width,
      _light.density.barHeight,
    );
    expect(find.text('Início'), findsNothing);
    expect(find.text('Pedidos'), findsNothing);
    expect(find.byIcon(RebicIcons.home), findsOneWidget);
    expect(find.semantics.byLabel('Início'), findsOneWidget);
    expect(find.semantics.byLabel('Vendas'), findsOneWidget);
    expect(
      tester.widget<Icon>(find.byIcon(RebicIcons.document)).color,
      _light.colors.brand,
    );
    handle.dispose();
  });

  testWidgets('[Comportamento] Teclado — Setas na navegação', (tester) async {
    await tester.pumpWidget(
      _app(_stateful([], initial: 'inicio', items: _nested)),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_focused(), 'Início');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(_focused(), 'Vendas');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Faturas'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(_focused(), 'Pedidos');
  });

  testWidgets('[Aparência] Tokens de componente — Item escolhido', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_stateful([], initial: 'pedidos')));
    expect(_textColor(tester, 'Pedidos'), _light.colors.brand);
    expect(_textColor(tester, 'Início'), _light.colors.text);
    final box = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('Pedidos'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(
      (box.decoration as BoxDecoration).color,
      _light.colors.selectionBackground,
    );
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Pedidos'),
                  matching: find.byType(SizedBox),
                )
                .first,
          )
          .height,
      _light.density.listItemHeight,
    );
  });

  testWidgets('[Estados] Interação — Item desabilitado', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(
      _app(_stateful(log, initial: 'inicio', items: _nested)),
    );
    await tester.tap(find.text('Relatórios'), warnIfMissed: false);
    await tester.pump();
    expect(log, isEmpty);
    final opacity = tester.widget<Opacity>(
      find
          .ancestor(of: find.text('Relatórios'), matching: find.byType(Opacity))
          .first,
    );
    expect(opacity.opacity, _light.interaction.disabledOpacity);
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Semântica da navegação',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _app(
            const RebicSideNavigation<String>(
              selectedKey: 'pedidos',
              items: [
                RebicNavigationListItem(key: 'pedidos', text: 'Pedidos'),
                RebicNavigationListItem(
                  key: 'vendas',
                  text: 'Vendas',
                  items: [
                    RebicNavigationListItem(key: 'faturas', text: 'Faturas'),
                  ],
                ),
              ],
            ),
          ),
        );
        expect(
          tester.getSemantics(find.text('Pedidos')),
          containsSemantics(isButton: true, isSelected: true, label: 'Pedidos'),
        );
        expect(
          tester.getSemantics(find.text('Vendas')),
          containsSemantics(
            isButton: true,
            isSelected: false,
            hasExpandedState: true,
            isExpanded: false,
            label: 'Vendas',
          ),
        );
        handle.dispose();
      },
    );

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Contraste e alvo da navegação',
      (tester) async {
        final handle = tester.ensureSemantics();
        for (final (_, theme) in goldenThemes) {
          await tester.pumpWidget(
            RebicApp(
              key: ValueKey(theme),
              theme: theme,
              darkTheme: theme,
              density: theme.density.density,
              home: RebicContainer(
                surface: RebicSurface.background,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    height: 500,
                    child: _stateful(
                      [],
                      initial: 'pedidos',
                      items: _nested.sublist(0, 2),
                      fixedItems: _fixed,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await expectLater(
            tester,
            meetsGuideline(
              MinimumTapTargetGuideline(
                size: Size.square(
                  RebicAccessibility.minTargetSize(theme.density),
                ),
                link: RebicAccessibility.targetSizeLink,
              ),
            ),
          );
        }
        handle.dispose();
      },
    );
  });

  testWidgets('[Responsividade] Altura e direção — Navegação em RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(direction: TextDirection.rtl, _stateful([], items: _nested)),
    );
    expect(
      tester.getCenter(find.byIcon(RebicIcons.home)).dx,
      greaterThan(tester.getCenter(find.text('Início')).dx),
    );
    expect(
      tester.getCenter(find.byIcon(RebicIcons.slimArrowRight)).dx,
      lessThan(tester.getCenter(find.text('Vendas')).dx),
    );
  });

  testWidgets('[Integração] Dependências — Navegação sem Material', (
    tester,
  ) async {
    var expanded = true;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) => RebicVBox(
            items: [
              RebicButton(
                text: 'Recolher',
                onPress: () => setState(() => expanded = !expanded),
              ),
              Expanded(
                child: _stateful(
                  [],
                  items: _nested,
                  fixedItems: _fixed,
                  expanded: expanded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Vendas'));
    await tester.pump();
    await tester.tap(find.text('Recolher'));
    await tester.pump();
    await tester.tap(find.byIcon(RebicIcons.home));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade da navegação', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-side-navigation',
        'add-rebic-side-navigation',
      );
      expect(names, hasLength(16));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens da navegação', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_side_navigation_$name',
          theme: theme,
          size: const Size(420, 420),
          child: SizedBox(
            height: 400,
            child: RebicHBox(
              gap: RebicSpace.l,
              items: [
                RebicSideNavigation<String>(
                  items: _nested,
                  fixedItems: _fixed,
                  selectedKey: 'pedidos',
                  onItemSelect: (_) {},
                ),
                RebicSideNavigation<String>(
                  items: _nested,
                  fixedItems: _fixed,
                  selectedKey: 'inicio',
                  expanded: false,
                  onItemSelect: (_) {},
                ),
              ],
            ),
          ),
        );
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Navegação sem valor literal', () {
    final source = File(
      'lib/src/acoes_navegacao/side_navigation/rebic_side_navigation.dart',
    ).readAsStringSync();
    final fields = RegExp(
      r'^  final (\S+) (\w+);$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!).toList();
    expect(fields, isNotEmpty);
    for (final type in fields) {
      expect(type, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
