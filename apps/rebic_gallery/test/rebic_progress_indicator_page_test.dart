import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_progress_indicator_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicProgressIndicator na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicProgressIndicatorPage.title);
      final indicators = tester
          .widgetList<RebicProgressIndicator>(
            find.byType(RebicProgressIndicator),
          )
          .toList();
      expect(
        indicators.map((i) => i.state).toSet(),
        RebicValueState.values.toSet(),
      );

      double advancing() => tester
          .widget<RebicProgressIndicator>(
            find.byKey(RebicProgressIndicatorPage.advancingKey),
          )
          .percentValue;
      final before = advancing();
      await tester.tap(find.text('Avançar'));
      await tester.pumpAndSettle();
      expect(advancing(), before + 10);
      expect(tester.takeException(), isNull);
    },
  );
}
