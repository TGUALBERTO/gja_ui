import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.

/// App com um botão "Abrir" que abre [dialog] e guarda o resultado.
Widget _launcher(
  WidgetBuilder dialog, {
  List<Object?>? results,
  bool dismissible = true,
  RebicThemeData? theme,
  TextDirection direction = TextDirection.ltr,
}) => RebicApp(
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

void main() {
  testWidgets('[Acessibilidade] Semântica e contraste — Contraste do diálogo', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    for (final base in [RebicThemeData.light(), RebicThemeData.dark()]) {
      for (final density in RebicDensity.values) {
        final theme = base.withDensity(density);
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(_launcher(_simple, theme: theme));
        await _open(tester);
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
    }
    handle.dispose();
  });
}
