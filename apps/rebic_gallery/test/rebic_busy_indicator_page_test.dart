import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_busy_indicator_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicBusyIndicator na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      // Os pontos animam sem parar: avança a transição em vez de assentar.
      await openGalleryPage(
        tester,
        RebicBusyIndicatorPage.title,
        settle: false,
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      RebicBusyIndicator card() => tester.widget<RebicBusyIndicator>(
        find.byKey(RebicBusyIndicatorPage.cardKey),
      );
      expect(card().busy, isFalse);
      await tester.tap(find.text('Atualizar'));
      await tester.pump();
      expect(card().busy, isTrue);
      await tester.tap(find.text('Concluir'));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
