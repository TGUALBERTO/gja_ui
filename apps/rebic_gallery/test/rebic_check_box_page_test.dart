import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_check_box_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicCheckBox na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicCheckBoxPage.title);
      RebicCheckBox terms() => tester.widget<RebicCheckBox>(
        find.widgetWithText(RebicCheckBox, RebicCheckBoxPage.terms),
      );
      expect(terms().selected, isFalse);

      await tester.tap(find.text(RebicCheckBoxPage.terms));
      await tester.pump();
      expect(terms().selected, isTrue);
      expect(
        tester
            .widget<RebicCheckBox>(
              find.widgetWithText(RebicCheckBox, 'Todos os canais'),
            )
            .partiallySelected,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
