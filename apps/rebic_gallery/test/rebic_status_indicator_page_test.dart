import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_status_indicator_page.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicStatusIndicator na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.scrollUntilVisible(
        find.text(RebicStatusIndicatorPage.title),
        200,
      );
      await tester.tap(find.text(RebicStatusIndicatorPage.title));
      await tester.pumpAndSettle();
      expect(find.text(RebicStatusIndicatorPage.opened), findsNothing);

      await tester.tap(find.text(RebicStatusIndicatorPage.pending));
      await tester.pumpAndSettle();
      expect(find.text(RebicStatusIndicatorPage.opened), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
