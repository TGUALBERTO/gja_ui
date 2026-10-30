import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_dropdown_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicDropdown na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicDropdownPage.title);

      await tester.tap(find.text(RebicDropdownPage.status('Em aberto')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aprovado'));
      await tester.pumpAndSettle();

      expect(find.text('Rejeitado'), findsNothing);
      expect(find.text(RebicDropdownPage.status('Aprovado')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
