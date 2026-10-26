/// Classe de tamanho de uma largura disponível, em ordem crescente.
///
/// Nível: semântico.
///
/// Obtida com `RebicBreakpointTokens.classify`. Layouts comparam classes com
/// [isAtLeast] e [isAtMost], nunca com larguras literais.
enum RebicSizeClass {
  /// Celulares e janelas estreitas.
  small,

  /// Tablets e janelas médias.
  medium,

  /// Notebooks e desktops.
  large,

  /// Desktops largos.
  extraLarge;

  /// Se esta classe é igual a [other] ou maior.
  bool isAtLeast(RebicSizeClass other) => index >= other.index;

  /// Se esta classe é igual a [other] ou menor.
  bool isAtMost(RebicSizeClass other) => index <= other.index;
}
