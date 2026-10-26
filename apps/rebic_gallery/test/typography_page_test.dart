import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/typography_page.dart';

import 'support/inter_font.dart';

void main() {
  testWidgets('Testes e documentação da tipografia — Página na galeria', (
    tester,
  ) async {
    await tester.runAsync(loadInterFont);
    await tester.binding.setSurfaceSize(const Size(1000, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(TypographyPage.title));
    await tester.pumpAndSettle();

    const expected = {
      'display': '40/48 · 600',
      'headline': '32/40 · 600',
      'title': '24/32 · 600',
      'subtitle': '18/24 · 600',
      'body': '14/20 · 400',
      'bodyStrong': '14/20 · 600',
      'label': '14/20 · 500',
      'caption': '12/16 · 400',
    };
    for (final MapEntry(key: name, value: measures) in expected.entries) {
      expect(find.text('$name · $measures'), findsOneWidget, reason: name);
    }
    final samples = tester.widgetList<Text>(find.text(TypographyPage.sample));
    expect(samples, hasLength(8));
    for (final sample in samples) {
      expect(sample.style!.fontFamily, 'packages/rebic_foundation/Inter');
    }
  });
}
