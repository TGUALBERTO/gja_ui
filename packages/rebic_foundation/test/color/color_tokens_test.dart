import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:rebic_foundation/rebic_foundation.dart';
import 'package:rebic_foundation/rebic_primitives.dart';

import '../support/token_set_contract.dart';

const _light = RebicColorTokens.light();
const _dark = RebicColorTokens.dark();

/// Todas as cores primitivas, incluindo branco, preto e as translúcidas.
final _primitives = <Color>{
  for (final scale in RebicColorPrimitives.scales.values) ...scale.values,
  RebicColorPrimitives.white,
  RebicColorPrimitives.black,
  RebicColorPrimitives.blackAlpha16,
  RebicColorPrimitives.blackAlpha40,
  RebicColorPrimitives.blackAlpha60,
};

const _fioriRoles = [
  'background',
  'base',
  'headerBackground',
  'shell',
  'text',
  'label',
  'link',
  'separator',
  'fieldBorder',
  'brand',
  'brandHover',
  'highlight',
  'contrastText',
  'hoverBackground',
  'selectionBackground',
  'selectionHoverBackground',
  'focus',
  'shadow',
  'blockLayer',
];

void main() {
  group('Papéis semânticos de cor', () {
    test('Papéis semânticos de cor — Papéis do modelo Fiori', () {
      expect(_light.roles.keys, _fioriRoles);
      for (final materialName in [
        'surface',
        'onSurface',
        'primaryContainer',
        'scrim',
      ]) {
        expect(
          _light.roles.containsKey(materialName),
          isFalse,
          reason: materialName,
        );
      }
    });

    test('Papéis semânticos de cor — Contrato do conjunto', () {
      expectTokenSetContract(
        a: _light,
        // Instância não canônica, para testar a igualdade por valor.
        // ignore: prefer_const_constructors
        aCopy: RebicColorTokens.light(),
        b: _dark,
      );
      expectTokenSetContract(
        a: _light.error,
        aCopy: _light.error.copyWith(),
        b: _light.success,
      );
    });

    test('Papéis semânticos de cor — Interpolação de cor', () {
      final a = _light.copyWith(base: const Color(0xFFFFFFFF));
      final b = _light.copyWith(base: const Color(0xFF000000));
      final mid = a.lerp(b, 0.5).base;
      expect(
        mid,
        Color.lerp(const Color(0xFFFFFFFF), const Color(0xFF000000), 0.5),
      );
      expect(mid.r, closeTo(0.5, 0.01));
      expect(mid.g, closeTo(0.5, 0.01));
      expect(mid.b, closeTo(0.5, 0.01));
    });

    test('igualdade e copyWith consideram cada campo isoladamente', () {
      const other = Color(0xFF123456);
      final variants = <String, RebicColorTokens>{
        'background': _light.copyWith(background: other),
        'base': _light.copyWith(base: other),
        'headerBackground': _light.copyWith(headerBackground: other),
        'shell': _light.copyWith(shell: other),
        'text': _light.copyWith(text: other),
        'label': _light.copyWith(label: other),
        'link': _light.copyWith(link: other),
        'separator': _light.copyWith(separator: other),
        'fieldBorder': _light.copyWith(fieldBorder: other),
        'brand': _light.copyWith(brand: other),
        'brandHover': _light.copyWith(brandHover: other),
        'highlight': _light.copyWith(highlight: other),
        'contrastText': _light.copyWith(contrastText: other),
        'hoverBackground': _light.copyWith(hoverBackground: other),
        'selectionBackground': _light.copyWith(selectionBackground: other),
        'selectionHoverBackground': _light.copyWith(
          selectionHoverBackground: other,
        ),
        'focus': _light.copyWith(focus: other),
        'shadow': _light.copyWith(shadow: other),
        'blockLayer': _light.copyWith(blockLayer: other),
        'none': _light.copyWith(none: _dark.none),
        'success': _light.copyWith(success: _dark.success),
        'warning': _light.copyWith(warning: _dark.warning),
        'error': _light.copyWith(error: _dark.error),
        'information': _light.copyWith(information: _dark.information),
      };
      expect(variants, hasLength(24));
      for (final MapEntry(key: field, value: variant) in variants.entries) {
        expect(variant, isNot(_light), reason: field);
        expect(variant.lerp(_light, 1), _light, reason: field);
      }
    });

    test('diagnóstico lista cada papel', () {
      final dump = _light.toDiagnosticsNode().toStringDeep();
      for (final name in [
        ..._fioriRoles,
        'none',
        'success',
        'warning',
        'error',
        'information',
      ]) {
        expect(dump, contains('$name:'), reason: name);
      }
    });
  });

  group('Mapeamentos claro e escuro de referência', () {
    test(
      'Mapeamentos claro e escuro de referência — Papéis vêm dos primitivos',
      () {
        for (final (mode, tokens) in [('claro', _light), ('escuro', _dark)]) {
          for (final MapEntry(key: role, value: color)
              in tokens.roles.entries) {
            expect(_primitives, contains(color), reason: '$mode.$role');
          }
          for (final state in RebicValueState.values) {
            final c = tokens.stateColors(state);
            for (final color in [c.foreground, c.background, c.border]) {
              expect(
                _primitives,
                contains(color),
                reason: '$mode.${state.name}',
              );
            }
          }
        }
      },
    );

    test(
      'Mapeamentos claro e escuro de referência — Polaridade do modo escuro',
      () {
        final text = _dark.text.computeLuminance();
        expect(_dark.base.computeLuminance(), lessThan(text));
        expect(_dark.background.computeLuminance(), lessThan(text));
        final lightText = _light.text.computeLuminance();
        expect(_light.base.computeLuminance(), greaterThan(lightText));
        expect(_light.background.computeLuminance(), greaterThan(lightText));
      },
    );
  });

  group('Estado semântico de valor', () {
    test('Estado semântico de valor — Cores de erro', () {
      final error = _light.stateColors(RebicValueState.error);
      final success = _light.stateColors(RebicValueState.success);
      expect(error, _light.error);
      expect(error.foreground, isNot(success.foreground));
      expect(error.background, isNot(success.background));
      expect(error.border, isNot(success.border));
    });

    test('Estado semântico de valor — Estado sem destaque', () {
      final neutral = RebicColorPrimitives.neutral.values.toSet();
      for (final tokens in [_light, _dark]) {
        final none = tokens.stateColors(RebicValueState.none);
        expect(
          neutral,
          containsAll([none.foreground, none.background, none.border]),
        );
      }
    });
  });
}
