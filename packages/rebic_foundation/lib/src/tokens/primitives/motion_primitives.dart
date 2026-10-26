import 'package:flutter/animation.dart';

/// Escalas primitivas de movimento: durações e curvas de animação.
///
/// Nível: primitivo.
///
/// Valores brutos, nomeados pela posição na escala (durações) ou pela forma
/// (curvas, que não formam escala). Widgets não os leem: eles usam os papéis
/// de `RebicMotionTokens`. Temas e aplicações os usam para montar o
/// mapeamento semântico.
abstract final class RebicMotionPrimitives {
  /// 0 ms.
  static const duration0 = Duration.zero;

  /// 50 ms.
  static const duration50 = Duration(milliseconds: 50);

  /// 100 ms.
  static const duration100 = Duration(milliseconds: 100);

  /// 150 ms.
  static const duration150 = Duration(milliseconds: 150);

  /// 200 ms.
  static const duration200 = Duration(milliseconds: 200);

  /// 250 ms.
  static const duration250 = Duration(milliseconds: 250);

  /// 300 ms.
  static const duration300 = Duration(milliseconds: 300);

  /// 400 ms.
  static const duration400 = Duration(milliseconds: 400);

  /// 500 ms.
  static const duration500 = Duration(milliseconds: 500);

  /// Escala completa de durações, em ordem crescente.
  static const durations = <String, Duration>{
    'duration0': duration0,
    'duration50': duration50,
    'duration100': duration100,
    'duration150': duration150,
    'duration200': duration200,
    'duration250': duration250,
    'duration300': duration300,
    'duration400': duration400,
    'duration500': duration500,
  };

  /// Aceleração e desaceleração suaves, para movimentos dentro da tela.
  static const curveStandard = Cubic(0.4, 0, 0.2, 1);

  /// Desaceleração, para elementos que entram na tela.
  static const curveDecelerate = Cubic(0, 0, 0.2, 1);

  /// Aceleração, para elementos que saem da tela.
  static const curveAccelerate = Cubic(0.4, 0, 1, 1);
}
