import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.

Widget _buttons(RebicThemeData theme, {double textScale = 1}) => RebicTheme(
  key: ValueKey((theme.brightness, theme.density.density, textScale)),
  data: theme,
  duration: Duration.zero,
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: RebicContainer(
          surface: RebicSurface.background,
          child: Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in RebicButtonType.values)
                  RebicButton(
                    label: type.name,
                    type: type,
                    icon: RebicIcons.accept,
                    onPressed: () {},
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('[Acessibilidade] Contraste, alvo e escala — Contraste e alvo', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    for (final base in [RebicThemeData.light(), RebicThemeData.dark()]) {
      for (final density in RebicDensity.values) {
        final theme = base.withDensity(density);
        await tester.pumpWidget(_buttons(theme));
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
  });

  testWidgets(
    '[Acessibilidade] Contraste, alvo e escala — Escala de texto 2,0',
    (tester) async {
      final theme = RebicThemeData.light();
      await tester.pumpWidget(_buttons(theme, textScale: 2));
      expect(tester.takeException(), isNull);
      for (final box
          in find
              .descendant(
                of: find.byType(RebicButton),
                matching: find.byType(DecoratedBox),
              )
              .evaluate()) {
        expect(
          tester.getSize(find.byWidget(box.widget)).height,
          greaterThanOrEqualTo(theme.density.controlHeight),
        );
      }
    },
  );
}
