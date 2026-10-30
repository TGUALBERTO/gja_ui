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
    RebicPage page() => tester.widget<RebicPage>(find.byType(RebicPage));
    expect(page().floatingFooter, isFalse);

    await tester.tap(find.byKey(RebicPagePage.floatingKey));
    await tester.pumpAndSettle();
    expect(page().floatingFooter, isTrue);

    final list = find.byKey(
      RebicPagePage.designKey(RebicPageBackgroundDesign.list),
    );
    await tester.ensureVisible(list);
    await tester.tap(list);
    await tester.pumpAndSettle();
    expect(page().backgroundDesign, RebicPageBackgroundDesign.list);

    await tester.tap(find.byIcon(RebicIcons.navBack));
    await tester.pumpAndSettle();
    expect(find.byType(RebicPage), findsNothing);
    expect(find.text(RebicPagePage.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
