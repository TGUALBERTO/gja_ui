import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_card_page.dart';

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicCard na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.scrollUntilVisible(find.text(RebicCardPage.title), 200);
    await tester.tap(find.text(RebicCardPage.title));
    await tester.pumpAndSettle();
    expect(find.text(RebicCardPage.opened), findsNothing);

    await tester.tap(find.text(RebicCardPage.pendingTitle));
    await tester.pumpAndSettle();
    expect(find.text(RebicCardPage.opened), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
