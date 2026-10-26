/// Escala primitiva de larguras de tela, em pixels lógicos.
///
/// Nível: primitivo.
///
/// Os nomes seguem o valor. Widgets não leem estes valores: eles usam os
/// limiares de `RebicBreakpointTokens`.
abstract final class RebicBreakpointPrimitives {
  /// 360 px.
  static const width360 = 360.0;

  /// 600 px.
  static const width600 = 600.0;

  /// 840 px.
  static const width840 = 840.0;

  /// 1024 px.
  static const width1024 = 1024.0;

  /// 1280 px.
  static const width1280 = 1280.0;

  /// 1440 px.
  static const width1440 = 1440.0;

  /// 1920 px.
  static const width1920 = 1920.0;

  /// Escala completa, em ordem crescente.
  static const values = <String, double>{
    'width360': width360,
    'width600': width600,
    'width840': width840,
    'width1024': width1024,
    'width1280': width1280,
    'width1440': width1440,
    'width1920': width1920,
  };
}
