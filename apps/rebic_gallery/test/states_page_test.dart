import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_gallery/main.dart';
import 'package:rebic_gallery/pages/states_page.dart';
import 'package:gja_ui/gja_ui.dart';

void main() {
  testWidgets('Testes e documentação dos estados — Página na galeria', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const RebicGalleryApp());

    await tester.tap(find.text(StatesPage.title));
    await tester.pumpAndSettle();

    const interaction = RebicInteractionStateTokens.fallback();
    for (final (mode, colors) in [
      ('claro', RebicColorTokens.light()),
      ('escuro', RebicColorTokens.dark()),
    ]) {
      for (final family in RebicControlFamily.values) {
        final expected = RebicControlColors.of(family, colors);
        for (final (label, states) in StatesPage.samples) {
          final reason = '$mode/${family.name}/$label';
          final ring = tester.widget<Container>(
            find.byKey(StatesPage.ringKey(mode, family, label)),
          );
          expect(ring.decoration != null, label == 'foco', reason: reason);
          final control = tester.widget<Container>(
            find.byKey(StatesPage.controlKey(mode, family, label)),
          );
          final box = control.decoration! as BoxDecoration;
          expect(
            box.color,
            expected.resolve(states).background,
            reason: reason,
          );
          final opacity = tester.widget<Opacity>(
            find.ancestor(
              of: find.byKey(StatesPage.controlKey(mode, family, label)),
              matching: find.byType(Opacity),
            ),
          );
          expect(opacity.opacity, interaction.opacity(states), reason: reason);
        }
      }
    }
    expect(RebicControlFamily.values.map((f) => f.name), [
      'standard',
      'emphasized',
      'transparent',
      'accept',
      'reject',
      'attention',
      'list',
    ]);
    for (final family in RebicControlFamily.values) {
      expect(find.text(family.name), findsNWidgets(2), reason: family.name);
    }
    for (final (label, _) in StatesPage.samples) {
      expect(
        find.text(label),
        findsNWidgets(2 * RebicControlFamily.values.length),
        reason: label,
      );
    }
  });
}
