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

const _long =
    'Pedidos de compra pendentes de aprovação do gestor do centro de custo da '
    'unidade de compras corporativas e das filiais regionais';

/// Monta [child] numa área de [width], sob [direction] e escala de texto, sem
/// `RebicApp`.
Widget _host(
  Widget child, {
  double width = 360,
  TextDirection direction = TextDirection.ltr,
  double textScale = 1,
  RebicThemeData? theme,
}) => RebicTheme(
  data: theme ?? _light,
  duration: Duration.zero,
  child: Directionality(
    textDirection: direction,
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

/// Cabeçalho completo, com [onPress] opcional.
RebicCardHeader _full({VoidCallback? onPress, Widget? toolbar}) =>
    RebicCardHeader(
      iconInitials: 'MB',
      title: 'Pedidos',
      statusText: '3 de 5',
      subtitle: 'Compras',
      dataTimestamp: 'Há 5 min',
      toolbar: toolbar,
      onPress: onPress,
    );

TextStyle _style(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

Color? _background(WidgetTester tester) => tester
    .widget<ColoredBox>(
      find
          .descendant(
            of: find.byType(RebicInteractable),
            matching: find.byType(ColoredBox),
          )
          .first,
    )
    .color;

void main() {
  setUpAll(loadRebicFonts);

  group('[API] Propriedades', () {
    testWidgets('[API] Propriedades — Cabeçalho completo', (tester) async {
      await tester.pumpWidget(
        _host(
          _full(
            toolbar: const SizedBox(key: Key('toolbar'), width: 24, height: 24),
          ),
        ),
      );
      final icon = tester.getRect(find.byType(RebicAvatar));
      final title = tester.getRect(find.text('Pedidos'));
      final status = tester.getRect(find.text('3 de 5'));
      final subtitle = tester.getRect(find.text('Compras'));
      final date = tester.getRect(find.text('Há 5 min'));
      final toolbar = tester.getRect(find.byKey(const Key('toolbar')));
      expect(icon.left, _light.spacing.l);
      expect(icon.right, lessThanOrEqualTo(title.left));
      expect(title.top, lessThan(subtitle.top));
      expect(status.right, lessThanOrEqualTo(toolbar.left));
      expect(status.top, lessThan(subtitle.top));
      expect(date.top, greaterThan(status.bottom));
      expect(date.right, closeTo(status.right, 0.01));
      expect(toolbar.right, 360 - _light.spacing.l);
    });

    test('[API] Propriedades — Linhas inválidas no cabeçalho', () {
      expect(
        () => RebicCardHeader(titleMaxLines: int.parse('0')),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('"titleMaxLines"'),
          ),
        ),
      );
    });
  });

  testWidgets('[API] Ícone do cabeçalho — Ícone por iniciais', (tester) async {
    await tester.pumpWidget(
      _host(
        const RebicCardHeader(
          title: 'Pedidos',
          iconInitials: 'MB',
          iconDisplayShape: RebicAvatarShape.square,
        ),
      ),
    );
    final avatar = tester.widget<RebicAvatar>(find.byType(RebicAvatar));
    expect(avatar.initials, 'MB');
    expect(avatar.shape, RebicAvatarShape.square);
    expect(avatar.size, RebicAvatarSize.s);
    await tester.pumpWidget(
      _host(
        const RebicCardHeader(
          title: 'Pedidos',
          iconInitials: 'MB',
          iconVisible: false,
        ),
      ),
    );
    expect(find.byType(RebicAvatar), findsNothing);
  });

  testWidgets('[API] Callbacks e controlador — Cabeçalho acionado', (
    tester,
  ) async {
    var calls = 0;
    var toolbarCalls = 0;
    await tester.pumpWidget(
      _host(
        _full(
          onPress: () => calls++,
          toolbar: RebicIconButton(
            icon: RebicIcons.overflow,
            tooltip: 'Mais',
            onPressed: () => toolbarCalls++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Pedidos'));
    await tester.tap(find.byType(RebicIconButton));
    await tester.pump();
    expect(calls, 1);
    expect(toolbarCalls, 1);
  });

  group('[Comportamento] Linhas dos textos', () {
    testWidgets(
      '[Comportamento] Linhas dos textos — Título longo no cabeçalho',
      (tester) async {
        await tester.pumpWidget(
          _host(width: 280, const RebicCardHeader(title: _long)),
        );
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(_long),
        );
        expect(tester.widget<Text>(find.text(_long)).maxLines, 3);
        expect(paragraph.didExceedMaxLines, isTrue);
      },
    );

    testWidgets('[Comportamento] Linhas dos textos — Status oculto', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const RebicCardHeader(
            title: 'Pedidos',
            statusText: '3 de 5',
            statusVisible: false,
          ),
        ),
      );
      expect(find.text('3 de 5'), findsNothing);
    });
  });

  testWidgets('[Aparência] Tokens de componente — Estilos do cabeçalho', (
    tester,
  ) async {
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        _host(
          theme: theme,
          KeyedSubtree(key: ValueKey(theme), child: _full()),
        ),
      );
      final t = theme.typography;
      final c = theme.colors;
      final title = _style(tester, 'Pedidos');
      expect(title.fontSize, t.header5.fontSize);
      expect(title.fontWeight, t.header5.fontWeight);
      expect(title.color, c.text);
      expect(_style(tester, 'Compras').fontSize, t.base.fontSize);
      expect(_style(tester, 'Compras').color, c.label);
      for (final small in ['3 de 5', 'Há 5 min']) {
        expect(_style(tester, small).fontSize, t.small.fontSize, reason: small);
        expect(_style(tester, small).color, c.label, reason: small);
      }
    }
  });

  group('[Estados] Cabeçalho acionável', () {
    testWidgets(
      '[Estados] Cabeçalho acionável — Cabeçalho do cartão em hover',
      (tester) async {
        await tester.pumpWidget(_host(_full(onPress: () {})));
        final list = RebicControlColors.of(
          RebicControlFamily.list,
          _light.colors,
        );
        expect(_background(tester), list.normal.background);
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        await mouse.moveTo(tester.getCenter(find.text('Pedidos')));
        await tester.pump();
        expect(_background(tester), list.hover.background);
      },
    );

    testWidgets(
      '[Estados] Cabeçalho acionável — Cabeçalho sem ação não recebe foco',
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
                const RebicCardHeader(title: 'Pedidos'),
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
  });

  testWidgets('[Acessibilidade] Teclado — Cabeçalho do cartão pelo teclado', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 360, child: _full(onPress: () => calls++)),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('[Acessibilidade] Semântica — Semântica do cabeçalho', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        RebicCard(
          headingLevel: RebicTitleLevel.h2,
          header: RebicCardHeader(
            title: 'Pedidos',
            subtitle: 'Compras',
            onPress: () {},
          ),
        ),
      ),
    );
    final data = tester
        .getSemantics(find.byType(RebicInteractable))
        .getSemanticsData();
    expect(data.label, 'Pedidos, Compras');
    expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(data.hasFlag(SemanticsFlag.isHeader), isTrue);
    expect(data.headingLevel, 2);
    handle.dispose();
  });

  // "Contraste e alvo do cabeçalho" fica em rebic_card_header_a11y_test.dart,
  // sem a fonte real: a diretriz de contraste mede pixels e precisa dos
  // glifos sólidos da fonte de teste padrão.

  group('[Responsividade] Direção e escala', () {
    testWidgets('[Responsividade] Direção e escala — Cabeçalho em RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          direction: TextDirection.rtl,
          const RebicCardHeader(
            title: 'Pedidos',
            iconInitials: 'MB',
            statusText: '3 de 5',
          ),
        ),
      );
      final l = _light.spacing.l;
      expect(tester.getRect(find.byType(RebicAvatar)).right, 360 - l);
      expect(tester.getRect(find.text('3 de 5')).left, l);
    });

    testWidgets(
      '[Responsividade] Direção e escala — Cabeçalho com escala de texto 2,0',
      (tester) async {
        await tester.pumpWidget(_host(width: 300, textScale: 2, _full()));
        expect(tester.takeException(), isNull);
      },
    );
  });

  testWidgets('[Integração] Dependências — Cabeçalho sem Material', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      RebicApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 360, child: _full(onPress: () => calls++)),
        ),
      ),
    );
    await tester.tap(find.text('Pedidos'));
    await tester.pump();
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test(
      '[Testes] Cobertura exigida — Rastreabilidade do cabeçalho de cartão',
      () {
        final names = scenarioNames(
          'rebic/widgets/rebic-card-header',
          'update-rebic-card-fiori-card-header',
        );
        expect(names, hasLength(19));
        expect(untestedScenarios(names), isEmpty);
      },
    );

    testWidgets(
      '[Testes] Cobertura exigida — Goldens do cabeçalho de cartão',
      (tester) async {
        for (final (name, theme) in goldenThemes) {
          await expectGolden(
            tester,
            name: 'rebic_card_header_$name',
            theme: theme,
            size: const Size(440, 320),
            child: SizedBox(
              width: 400,
              child: Column(
                spacing: 16,
                children: [
                  _full(),
                  _full(onPress: () {}),
                ],
              ),
            ),
          );
          // Hover no cabeçalho acionável.
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(
            location: tester.getCenter(find.byType(RebicInteractable)),
          );
          await tester.pump();
          await expectLater(
            find.byKey(const Key('golden')),
            matchesGoldenFile('goldens/rebic_card_header_hover_$name.png'),
          );
          await mouse.removePointer();
        }
      },
      tags: ['golden'],
    );
  });

  test('[Restrições] Fora do escopo — Cabeçalho sem valor literal', () {
    final file = File(
      'lib/src/fundacao_layout/card_header/rebic_card_header.dart',
    ).readAsStringSync();
    final source = file.substring(
      file.indexOf('class RebicCardHeader '),
      file.indexOf('class RebicCardHeadingScope'),
    );
    for (final field in RegExp(
      r'^  final (\S+) \w+;$',
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)!)) {
      expect(field, isNot(anyOf('double', 'double?', 'Color', 'Color?')));
    }
  });
}
