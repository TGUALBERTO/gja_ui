import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_text_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicText na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 2000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(RebicTextPage.title));
    await tester.pumpAndSettle();

    for (final variant in RebicTextVariant.values) {
      expect(find.text(variant.name), findsOneWidget, reason: variant.name);
    }
    for (final tone in RebicTextTone.values) {
      expect(find.text('tom ${tone.name}'), findsOneWidget, reason: tone.name);
    }
    final truncated = tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.byKey(RebicTextPage.truncatedKey),
        matching: find.byType(RichText),
      ),
    );
    expect(truncated.maxLines, 2);
    expect(truncated.didExceedMaxLines, isTrue);
  });
}
