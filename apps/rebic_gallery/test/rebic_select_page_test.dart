import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_select_page.dart';
import 'package:gja_ui/gja_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicSelect na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicSelectPage.title);
      final status = find.byWidgetPredicate(
        (w) =>
            w is RebicSelect<String> &&
            w.semanticLabel == RebicSelectPage.statusLabel,
      );
      await tester.tap(status);
      await tester.pumpAndSettle();
      // O item da lista, cujo elemento interativo tem o nome do item.
      final item = find.byWidgetPredicate(
        (w) => w is RebicInteractable && w.semanticLabel == 'Aprovado',
      );
      await tester.tap(item);
      await tester.pumpAndSettle();
      expect(
        tester.widget<RebicSelect<String>>(status).selectedKey,
        'aprovado',
      );
      expect(
        find.descendant(of: status, matching: find.text('Aprovado')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
