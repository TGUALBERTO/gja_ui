import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_icon_tab_bar_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicIconTabBar na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicIconTabBarPage.title);
      expect(find.text(RebicIconTabBarPage.attachments), findsNothing);
      await tester.tap(find.text('Anexos'));
      await tester.pump();
      expect(find.text(RebicIconTabBarPage.attachments), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
