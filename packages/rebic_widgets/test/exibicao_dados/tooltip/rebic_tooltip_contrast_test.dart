import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.
void main() {
  testWidgets('[Acessibilidade] Semântica e contraste — Contraste da dica', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        RebicApp(
          key: ValueKey(theme.brightness),
          theme: theme,
          darkTheme: theme,
          home: const Center(
            child: RebicTooltip(
              message: 'Editar pedido',
              child: SizedBox(key: Key('icon'), width: 24, height: 24),
            ),
          ),
        ),
      );
      await tester.longPress(find.byKey(const Key('icon')));
      await tester.pump();
      expect(find.text('Editar pedido'), findsOneWidget);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await tester.tapAt(Offset.zero);
      await tester.pump();
    }
    handle.dispose();
  });
}
