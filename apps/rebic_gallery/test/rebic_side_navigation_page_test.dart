import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_side_navigation_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicSideNavigation na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicSideNavigationPage.title);
      await tester.tap(
        find.descendant(
          of: find.byType(RebicSideNavigation<String>),
          matching: find.text('Clientes'),
        ),
      );
      await tester.pump();
      expect(find.text('Página: Clientes'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
