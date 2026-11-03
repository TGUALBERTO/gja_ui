import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_breadcrumbs_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicBreadcrumbs na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicBreadcrumbsPage.title);
      final trail = find.byKey(RebicBreadcrumbsPage.trailKey);
      await tester.tap(
        find.descendant(of: trail, matching: find.text('Pedidos')),
      );
      await tester.pump();
      expect(
        tester.widget<RebicBreadcrumbs>(trail).currentLocationText,
        'Pedidos',
      );
      expect(tester.takeException(), isNull);
    },
  );
}
