import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

import '../support/token_set_contract.dart';

const _comfortable = RebicDensityTokens.comfortable();
const _compact = RebicDensityTokens.compact();

Map<String, double> _spacingValues(RebicSpacingTokens s) => {
  'none': s.none,
  'xxs': s.xxs,
  'xs': s.xs,
  's': s.s,
  'm': s.m,
  'l': s.l,
  'xl': s.xl,
  'xxl': s.xxl,
  'xxxl': s.xxxl,
  'inlineGap': s.inlineGap,
  'stackGap': s.stackGap,
  'sectionGap': s.sectionGap,
  'pageMargin': s.pageMargin,
};

void main() {
  test('Modos de densidade — Mapeamento por modo', () {
    expect(RebicDensity.values, [
      RebicDensity.comfortable,
      RebicDensity.compact,
    ]);
    for (final mode in RebicDensity.values) {
      expect(RebicDensityTokens.of(mode).density, mode);
    }
    expect(_comfortable, isNot(_compact));
  });

  group('Dimensões de controle por densidade', () {
    test('Dimensões de controle por densidade — Valores de referência', () {
      expect(_comfortable.controlHeight, 40);
      expect(_comfortable.listItemHeight, 48);
      expect(_comfortable.minTargetSize, 48);
      expect(_compact.controlHeight, 32);
      expect(_compact.listItemHeight, 32);
      expect(_compact.minTargetSize, 24);
      final primitives = RebicSpacingPrimitives.values.values.toSet();
      for (final tokens in [_comfortable, _compact]) {
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
            lessThanOrEqualTo(_comfortable.dimensions[name]!),
            reason: name,
          );
        }
      },
    );
  });

  group('Alvo mínimo de interação', () {
    test('Alvo mínimo de interação — Alvos dos mapeamentos de referência', () {
      expect(_comfortable.minTargetSize, greaterThanOrEqualTo(48));
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
      expect(_comfortable.spacing, const RebicSpacingTokens.fallback());
    });

    test('Espaçamento por densidade — Espaçamento compacto', () {
      final compact = _spacingValues(_compact.spacing);
      final comfortable = _spacingValues(_comfortable.spacing);
      final primitives = RebicSpacingPrimitives.values.values.toSet();
      for (final MapEntry(key: name, value: value) in compact.entries) {
        expect(value, lessThanOrEqualTo(comfortable[name]!), reason: name);
        expect(primitives, contains(value), reason: name);
      }
      final steps = compact.values.take(9).toList();
      expect(compact['none'], 0);
      for (var i = 1; i < steps.length; i++) {
        expect(
          steps[i],
          greaterThanOrEqualTo(steps[i - 1]),
          reason: 'passo $i',
        );
      }
      for (final role in [
        'inlineGap',
        'stackGap',
        'sectionGap',
        'pageMargin',
      ]) {
        expect(steps, contains(compact[role]), reason: role);
      }
    });
  });

  group('Tipografia preservada', () {
    test('Tipografia preservada — Rótulo cabe no controle', () {
      final label = const RebicTypographyTokens.fallback().baseSemibold;
      final labelLine = label.fontSize! * label.height!;
      for (final tokens in [_comfortable, _compact]) {
        expect(
          tokens.controlHeight,
          greaterThanOrEqualTo(labelLine + 2 * tokens.spacing.xs - 1e-9),
          reason: tokens.density.name,
        );
      }
    });

    test('Tipografia preservada — Densidade sem estilos de texto', () {
      for (final tokens in [_comfortable, _compact]) {
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
        a: _comfortable,
        // Instância não canônica, para testar a igualdade por valor.
        // ignore: prefer_const_constructors
        aCopy: RebicDensityTokens.comfortable(),
        b: _compact,
      );
    });

    test(
      'Contrato do conjunto de densidade — Interpolação entre densidades',
      () {
        final mid = _comfortable.lerp(_compact, 0.5);
        expect(mid.controlHeight, 36);
        expect(mid.density, RebicDensity.compact);
        expect(
          _comfortable.lerp(_compact, 0.49).density,
          RebicDensity.comfortable,
        );
        expect(mid.spacing.m, 10);
      },
    );

    test('igualdade e copyWith consideram cada campo isoladamente', () {
      final variants = [
        _comfortable.copyWith(density: RebicDensity.compact),
        _comfortable.copyWith(controlHeight: 44),
        _comfortable.copyWith(listItemHeight: 56),
        _comfortable.copyWith(minTargetSize: 44),
        _comfortable.copyWith(spacing: _compact.spacing),
      ];
      for (final (i, variant) in variants.indexed) {
        expect(variant, isNot(_comfortable), reason: 'campo $i');
        expect(variant.lerp(_comfortable, 1), _comfortable, reason: 'campo $i');
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
