import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_tooltip_page.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicTooltip na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.scrollUntilVisible(find.text(RebicTooltipPage.title), 200);
      await tester.tap(find.text(RebicTooltipPage.title));
      await tester.pumpAndSettle();

      final (_, message) = RebicTooltipPage.examples.first;
      expect(find.text(message), findsNothing);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(
        tester.getCenter(find.byKey(RebicTooltipPage.firstIconKey)),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(message), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
