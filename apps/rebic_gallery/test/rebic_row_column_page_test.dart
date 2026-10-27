import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_row_column_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

Future<void> _open(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 2200);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const RebicGalleryApp());
  await tester.tap(find.text(RebicRowColumnPage.title));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('[Documentação] Exemplos mínimos — Página RebicRow na galeria', (
    tester,
  ) async {
    await _open(tester);
    for (final alignment in RebicMainAlignment.values) {
      final row = tester.widget<RebicRow>(
        find.byKey(RebicRowColumnPage.rowKey(alignment)),
      );
      expect(row.mainAlignment, alignment);
    }
    expect(find.byKey(RebicRowColumnPage.rowExpandedKey), findsOneWidget);
    // A linha com quebra ocupa mais de uma linha de blocos.
    final wrap = tester.getSize(find.byKey(RebicRowColumnPage.wrapKey));
    final block = tester.getSize(find.byKey(RebicRowColumnPage.rowExpandedKey));
    expect(wrap.height, greaterThan(block.height));
  });

  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicColumn na galeria',
    (tester) async {
      await _open(tester);
      for (final alignment in RebicCrossAlignment.values) {
        final column = tester.widget<RebicColumn>(
          find.byKey(RebicRowColumnPage.columnKey(alignment)),
        );
        expect(column.crossAlignment, alignment);
      }
      expect(find.byKey(RebicRowColumnPage.columnExpandedKey), findsOneWidget);
    },
  );
}
