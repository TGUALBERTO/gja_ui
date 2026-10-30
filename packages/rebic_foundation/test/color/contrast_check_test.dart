import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

const _light = RebicColorTokens.light();
const _dark = RebicColorTokens.dark();

void main() {
  group('Contraste mínimo dos papéis', () {
    test('Contraste mínimo dos papéis — Pares de texto', () {
      for (final tokens in [_light, _dark]) {
        final issues = rebicCheckContrast(
          tokens,
        ).where((i) => i.minimum == rebicTextContrastMinimum);
        expect(issues, isEmpty);
      }
      // Confere diretamente alguns pares, independentemente da lista.
      expect(
        rebicContrastRatio(_light.text, _light.selectionHoverBackground),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        rebicContrastRatio(_dark.required, _dark.headerBackground),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        rebicContrastRatio(_dark.contrastText, _dark.highlight),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        rebicContrastRatio(_dark.brand, _dark.selectionBackground),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        rebicContrastRatio(
          _light.warning.foreground,
          _light.warning.background,
        ),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        rebicContrastRatio(_dark.error.foreground, _dark.error.hoverBackground),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('Contraste mínimo dos papéis — Pares não textuais', () {
      for (final tokens in [_light, _dark]) {
        final issues = rebicCheckContrast(
          tokens,
        ).where((i) => i.minimum == rebicNonTextContrastMinimum);
        expect(issues, isEmpty);
      }
      expect(
        rebicContrastRatio(_dark.focus, _dark.headerBackground),
        greaterThanOrEqualTo(3),
      );
    });

    test(
      'Contraste mínimo dos papéis — Personalização que viola o contraste',
      () {
        // Cinza escolhido para ter ≈ 2:1 sobre branco.
        final custom = _light.copyWith(
          base: const Color(0xFFFFFFFF),
          text: const Color(0xFFAAAAAA),
        );
        final issue = rebicCheckContrast(
          custom,
        ).singleWhere((i) => i.foreground == 'text' && i.background == 'base');
        expect(issue.ratio, closeTo(2.32, 0.05));
        expect(issue.minimum, rebicTextContrastMinimum);
      },
    );

    test('Contraste mínimo dos papéis — Papéis isentos', () {
      final custom = _light.copyWith(separator: _light.base);
      expect(rebicCheckContrast(custom), isEmpty);
    });
  });
}
