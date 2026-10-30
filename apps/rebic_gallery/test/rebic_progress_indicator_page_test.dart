import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_progress_indicator_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicProgressIndicator na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(
        tester,
        RebicProgressIndicatorPage.title,
        settle: false,
      );
      // Indicadores indeterminados nunca assentam: avança só a transição.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final indicators = tester
          .widgetList<RebicProgressIndicator>(
            find.byType(RebicProgressIndicator),
          )
          .toList();
      final determinate = indicators.where((i) => i.value != null);
      expect(
        determinate.map((i) => i.state).toSet(),
        RebicValueState.values.toSet(),
      );
      expect(determinate, hasLength(RebicValueState.values.length));
      expect(
        indicators.where((i) => i.value == null).map((i) => i.size).toList(),
        [RebicIconSize.control, ...RebicProgressIndicatorPage.circleSizes],
      );
      expect(tester.takeException(), isNull);
    },
  );
}
