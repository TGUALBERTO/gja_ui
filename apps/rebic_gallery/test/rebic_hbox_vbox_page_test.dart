import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_hbox_vbox_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

Future<void> _open(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 2200);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const RebicGalleryApp());
  await tester.tap(find.text(RebicHBoxVBoxPage.title));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicHBox na galeria', (
    tester,
  ) async {
    await _open(tester);
    for (final alignment in RebicFlexJustifyContent.values) {
      final row = tester.widget<RebicHBox>(
        find.byKey(RebicHBoxVBoxPage.rowKey(alignment)),
      );
      expect(row.justifyContent, alignment);
    }
    expect(
      tester
          .widget<RebicHBox>(find.byKey(RebicHBoxVBoxPage.baselineKey))
          .alignItems,
      RebicFlexAlignItems.baseline,
    );
    expect(find.byKey(RebicHBoxVBoxPage.rowExpandedKey), findsOneWidget);
    // A linha com quebra ocupa mais de uma linha de blocos.
    final wrap = tester.getSize(find.byKey(RebicHBoxVBoxPage.wrapKey));
    final block = tester.getSize(find.byKey(RebicHBoxVBoxPage.rowExpandedKey));
    expect(wrap.height, greaterThan(block.height));
  });

  testWidgets('[Documentação] Exemplos mínimos — Página RebicVBox na galeria', (
    tester,
  ) async {
    await _open(tester);
    for (final alignment in RebicFlexAlignItems.values) {
      if (alignment == RebicFlexAlignItems.baseline) continue;
      final column = tester.widget<RebicVBox>(
        find.byKey(RebicHBoxVBoxPage.columnKey(alignment)),
      );
      expect(column.alignItems, alignment);
    }
    expect(find.byKey(RebicHBoxVBoxPage.columnExpandedKey), findsOneWidget);
  });
}
