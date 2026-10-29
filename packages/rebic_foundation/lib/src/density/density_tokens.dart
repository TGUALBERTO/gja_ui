import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../spacing/primitives/spacing_primitives.dart';
import 'primitives/density_primitives.dart';
import '../spacing/spacing_tokens.dart';
import '../tokens/lerp.dart';
import '../tokens/token_set.dart';

/// Modo de densidade de conteúdo, como as densidades do Fiori.
///
/// Nível: semântico.
enum RebicDensity {
  /// Densidade confortável, para entrada por toque: controles e alvos
  /// maiores (`sapUiSizeCozy`).
  cozy,

  /// Entrada por ponteiro: controles e espaçamentos reduzidos
  /// (`sapUiSizeCompact`).
  compact,
}

typedef _S = RebicSpacingPrimitives;
typedef _D = RebicDensityPrimitives;

/// Espaçamento da densidade compacta: passos e papéis reduzidos, na mesma
/// escala primitiva (grade de 4 px).
const _compactSpacing = RebicSpacingTokens(
  none: _S.space0,
  xxs: _S.space2,
  xs: _S.space4,
  s: _S.space4,
  m: _S.space8,
  l: _S.space12,
  xl: _S.space16,
  xxl: _S.space24,
  xxxl: _S.space32,
  inlineGap: _S.space4,
  stackGap: _S.space8,
  sectionGap: _S.space24,
  pageMargin: _S.space12,
);

/// Dimensões e espaçamento de uma densidade.
///
/// Nível: semântico.
///
/// Widgets interativos ajustam dimensões somente por estes valores. A
/// densidade não altera tipografia: os mesmos estilos de texto valem nos dois
/// modos. As dimensões devem ser finitas e positivas, e [minTargetSize] deve
/// ser ≥ 24 (WCAG 2.2, 2.5.8); [copyWith] verifica com `assert` em modo debug.
@immutable
class RebicDensityTokens extends RebicTokenSet<RebicDensityTokens> {
  /// Cria um mapeamento de densidade.
  const RebicDensityTokens({
    required this.density,
    required this.controlHeight,
    required this.listItemHeight,
    required this.minTargetSize,
    required this.spacing,
  });

  /// Mapeamento de referência cozy: controle 36 (`sapElement_Height`), item e
  /// alvo 44 (`sapElement_LineHeight`).
  const RebicDensityTokens.cozy()
    : this(
        density: RebicDensity.cozy,
        controlHeight: _D.size36,
        listItemHeight: _D.size44,
        minTargetSize: _D.size44,
        spacing: const RebicSpacingTokens.fallback(),
      );

  /// Mapeamento de referência compacto: controle 26
  /// (`sapElement_Compact_Height`), item e alvo 32
  /// (`sapElement_Compact_LineHeight`).
  const RebicDensityTokens.compact()
    : this(
        density: RebicDensity.compact,
        controlHeight: _D.size26,
        listItemHeight: _D.size32,
        minTargetSize: _D.size32,
        spacing: _compactSpacing,
      );

  /// Mapeamento de referência de [density].
  static RebicDensityTokens of(RebicDensity density) {
    return switch (density) {
      RebicDensity.cozy => const RebicDensityTokens.cozy(),
      RebicDensity.compact => const RebicDensityTokens.compact(),
    };
  }

  /// Menor alvo de interação permitido em qualquer mapeamento.
  static const minTargetSizeFloor = 24.0;

  /// Modo desta densidade.
  final RebicDensity density;

  /// Altura de botões, campos e seleções (`sapElement_Height`).
  final double controlHeight;

  /// Altura de um item de lista de uma linha.
  final double listItemHeight;

  /// Tamanho mínimo, em largura e altura, da área de interação: a caixa
  /// externa do controle, com a altura de linha (`sapElement_LineHeight`).
  final double minTargetSize;

  /// Espaçamento desta densidade.
  final RebicSpacingTokens spacing;

  /// Dimensões por nome, na ordem de declaração.
  Map<String, double> get dimensions => {
    'controlHeight': controlHeight,
    'listItemHeight': listItemHeight,
    'minTargetSize': minTargetSize,
  };

  @override
  RebicDensityTokens copyWith({
    RebicDensity? density,
    double? controlHeight,
    double? listItemHeight,
    double? minTargetSize,
    RebicSpacingTokens? spacing,
  }) {
    final result = RebicDensityTokens(
      density: density ?? this.density,
      controlHeight: controlHeight ?? this.controlHeight,
      listItemHeight: listItemHeight ?? this.listItemHeight,
      minTargetSize: minTargetSize ?? this.minTargetSize,
      spacing: spacing ?? this.spacing,
    );
    assert(() {
      for (final MapEntry(key: name, value: value)
          in result.dimensions.entries) {
        if (!value.isFinite || value <= 0) {
          throw AssertionError(
            'dimensão de densidade "$name" deve ser finita e positiva: $value',
          );
        }
      }
      if (result.minTargetSize < minTargetSizeFloor) {
        throw AssertionError(
          'minTargetSize deve ser ≥ $minTargetSizeFloor (WCAG 2.2, 2.5.8): '
          '${result.minTargetSize}',
        );
      }
      return true;
    }());
    return result;
  }

  @override
  RebicDensityTokens lerp(RebicDensityTokens? other, double t) {
    if (other == null) return this;
    double mix(double a, double b) => lerpDouble(a, b, t)!;
    return RebicDensityTokens(
      density: lerpDiscrete(density, other.density, t),
      controlHeight: mix(controlHeight, other.controlHeight),
      listItemHeight: mix(listItemHeight, other.listItemHeight),
      minTargetSize: mix(minTargetSize, other.minTargetSize),
      spacing: spacing.lerp(other.spacing, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicDensityTokens &&
        other.density == density &&
        other.controlHeight == controlHeight &&
        other.listItemHeight == listItemHeight &&
        other.minTargetSize == minTargetSize &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
    density,
    controlHeight,
    listItemHeight,
    minTargetSize,
    spacing,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<RebicDensity>('density', density));
    for (final MapEntry(key: name, value: value) in dimensions.entries) {
      properties.add(DoubleProperty(name, value));
    }
    properties.add(DiagnosticsProperty<RebicSpacingTokens>('spacing', spacing));
  }
}
