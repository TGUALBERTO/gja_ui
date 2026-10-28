import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_link_page.dart';

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicLink na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 900);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.scrollUntilVisible(find.text(RebicLinkPage.title), 200);
    await tester.tap(find.text(RebicLinkPage.title));
    await tester.pumpAndSettle();
    expect(find.text(RebicLinkPage.opened), findsNothing);

    await tester.tap(find.text(RebicLinkPage.orderLink));
    await tester.pumpAndSettle();
    expect(find.text(RebicLinkPage.opened), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
