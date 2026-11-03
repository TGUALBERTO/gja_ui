import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_message_toast_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicMessageToast na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicMessageToastPage.title);
      await tester.tap(find.text('Salvar'));
      await tester.pump();
      expect(find.text(RebicMessageToastPage.saved), findsOneWidget);
      await tester.pump(RebicMessageToast.defaultDuration);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
