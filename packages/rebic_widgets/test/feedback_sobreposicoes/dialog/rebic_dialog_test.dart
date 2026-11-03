import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

import '../../support/fonts.dart';
import '../../support/traceability.dart';

final _light = RebicThemeData.light();

/// App com um botão "Abrir" que abre [dialog] e guarda o resultado.
Widget _launcher(
  WidgetBuilder dialog, {
  List<Object?>? results,
  bool dismissible = true,
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicApp(
  debugShowCheckedModeBanner: false,
  theme: theme,
  darkTheme: theme,
  density: theme?.density.density,
  builder: (context, child) =>
      Directionality(textDirection: direction, child: child!),
  home: Builder(
    builder: (context) => Center(
      child: RebicButton(
        text: 'Abrir',
        onPress: () async {
          final result = await RebicDialog.open<Object?>(
            context,
            builder: dialog,
            dismissible: dismissible,
          );
          results?.add(result);
        },
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

RebicDialog _simple(
  BuildContext context, {
  String title = 'Excluir pedido',
  RebicValueState state = RebicValueState.none,
}) => RebicDialog(
  title: title,
  state: state,
  content: const RebicText('O pedido 4711 será excluído.'),
  beginButton: RebicButton(
    text: 'Excluir',
    type: RebicButtonType.emphasized,
    onPress: () => Navigator.of(context).pop(true),
  ),
  endButton: RebicButton(
    text: 'Cancelar',
    onPress: () => Navigator.of(context).pop(false),
  ),
);

Finder get _panel => find
    .descendant(
      of: find.byType(RebicDialog),
      matching: find.byType(RebicContainer),
    )
    .first;

void main() {
  setUpAll(loadRebicFonts);

  testWidgets('[API] Propriedades — Diálogo mínimo', (tester) async {
    await tester.pumpWidget(_launcher(_simple));
    await _open(tester);
    final panel = tester.getRect(_panel);
    final screen = tester.getRect(find.byType(RebicApp));
    expect(panel.center.dx, closeTo(screen.center.dx, 1));
    expect(
      tester.getTopLeft(find.text('Excluir pedido')).dy,
      lessThan(tester.getTopLeft(find.text('O pedido 4711 será excluído.')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Excluir')).dy,
      greaterThan(
        tester.getTopLeft(find.text('O pedido 4711 será excluído.')).dy,
      ),
    );
  });

  test('[API] Nome válido — Diálogo sem nome', () {
    expect(() => RebicDialog(content: const SizedBox()), throwsAssertionError);
  });

  testWidgets('[API] Callbacks e controlador — Resultado do diálogo', (
    tester,
  ) async {
    final results = <Object?>[];
    await tester.pumpWidget(_launcher(_simple, results: results));
    await _open(tester);
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    expect(find.byType(RebicDialog), findsNothing);
    expect(results, [true]);
  });

  testWidgets('[Comportamento] Fechar com Esc — Esc no diálogo', (
    tester,
  ) async {
    final results = <Object?>[];
    await tester.pumpWidget(_launcher(_simple, results: results));
    await _open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(RebicDialog), findsNothing);
    expect(results, [null]);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_launcher(_simple, dismissible: false));
    await _open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(RebicDialog), findsOneWidget);
  });

  testWidgets('[Comportamento] Rodapé e rolagem — Conteúdo longo', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _launcher(
        (context) => RebicDialog(
          title: 'Longo',
          content: const SizedBox(height: 1000, child: RebicText('Início')),
          endButton: RebicButton(
            text: 'Fechar',
            onPress: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
    await _open(tester);
    final panel = tester.getRect(_panel);
    expect(panel.height, lessThanOrEqualTo(400));
    expect(tester.getRect(find.text('Longo')).top, greaterThanOrEqualTo(0));
    expect(tester.getRect(find.text('Fechar')).bottom, lessThanOrEqualTo(400));
    expect(
      find.descendant(
        of: find.byType(RebicDialog),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
  });

  testWidgets('[Aparência] Tokens de componente — Diálogo de erro', (
    tester,
  ) async {
    await tester.pumpWidget(
      _launcher((context) => _simple(context, state: RebicValueState.error)),
    );
    await _open(tester);
    final icon = tester.widget<Icon>(
      find.descendant(
        of: find.byType(RebicDialog),
        matching: find.byIcon(RebicIcons.error),
      ),
    );
    expect(
      icon.color,
      _light.colors.stateColors(RebicValueState.error).foreground,
    );
    final container = tester.widget<RebicContainer>(_panel);
    expect(container.surface, RebicSurface.base);
    expect(container.shadow, RebicShadow.dialog);
    expect(container.radius, RebicRadius.element);
    expect(tester.getSize(_panel).width, _light.spacing.xxxl * 8);
  });

  testWidgets('[Estados] Foco preso — Foco no diálogo', (tester) async {
    await tester.pumpWidget(_launcher(_simple));
    await _open(tester);
    final seen = <String?>{};
    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      seen.add(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<RebicButton>()
            ?.text,
      );
    }
    expect(seen, {'Excluir', 'Cancelar'});
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(
      FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<RebicButton>()
          ?.text,
      'Abrir',
    );
  });

  group('[Acessibilidade] Semântica e contraste', () {
    testWidgets(
      '[Acessibilidade] Semântica e contraste — Semântica do diálogo',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(_launcher(_simple));
        await _open(tester);
        expect(
          tester.getSemantics(find.byType(RebicDialog)),
          containsSemantics(
            label: 'Excluir pedido',
            scopesRoute: true,
            namesRoute: true,
          ),
        );
        expect(
          tester.getSemantics(find.text('Excluir pedido')),
          containsSemantics(isHeader: true),
        );
        expect(find.semantics.byLabel('Abrir'), findsNothing);
        handle.dispose();
      },
    );
  });

  testWidgets('[Responsividade] Largura e direção — Diálogo em tela estreita', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_launcher(_simple));
    await _open(tester);
    expect(tester.getSize(_panel).width, 320 - 2 * _light.spacing.l);
  });

  testWidgets('[Integração] Dependências — Diálogo sem Material', (
    tester,
  ) async {
    await tester.pumpWidget(
      _launcher((context) => _simple(context, state: RebicValueState.warning)),
    );
    await _open(tester);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('[Testes] Cobertura exigida', () {
    test('[Testes] Cobertura exigida — Rastreabilidade do diálogo', () {
      final names = scenarioNames(
        'rebic/widgets/rebic-dialog',
        'add-rebic-dialog',
      );
      expect(names, hasLength(15));
      expect(untestedScenarios(names), isEmpty);
    });

    testWidgets('[Testes] Cobertura exigida — Goldens do diálogo', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(640, 400);
      addTearDown(tester.view.reset);
      for (final base in [
        ('light', RebicThemeData.light()),
        ('dark', RebicThemeData.dark()),
      ]) {
        for (final density in RebicDensity.values) {
          final theme = base.$2.withDensity(density);
          for (final (kind, state) in [
            ('standard', RebicValueState.none),
            ('error', RebicValueState.error),
          ]) {
            await tester.pumpWidget(const SizedBox());
            await tester.pumpWidget(
              _launcher(
                (context) => _simple(context, state: state),
                theme: theme,
              ),
            );
            await _open(tester);
            await expectLater(
              find.byType(RebicApp),
              matchesGoldenFile(
                'goldens/rebic_dialog_${kind}_${base.$1}_${density.name}.png',
              ),
            );
          }
        }
      }
    }, tags: ['golden']);
  });

  test('[Restrições] Fora do escopo — Diálogo sem valor literal', () {
    final source = File(
      'lib/src/feedback_sobreposicoes/dialog/rebic_dialog.dart',
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
