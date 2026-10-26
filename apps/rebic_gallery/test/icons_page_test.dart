import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/icons_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

import 'support/lucide_font.dart';

void main() {
  testWidgets('Testes e documentação dos ícones — Página na galeria', (
    tester,
  ) async {
    await tester.runAsync(loadLucideFont);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(IconsPage.title));
    await tester.pumpAndSettle();

    for (final MapEntry(key: name, value: icon) in RebicIcons.all.entries) {
      final cell = find.ancestor(
        of: find.text(name),
        matching: find.byType(Column),
      );
      expect(
        find.descendant(of: cell.first, matching: find.byIcon(icon)),
        findsOneWidget,
        reason: name,
      );
    }
    expect(find.byType(Icon), findsNWidgets(RebicIcons.all.length));
  });
}
