import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_separator_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/navigation.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicSeparator na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 1200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());
      await openGalleryPage(tester, RebicSeparatorPage.title);

      Iterable<Size> strokes(Key key) => [
        for (final e
            in find
                .descendant(
                  of: find.descendant(
                    of: find.byKey(key),
                    matching: find.byType(RebicSeparator),
                  ),
                  matching: find.byType(ColoredBox),
                )
                .evaluate())
          (e.renderObject! as RenderBox).size,
      ];

      final horizontal = strokes(RebicSeparatorPage.listKey);
      expect(horizontal, hasLength(2));
      expect(horizontal.every((s) => s.width > s.height), isTrue);
      final vertical = strokes(RebicSeparatorPage.barKey);
      expect(vertical, hasLength(1));
      expect(vertical.single.height, greaterThan(vertical.single.width));
      expect(tester.takeException(), isNull);
    },
  );
}
