import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/token_set.dart';
import 'primitives/radius_primitives.dart';

/// Passos e papéis semânticos de raio de borda, em pixels lógicos.
///
/// Nível: semântico.
///
/// Widgets expressam raios somente com estes valores (ex.:
/// `BorderRadius.circular(radius.control)`). [full] produz o formato de
/// pílula. Os papéis [control] e [container] dão nome à intenção e podem ser
/// ajustados sem mexer na escala. Todos os valores devem ser finitos e não
/// negativos; [copyWith] verifica com `assert` em modo debug.
@immutable
class RebicRadiusTokens extends RebicTokenSet<RebicRadiusTokens> {
  /// Cria um mapeamento de raios.
  const RebicRadiusTokens({
    required this.none,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.full,
    required this.control,
    required this.container,
  });

  /// Mapeamento de referência.
  const RebicRadiusTokens.fallback()
    : this(
        none: RebicRadiusPrimitives.radius0,
        xs: RebicRadiusPrimitives.radius2,
        s: RebicRadiusPrimitives.radius4,
        m: RebicRadiusPrimitives.radius8,
        l: RebicRadiusPrimitives.radius12,
        xl: RebicRadiusPrimitives.radius16,
        full: RebicRadiusPrimitives.radiusFull,
        control: RebicRadiusPrimitives.radius4,
        container: RebicRadiusPrimitives.radius8,
      );

  /// Cantos retos.
  final double none;

  /// Arredondamento mínimo (indicadores pequenos).
  final double xs;

  /// Arredondamento pequeno.
  final double s;

  /// Arredondamento médio.
  final double m;

  /// Arredondamento grande.
  final double l;

  /// Arredondamento muito grande.
  final double xl;

  /// Pílula: extremidades em semicírculo.
  final double full;

  /// Botões, campos e caixas de seleção.
  final double control;

  /// Cartões, diálogos e menus.
  final double container;

  /// Valores por nome, na ordem de declaração.
  Map<String, double> get values => {
    'none': none,
    'xs': xs,
    's': s,
    'm': m,
    'l': l,
    'xl': xl,
    'full': full,
    'control': control,
    'container': container,
  };

  @override
  RebicRadiusTokens copyWith({
    double? none,
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? full,
    double? control,
    double? container,
  }) {
    final result = RebicRadiusTokens(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      full: full ?? this.full,
      control: control ?? this.control,
      container: container ?? this.container,
    );
    assert(() {
      for (final MapEntry(key: name, value: value) in result.values.entries) {
        if (!value.isFinite || value < 0) {
          throw AssertionError(
            'raio "$name" deve ser finito e não negativo: $value',
          );
        }
      }
      return true;
    }());
    return result;
  }

  @override
  RebicRadiusTokens lerp(RebicRadiusTokens? other, double t) {
    if (other == null) return this;
    double mix(double a, double b) => lerpDouble(a, b, t)!;
    return RebicRadiusTokens(
      none: mix(none, other.none),
      xs: mix(xs, other.xs),
      s: mix(s, other.s),
      m: mix(m, other.m),
      l: mix(l, other.l),
      xl: mix(xl, other.xl),
      full: mix(full, other.full),
      control: mix(control, other.control),
      container: mix(container, other.container),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RebicRadiusTokens &&
        other.none == none &&
        other.xs == xs &&
        other.s == s &&
        other.m == m &&
        other.l == l &&
        other.xl == xl &&
        other.full == full &&
        other.control == control &&
        other.container == container;
  }

  @override
  int get hashCode =>
      Object.hash(none, xs, s, m, l, xl, full, control, container);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (final MapEntry(key: name, value: value) in values.entries) {
      properties.add(DoubleProperty(name, value));
    }
  }
}
