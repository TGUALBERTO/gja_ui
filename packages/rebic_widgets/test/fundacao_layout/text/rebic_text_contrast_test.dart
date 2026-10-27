import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.
void main() {
  testWidgets('[Acessibilidade] Semântica e contraste — Contraste dos tons', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    for (final theme in [RebicThemeData.light(), RebicThemeData.dark()]) {
      await tester.pumpWidget(
        RebicTheme(
          // Chave por tema: sem transição entre um tema e outro.
          key: ValueKey(theme.brightness),
          data: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ColoredBox(
              color: theme.colors.base,
              child: Column(
                children: [
                  for (final tone in RebicTextTone.values)
                    RebicText('tom ${tone.name}', tone: tone),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    handle.dispose();
  });
}
