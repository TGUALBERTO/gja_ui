import '../shadow_layer.dart';

/// Sombras primitivas: geometria em camadas, sem cor.
///
/// Nível: primitivo.
///
/// Nomeadas como os parâmetros `sapContent_Shadow0`…`3` e
/// `sapContent_HeaderShadow` do Fiori. De [shadow0] a [shadow3], cada sombra
/// tem uma camada de contato (nítida, opacidade total) e uma de ambiente
/// (difusa, meia opacidade), e o maior desfoque e o maior deslocamento
/// crescem. Widgets não leem estes valores: eles usam as sombras e papéis de
/// `RebicElevationTokens`.
abstract final class RebicElevationPrimitives {
  /// Sem sombra.
  static const none = <RebicShadowLayer>[];

  /// Sombra sutil, de cartões e blocos.
  static const shadow0 = <RebicShadowLayer>[
    RebicShadowLayer(offsetY: 1, blurRadius: 2),
    RebicShadowLayer(offsetY: 1, blurRadius: 3, spreadRadius: 1, opacity: 0.5),
  ];

  /// Sombra baixa, de popovers e menus.
  static const shadow1 = <RebicShadowLayer>[
    RebicShadowLayer(offsetY: 1, blurRadius: 2),
    RebicShadowLayer(offsetY: 2, blurRadius: 6, spreadRadius: 2, opacity: 0.5),
  ];

  /// Sombra média, de diálogos.
  static const shadow2 = <RebicShadowLayer>[
    RebicShadowLayer(offsetY: 1, blurRadius: 3),
    RebicShadowLayer(offsetY: 4, blurRadius: 8, spreadRadius: 3, opacity: 0.5),
  ];

  /// Sombra alta, de item arrastado.
  static const shadow3 = <RebicShadowLayer>[
    RebicShadowLayer(offsetY: 2, blurRadius: 3),
    RebicShadowLayer(offsetY: 6, blurRadius: 10, spreadRadius: 4, opacity: 0.5),
  ];

  /// Sombra curta para baixo, de cabeçalhos e barras fixas.
  static const header = <RebicShadowLayer>[
    RebicShadowLayer(offsetY: 2, blurRadius: 4, opacity: 0.5),
  ];

  /// Sombras por nome: [none] e [shadow0] a [shadow3] em ordem crescente de
  /// profundidade, seguidas de [header].
  static const shadows = <String, List<RebicShadowLayer>>{
    'none': none,
    'shadow0': shadow0,
    'shadow1': shadow1,
    'shadow2': shadow2,
    'shadow3': shadow3,
    'header': header,
  };
}
