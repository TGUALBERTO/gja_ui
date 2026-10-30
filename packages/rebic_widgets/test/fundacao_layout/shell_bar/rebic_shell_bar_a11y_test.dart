import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.
void main() {
  testWidgets('[Acessibilidade] Contraste e alvo — Contraste e alvo na barra', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 400);
    addTearDown(tester.view.reset);
    final handle = tester.ensureSemantics();
    for (final base in [RebicThemeData.light(), RebicThemeData.dark()]) {
      for (final density in RebicDensity.values) {
        final theme = base.withDensity(density);
        await tester.pumpWidget(
          RebicTheme(
            key: ValueKey((theme.brightness, density)),
            data: theme,
            duration: Duration.zero,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.topCenter,
                child: RebicShellBar(
                  title: 'Compras',
                  secondTitle: 'Pedidos',
                  showMenuButton: true,
                  showSearch: true,
                  showNotifications: true,
                  showProductSwitcher: true,
                  profile: const RebicAvatar(initials: 'TA'),
                  onMenuButtonPressed: () {},
                  onSearchButtonPressed: () {},
                  onNotificationsPressed: () {},
                  onProductSwitcherPressed: () {},
                  onAvatarPressed: () {},
                ),
              ),
            ),
          ),
        );
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
