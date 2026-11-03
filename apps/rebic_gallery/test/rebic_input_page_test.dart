import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_input_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicInput na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicInputPage.title);
      final name = find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is RebicInput && w.semanticLabel == RebicInputPage.nameLabel,
        ),
        matching: find.byType(EditableText),
      );
      await tester.tap(name);
      await tester.pump();
      await tester.enterText(name, 'Ana');
      await tester.pump();
      expect(find.text('Olá, Ana'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
