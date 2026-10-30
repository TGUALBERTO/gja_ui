import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_shell_bar_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicShellBar na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 1000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await openGalleryPage(tester, RebicShellBarPage.title);

      for (final key in [
        RebicShellBarPage.fullKey,
        RebicShellBarPage.titleOnlyKey,
        RebicShellBarPage.narrowKey,
      ]) {
        expect(find.byKey(key), findsOneWidget);
      }
      final narrowSecond = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byKey(RebicShellBarPage.narrowKey),
          matching: find.text('Pedidos de compra em aberto no período'),
        ),
      );
      expect(narrowSecond.didExceedMaxLines, isTrue);

      await tester.tap(
        find.descendant(
          of: find.byKey(RebicShellBarPage.fullKey),
          matching: find.byIcon(RebicIcons.menu2),
        ),
      );
      await tester.pump();
      expect(find.text(RebicShellBarPage.menuMessage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
