import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_scaffold_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicScaffold na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(500, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.scrollUntilVisible(find.text(RebicScaffoldPage.title), 200);
      await tester.tap(find.text(RebicScaffoldPage.title));
      await tester.pumpAndSettle();
      expect(find.byKey(RebicScaffoldPage.navigationKey), findsNothing);
      expect(find.text(RebicScaffoldPage.bodyText), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(RebicScaffold),
          matching: find.byType(RebicInteractable),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(RebicScaffoldPage.navigationKey)).width,
        500,
      );
      expect(find.text(RebicScaffoldPage.bodyText), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
