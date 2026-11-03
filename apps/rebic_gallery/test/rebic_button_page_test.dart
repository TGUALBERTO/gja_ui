import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_button_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicButton na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 900);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicButtonPage.title);

      final types = tester
          .widgetList<RebicButton>(find.byType(RebicButton))
          .map((b) => b.type)
          .toSet();
      expect(types, RebicButtonType.values.toSet());
      RebicButton send() =>
          tester.widget<RebicButton>(find.byKey(RebicButtonPage.sendKey));
      expect(send().busy, isFalse);

      await tester.tap(find.byKey(RebicButtonPage.sendKey));
      await tester.pump();
      expect(send().busy, isTrue);

      // Sai do estado ocupado para parar a animação do indicador.
      await tester.tap(find.text('Concluir envio'));
      await tester.pumpAndSettle();
      expect(send().busy, isFalse);

      // O primeiro botão da barra de ícones recebe o foco por Tab e mostra a
      // dica.
      final (_, tooltip) = RebicButtonPage.actions.first;
      expect(find.text(tooltip), findsNothing);
      String? focusedTooltip() => FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<RebicButton>()
          ?.tooltip;
      for (var i = 0; i < 20 && focusedTooltip() != tooltip; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }
      expect(focusedTooltip(), tooltip);
      expect(find.text(tooltip), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
