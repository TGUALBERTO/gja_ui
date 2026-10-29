import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

double _max(
  List<RebicShadowLayer> level,
  double Function(RebicShadowLayer) f,
) => level.map(f).fold(0, (a, b) => a > b ? a : b);

void main() {
  group('Escala primitiva de sombras', () {
    test('Escala primitiva de sombras — Profundidade crescente', () {
      const levels = [
        RebicShadowPrimitives.shadow0,
        RebicShadowPrimitives.shadow1,
        RebicShadowPrimitives.shadow2,
        RebicShadowPrimitives.shadow3,
      ];
      expect(RebicShadowPrimitives.none, isEmpty);
      for (var i = 1; i < levels.length; i++) {
        expect(
          _max(levels[i], (l) => l.blurRadius),
          greaterThan(_max(levels[i - 1], (l) => l.blurRadius)),
          reason: 'desfoque de shadow$i',
        );
        expect(
          _max(levels[i], (l) => l.offsetY),
          greaterThanOrEqualTo(_max(levels[i - 1], (l) => l.offsetY)),
          reason: 'deslocamento de shadow$i',
        );
      }
    });

    test('Escala primitiva de sombras — Fatores de opacidade válidos', () {
      for (final MapEntry(key: name, value: level)
          in RebicShadowPrimitives.values.entries) {
        for (final layer in level) {
          expect(layer.isValid, isTrue, reason: name);
          expect(layer.opacity, inInclusiveRange(0, 1), reason: name);
        }
      }
      expect(RebicShadowPrimitives.header, isNotEmpty);
      expect(RebicShadowPrimitives.header.every((l) => l.offsetY > 0), isTrue);
    });
  });

  group('Geometria no modelo Horizon', () {
    bool isOutline(RebicShadowLayer l) =>
        l.offsetY == 0 && l.blurRadius == 0 && l.spreadRadius == 1;

    test(
      'Geometria no modelo Horizon — Contorno nas sombras de sobreposição',
      () {
        for (final (name, shadow) in [
          ('shadow1', RebicShadowPrimitives.shadow1),
          ('shadow2', RebicShadowPrimitives.shadow2),
          ('shadow3', RebicShadowPrimitives.shadow3),
        ]) {
          expect(shadow.where(isOutline), hasLength(1), reason: name);
          expect(shadow.any((l) => l.blurRadius > 0), isTrue, reason: name);
        }
      },
    );

    test('Geometria no modelo Horizon — Cartão sem contorno', () {
      expect(
        RebicShadowPrimitives.shadow0.every((l) => l.spreadRadius == 0),
        isTrue,
      );
    });
  });

  test('RebicShadowLayer.lerp e lerpList', () {
    const a = RebicShadowLayer(offsetY: 2, blurRadius: 4);
    const b = RebicShadowLayer(
      offsetY: 6,
      blurRadius: 8,
      spreadRadius: 2,
      opacity: 0.5,
    );
    expect(RebicShadowLayer.lerp(a, b, 0), a);
    expect(RebicShadowLayer.lerp(a, b, 1), b);
    expect(
      RebicShadowLayer.lerp(a, b, 0.5),
      const RebicShadowLayer(
        offsetY: 4,
        blurRadius: 6,
        spreadRadius: 1,
        opacity: 0.75,
      ),
    );
    final padded = RebicShadowLayer.lerpList(const [a], const [a, b], 1);
    expect(padded, [a, b]);
    expect(RebicShadowLayer.lerpList(const [a, b], const [], 1), isEmpty);
    expect(RebicShadowLayer.lerpList(const [a, b], const [], 0.5), [
      RebicShadowLayer.lerp(a, RebicShadowLayer.zero, 0.5),
      RebicShadowLayer.lerp(b, RebicShadowLayer.zero, 0.5),
    ]);
  });
}
