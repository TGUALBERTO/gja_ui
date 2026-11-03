import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_panel_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicPanel na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicPanelPage.title);
      expect(find.text('Boleto em 30 dias').hitTestable(), findsNothing);
      await tester.tap(find.text('Pagamento'));
      await tester.pumpAndSettle();
      expect(find.text('Boleto em 30 dias').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
