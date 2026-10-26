import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/elevation_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

void main() {
  testWidgets('Testes e documentação da elevação — Página na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 2000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(ElevationPage.title));
    await tester.pumpAndSettle();

    const elevation = RebicElevationTokens.fallback();
    for (final (mode, colors) in [
      ('claro', RebicColorTokens.light()),
      ('escuro', RebicColorTokens.dark()),
    ]) {
      for (final MapEntry(key: name, value: level)
          in elevation.values.entries) {
        final card = tester.widget<Container>(
          find.byKey(ElevationPage.cardKey(mode, name)),
        );
        final decoration = card.decoration! as BoxDecoration;
        expect(
          decoration.boxShadow,
          elevation.shadowsFor(level, colors.shadow),
          reason: '$mode/$name',
        );
      }
      expect(find.text(mode), findsOneWidget);
    }
    expect(find.text('card'), findsNWidgets(2));
    expect(find.text('dialog'), findsNWidgets(2));
  });
}
