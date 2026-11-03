import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_illustrated_message_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicIllustratedMessage na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicIllustratedMessagePage.title);
      expect(find.text(RebicIllustratedMessagePage.list), findsNothing);
      await tester.tap(find.text(RebicIllustratedMessagePage.clear));
      await tester.pumpAndSettle();
      expect(find.text(RebicIllustratedMessagePage.list), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
