import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_toolbar_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicToolbar na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicToolbarPage.title);
      await tester.tap(find.text(RebicToolbarPage.filters));
      await tester.pumpAndSettle();
      expect(find.text(RebicToolbarPage.cleared), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
