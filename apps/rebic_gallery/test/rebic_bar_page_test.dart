import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_bar_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicBar na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 1200);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await openGalleryPage(tester, RebicBarPage.title);

    for (final design in RebicBarPage.designs) {
      expect(
        tester
            .widget<RebicBar>(find.byKey(RebicBarPage.designKey(design)))
            .design,
        design,
      );
    }
    for (final alignment in [
      RebicTitleAlignment.none,
      RebicTitleAlignment.start,
    ]) {
      expect(
        tester
            .widget<RebicBar>(find.byKey(RebicBarPage.alignmentKey(alignment)))
            .titleAlignment,
        alignment,
      );
    }
    expect(tester.takeException(), isNull);
  });
}
