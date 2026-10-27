import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/rebic_divider_page.dart';
import 'package:rebic_ui/rebic_ui.dart';

void main() {
  testWidgets(
    '[Documentação] Exemplos mínimos — Página RebicDivider na galeria',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 1600);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const RebicGalleryApp());

      await tester.tap(find.text(RebicDividerPage.title));
      await tester.pumpAndSettle();

      final dividers = tester
          .widgetList<RebicDivider>(find.byType(RebicDivider))
          .toList();
      final tones = dividers.map((d) => d.tone).toSet();
      expect(tones, RebicDividerTone.values.toSet());
      expect(dividers.any((d) => d.spacing != RebicSpace.none), isTrue);
      expect(dividers.any((d) => d.indent != null), isTrue);
      // Horizontais e verticais: os verticais ficam na barra de ações.
      final sizes = [
        for (final e in find.byType(RebicDivider).evaluate())
          tester.getSize(find.byWidget(e.widget)),
      ];
      expect(sizes.any((s) => s.width > s.height), isTrue);
      expect(sizes.any((s) => s.height > s.width), isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
