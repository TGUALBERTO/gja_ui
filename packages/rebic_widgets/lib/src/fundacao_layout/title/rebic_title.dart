import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Nível de um [RebicTitle], como o `sap.ui.core.TitleLevel` do SAPUI5.
///
/// Serve tanto ao nível semântico ([RebicTitle.level]) quanto ao estilo
/// visual ([RebicTitle.titleStyle]).
enum RebicTitleLevel {
  /// Sem nível explícito: cabeçalho sem nível, ou o estilo H5.
  auto,

  /// Nível 1 (`header1`).
  h1,

  /// Nível 2 (`header2`).
  h2,

  /// Nível 3 (`header3`).
  h3,

  /// Nível 4 (`header4`).
  h4,

  /// Nível 5 (`header5`).
  h5,

  /// Nível 6 (`header6`).
  h6,
}

/// Exibe o título de uma página, seção, cartão ou diálogo, como o
/// `sap.m.Title` do SAPUI5.
///
/// [level] define só a semântica: o título é sempre anunciado como cabeçalho,
/// com o nível informado. [titleStyle] define só o estilo, e `auto` é o H5.
/// A cor é `text` do tema ativo. Sem [wrapping], o título ocupa uma linha e
/// termina com reticências; o leitor de tela lê o texto completo.
///
/// ```dart
/// RebicTitle('Pedidos em aberto', level: RebicTitleLevel.h2,
///     titleStyle: RebicTitleLevel.h3)
/// ```
class RebicTitle extends StatelessWidget {
  /// Cria o título [text].
  const RebicTitle(
    this.text, {
    this.level = RebicTitleLevel.auto,
    this.titleStyle = RebicTitleLevel.auto,
    this.wrapping = false,
    this.textAlign = TextAlign.start,
    super.key,
  });

  /// Texto exibido.
  final String text;

  /// Nível semântico do cabeçalho; `auto` não informa nível.
  final RebicTitleLevel level;

  /// Estilo visual; `auto` usa o H5.
  final RebicTitleLevel titleStyle;

  /// Se o título quebra linhas; sem quebra, ocupa uma linha com reticências.
  final bool wrapping;

  /// Alinhamento horizontal.
  final TextAlign textAlign;

  static TextStyle _style(RebicTypographyTokens t, RebicTitleLevel style) =>
      switch (style) {
        RebicTitleLevel.h1 => t.header1,
        RebicTitleLevel.h2 => t.header2,
        RebicTitleLevel.h3 => t.header3,
        RebicTitleLevel.h4 => t.header4,
        RebicTitleLevel.h5 || RebicTitleLevel.auto => t.header5,
        RebicTitleLevel.h6 => t.header6,
      };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    return Semantics(
      header: true,
      // Com `auto`, cabeçalho sem nível.
      headingLevel: level == RebicTitleLevel.auto ? null : level.index,
      child: Text(
        text,
        style: _style(
          theme.typography,
          titleStyle,
        ).copyWith(color: theme.colors.text),
        maxLines: wrapping ? null : 1,
        overflow: wrapping ? TextOverflow.clip : TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    );
  }
}
