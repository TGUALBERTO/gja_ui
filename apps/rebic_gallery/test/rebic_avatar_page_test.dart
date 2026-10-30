import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_avatar_page.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicAvatar na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicAvatarPage.title);
      expect(find.text(RebicAvatarPage.opened), findsNothing);

      await tester.tap(find.bySemanticsLabel(RebicAvatarPage.person));
      await tester.pumpAndSettle();
      expect(find.text(RebicAvatarPage.opened), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
