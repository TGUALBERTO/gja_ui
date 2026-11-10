import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_title_page.dart';
import 'package:gja_ui/gja_ui.dart';

RenderParagraph _paragraph(WidgetTester tester, Key key) =>
    tester.renderObject<RenderParagraph>(
      find.descendant(of: find.byKey(key), matching: find.byType(RichText)),
    );

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicTitle na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 2000);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.tap(find.text(RebicTitlePage.title));
      await tester.pumpAndSettle();

      for (final style in RebicTitleLevel.values) {
        final label = RebicTitlePage.styleLabel(style);
        expect(
          tester
              .widget<RebicTitle>(find.widgetWithText(RebicTitle, label))
              .titleStyle,
          style,
          reason: label,
        );
      }
      final level = tester.widget<RebicTitle>(
        find.byKey(RebicTitlePage.levelKey),
      );
      expect(level.level, RebicTitleLevel.h1);
      expect(level.titleStyle, RebicTitleLevel.h5);
      expect(
        _paragraph(tester, RebicTitlePage.truncatedKey).didExceedMaxLines,
        isTrue,
      );
      final wrapping = _paragraph(tester, RebicTitlePage.wrappingKey);
      expect(wrapping.didExceedMaxLines, isFalse);
      expect(
        wrapping.size.height,
        greaterThan(
          _paragraph(tester, RebicTitlePage.truncatedKey).size.height,
        ),
      );
    },
  );
}
