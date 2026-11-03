import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_dialog_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicDialog na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicDialogPage.title);
      await tester.tap(find.text(RebicDialogPage.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();
      expect(find.text(RebicDialogPage.deleted), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
