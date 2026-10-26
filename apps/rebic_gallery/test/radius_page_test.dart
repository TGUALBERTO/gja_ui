import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/radius_page.dart';

void main() {
  testWidgets('Testes e documentação dos raios — Página na galeria', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(RadiusPage.title));
    await tester.pumpAndSettle();

    const expected = {
      'none': '0 px',
      'xs': '2 px',
      's': '4 px',
      'm': '8 px',
      'l': '12 px',
      'xl': '16 px',
      'full': 'pílula',
      'control': '4 px',
      'container': '8 px',
    };
    for (final MapEntry(key: name, value: value) in expected.entries) {
      final sample = find.ancestor(
        of: find.text(name),
        matching: find.byType(Column),
      );
      expect(
        find.descendant(of: sample.first, matching: find.text(value)),
        findsOneWidget,
        reason: name,
      );
    }
  });
}
