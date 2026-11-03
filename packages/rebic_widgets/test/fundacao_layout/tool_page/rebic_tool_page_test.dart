import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/golden.dart';
import '../../support/traceability.dart';

const _headerKey = Key('header');
const _subHeaderKey = Key('subHeader');
const _sideKey = Key('side');
const _mainKey = Key('main');
const _toggleKey = Key('toggle');

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

/// Cabeçalho com um alvo que alterna o conteúdo lateral.
class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: GestureDetector(
        key: _toggleKey,
        behavior: HitTestBehavior.opaque,
        onTap: () => RebicToolPage.toggleSideContentMode(context),
        child: const SizedBox(width: 40, height: 40),
      ),
    ),
  );
}

/// Conteúdo lateral que mede 240 expandido e 48 recolhido.
class _Side extends StatelessWidget {
  const _Side();

  @override
  Widget build(BuildContext context) => SizedBox(
    key: _sideKey,
    width: RebicToolPage.sideExpandedOf(context)! ? 240 : 48,
    child: Semantics(label: 'Lateral', child: const SizedBox.expand()),
  );
}

/// Conteúdo principal com rótulo próprio na semântica.
class _Main extends StatelessWidget {
  const _Main() : super(key: _mainKey);

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Principal',
    container: true,
    child: const SizedBox.expand(),
  );
}

const _main = _Main();

/// Lê o estado em vigor a partir do conteúdo principal.
bool? _expandedOf(WidgetTester tester) =>
    RebicToolPage.sideExpandedOf(tester.element(find.byKey(_mainKey)));

Future<void> _toggle(WidgetTester tester) async {
  await tester.tap(find.byKey(_toggleKey));
  await tester.pumpAndSettle();
}

void main() {
  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Estrutura completa', (tester) async {
      _view(tester, 1200);
      await tester.pumpWidget(
        _host(
          const RebicToolPage(
            header: _Header(key: _headerKey),
            subHeader: SizedBox(key: _subHeaderKey, height: 40),
            sideContent: _Side(),
            mainContents: [_main],
          ),
        ),
      );
      final header = tester.getRect(find.byKey(_headerKey));
      final subHeader = tester.getRect(find.byKey(_subHeaderKey));
      final side = tester.getRect(find.byKey(_sideKey));
      final main = tester.getRect(find.byKey(_mainKey));
      expect(header.top, 0);
      expect(subHeader.top, header.bottom);
      expect(side.top, subHeader.bottom);
      expect(side.left, 0);
      expect(main.left, side.right);
      expect(main.right, 1200);
      expect(main.bottom, 800);
    });

    testWidgets('[API] Propriedades — Página só com conteúdo principal', (
      tester,
    ) async {
      _view(tester, 1200);
      await tester.pumpWidget(
        _host(const RebicToolPage(mainContents: [_main])),
      );
      expect(
        tester.getRect(find.byKey(_mainKey)),
        const Rect.fromLTWH(0, 0, 1200, 800),
      );
    });
  });

  group('[API] Callbacks e controlador', () {
    testWidgets('[API] Callbacks e controlador — Estado controlado', (
      tester,
    ) async {
      _view(tester, 1200);
      final log = <bool>[];
      await tester.pumpWidget(
        _host(
          RebicToolPage(
            header: const _Header(),
            sideContent: const _Side(),
            mainContents: const [_main],
            sideExpanded: false,
            onSideExpandedChanged: log.add,
          ),
        ),
      );
      await _toggle(tester);
      expect(log, [true]);
      expect(_expandedOf(tester), isFalse);
    });

    testWidgets('[API] Callbacks e controlador — Estado automático alternado', (
      tester,
    ) async {
      _view(tester, 1200);
      final log = <bool>[];
      await tester.pumpWidget(
        _host(
          RebicToolPage(
            header: const _Header(),
            sideContent: const _Side(),
            mainContents: const [_main],
            onSideExpandedChanged: log.add,
          ),
        ),
      );
      expect(_expandedOf(tester), isTrue);
      await _toggle(tester);
      expect(_expandedOf(tester), isFalse);
      expect(log, [false]);
    });
  });

  group('[Comportamento] Estado automático', () {
    testWidgets(
      '[Comportamento] Estado automático — Estado inicial por classe',
      (tester) async {
        for (final (width, expected) in [
          (400.0, false),
          (800.0, true),
          (1200.0, true),
          (1600.0, true),
        ]) {
          _view(tester, width);
          await tester.pumpWidget(
            _host(
              RebicToolPage(
                key: ValueKey(width),
                sideContent: const _Side(),
                mainContents: const [_main],
              ),
            ),
          );
          expect(_expandedOf(tester), expected, reason: '$width');
        }
      },
    );

    testWidgets(
      '[Comportamento] Estado automático — Estado mantido na troca de classe',
      (tester) async {
        _view(tester, 1200);
        await tester.pumpWidget(
          _host(
            const RebicToolPage(
              header: _Header(),
              sideContent: _Side(),
              mainContents: [_main],
            ),
          ),
        );
        await _toggle(tester);
        expect(_expandedOf(tester), isFalse);
        for (final width in [1600.0, 800.0]) {
          tester.view.physicalSize = Size(width, 800);
          await tester.pumpAndSettle();
          expect(_expandedOf(tester), isFalse, reason: '$width');
        }
      },
    );
  });

  testWidgets(
    '[Comportamento] Conteúdo lateral ao lado — Largura definida pelo conteúdo lateral',
    (tester) async {
      _view(tester, 800);
      await tester.pumpWidget(
        _host(
          const RebicToolPage(
            header: _Header(),
            sideContent: _Side(),
            mainContents: [_main],
          ),
        ),
      );
      expect(tester.getSize(find.byKey(_sideKey)).width, 240);
      await _toggle(tester);
      final side = tester.getRect(find.byKey(_sideKey));
      final main = tester.getRect(find.byKey(_mainKey));
      expect(side.width, 48);
      expect(main.left, side.right);
      expect(main.right, 800);
    },
  );

  group('[Comportamento] Conteúdo lateral na tela pequena', () {
    testWidgets(
      '[Comportamento] Conteúdo lateral na tela pequena — Conteúdo lateral cobre o principal',
      (tester) async {
        _view(tester, 400);
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _host(
            const RebicToolPage(
              header: _Header(key: _headerKey),
              sideContent: _Side(),
              mainContents: [_main],
              sideExpanded: true,
            ),
          ),
        );
        final side = tester.getRect(find.byKey(_sideKey));
        expect(side.left, 0);
        expect(side.width, 400);
        expect(side.top, tester.getRect(find.byKey(_headerKey)).bottom);
        expect(side.bottom, 800);
        expect(find.semantics.byLabel('Principal'), findsNothing);
        expect(find.semantics.byLabel('Lateral'), findsOneWidget);
        handle.dispose();
      },
    );

    testWidgets(
      '[Comportamento] Conteúdo lateral na tela pequena — Conteúdo lateral recolhido fora da tela',
      (tester) async {
        _view(tester, 400);
        await tester.pumpWidget(
          _host(
            const RebicToolPage(
              sideContent: _Side(),
              mainContents: [_main],
              sideExpanded: false,
            ),
          ),
        );
        expect(find.byKey(_sideKey), findsNothing);
        expect(
          tester.getRect(find.byKey(_mainKey)),
          const Rect.fromLTWH(0, 0, 400, 800),
        );
      },
    );

    testWidgets(
      '[Comportamento] Conteúdo lateral na tela pequena — Estado do conteúdo principal preservado',
      (tester) async {
        _view(tester, 400);
        await tester.pumpWidget(
          _host(
            const RebicToolPage(
              header: _Header(),
              sideContent: _Side(),
              mainContents: [_Counter()],
            ),
          ),
        );
        for (var i = 0; i < 3; i++) {
          await tester.tap(find.byKey(_Counter.buttonKey));
        }
        await tester.pump();
        expect(find.text('3'), findsOneWidget);
        await _toggle(tester);
        expect(find.byKey(_sideKey), findsOneWidget);
        await _toggle(tester);
        expect(find.byKey(_sideKey), findsNothing);
        expect(find.text('3'), findsOneWidget);
      },
    );
  });

  testWidgets(
    '[Comportamento] Vários conteúdos principais — Dois conteúdos principais',
    (tester) async {
      _view(tester, 800, 600);
      await tester.pumpWidget(
        _host(
          const RebicToolPage(
            mainContents: [
              SizedBox.expand(key: Key('first')),
              SizedBox.expand(key: Key('second')),
            ],
          ),
        ),
      );
      expect(
        tester.getRect(find.byKey(const Key('first'))),
        const Rect.fromLTWH(0, 0, 800, 300),
      );
      expect(
        tester.getRect(find.byKey(const Key('second'))),
        const Rect.fromLTWH(0, 300, 800, 300),
      );
    },
  );

  testWidgets('[Aparência] Tokens de componente — Fundo da página', (
    tester,
  ) async {
    _view(tester, 1200);
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        _host(
          theme: theme,
          RebicToolPage(
            key: ValueKey(theme.brightness),
            sideContent: const _Side(),
            mainContents: const [_main],
          ),
        ),
      );
      final decoration =
          tester
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: find.byType(RebicToolPage),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(decoration.color, theme.colors.background);
    }
  });

  testWidgets(
    '[Aparência] Movimento do conteúdo lateral — Saída sem animação no movimento reduzido',
    (tester) async {
      _view(tester, 400);
      await tester.pumpWidget(
        _host(
          reduceMotion: true,
          const RebicToolPage(
            header: _Header(),
            sideContent: _Side(),
            mainContents: [_main],
          ),
        ),
      );
      await tester.tap(find.byKey(_toggleKey));
      await tester.pump();
      expect(find.byKey(_sideKey), findsOneWidget);
      await tester.tap(find.byKey(_toggleKey));
      await tester.pump();
      expect(find.byKey(_sideKey), findsNothing);
    },
  );

  testWidgets('[Estados] Sem estados próprios — Página não recebe foco', (
    tester,
  ) async {
    _view(tester, 1200);
    final header = FocusNode();
    final content = FocusNode();
    addTearDown(header.dispose);
    addTearDown(content.dispose);
    await tester.pumpWidget(
      RebicApp(
        home: RebicToolPage(
          header: Focus(focusNode: header, child: const SizedBox(height: 40)),
          mainContents: [
            Align(
              alignment: Alignment.topLeft,
              child: Focus(
                focusNode: content,
                child: const SizedBox(width: 20, height: 20),
              ),
            ),
          ],
        ),
      ),
    );
    header.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(content.hasPrimaryFocus, isTrue);
  });

  testWidgets('[Acessibilidade] Teclado e foco — Ordem de foco na página', (
    tester,
  ) async {
    _view(tester, 1200);
    final nodes = List.generate(4, (_) => FocusNode());
    addTearDown(() {
      for (final node in nodes) {
        node.dispose();
      }
    });
    Widget focusable(int i) => Focus(
      focusNode: nodes[i],
      child: const SizedBox(width: 20, height: 20),
    );
    await tester.pumpWidget(
      RebicApp(
        home: RebicToolPage(
          header: Align(alignment: Alignment.topLeft, child: focusable(0)),
          subHeader: Align(alignment: Alignment.topLeft, child: focusable(1)),
          sideContent: SizedBox(
            width: 240,
            child: Align(alignment: Alignment.topLeft, child: focusable(2)),
          ),
          mainContents: [
            Align(alignment: Alignment.topLeft, child: focusable(3)),
          ],
        ),
      ),
    );
    nodes[0].requestFocus();
    await tester.pump();
    final visited = <int>[];
    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      visited.add(nodes.indexWhere((n) => n.hasPrimaryFocus));
    }
    expect(visited, [1, 2, 3]);
  });

  testWidgets(
    '[Acessibilidade] Semântica — Conteúdo lateral recolhido fora da semântica',
    (tester) async {
      _view(tester, 400);
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const RebicToolPage(
            sideContent: _Side(),
            mainContents: [_main],
            sideExpanded: false,
          ),
        ),
      );
      expect(find.semantics.byLabel('Lateral'), findsNothing);
      expect(find.semantics.byLabel('Principal'), findsOneWidget);
      handle.dispose();
    },
  );

  testWidgets('[Responsividade] Tela e direção — Página em RTL', (
    tester,
  ) async {
    _view(tester, 1200);
    await tester.pumpWidget(
      _host(
        direction: TextDirection.rtl,
        const RebicToolPage(sideContent: _Side(), mainContents: [_main]),
      ),
    );
    final side = tester.getRect(find.byKey(_sideKey));
    final main = tester.getRect(find.byKey(_mainKey));
    expect(side.right, 1200);
    expect(main.right, side.left);
    expect(main.left, 0);
  });

  testWidgets('[Integração] Dependências — Página sem Material', (
    tester,
  ) async {
    _view(tester, 1200);
    await tester.pumpWidget(const RebicApp(home: _GoldenToolPage()));
    expect(find.byType(RebicShellBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test(
      '[Testes] Cobertura exigida — Rastreabilidade da página de ferramentas',
      () {
        final names = scenarioNames(
          'rebic/widgets/rebic-tool-page',
          'update-rebic-scaffold-fiori-tool-page',
        );
        expect(names, hasLength(22));
        expect(untestedScenarios(names), isEmpty);
      },
    );

    testWidgets(
      '[Testes] Cobertura exigida — Goldens da página de ferramentas',
      (tester) async {
        for (final (name, theme) in goldenThemes) {
          await expectGolden(
            tester,
            name: 'rebic_tool_page_$name',
            theme: theme,
            size: const Size(1100, 480),
            surface: RebicSurface.none,
            child: const SizedBox(
              width: 1068,
              height: 448,
              child: _GoldenToolPage(),
            ),
          );
        }
      },
      tags: ['golden'],
    );
  });

  test('[Restrições] Fora do escopo — Página sem valor literal', () {
    final source = File(
      'lib/src/fundacao_layout/tool_page/rebic_tool_page.dart',
    ).readAsStringSync();
    final ctor = RegExp(
      r'const RebicToolPage\(\{(.*?)\}\)',
      dotAll: true,
    ).firstMatch(source)!.group(1)!;
    expect(ctor, contains('this.mainContents'));
    for (final field in RegExp(
      r'^  final (\S+) \w+;$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!)) {
      expect(field, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}

/// Contador que preserva o próprio estado.
class _Counter extends StatefulWidget {
  const _Counter();

  static const buttonKey = Key('increment');

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: GestureDetector(
      key: _Counter.buttonKey,
      onTap: () => setState(() => _count++),
      child: Text('$_count'),
    ),
  );
}

/// Amostra dos goldens: barra, navegação expandida e conteúdo principal.
class _GoldenToolPage extends StatelessWidget {
  const _GoldenToolPage();

  @override
  Widget build(BuildContext context) {
    Widget item(BuildContext context, IconData icon, String label) =>
        RebicSpacing.padding(
          horizontal: RebicSpace.m,
          vertical: RebicSpace.s,
          child: RebicHBox(
            items: [
              RebicIcon(icon),
              if (RebicToolPage.sideExpandedOf(context)!) RebicText(label),
            ],
          ),
        );
    return RebicToolPage(
      header: Builder(
        builder: (context) => RebicShellBar(
          title: 'Compras',
          homeIcon: const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
          showMenuButton: true,
          onMenuButtonPressed: () =>
              RebicToolPage.toggleSideContentMode(context),
          showNotifications: true,
          onNotificationsPressed: () {},
          profile: const RebicAvatar(initials: 'TA'),
        ),
      ),
      sideContent: Builder(
        builder: (context) => RebicContainer(
          surface: RebicSurface.base,
          child: SizedBox(
            width: RebicToolPage.sideExpandedOf(context)! ? 240 : 48,
            child: RebicVBox(
              gap: RebicSpace.none,
              items: [
                item(context, RebicIcons.home, 'Início'),
                item(context, RebicIcons.document, 'Pedidos'),
                item(context, RebicIcons.actionSettings, 'Configurações'),
              ],
            ),
          ),
        ),
      ),
      mainContents: const [
        RebicSpacing.padding(
          all: RebicSpace.l,
          child: RebicTitle(
            'Pedidos em aberto',
            titleStyle: RebicTitleLevel.h2,
          ),
        ),
      ],
    );
  }
}
