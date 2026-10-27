import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_grid_page.dart';

/// Cartões da primeira grade na mesma linha do primeiro.
int _perRow(WidgetTester tester) {
  final top = tester.getTopLeft(find.byKey(RebicGridPage.cardKey(0))).dy;
  return [
    for (var i = 0; i < 6; i++)
      tester.getTopLeft(find.byKey(RebicGridPage.cardKey(i))).dy,
  ].where((t) => t == top).length;
}

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicGrid na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(RebicGridPage.title));
    await tester.pumpAndSettle();
    expect(_perRow(tester), 3);
    expect(find.byKey(RebicGridPage.highlightKey), findsOneWidget);

    tester.view.physicalSize = const Size(500, 2400);
    await tester.pumpAndSettle();
    expect(_perRow(tester), 1);
    expect(tester.takeException(), isNull);
  });
}
