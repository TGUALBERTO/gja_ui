import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_tool_page_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicToolPage na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(500, 900);
      addTearDown(tester.view.reset);
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicToolPagePage.title);
      expect(find.byKey(RebicToolPagePage.navigationKey), findsNothing);
      expect(
        find.semantics.byLabel(
          RegExp(RegExp.escape(RebicToolPagePage.bodyText)),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(RebicIcons.menu2));
      await tester.pumpAndSettle();
      final navigation = tester.getRect(
        find.byKey(RebicToolPagePage.navigationKey),
      );
      expect(navigation.width, 500);
      expect(
        navigation.overlaps(
          tester.getRect(find.byKey(RebicToolPagePage.mainKey)),
        ),
        isTrue,
      );
      expect(
        find.semantics.byLabel(
          RegExp(RegExp.escape(RebicToolPagePage.bodyText)),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
      handle.dispose();
    },
  );
}
