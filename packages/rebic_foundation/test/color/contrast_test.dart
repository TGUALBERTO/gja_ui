import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

const _black = Color(0xFF000000);
const _white = Color(0xFFFFFFFF);

void main() {
  group('Cálculo de contraste', () {
    test('Cálculo de contraste — Extremos', () {
      expect(rebicContrastRatio(_black, _white), closeTo(21, 1e-9));
      expect(rebicContrastRatio(_white, _white), 1);
    });

    test('Cálculo de contraste — Simetria', () {
      const gray = Color(0xFF767676);
      expect(
        rebicContrastRatio(gray, _white),
        rebicContrastRatio(_white, gray),
      );
    });

    test('Cálculo de contraste — Cor translúcida', () {
      const translucent = Color(0x80000000);
      expect(
        () => rebicContrastRatio(translucent, _white),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('cor de fundo'),
          ),
        ),
      );
      expect(rebicContrastRatioOver(translucent, _white), greaterThan(1));
      expect(rebicContrastRatioOver(_black, _white), closeTo(21, 1e-9));
    });

    test('valor de referência: #767676 sobre branco ≈ 4,54', () {
      expect(
        rebicContrastRatio(const Color(0xFF767676), _white),
        closeTo(4.54, 0.01),
      );
    });
  });

  test('RebicValueState tem exatamente os cinco estados', () {
    expect(RebicValueState.values.map((s) => s.name), [
      'none',
      'success',
      'warning',
      'error',
      'information',
    ]);
  });
}
