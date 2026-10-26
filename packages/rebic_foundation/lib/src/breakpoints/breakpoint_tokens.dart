import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/token_set.dart';
import 'primitives/breakpoint_primitives.dart';
import 'size_class.dart';

/// Limiares semânticos de largura e a classificação de uma largura.
///
/// Nível: semântico.
///
/// Cada campo é a largura mínima, em pixels lógicos, da classe de mesmo nome;
/// abaixo de [medium] a classe é `small`. Os limiares devem ser finitos,
/// positivos e estritamente crescentes; [copyWith] verifica com `assert` em
/// modo debug.
@immutable
class RebicBreakpointTokens extends RebicTokenSet<RebicBreakpointTokens> {
  /// Cria um mapeamento de limiares.
  const RebicBreakpointTokens({
    required this.medium,
    required this.large,
    required this.extraLarge,
  });

  /// Mapeamento de referência: 600, 1024 e 1440.
  const RebicBreakpointTokens.fallback()
    : this(
        medium: RebicBreakpointPrimitives.width600,
        large: RebicBreakpointPrimitives.width1024,
        extraLarge: RebicBreakpointPrimitives.width1440,
      );

  /// Largura mínima da classe `medium`.
  final double medium;

  /// Largura mínima da classe `large`.
  final double large;

  /// Largura mínima da classe `extraLarge`.
  final double extraLarge;

  /// Classe de tamanho de [width], em pixels lógicos.
  ///
  /// É a maior classe cujo limiar é menor ou igual a [width] (limiar
  /// inclusivo). Zero é `small`; `double.infinity` é `extraLarge`.
  ///
  /// Lança [ArgumentError] para largura negativa ou `NaN`.
  RebicSizeClass classify(double width) {
    if (width.isNaN || width < 0) {
      throw ArgumentError.value(width, 'width', 'largura inválida');
    }
    if (width >= extraLarge) return RebicSizeClass.extraLarge;
    if (width >= large) return RebicSizeClass.large;
    if (width >= medium) return RebicSizeClass.medium;
    return RebicSizeClass.small;
  }

  /// Largura mínima de [sizeClass]; `small` começa em zero.
  double minWidthOf(RebicSizeClass sizeClass) {
    return switch (sizeClass) {
      RebicSizeClass.small => 0,
      RebicSizeClass.medium => medium,
      RebicSizeClass.large => large,
      RebicSizeClass.extraLarge => extraLarge,
    };
  }

  @override
  RebicBreakpointTokens copyWith({
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    final result = RebicBreakpointTokens(
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
    );
    assert(
      result._isValid,
      'limiares devem ser finitos, positivos e crescentes '
      '(medium < large < extraLarge): ${result.medium}, ${result.large}, '
      '${result.extraLarge}',
    );
    return result;
  }

  bool get _isValid =>
      extraLarge.isFinite && medium > 0 && medium < large && large < extraLarge;

  @override
  RebicBreakpointTokens lerp(RebicBreakpointTokens? other, double t) {
    if (other == null) return this;
    return RebicBreakpointTokens(
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicBreakpointTokens &&
        other.medium == medium &&
        other.large == large &&
        other.extraLarge == extraLarge;
  }

  @override
  int get hashCode => Object.hash(medium, large, extraLarge);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('medium', medium))
      ..add(DoubleProperty('large', large))
      ..add(DoubleProperty('extraLarge', extraLarge));
  }
}
