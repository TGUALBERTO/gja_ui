import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.
void main() {
  testWidgets('[Acessibilidade] Semântica e contraste — Contraste na barra', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        RebicTheme(
          key: ValueKey(theme.brightness),
          data: theme,
          duration: Duration.zero,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                for (final design in [
                  RebicBarDesign.header,
                  RebicBarDesign.subHeader,
                  RebicBarDesign.footer,
                  RebicBarDesign.floatingFooter,
                ])
                  RebicBar(
                    design: design,
                    contentMiddle: [RebicText('Pedidos ${design.name}')],
                  ),
              ],
            ),
          ),
        ),
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    handle.dispose();
  });
}
