import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_menu_page.dart';

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicMenu na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1000);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.scrollUntilVisible(find.text(RebicMenuPage.title), 200);
    await tester.tap(find.text(RebicMenuPage.title));
    await tester.pumpAndSettle();

    await tester.tap(find.text(RebicMenuPage.actions));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copiar'));
    await tester.pumpAndSettle();

    expect(find.text('Excluir'), findsNothing);
    expect(find.text(RebicMenuPage.lastAction('Copiar')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
