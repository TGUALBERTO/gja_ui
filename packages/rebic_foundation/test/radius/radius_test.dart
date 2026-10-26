import 'dart:ui' show RRect, Radius, Rect;

import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

import '../support/token_set_contract.dart';

const _fallback = RebicRadiusTokens.fallback();

List<double> _steps(RebicRadiusTokens t) => [
  t.none,
  t.xs,
  t.s,
  t.m,
  t.l,
  t.xl,
  t.full,
];

void main() {
  test('Escala primitiva de raios — Escala em ordem', () {
    final entries = RebicRadiusPrimitives.values.entries.toList();
    for (final (i, MapEntry(key: name, value: value)) in entries.indexed) {
      expect(
        double.parse(name.substring('radius'.length)),
        value,
        reason: name,
      );
      if (i > 0) expect(value, greaterThan(entries[i - 1].value), reason: name);
    }
    expect(
      RebicRadiusPrimitives.values.values,
      containsAll(<double>[0, 2, 4, 6, 8, 12, 16]),
    );
  });

  group('Formato de pílula', () {
    test('Formato de pílula — Pílula em um controle', () {
      final rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 120, 32),
        Radius.circular(_fallback.full),
      ).scaleRadii();
      for (final corner in [
        rrect.tlRadius,
        rrect.trRadius,
        rrect.blRadius,
        rrect.brRadius,
      ]) {
        expect(corner.x, closeTo(16, 1e-9));
        expect(corner.y, closeTo(16, 1e-9));
      }
    });

    test('Formato de pílula — Valor finito', () {
      for (final value in [_fallback.full, RebicRadiusPrimitives.radiusFull]) {
        expect(value.isFinite, isTrue);
        expect(value, greaterThanOrEqualTo(2048));
      }
    });
  });

  group('Passos e papéis semânticos de raio', () {
    test('Passos e papéis semânticos de raio — Ordem dos passos', () {
      final steps = _steps(_fallback);
      expect(_fallback.none, 0);
      for (var i = 1; i < steps.length; i++) {
        expect(
          steps[i],
          greaterThanOrEqualTo(steps[i - 1]),
          reason: 'passo $i',
        );
      }
    });

    test('Passos e papéis semânticos de raio — Papéis apontam para passos', () {
      final steps = _steps(_fallback).toSet();
      expect(steps, contains(_fallback.control));
      expect(steps, contains(_fallback.container));
      expect(_fallback.control, lessThanOrEqualTo(_fallback.container));
    });

    test('Passos e papéis semânticos de raio — Valor negativo rejeitado', () {
      expect(
        () => _fallback.copyWith(control: -1),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('"control"'),
          ),
        ),
      );
      expect(
        () => _fallback.copyWith(full: double.infinity),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Contrato do conjunto de raios', () {
    test('Contrato do conjunto de raios — Contrato verificado', () {
      final doubled = _fallback.copyWith(
        xs: _fallback.xs * 2,
        s: _fallback.s * 2,
        m: _fallback.m * 2,
        l: _fallback.l * 2,
        xl: _fallback.xl * 2,
        control: _fallback.control * 2,
        container: _fallback.container * 2,
      );
      expectTokenSetContract(
        a: _fallback,
        // Instância não canônica, para testar a igualdade por valor.
        // ignore: prefer_const_constructors
        aCopy: RebicRadiusTokens.fallback(),
        b: doubled,
      );
    });

    test('Contrato do conjunto de raios — Interpolação de um papel', () {
      final a = _fallback.copyWith(control: 4);
      final b = _fallback.copyWith(control: 8);
      expect(a.lerp(b, 0.5).control, 6);
    });

    test('Contrato do conjunto de raios — Valores vêm dos primitivos', () {
      final primitives = {
        ...RebicRadiusPrimitives.values.values,
        RebicRadiusPrimitives.radiusFull,
      };
      for (final MapEntry(key: name, value: value)
          in _fallback.values.entries) {
        expect(primitives, contains(value), reason: name);
      }
    });

    test('igualdade e copyWith consideram cada campo isoladamente', () {
      final variants = [
        _fallback.copyWith(none: 1),
        _fallback.copyWith(xs: 3),
        _fallback.copyWith(s: 5),
        _fallback.copyWith(m: 9),
        _fallback.copyWith(l: 13),
        _fallback.copyWith(xl: 17),
        _fallback.copyWith(full: 5000),
        _fallback.copyWith(control: 5),
        _fallback.copyWith(container: 9),
      ];
      for (final (i, variant) in variants.indexed) {
        expect(variant, isNot(_fallback), reason: 'campo $i');
        expect(variant.lerp(_fallback, 1), _fallback, reason: 'campo $i');
      }
    });

    test('diagnóstico lista cada passo e papel', () {
      final dump = _fallback.toDiagnosticsNode().toStringDeep();
      for (final name in _fallback.values.keys) {
        expect(dump, contains('$name:'), reason: name);
      }
    });
  });
}
