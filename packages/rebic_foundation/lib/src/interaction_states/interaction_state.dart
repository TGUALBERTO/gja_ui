/// Estado de interação de um componente.
///
/// Nível: semântico.
///
/// Um componente pode estar em vários estados ao mesmo tempo; as regras de
/// `RebicInteractionStateTokens` recebem o conjunto de estados ativos, e o
/// conjunto vazio representa o estado normal.
enum RebicInteractionState {
  /// Ponteiro sobre o componente.
  hovered,

  /// Foco de teclado no componente.
  focused,

  /// Componente sendo pressionado.
  pressed,

  /// Componente selecionado ou marcado.
  selected,

  /// Componente sendo arrastado.
  dragged,

  /// Componente desabilitado.
  disabled,
}
