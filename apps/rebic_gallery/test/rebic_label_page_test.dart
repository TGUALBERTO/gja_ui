import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_label_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

RebicLabel _label(WidgetTester tester, Key key) =>
    tester.widget<RebicLabel>(find.byKey(key));

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicLabel na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 2000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.tap(find.text(RebicLabelPage.title));
      await tester.pumpAndSettle();

      expect(
        _label(tester, RebicLabelPage.standardKey).design,
        RebicLabelDesign.standard,
      );
      expect(
        _label(tester, RebicLabelPage.boldKey).design,
        RebicLabelDesign.bold,
      );
      expect(_label(tester, RebicLabelPage.colonKey).showColon, isTrue);
      expect(_label(tester, RebicLabelPage.requiredKey).required, isTrue);
      final truncated = tester.renderObject<RenderParagraph>(
        find
            .descendant(
              of: find.byKey(RebicLabelPage.truncatedKey),
              matching: find.byType(RichText),
            )
            .first,
      );
      expect(truncated.didExceedMaxLines, isTrue);
    },
  );
}
