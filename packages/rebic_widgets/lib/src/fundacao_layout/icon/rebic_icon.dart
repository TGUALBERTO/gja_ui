import 'package:flutter/widgets.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Papel de tamanho de um [RebicIcon], conforme `RebicIconTokens`.
enum RebicIconSize {
  /// Ícone pequeno.
  small,

  /// Ícone médio.
  medium,

  /// Ícone grande (navegação).
  large,

  /// Ícone extragrande (destaques).
  xLarge,

  /// Junto ao texto corrido; acompanha a escala de texto do sistema.
  inline,

  /// Dentro de botões e campos (padrão).
  control,
}

/// Cor de papel de um [RebicIcon].
///
/// Os tons são fixos para que todo ícone mantenha o contraste verificado
/// pelos fundamentos; não há cor livre.
enum RebicIconTone {
  /// Cor `text` do tema (padrão).
  standard,

  /// Cor `label` do tema, para ícones secundários.
  muted,

  /// Cor `brand` do tema, para ícones de destaque.
  brand,

  /// Cor do estado de valor `success`.
  success,

  /// Cor do estado de valor `warning`.
  warning,

  /// Cor do estado de valor `error`.
  error,

  /// Cor do estado de valor `information`.
  information,
}

/// Exibe um ícone da fonte do Rebic, como o `sap.ui.core.Icon` do SAPUI5.
///
/// O tamanho vem de `icons.<size>` e a cor, do [tone], ambos do tema ativo.
/// Sem [semanticLabel], o ícone é decorativo e fica fora da árvore de
/// semântica; com ele, é anunciado como imagem. Os ícones direcionais do
/// catálogo (`RebicIcons`) são espelhados em RTL.
///
/// ```dart
/// const RebicIcon(RebicIcons.search)
/// const RebicIcon(
///   RebicIcons.warning,
///   tone: RebicIconTone.warning,
///   semanticLabel: 'Aviso',
/// )
/// ```
///
/// Para um ícone clicável, use `RebicIconButton`.
class RebicIcon extends StatelessWidget {
  /// Cria o ícone [icon].
  const RebicIcon(
    this.icon, {
    this.size = RebicIconSize.control,
    this.tone = RebicIconTone.standard,
    this.semanticLabel,
    super.key,
  });

  /// Ícone exibido, do catálogo `RebicIcons` ou da aplicação.
  final IconData icon;

  /// Papel de tamanho.
  final RebicIconSize size;

  /// Cor de papel.
  final RebicIconTone tone;

  /// Rótulo para leitores de tela; nulo torna o ícone decorativo.
  final String? semanticLabel;

  static double _size(RebicIconTokens t, RebicIconSize size) => switch (size) {
    RebicIconSize.small => t.small,
    RebicIconSize.medium => t.medium,
    RebicIconSize.large => t.large,
    RebicIconSize.xLarge => t.xLarge,
    RebicIconSize.inline => t.inline,
    RebicIconSize.control => t.control,
  };

  static Color _color(RebicColorTokens c, RebicIconTone tone) => switch (tone) {
    RebicIconTone.standard => c.text,
    RebicIconTone.muted => c.label,
    RebicIconTone.brand => c.brand,
    RebicIconTone.success => c.stateColors(RebicValueState.success).foreground,
    RebicIconTone.warning => c.stateColors(RebicValueState.warning).foreground,
    RebicIconTone.error => c.stateColors(RebicValueState.error).foreground,
    RebicIconTone.information =>
      c.stateColors(RebicValueState.information).foreground,
  };

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final glyph = Icon(
      icon,
      size: _size(theme.icons, size),
      color: _color(theme.colors, tone),
      applyTextScaling: size == RebicIconSize.inline,
    );
    final label = semanticLabel;
    if (label == null) return ExcludeSemantics(child: glyph);
    return Semantics(
      label: label,
      image: true,
      excludeSemantics: true,
      child: glyph,
    );
  }
}
