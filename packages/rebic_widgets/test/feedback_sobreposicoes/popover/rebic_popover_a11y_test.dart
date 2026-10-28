import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.
void main() {
  testWidgets(
    '[Acessibilidade] Contraste e alvo — Contraste e alvo do popover',
    (tester) async {
      final handle = tester.ensureSemantics();
      for (final base in [RebicThemeData.light(), RebicThemeData.dark()]) {
        for (final density in RebicDensity.values) {
          final theme = base.withDensity(density);
          final controller = RebicPopoverController();
          addTearDown(controller.dispose);
          await tester.pumpWidget(
            RebicApp(
              key: ValueKey((theme.brightness, density)),
              theme: theme,
              darkTheme: theme,
              home: RebicContainer(
                surface: RebicSurface.background,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: RebicPopover(
                      controller: controller,
                      title: 'Filtros',
                      content: const RebicText('Status: em aberto'),
                      actions: [
                        RebicButton(
                          label: 'Aplicar',
                          type: RebicButtonType.emphasized,
                          onPressed: () {},
                        ),
                        RebicButton(
                          label: 'Cancelar',
                          type: RebicButtonType.transparent,
                          onPressed: () {},
                        ),
                      ],
                      child: RebicButton(
                        label: 'Filtrar',
                        onPressed: controller.toggle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          controller.open();
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
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
    },
  );
}
