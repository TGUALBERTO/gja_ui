import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Estilo da escala tipográfica de um [RebicText].
///
/// Os nomes são os dos estilos semânticos de `RebicTypographyTokens`.
enum RebicTextVariant {
  /// Número de destaque ou título de tela inicial.
  display,

  /// Título de página.
  headline,

  /// Título de seção, cartão ou diálogo.
  title,

  /// Subtítulo ou título de grupo.
  subtitle,

  /// Texto corrido (padrão).
  body,

  /// Texto corrido em destaque.
  bodyStrong,

  /// Rótulo de controle ou de campo.
  label,

  /// Texto auxiliar, como notas e metadados.
  caption,
}

/// Cor de papel de um [RebicText].
///
/// Os tons são fixos para que todo texto mantenha o contraste verificado
/// pelos fundamentos; não há cor livre.
enum RebicTextTone {
  /// Cor `text` do tema (padrão).
  standard,

  /// Cor `label` do tema, para texto secundário.
  muted,

  /// Cor do estado de valor `success`.
  success,

  /// Cor do estado de valor `warning`.
  warning,

  /// Cor do estado de valor `error`.
  error,

  /// Cor do estado de valor `information`.
  information,
}

/// Exibe texto do Rebic, como o `sap.m.Text` e o `sap.m.Title` do SAPUI5.
///
/// O estilo vem de `typography.<variant>` e a cor, do [tone], ambos do tema
/// ativo. Com [maxLines], o texto termina com reticências quando não cabe;
/// o leitor de tela lê o texto completo. As variantes `display`, `headline` e
/// `title` são anunciadas como cabeçalho, o que [heading] pode trocar.
///
/// ```dart
/// RebicText('Pedidos em aberto', variant: RebicTextVariant.title)
/// RebicText('Entrega atrasada', tone: RebicTextTone.error, maxLines: 2)
/// ```
class RebicText extends StatelessWidget {
  /// Cria o texto [data].
  const RebicText(
    this.data, {
    this.variant = RebicTextVariant.body,
    this.tone = RebicTextTone.standard,
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.heading,
    super.key,
  }) : assert(
         maxLines == null || maxLines > 0,
         '"maxLines" deve ser maior que zero',
       );

  /// Texto exibido.
  final String data;

  /// Estilo da escala tipográfica.
  final RebicTextVariant variant;

  /// Cor de papel.
  final RebicTextTone tone;

  /// Número máximo de linhas; nulo não limita.
  final int? maxLines;

  /// Alinhamento horizontal.
  final TextAlign textAlign;

  /// Se o texto é anunciado como cabeçalho; nulo segue a variante.
  final bool? heading;

  static TextStyle _style(RebicTypographyTokens t, RebicTextVariant variant) =>
      switch (variant) {
        RebicTextVariant.display => t.display,
        RebicTextVariant.headline => t.headline,
        RebicTextVariant.title => t.title,
        RebicTextVariant.subtitle => t.subtitle,
        RebicTextVariant.body => t.body,
        RebicTextVariant.bodyStrong => t.bodyStrong,
        RebicTextVariant.label => t.label,
        RebicTextVariant.caption => t.caption,
      };

  static Color _color(RebicColorTokens c, RebicTextTone tone) => switch (tone) {
    RebicTextTone.standard => c.text,
    RebicTextTone.muted => c.label,
    RebicTextTone.success => c.stateColors(RebicValueState.success).foreground,
    RebicTextTone.warning => c.stateColors(RebicValueState.warning).foreground,
    RebicTextTone.error => c.stateColors(RebicValueState.error).foreground,
    RebicTextTone.information =>
      c.stateColors(RebicValueState.information).foreground,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final isHeading =
        heading ??
        switch (variant) {
          RebicTextVariant.display ||
          RebicTextVariant.headline ||
          RebicTextVariant.title => true,
          _ => false,
        };
    return Semantics(
      header: isHeading,
      child: Text(
        data,
        style: _style(
          theme.typography,
          variant,
        ).copyWith(color: _color(theme.colors, tone)),
        maxLines: maxLines,
        overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
        textAlign: textAlign,
        softWrap: true,
      ),
    );
  }
}
