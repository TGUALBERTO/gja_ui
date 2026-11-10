import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_card_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

Future<void> _open(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1200, 1200);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const RebicGalleryApp());
  await openGalleryPage(tester, RebicCardPage.title);
}

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicCard na galeria', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text(RebicCardPage.opened), findsNothing);

    await tester.tap(find.text(RebicCardPage.pendingTitle));
    await tester.pumpAndSettle();
    expect(find.text(RebicCardPage.opened), findsOneWidget);
    expect(
      tester
          .widget<RebicCard>(find.byKey(RebicCardPage.bottomCardKey))
          .headerPosition,
      RebicCardHeaderPosition.bottom,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    '[Documentação] Exemplos mínimos — Cabeçalhos na página RebicCard',
    (tester) async {
      await _open(tester);
      final full = tester.widget<RebicCardHeader>(
        find.byKey(RebicCardPage.fullHeaderKey),
      );
      expect(full.iconInitials, isNotNull);
      expect(full.statusText, isNotNull);
      expect(full.dataTimestamp, isNotNull);
      final actionable = tester.widget<RebicCardHeader>(
        find.ancestor(
          of: find.text(RebicCardPage.pendingTitle),
          matching: find.byType(RebicCardHeader),
        ),
      );
      expect(actionable.onPress, isNotNull);
      expect(
        tester
            .widget<RebicCardHeader>(find.byKey(RebicCardPage.toolbarHeaderKey))
            .toolbar,
        isNotNull,
      );
    },
  );
}
