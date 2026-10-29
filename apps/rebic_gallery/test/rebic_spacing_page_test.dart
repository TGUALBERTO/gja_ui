import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_spacing_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicSpacing na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 2000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.tap(find.text('Densidade: cozy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(RebicSpacingPage.title));
      await tester.pumpAndSettle();

      final spacing = RebicThemeData.light().spacing;
      for (final space in RebicSpace.values) {
        expect(find.text(space.name), findsOneWidget, reason: space.name);
        expect(
          tester.getSize(find.byKey(RebicSpacingPage.barKey(space))).width,
          RebicSpacing.resolve(spacing, space),
          reason: space.name,
        );
      }

      // Mesmo padding `l` nas duas densidades: o compacto é menor.
      double inset(RebicDensity density) {
        final text = find.byKey(RebicSpacingPage.paddedKey(density));
        final box = find.ancestor(
          of: text,
          matching: find.byType(DecoratedBox),
        );
        return tester.getTopLeft(text).dx - tester.getTopLeft(box.first).dx;
      }

      final compact = RebicThemeData.light(density: RebicDensity.compact);
      expect(inset(RebicDensity.cozy), spacing.l);
      expect(inset(RebicDensity.compact), compact.spacing.l);
    },
  );
}
