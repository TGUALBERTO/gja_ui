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

const _s = Key('separator');
final _line = const BorderSide().width;

/// Monta [child] sob [theme], numa coluna de 300.
Widget _themed(Widget child, {RebicThemeData? theme}) => RebicTheme(
  data: theme ?? RebicThemeData.light(),
  duration: Duration.zero,
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: 300, child: child),
    ),
  ),
);

Finder _strokeOf(Key key) =>
    find.descendant(of: find.byKey(key), matching: find.byType(ColoredBox));

/// Retângulo da linha pintada (o `ColoredBox`) do separador de chave [key].
Rect _stroke(WidgetTester tester, [Key key = _s]) =>
    tester.getRect(_strokeOf(key));

Color _color(WidgetTester tester) =>
    tester.widget<ColoredBox>(_strokeOf(_s)).color;

/// Amostra dos goldens: lista com separadores horizontais e barra com
/// separador vertical entre as ações.
Widget _sample() => RebicColumn(
  gap: RebicSpace.l,
  children: [
    const RebicColumn(
      gap: RebicSpace.s,
      children: [
        RebicText('Item 1'),
        RebicSeparator(),
        RebicText('Item 2'),
        RebicSeparator(),
        RebicText('Item 3'),
      ],
    ),
    RebicBar(
      contentLeft: [
        RebicButton(label: 'Salvar', onPressed: () {}),
        const RebicSeparator.vertical(),
        RebicButton(label: 'Copiar', onPressed: () {}),
        RebicButton(label: 'Excluir', onPressed: () {}),
      ],
    ),
  ],
);

void main() {
  setUpAll(loadRebicFonts);

  testWidgets('[API] Propriedades — Separador mínimo', (tester) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 300, child: RebicSeparator(key: _s)),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(_s)), Size(300, _line));
    expect(_color(tester), RebicThemeData.light().colors.separator);
  });

  testWidgets('[API] Callbacks e controlador — Separador sem ação', (
    tester,
  ) async {
    await tester.pumpWidget(_themed(const RebicSeparator(key: _s)));
    await tester.tapAt(tester.getCenter(find.byKey(_s)));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byKey(_s),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  group('[Comportamento] Orientação', () {
    testWidgets('[Comportamento] Orientação — Separador vertical numa barra', (
      tester,
    ) async {
      final theme = RebicThemeData.light();
      await tester.pumpWidget(
        _themed(
          RebicBar(
            contentLeft: [
              RebicButton(label: 'Salvar', onPressed: () {}),
              const RebicSeparator.vertical(key: _s),
              RebicButton(label: 'Copiar', onPressed: () {}),
            ],
          ),
        ),
      );
      final stroke = _stroke(tester);
      final bar = tester.getRect(find.byType(RebicBar));
      expect(stroke.size, Size(_line, theme.density.separatorHeight));
      expect(theme.density.separatorHeight, lessThan(theme.density.barHeight));
      expect(stroke.center.dy, closeTo(bar.center.dy, 0.5));
    });

    testWidgets(
      '[Comportamento] Orientação — Separador vertical numa linha esticada',
      (tester) async {
        await tester.pumpWidget(
          _themed(
            const SizedBox(
              height: 80,
              child: RebicRow(
                crossAlignment: RebicCrossAlignment.stretch,
                children: [
                  RebicText('a'),
                  RebicSeparator.vertical(key: _s),
                  RebicText('b'),
                ],
              ),
            ),
          ),
        );
        expect(
          _stroke(tester).size,
          Size(_line, RebicThemeData.light().density.separatorHeight),
        );
      },
    );
  });

  testWidgets('[Aparência] Tokens de componente — Troca de tema do separador', (
    tester,
  ) async {
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        _themed(const RebicSeparator(key: _s), theme: theme),
      );
      await tester.pumpAndSettle();
      expect(_color(tester), theme.colors.separator);
    }
  });

  testWidgets(
    '[Estados] Sem estados de interação — Separador não recebe foco',
    (tester) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      await tester.pumpWidget(
        RebicApp(
          home: Column(
            children: [
              Focus(
                focusNode: first,
                child: const SizedBox(width: 20, height: 20),
              ),
              const RebicSeparator(),
              Focus(
                focusNode: second,
                child: const SizedBox(width: 20, height: 20),
              ),
            ],
          ),
        ),
      );
      first.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(second.hasPrimaryFocus, isTrue);
    },
  );

  testWidgets(
    '[Acessibilidade] Teclado e foco — Teclas ignoradas pelo separador',
    (tester) async {
      await tester.pumpWidget(
        const RebicApp(home: Center(child: RebicSeparator())),
      );
      for (final key in [
        LogicalKeyboardKey.tab,
        LogicalKeyboardKey.enter,
        LogicalKeyboardKey.space,
      ]) {
        await tester.sendKeyEvent(key);
        await tester.pump();
      }
      expect(find.byType(RebicSeparator), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    '[Acessibilidade] Semântica e contraste — Separador fora da semântica',
    (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _themed(
          const Column(
            children: [
              RebicText('Antes'),
              RebicSeparator(key: _s),
              RebicText('Depois'),
            ],
          ),
        ),
      );
      final labels = <String>[];
      bool visit(SemanticsNode node) {
        if (node.label.isNotEmpty) labels.add(node.label);
        node.visitChildren(visit);
        return true;
      }

      visit(
        tester
            .binding
            .renderViews
            .first
            .owner!
            .semanticsOwner!
            .rootSemanticsNode!,
      );
      expect(labels.join('\n').split('\n'), ['Antes', 'Depois']);
      expect(
        find.descendant(
          of: find.byKey(_s),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      handle.dispose();
    },
  );

  testWidgets('[Responsividade] Densidade — Densidade compacta do separador', (
    tester,
  ) async {
    await tester.pumpWidget(
      _themed(
        const RebicRow(
          children: [
            RebicSeparator.vertical(key: Key('cozy')),
            RebicTheme.density(
              density: RebicDensity.compact,
              child: RebicSeparator.vertical(key: Key('compact')),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cozy = _stroke(tester, const Key('cozy')).size;
    final compact = _stroke(tester, const Key('compact')).size;
    expect(cozy.height, RebicThemeData.light().density.separatorHeight);
    expect(
      compact.height,
      RebicThemeData.light(
        density: RebicDensity.compact,
      ).density.separatorHeight,
    );
    expect(compact.height, lessThan(cozy.height));
    expect(compact.width, cozy.width);
  });

  testWidgets('[Integração] Dependências — Separador sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      const RebicApp(
        home: Column(
          children: [
            RebicSeparator(),
            RebicRow(children: [RebicSeparator.vertical()]),
          ],
        ),
      ),
    );
    expect(find.byType(RebicSeparator), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    testWidgets('[Testes] Cobertura exigida — Goldens do separador', (
      tester,
    ) async {
      for (final (name, theme) in goldenThemes) {
        // Recria a árvore a cada tema, para não capturar a barra no meio da
        // animação de densidade.
        await tester.pumpWidget(const SizedBox());
        await expectGolden(
          tester,
          name: 'rebic_separator_$name',
          theme: theme,
          child: SizedBox(width: 360, child: _sample()),
          size: const Size(420, 220),
        );
      }
    }, tags: ['golden']);

    test('[Testes] Cobertura exigida — Rastreabilidade do separador', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-separator',
        'update-rebic-divider-fiori-separator',
      );
      expect(names, hasLength(14));
      expect(untestedScenarios(names), isEmpty);
    });
  });

  test('[Restrições] Fora do escopo — Separador sem parâmetros visuais', () {
    final source = File(
      'lib/src/fundacao_layout/separator/rebic_separator.dart',
    ).readAsStringSync();
    final ctors = RegExp(
      r'const RebicSeparator(?:\.\w+)?\((.*?)\)\s*:',
      dotAll: true,
    ).allMatches(source).map((m) => m.group(1)!.trim()).toList();
    expect(ctors, ['{super.key}', '{super.key}']);
  });
}
