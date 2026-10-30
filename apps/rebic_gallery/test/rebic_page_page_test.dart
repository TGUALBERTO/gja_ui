import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_page_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicPage na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 900);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await openGalleryPage(tester, RebicPagePage.title);
    expect(find.byType(RebicPage), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(RebicPage),
        matching: find.byType(RebicInteractable),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RebicPage), findsNothing);
    expect(find.text(RebicPagePage.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
