import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_badge_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicBadge na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicBadgePage.title);

      Finder bellCount(String text) => find.descendant(
        of: find.byKey(RebicBadgePage.bellKey),
        matching: find.text(text),
      );
      expect(bellCount('0'), findsNothing);
      await tester.tap(find.text('Nova notificação'));
      await tester.pump();
      await tester.tap(find.text('Nova notificação'));
      await tester.pumpAndSettle();
      expect(bellCount('2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
