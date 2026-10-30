import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Desenho de um [RebicLabel], como o `sap.m.LabelDesign` do SAPUI5.
enum RebicLabelDesign {
  /// Texto no estilo `base` (padrão).
  standard,

  /// Texto no estilo `baseBold`.
  bold,
}

/// Exibe o rótulo de um campo ou de um valor, como o `sap.m.Label` do SAPUI5.
///
/// Usa a cor `label` do tema ativo. Com [showColon], mostra ":" depois do
/// texto; com [required], mostra "*" na cor `required` depois dos dois-pontos.
/// Sem [wrapping], o rótulo ocupa uma linha e só o texto termina com
/// reticências: os sinais continuam visíveis. O leitor de tela lê o texto
/// completo e anuncia o asterisco como "Obrigatório".
///
/// ```dart
/// RebicLabel('Fornecedor', showColon: true, required: true)
/// ```
class RebicLabel extends StatelessWidget {
  /// Cria o rótulo [text].
  const RebicLabel(
    this.text, {
    this.design = RebicLabelDesign.standard,
    this.required = false,
    this.showColon = false,
    this.wrapping = false,
    this.textAlign = TextAlign.start,
    super.key,
  });

  /// Texto exibido.
  final String text;

  /// Desenho: padrão ou negrito.
  final RebicLabelDesign design;

  /// Se mostra o asterisco de obrigatório.
  final bool required;

  /// Se mostra os dois-pontos depois do texto.
  final bool showColon;

  /// Se o rótulo quebra linhas; sem quebra, ocupa uma linha com reticências.
  final bool wrapping;

  /// Alinhamento horizontal.
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final style = switch (design) {
      RebicLabelDesign.standard => theme.typography.base,
      RebicLabelDesign.bold => theme.typography.baseBold,
    }.copyWith(color: theme.colors.label);
    final colon = showColon ? ':' : '';
    // Asterisco como no `sap.m.Label`: tamanho `large`, negrito e cor
    // `required`. A métrica da linha é forçada à do texto, como o
    // `line-height: 0` do UI5, para o asterisco maior não aumentar a altura
    // do rótulo.
    final requiredStyle = theme.typography.large.copyWith(
      fontWeight: theme.typography.baseBold.fontWeight,
      color: theme.colors.required,
    );
    final strut = StrutStyle.fromTextStyle(style, forceStrutHeight: true);
    final gap = theme.spacing.xxs;
    final semanticLabel = required
        ? '$text$colon, ${RebicLocalizations.of(context).required}'
        : '$text$colon';

    final Widget label;
    if (wrapping) {
      label = Text.rich(
        TextSpan(
          text: '$text$colon',
          children: [
            if (required) ...[
              WidgetSpan(child: SizedBox(width: gap)),
              TextSpan(text: '*', style: requiredStyle),
            ],
          ],
        ),
        style: style,
        strutStyle: strut,
        textAlign: textAlign,
      );
    } else if (!showColon && !required) {
      label = Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      );
    } else {
      // Os sinais ficam fora do texto truncado, como o `::after` do
      // `sap.m.Label`, para continuarem visíveis com as reticências.
      final row = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: Text(
              text,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showColon) Text(colon, style: style),
          if (required)
            Padding(
              padding: EdgeInsetsDirectional.only(start: gap),
              child: Text('*', style: requiredStyle, strutStyle: strut),
            ),
        ],
      );
      final alignment = switch (textAlign) {
        TextAlign.start || TextAlign.justify => null,
        TextAlign.end => AlignmentDirectional.centerEnd,
        TextAlign.center => AlignmentDirectional.center,
        TextAlign.left => Alignment.centerLeft,
        TextAlign.right => Alignment.centerRight,
      };
      label = alignment == null ? row : Align(alignment: alignment, child: row);
    }
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: label,
    );
  }
}
