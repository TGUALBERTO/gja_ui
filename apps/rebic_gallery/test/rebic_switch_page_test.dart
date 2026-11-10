import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_switch_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicSwitch na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicSwitchPage.title);
      final finder = find.byWidgetPredicate(
        (w) =>
            w is RebicSwitch &&
            w.semanticLabel == RebicSwitchPage.notifications,
      );
      expect(tester.widget<RebicSwitch>(finder).state, isFalse);

      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(tester.widget<RebicSwitch>(finder).state, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
