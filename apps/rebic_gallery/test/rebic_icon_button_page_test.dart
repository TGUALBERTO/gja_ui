import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_icon_button_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicIconButton na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicIconButtonPage.title);

      final (_, tooltip) = RebicIconButtonPage.actions.first;
      expect(find.text(tooltip), findsNothing);
      // Tab: botão de voltar da página, depois o primeiro da barra.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final focused = FocusManager.instance.primaryFocus!.context!
          .findAncestorWidgetOfExactType<RebicIconButton>();
      expect(focused?.tooltip, tooltip);
      expect(find.text(tooltip), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
