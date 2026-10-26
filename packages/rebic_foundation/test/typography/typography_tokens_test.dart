import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

import '../support/token_set_contract.dart';

const _fallback = RebicTypographyTokens.fallback();

/// Altura de linha em pixels lógicos (tamanho × altura relativa).
double _lineHeightPx(TextStyle s) => s.fontSize! * s.height!;

RebicTypographyTokens _bigger(RebicTypographyTokens t) => RebicTypographyTokens(
  display: t.display.copyWith(fontSize: t.display.fontSize! + 4),
  headline: t.headline.copyWith(fontSize: t.headline.fontSize! + 4),
  title: t.title.copyWith(fontSize: t.title.fontSize! + 4),
  subtitle: t.subtitle.copyWith(fontSize: t.subtitle.fontSize! + 4),
  body: t.body.copyWith(fontSize: t.body.fontSize! + 4),
  bodyStrong: t.bodyStrong.copyWith(fontSize: t.bodyStrong.fontSize! + 4),
  label: t.label.copyWith(fontSize: t.label.fontSize! + 4),
  caption: t.caption.copyWith(fontSize: t.caption.fontSize! + 4),
);

void main() {
  test('Fontes de fallback do sistema — Fallback sem prefixo de pacote', () {
    for (final MapEntry(key: name, value: style) in _fallback.styles.entries) {
      expect(style.fontFamily, 'packages/rebic_foundation/Inter', reason: name);
      expect(style.fontFamilyFallback, isNotEmpty, reason: name);
      for (final family in style.fontFamilyFallback!) {
        expect(
          family,
          isNot(startsWith('packages/')),
          reason: '$name: $family',
        );
      }
    }
  });

  group('Estilos semânticos de texto', () {
    test('Estilos semânticos de texto — Estilo completo e sem cor', () {
      expect(_fallback.styles.keys, [
        'display',
        'headline',
        'title',
        'subtitle',
        'body',
        'bodyStrong',
        'label',
        'caption',
      ]);
      for (final MapEntry(key: name, value: s) in _fallback.styles.entries) {
        expect(s.fontFamily, isNotNull, reason: name);
        expect(s.fontFamilyFallback, isNotNull, reason: name);
        expect(s.fontSize, isNotNull, reason: name);
        expect(s.height, isNotNull, reason: name);
        expect(s.fontWeight, isNotNull, reason: name);
        expect(s.color, isNull, reason: name);
        expect(s.backgroundColor, isNull, reason: name);
        expect(s.foreground, isNull, reason: name);
        expect(s.background, isNull, reason: name);
      }
    });

    test('Estilos semânticos de texto — Hierarquia de tamanhos', () {
      final t = _fallback;
      final ordered = [
        t.display,
        t.headline,
        t.title,
        t.subtitle,
        t.body,
        t.caption,
      ];
      for (var i = 1; i < ordered.length; i++) {
        expect(
          ordered[i].fontSize,
          lessThanOrEqualTo(ordered[i - 1].fontSize!),
        );
      }
      expect(t.bodyStrong.fontSize, t.body.fontSize);
      expect(
        t.bodyStrong.fontWeight!.value,
        greaterThan(t.body.fontWeight!.value),
      );
    });
  });

  group('Ritmo vertical e legibilidade', () {
    test('Ritmo vertical e legibilidade — Altura de linha na grade', () {
      for (final MapEntry(key: name, value: s) in _fallback.styles.entries) {
        final px = _lineHeightPx(s);
        expect(
          (px / 4 - (px / 4).round()).abs(),
          lessThan(1e-9),
          reason: '$name: $px',
        );
        expect(
          px,
          greaterThanOrEqualTo(1.2 * s.fontSize! - 1e-9),
          reason: name,
        );
        expect(
          s.leadingDistribution,
          TextLeadingDistribution.even,
          reason: name,
        );
      }
    });

    test('Ritmo vertical e legibilidade — Tamanho mínimo', () {
      for (final MapEntry(key: name, value: s) in _fallback.styles.entries) {
        expect(s.fontSize, greaterThanOrEqualTo(12), reason: name);
      }
    });
  });

  group('Contrato do conjunto tipográfico', () {
    test('Contrato do conjunto tipográfico — Contrato verificado', () {
      expectTokenSetContract(
        a: _fallback,
        // Instância não canônica, para testar a igualdade por valor.
        // ignore: prefer_const_constructors
        aCopy: RebicTypographyTokens.fallback(),
        b: _bigger(_fallback),
      );
    });

    test('Contrato do conjunto tipográfico — Interpolação de tamanho', () {
      final a = _fallback.copyWith(body: _fallback.body.copyWith(fontSize: 14));
      final b = _fallback.copyWith(body: _fallback.body.copyWith(fontSize: 18));
      expect(a.lerp(b, 0.5).body.fontSize, 16);
    });

    test('Contrato do conjunto tipográfico — Valores vêm dos primitivos', () {
      final sizes = RebicTypographyPrimitives.sizes.values.toSet();
      final lineHeights = RebicTypographyPrimitives.lineHeights.values.toList();
      final weights = RebicTypographyPrimitives.weights.values.toSet();
      for (final MapEntry(key: name, value: s) in _fallback.styles.entries) {
        expect(sizes, contains(s.fontSize), reason: name);
        expect(weights, contains(s.fontWeight), reason: name);
        final px = _lineHeightPx(s);
        expect(
          lineHeights.any((lh) => (lh - px).abs() < 1e-9),
          isTrue,
          reason: '$name: $px',
        );
      }
    });

    test('igualdade e copyWith consideram cada estilo isoladamente', () {
      const other = TextStyle(fontSize: 99);
      final variants = [
        _fallback.copyWith(display: other),
        _fallback.copyWith(headline: other),
        _fallback.copyWith(title: other),
        _fallback.copyWith(subtitle: other),
        _fallback.copyWith(body: other),
        _fallback.copyWith(bodyStrong: other),
        _fallback.copyWith(label: other),
        _fallback.copyWith(caption: other),
      ];
      for (final (i, variant) in variants.indexed) {
        expect(variant, isNot(_fallback), reason: 'estilo $i');
      }
    });

    test('diagnóstico lista cada estilo', () {
      final dump = _fallback.toDiagnosticsNode().toStringDeep();
      for (final name in _fallback.styles.keys) {
        expect(dump, contains('$name:'), reason: name);
      }
    });
  });
}
