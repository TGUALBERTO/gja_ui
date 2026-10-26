/// Escalas primitivas de interação: opacidades e espessuras de traço.
///
/// Nível: primitivo.
///
/// Opacidades são nomeadas pela porcentagem (`opacity12` = 0,12); espessuras,
/// pelo valor em pixels lógicos. Widgets não leem estes valores: eles usam
/// `RebicInteractionStateTokens`.
abstract final class RebicInteractionPrimitives {
  /// 0%.
  static const opacity0 = 0.0;

  /// 4%.
  static const opacity4 = 0.04;

  /// 8%.
  static const opacity8 = 0.08;

  /// 12%.
  static const opacity12 = 0.12;

  /// 16%.
  static const opacity16 = 0.16;

  /// 24%.
  static const opacity24 = 0.24;

  /// 40%.
  static const opacity40 = 0.4;

  /// 50%.
  static const opacity50 = 0.5;

  /// 100%.
  static const opacity100 = 1.0;

  /// Escala de opacidades, em ordem crescente.
  static const opacities = <String, double>{
    'opacity0': opacity0,
    'opacity4': opacity4,
    'opacity8': opacity8,
    'opacity12': opacity12,
    'opacity16': opacity16,
    'opacity24': opacity24,
    'opacity40': opacity40,
    'opacity50': opacity50,
    'opacity100': opacity100,
  };

  /// Traço de 1 px.
  static const stroke1 = 1.0;

  /// Traço de 2 px.
  static const stroke2 = 2.0;

  /// Traço de 3 px.
  static const stroke3 = 3.0;

  /// Escala de espessuras de traço, em ordem crescente.
  static const strokes = <String, double>{
    'stroke1': stroke1,
    'stroke2': stroke2,
    'stroke3': stroke3,
  };
}
