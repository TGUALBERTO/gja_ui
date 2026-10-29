import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_container_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicContainer na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 2200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.tap(find.text(RebicContainerPage.title));
      await tester.pumpAndSettle();

      Iterable<RebicContainer> containers() =>
          tester.widgetList<RebicContainer>(find.byType(RebicContainer));
      for (final surface in RebicSurface.values) {
        expect(
          containers().where((c) => c.surface == surface && c.border),
          isNotEmpty,
          reason: surface.name,
        );
      }
      for (final radius in RebicRadius.values) {
        expect(find.text(radius.name), findsWidgets, reason: radius.name);
      }
      for (final shadow in RebicShadow.values) {
        expect(
          containers().where((c) => c.shadow == shadow),
          isNotEmpty,
          reason: shadow.name,
        );
      }
      final card = tester.widget<RebicContainer>(
        find.byKey(RebicContainerPage.cardKey),
      );
      expect(card.surface, RebicSurface.base);
      expect(card.border, isTrue);
      expect(card.radius, RebicRadius.tile);
      expect(card.shadow, RebicShadow.card);
      expect(card.padding, RebicSpace.l);
    },
  );
}
