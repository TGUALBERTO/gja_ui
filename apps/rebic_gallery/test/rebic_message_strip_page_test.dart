import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_message_strip_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicMessageStrip na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicMessageStripPage.title);
      expect(find.text(RebicMessageStripPage.closable), findsOneWidget);
      final close = find.descendant(
        of: find.widgetWithText(
          RebicMessageStrip,
          RebicMessageStripPage.closable,
        ),
        matching: find.byType(RebicButton),
      );
      await tester.tap(close);
      await tester.pumpAndSettle();
      expect(find.text(RebicMessageStripPage.closable), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
