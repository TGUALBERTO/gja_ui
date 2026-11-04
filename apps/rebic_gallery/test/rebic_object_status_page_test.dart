import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_object_status_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicObjectStatus na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicObjectStatusPage.title);
      expect(find.text(RebicObjectStatusPage.opened), findsNothing);

      await tester.tap(find.text(RebicObjectStatusPage.pending));
      await tester.pumpAndSettle();
      expect(find.text(RebicObjectStatusPage.opened), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
