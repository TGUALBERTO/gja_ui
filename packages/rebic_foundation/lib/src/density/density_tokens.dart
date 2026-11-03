import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

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

  /// Entrada por ponteiro: controles menores, com o mesmo espaçamento
  /// (`sapUiSizeCompact`).
  compact,
}

typedef _D = RebicDensityPrimitives;

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
    required this.barHeight,
    required this.separatorHeight,
    required this.spacing,
  });

  /// Mapeamento de referência cozy: controle 36 (`sapElement_Height`), item e
  /// alvo 44 (`sapElement_LineHeight`), barra 48 (`sap.m.Bar`, 3rem) e
  /// separador 32 (`sap.m.ToolbarSeparator`, 2rem).
  const RebicDensityTokens.cozy()
    : this(
        density: RebicDensity.cozy,
        controlHeight: _D.size36,
        listItemHeight: _D.size44,
        minTargetSize: _D.size44,
        barHeight: _D.size48,
        separatorHeight: _D.size32,
        spacing: const RebicSpacingTokens.fallback(),
      );

  /// Mapeamento de referência compacto: controle 26
  /// (`sapElement_Compact_Height`), item e alvo 32
  /// (`sapElement_Compact_LineHeight`), barra 32 (`sap.m.Bar`, 2rem) e
  /// separador 24 (`sap.m.ToolbarSeparator`, 1.5rem).
  const RebicDensityTokens.compact()
    : this(
        density: RebicDensity.compact,
        controlHeight: _D.size26,
        listItemHeight: _D.size32,
        minTargetSize: _D.size32,
        barHeight: _D.size32,
        separatorHeight: _D.size24,
        spacing: const RebicSpacingTokens.fallback(),
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

  /// Altura de uma barra de cabeçalho, subcabeçalho ou rodapé, como a do
  /// `sap.m.Bar`.
  final double barHeight;

  /// Altura de um separador vertical, como a do `sap.m.ToolbarSeparator`.
  final double separatorHeight;

  /// Espaçamento desta densidade.
  final RebicSpacingTokens spacing;

  /// Dimensões por nome, na ordem de declaração.
  Map<String, double> get dimensions => {
    'controlHeight': controlHeight,
    'listItemHeight': listItemHeight,
    'minTargetSize': minTargetSize,
    'barHeight': barHeight,
    'separatorHeight': separatorHeight,
  };

  @override
  RebicDensityTokens copyWith({
    RebicDensity? density,
    double? controlHeight,
    double? listItemHeight,
    double? minTargetSize,
    double? barHeight,
    double? separatorHeight,
    RebicSpacingTokens? spacing,
  }) {
    final result = RebicDensityTokens(
      density: density ?? this.density,
      controlHeight: controlHeight ?? this.controlHeight,
      listItemHeight: listItemHeight ?? this.listItemHeight,
      minTargetSize: minTargetSize ?? this.minTargetSize,
      barHeight: barHeight ?? this.barHeight,
      separatorHeight: separatorHeight ?? this.separatorHeight,
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
      barHeight: mix(barHeight, other.barHeight),
      separatorHeight: mix(separatorHeight, other.separatorHeight),
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
        other.barHeight == barHeight &&
        other.separatorHeight == separatorHeight &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
    density,
    controlHeight,
    listItemHeight,
    minTargetSize,
    barHeight,
    separatorHeight,
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
