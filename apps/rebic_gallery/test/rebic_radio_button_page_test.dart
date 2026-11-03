import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_radio_button_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

Future<void> _open(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(800, 1000);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const RebicGalleryApp());
  await openGalleryPage(tester, RebicRadioButtonPage.title);
}

RebicRadioButton _option(WidgetTester tester, String text) => tester
    .widget<RebicRadioButton>(find.widgetWithText(RebicRadioButton, text));

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicRadioButton na galeria',
    (tester) async {
      await _open(tester);
      expect(_option(tester, RebicRadioButtonPage.single).selected, isFalse);
      await tester.tap(find.text(RebicRadioButtonPage.single));
      await tester.pump();
      expect(_option(tester, RebicRadioButtonPage.single).selected, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicRadioButtonGroup na galeria',
    (tester) async {
      await _open(tester);
      expect(_option(tester, 'Boleto').selected, isTrue);
      await tester.tap(find.text('Pix'));
      await tester.pump();
      expect(_option(tester, 'Pix').selected, isTrue);
      expect(_option(tester, 'Boleto').selected, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
