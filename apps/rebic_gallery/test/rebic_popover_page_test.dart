import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_popover_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicPopover na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicPopoverPage.title);
      expect(find.text(RebicPopoverPage.applied), findsNothing);

      await tester.tap(find.text(RebicPopoverPage.filter));
      await tester.pumpAndSettle();
      expect(find.text('Filtros'), findsOneWidget);

      await tester.tap(find.text(RebicPopoverPage.apply));
      await tester.pumpAndSettle();
      expect(find.text('Filtros'), findsNothing);
      expect(find.text(RebicPopoverPage.applied), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
