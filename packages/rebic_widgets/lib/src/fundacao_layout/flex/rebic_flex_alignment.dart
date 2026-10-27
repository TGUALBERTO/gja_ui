/// Alinhamento no eixo principal de `RebicRow` e `RebicColumn`, como o
/// `justifyContent` do `sap.m.FlexBox`.
enum RebicMainAlignment {
  /// Junto ao início (esquerda em LTR, topo na coluna).
  start,

  /// Centralizado.
  center,

  /// Junto ao fim.
  end,

  /// Espaço livre distribuído entre os filhos, além do `gap`.
  spaceBetween,
}

/// Alinhamento no eixo cruzado de `RebicRow` e `RebicColumn`, como o
/// `alignItems` do `sap.m.FlexBox`.
enum RebicCrossAlignment {
  /// Junto ao início (topo na linha, início do texto na coluna).
  start,

  /// Centralizado.
  center,

  /// Junto ao fim.
  end,

  /// Ocupa toda a extensão do eixo cruzado.
  stretch,
}
