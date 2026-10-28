import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter, como nos demais testes de acessibilidade.

const _families = {
  RebicButtonType.standard: RebicControlFamily.standard,
  RebicButtonType.emphasized: RebicControlFamily.emphasized,
  RebicButtonType.transparent: RebicControlFamily.transparent,
  RebicButtonType.accept: RebicControlFamily.accept,
  RebicButtonType.reject: RebicControlFamily.reject,
  RebicButtonType.attention: RebicControlFamily.attention,
};

void main() {
  testWidgets(
    '[Acessibilidade] Contraste e alvo — Contraste e alvo do botão de ícone',
    (tester) async {
      final handle = tester.ensureSemantics();
      for (final base in [RebicThemeData.light(), RebicThemeData.dark()]) {
        for (final density in RebicDensity.values) {
          final theme = base.withDensity(density);
          await tester.pumpWidget(
            RebicApp(
              key: ValueKey((theme.brightness, density)),
              theme: theme,
              darkTheme: theme,
              density: density,
              home: Center(
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final type in RebicButtonType.values)
                      RebicIconButton(
                        icon: RebicIcons.edit,
                        tooltip: type.name,
                        type: type,
                        onPressed: () {},
                      ),
                  ],
                ),
              ),
            ),
          );
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
          // Contraste não textual do ícone sobre o fundo de cada estado.
          final c = theme.colors;
          for (final type in RebicButtonType.values) {
            final family = RebicControlColors.of(_families[type]!, c);
            for (final state in family.states.values) {
              final grounds = state.background.a == 0
                  ? [c.base, c.background]
                  : [state.background];
              for (final ground in grounds) {
                expect(
                  rebicContrastRatioOver(state.text, ground),
                  greaterThanOrEqualTo(RebicAccessibility.minNonTextContrast),
                  reason: '${theme.brightness.name}/${type.name}',
                );
              }
            }
          }
        }
      }
      handle.dispose();
    },
  );
}
