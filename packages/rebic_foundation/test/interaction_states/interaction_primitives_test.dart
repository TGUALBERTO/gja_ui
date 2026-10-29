import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

void main() {
  test('Estados de interação — Conjunto de estados', () {
    expect(RebicInteractionState.values.map((s) => s.name), [
      'hovered',
      'focused',
      'pressed',
      'selected',
      'disabled',
    ]);
    expect(<RebicInteractionState>{}, isEmpty);
  });

  test('Estados de interação — Sem estado de arraste', () {
    expect(
      RebicInteractionState.values.map((s) => s.name),
      isNot(contains('dragged')),
    );
  });

  test('escalas primitivas de interação em ordem e nomeadas pelo valor', () {
    final opacities = RebicInteractionPrimitives.opacities.entries.toList();
    for (final (i, MapEntry(key: name, value: value)) in opacities.indexed) {
      final percent = int.parse(name.substring('opacity'.length));
      expect(value, closeTo(percent / 100, 1e-12), reason: name);
      expect(value, inInclusiveRange(0, 1), reason: name);
      if (i > 0) {
        expect(value, greaterThan(opacities[i - 1].value), reason: name);
      }
    }
    final strokes = RebicInteractionPrimitives.strokes.entries.toList();
    for (final (i, MapEntry(key: name, value: value)) in strokes.indexed) {
      expect(
        double.parse(name.substring('stroke'.length)),
        value,
        reason: name,
      );
      if (i > 0) expect(value, greaterThan(strokes[i - 1].value), reason: name);
    }
  });
}
