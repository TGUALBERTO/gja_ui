import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

import '../support/token_set_contract.dart';

const _cozy = RebicDensityTokens.cozy();
const _compact = RebicDensityTokens.compact();

void main() {
  test('Modos de densidade — Mapeamento por modo', () {
    expect(RebicDensity.values, [RebicDensity.cozy, RebicDensity.compact]);
    for (final mode in RebicDensity.values) {
      expect(RebicDensityTokens.of(mode).density, mode);
    }
    expect(_cozy, isNot(_compact));
  });

  test('Modos de densidade — Nomes do Fiori', () {
    expect(RebicDensity.values.map((d) => d.name), ['cozy', 'compact']);
  });

  group('Dimensões de controle por densidade', () {
    test('Dimensões de controle por densidade — Valores de referência', () {
      expect(_cozy.controlHeight, 36);
      expect(_cozy.listItemHeight, 44);
      expect(_cozy.minTargetSize, 44);
      expect(_compact.controlHeight, 26);
      expect(_compact.listItemHeight, 32);
      expect(_compact.minTargetSize, 32);
      expect(_cozy.barHeight, 48);
      expect(_compact.barHeight, 32);
      expect(_cozy.separatorHeight, 32);
      expect(_compact.separatorHeight, 24);
      final primitives = RebicDensityPrimitives.sizes.values.toSet();
      for (final tokens in [_cozy, _compact]) {
        for (final MapEntry(key: name, value: value)
            in tokens.dimensions.entries) {
          expect(primitives, contains(value), reason: name);
        }
      }
    });

    test(
      'Dimensões de controle por densidade — Compacto não maior que confortável',
      () {
        for (final MapEntry(key: name, value: value)
            in _compact.dimensions.entries) {
          expect(
            value,
            lessThanOrEqualTo(_cozy.dimensions[name]!),
            reason: name,
          );
        }
      },
    );
  });

  test(
    'Dimensões de controle por densidade — Escala primitiva de densidade',
    () {
      final sizes = RebicDensityPrimitives.sizes;
      expect(sizes.values, [24, 26, 32, 36, 44, 48]);
      for (final MapEntry(key: name, value: value) in sizes.entries) {
        expect(name, 'size${value.round()}');
      }
    },
  );

  group('Alvo mínimo de interação', () {
    test('Alvo mínimo de interação — Alvos dos mapeamentos de referência', () {
      expect(_cozy.minTargetSize, greaterThanOrEqualTo(44));
      expect(_compact.minTargetSize, greaterThanOrEqualTo(24));
    });

    test('Alvo mínimo de interação — Alvo abaixo do mínimo rejeitado', () {
      expect(
        () => _compact.copyWith(minTargetSize: 20),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('24'),
          ),
        ),
      );
      expect(
        () => _compact.copyWith(controlHeight: 0),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('"controlHeight"'),
          ),
        ),
      );
    });
  });

  group('Espaçamento por densidade', () {
    test('Espaçamento por densidade — Espaçamento confortável', () {
      expect(_cozy.spacing, const RebicSpacingTokens.fallback());
    });

    test('Espaçamento por densidade — Espaçamento compacto', () {
      expect(_compact.spacing, const RebicSpacingTokens.fallback());
      expect(_compact.spacing, _cozy.spacing);
      expect(
        _compact.copyWith(
          controlHeight: _cozy.controlHeight,
          listItemHeight: _cozy.listItemHeight,
          minTargetSize: _cozy.minTargetSize,
          barHeight: _cozy.barHeight,
          separatorHeight: _cozy.separatorHeight,
          density: RebicDensity.cozy,
        ),
        _cozy,
      );
    });
  });

  group('Tipografia preservada', () {
    test('Tipografia preservada — Rótulo cabe no controle', () {
      final base = const RebicTypographyTokens.fallback().base;
      final baseLine = base.fontSize! * base.height!;
      for (final tokens in [_cozy, _compact]) {
        expect(
          tokens.controlHeight,
          greaterThanOrEqualTo(baseLine + 2 * tokens.spacing.xxs - 1e-9),
          reason: tokens.density.name,
        );
      }
    });

    test('Tipografia preservada — Densidade sem estilos de texto', () {
      for (final tokens in [_cozy, _compact]) {
        final builder = DiagnosticPropertiesBuilder();
        tokens.debugFillProperties(builder);
        for (final property in builder.properties) {
          expect(
            property.value,
            isNot(isA<TextStyle>()),
            reason: property.name,
          );
          expect(property.name!.toLowerCase(), isNot(contains('font')));
        }
      }
    });
  });

  group('Contrato do conjunto de densidade', () {
    test('Contrato do conjunto de densidade — Contrato verificado', () {
      expectTokenSetContract(
        a: _cozy,
        // Instância não canônica, para testar a igualdade por valor.
        // ignore: prefer_const_constructors
        aCopy: RebicDensityTokens.cozy(),
        b: _compact,
      );
    });

    test(
      'Contrato do conjunto de densidade — Interpolação entre densidades',
      () {
        final mid = _cozy.lerp(_compact, 0.5);
        expect(mid.controlHeight, 31);
        expect(mid.density, RebicDensity.compact);
        expect(_cozy.lerp(_compact, 0.49).density, RebicDensity.cozy);
        expect(mid.spacing, _cozy.spacing);
      },
    );

    test('igualdade e copyWith consideram cada campo isoladamente', () {
      final variants = [
        _cozy.copyWith(density: RebicDensity.compact),
        _cozy.copyWith(controlHeight: 44),
        _cozy.copyWith(listItemHeight: 56),
        _cozy.copyWith(minTargetSize: 52),
        _cozy.copyWith(spacing: _cozy.spacing.copyWith(l: 20)),
      ];
      for (final (i, variant) in variants.indexed) {
        expect(variant, isNot(_cozy), reason: 'campo $i');
        expect(variant.lerp(_cozy, 1), _cozy, reason: 'campo $i');
      }
    });

    test('diagnóstico lista modo, dimensões e espaçamento', () {
      final dump = _compact.toDiagnosticsNode().toStringDeep();
      for (final name in [
        'density',
        'controlHeight',
        'listItemHeight',
        'minTargetSize',
        'spacing',
      ]) {
        expect(dump, contains('$name:'), reason: name);
      }
    });
  });
}
