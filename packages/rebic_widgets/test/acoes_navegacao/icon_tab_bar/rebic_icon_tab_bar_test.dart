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
  RebicIconTabFilter(
    key: 'itens',
    text: 'Itens',
    content: RebicText('Lista de itens'),
  ),
  RebicIconTabFilter(
    key: 'notas',
    text: 'Notas',
    content: RebicText('Notas do pedido'),
  ),
  RebicIconTabFilter(
    key: 'anexos',
    text: 'Anexos',
    content: RebicText('Arquivos anexos'),
  ),
];

Widget _app(
  Widget home, {
  TextDirection direction = TextDirection.ltr,
  double width = 600,
}) => RebicApp(
  builder: (context, child) =>
      Directionality(textDirection: direction, child: child!),
  home: Align(
    alignment: Alignment.topCenter,
    child: SizedBox(width: width, child: home),
  ),
);

/// Barra que guarda a própria aba e registra cada `onSelect`.
Widget _stateful(
  List<String> log, {
  String initial = 'itens',
  List<RebicIconTabFilter<String>> items = _items,
}) {
  var key = initial;
  return StatefulBuilder(
    builder: (context, setState) => RebicIconTabBar<String>(
      items: items,
      selectedKey: key,
      onSelect: (value) {
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
  testWidgets('[API] Propriedades — Abas mínimas', (tester) async {
    await tester.pumpWidget(_app(_stateful([], initial: 'notas')));
    final a = tester.getCenter(find.text('Itens'));
    expect(tester.getCenter(find.text('Notas')).dy, a.dy);
    expect(tester.getCenter(find.text('Anexos')).dx, greaterThan(a.dx));
    expect(_textColor(tester, 'Notas'), _light.colors.brand);
    expect(find.text('Notas do pedido'), findsOneWidget);
    expect(find.text('Lista de itens'), findsNothing);
  });

  testWidgets('[API] Abas válidas — Abas com chave repetida', (tester) async {
    await tester.pumpWidget(
      _app(
        RebicIconTabBar<String>(
          items: const [
            RebicIconTabFilter(key: 'a', text: 'A'),
            RebicIconTabFilter(key: 'a', text: 'B'),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('[API] Callbacks e controlador — Trocar de aba', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(_app(_stateful(log)));
    await tester.tap(find.text('Anexos'));
    await tester.pump();
    expect(log, ['anexos']);
    expect(find.text('Arquivos anexos'), findsOneWidget);
  });

  testWidgets('[Comportamento] Teclado — Setas no cabeçalho', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(
      _app(
        _stateful(
          log,
          items: const [
            RebicIconTabFilter(key: 'a', text: 'A'),
            RebicIconTabFilter(key: 'b', text: 'B', enabled: false),
            RebicIconTabFilter(key: 'c', text: 'C'),
          ],
          initial: 'a',
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_focused(), 'A');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_focused(), 'C');
    expect(log, isEmpty);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(log, ['c']);
  });

  testWidgets('[Aparência] Tokens de componente — Aba escolhida', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_stateful([], initial: 'notas')));
    expect(_textColor(tester, 'Notas'), _light.colors.brand);
    expect(_textColor(tester, 'Itens'), _light.colors.text);
    final indicator = find.descendant(
      of: find.byType(PositionedDirectional),
      matching: find.byType(ColoredBox),
    );
    expect(indicator, findsOneWidget);
    expect(tester.getSize(indicator).height, _light.spacing.xxs);
    expect(
      tester.getCenter(indicator).dx,
      closeTo(tester.getCenter(find.text('Notas')).dx, 1),
    );
  });

  testWidgets('[Estados] Interação — Aba desabilitada', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(
      _app(
        _stateful(
          log,
          items: const [
            RebicIconTabFilter(key: 'a', text: 'A'),
            RebicIconTabFilter(key: 'b', text: 'B', enabled: false),
          ],
          initial: 'a',
        ),
      ),
    );
    await tester.tap(find.text('B'), warnIfMissed: false);
    expect(log, isEmpty);
    final opacity = tester.widget<Opacity>(
      find.ancestor(of: find.text('B'), matching: find.byType(Opacity)).first,
    );
    expect(opacity.opacity, _light.interaction.disabledOpacity);
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets('[Acessibilidade] Semântica e contraste — Semântica das abas', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(_stateful([], initial: 'notas')));
      expect(
        tester.getSemantics(find.text('Notas')),
        containsSemantics(isButton: true, isSelected: true, label: 'Notas'),
      );
      expect(
        tester.getSemantics(find.text('Itens')),
        containsSemantics(isButton: true, isSelected: false, label: 'Itens'),
      );
      handle.dispose();
    });

    testWidgets(
      '[Acessibilidade] Semântica e contraste — Contraste e alvo das abas',
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
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 600,
                    child: _stateful([], initial: 'notas'),
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

  group('[Responsividade] Rolagem e direção', () {
    testWidgets('[Responsividade] Rolagem e direção — Muitas abas', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          width: 300,
          RebicIconTabBar<int>(
            items: [
              for (var i = 0; i < 10; i++)
                RebicIconTabFilter(key: i, text: 'Aba $i'),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(RebicIconTabBar<int>),
          matching: find.byWidgetPredicate(
            (w) =>
                w is SingleChildScrollView &&
                w.scrollDirection == Axis.horizontal,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('[Responsividade] Rolagem e direção — Abas em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(direction: TextDirection.rtl, _stateful([])),
      );
      expect(
        tester.getCenter(find.text('Itens')).dx,
        greaterThan(tester.getCenter(find.text('Anexos')).dx),
      );
    });
  });

  testWidgets('[Integração] Dependências — Abas sem Material', (tester) async {
    await tester.pumpWidget(
      _app(
        _stateful(
          [],
          items: const [
            RebicIconTabFilter(
              key: 'a',
              text: 'Itens',
              icon: RebicIcons.document,
              count: '12',
              content: RebicText('a'),
            ),
            RebicIconTabFilter(
              key: 'b',
              text: 'Notas',
              icon: RebicIcons.edit,
              count: '3',
              content: RebicText('b'),
            ),
          ],
          initial: 'a',
        ),
      ),
    );
    await tester.tap(find.text('Notas'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade das abas', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-icon-tab-bar',
        'add-rebic-icon-tab-bar',
      );
      expect(names, hasLength(15));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens das abas', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_icon_tab_bar_$name',
          theme: theme,
          size: const Size(520, 300),
          child: SizedBox(
            width: 480,
            child: RebicVBox(
              gap: RebicSpace.l,
              alignItems: RebicFlexAlignItems.stretch,
              items: [
                RebicIconTabBar<String>(
                  items: _items,
                  selectedKey: 'notas',
                  onSelect: (_) {},
                ),
                RebicIconTabBar<String>(
                  selectedKey: 'a',
                  onSelect: (_) {},
                  applyContentPadding: false,
                  items: const [
                    RebicIconTabFilter(
                      key: 'a',
                      text: 'Itens',
                      icon: RebicIcons.document,
                      count: '12',
                    ),
                    RebicIconTabFilter(
                      key: 'b',
                      text: 'Notas',
                      icon: RebicIcons.edit,
                      count: '3',
                    ),
                    RebicIconTabFilter(
                      key: 'c',
                      text: 'Anexos',
                      icon: RebicIcons.folderBlank,
                      enabled: false,
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

  test('[Restrições] Fora do escopo — Abas sem valor literal', () {
    final source = File(
      'lib/src/acoes_navegacao/icon_tab_bar/rebic_icon_tab_bar.dart',
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
