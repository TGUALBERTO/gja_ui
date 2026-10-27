import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_widgets/rebic_widgets.dart';

// Sem carregar a Inter: a diretriz de contraste mede os pixels do texto, e os
// glifos sólidos da fonte de teste padrão dão as cores reais de frente e fundo.

Widget _scaffold(RebicThemeData theme, {bool? expanded}) => RebicTheme(
  key: ValueKey((theme.brightness, theme.density.density)),
  data: theme,
  duration: Duration.zero,
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: RebicScaffold(
      title: 'Compras',
      navigationExpanded: expanded,
      onNavigationExpandedChanged: (_) {},
      navigation: const SizedBox(width: 64),
      body: const SizedBox.expand(),
    ),
  ),
);

void _view(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1200, 800);
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets(
    '[Acessibilidade] Semântica e contraste — Semântica do botão de navegação',
    (tester) async {
      _view(tester);
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _scaffold(RebicThemeData.light(), expanded: false),
      );
      expect(
        tester.getSemantics(find.byType(RebicInteractable)),
        containsSemantics(
          isButton: true,
          label: 'Navegação',
          hasExpandedState: true,
          isExpanded: false,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.text('Compras')),
        containsSemantics(isHeader: true, label: 'Compras'),
      );
      await tester.pumpWidget(
        _scaffold(RebicThemeData.light(), expanded: true),
      );
      expect(
        tester.getSemantics(find.byType(RebicInteractable)),
        containsSemantics(hasExpandedState: true, isExpanded: true),
      );
      handle.dispose();
    },
  );

  testWidgets(
    '[Acessibilidade] Semântica e contraste — Contraste e alvo na barra',
    (tester) async {
      _view(tester);
      final handle = tester.ensureSemantics();
      for (final base in [RebicThemeData.light(), RebicThemeData.dark()]) {
        for (final density in RebicDensity.values) {
          final theme = base.withDensity(density);
          await tester.pumpWidget(_scaffold(theme));
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
    },
  );
}
