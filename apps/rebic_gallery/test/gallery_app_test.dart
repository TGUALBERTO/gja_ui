import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Spec `rebic/widgets/rebic-app`: a galeria usa `RebicApp` como raiz.
void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    Finder background(RebicThemeData theme) => find.byWidgetPredicate(
      (w) => w is ColoredBox && w.color == theme.colors.background,
    );
    expect(find.byType(RebicApp), findsOneWidget);
    expect(background(RebicThemeData.light()), findsOneWidget);

    await tester.tap(find.text('Tema: escuro'));
    await tester.pumpAndSettle();
    expect(background(RebicThemeData.dark()), findsOneWidget);

    await tester.tap(find.text('Densidade: compacta'));
    await tester.pumpAndSettle();
    final context = tester.element(find.text(RebicGalleryApp.title));
    expect(RebicTheme.of(context).density.density, RebicDensity.compact);
  });
}
