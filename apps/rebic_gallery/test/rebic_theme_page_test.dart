import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_theme_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

Color _previewColor(WidgetTester tester) {
  final box = tester.widget<Container>(find.byKey(RebicThemePage.previewKey));
  return (box.decoration! as BoxDecoration).color!;
}

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(RebicThemePage.title));
    await tester.pumpAndSettle();
    expect(_previewColor(tester), RebicThemeData.light().colors.base);

    await tester.tap(find.text('Tema: claro'));
    await tester.pumpAndSettle();
    expect(_previewColor(tester), RebicThemeData.dark().colors.base);

    final compact = RebicThemeData.light(density: RebicDensity.compact);
    final comfortable = RebicThemeData.light();
    expect(
      tester.getSize(find.byKey(RebicThemePage.compactKey)).height,
      greaterThanOrEqualTo(compact.density.minTargetSize),
    );
    expect(
      tester.getSize(find.byKey(RebicThemePage.comfortableKey)).height,
      greaterThanOrEqualTo(comfortable.density.minTargetSize),
    );
    expect(
      find.text('Alvo mínimo: ${compact.density.minTargetSize.round()}'),
      findsOneWidget,
    );
    expect(
      find.text('Alvo mínimo: ${comfortable.density.minTargetSize.round()}'),
      findsOneWidget,
    );
  });
}
