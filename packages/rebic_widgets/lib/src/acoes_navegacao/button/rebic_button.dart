import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../exibicao_dados/progress_indicator/rebic_progress_view.dart';
import '../../exibicao_dados/tooltip/rebic_tooltip.dart';
import 'rebic_button_family.dart';

/// Tipo de um [RebicButton], no modelo dos tipos de botão do Fiori.
///
/// Cada tipo usa a família de controle de mesmo nome de `RebicControlFamily`.
enum RebicButtonType {
  /// Ação comum (Default do Fiori): fundo base, borda e texto da marca.
  standard,

  /// Ação principal da tela: fundo da marca.
  emphasized,

  /// Ação secundária sem fundo, como em barras de ferramentas.
  transparent,

  /// Ação positiva (aprovar, aceitar).
  accept,

  /// Ação negativa (rejeitar, excluir).
  reject,

  /// Ação que pede atenção antes de ser executada.
  attention,
}

/// Botão de ação, como o `sap.m.Button` do SAPUI5.
///
/// Com [text], mostra o texto e, antes dele, o [icon] opcional; a altura é
/// `density.controlHeight` (cresce com a escala de texto), e o texto fica
/// numa linha, com reticências quando não cabe. Sem [text], é o botão só com
/// ícone: um quadrado de lado `density.controlHeight` com o [icon] centrado,
/// e a [tooltip] é obrigatória, porque é o rótulo anunciado.
///
/// As cores vêm da família de controle do [type] em cada estado (hover,
/// pressionado, foco pelo teclado). Com [enabled] `false`, o botão fica
/// desabilitado: sem ativação, fora da ordem de foco e com a opacidade de
/// desabilitado. Com [onPress] nulo, continua habilitado, sem ação, como um
/// `sap.m.Button` sem tratador de `press`. Com [busy], mostra um indicador de
/// progresso no lugar do ícone e ignora os acionamentos, sem mudar as cores,
/// o tamanho nem o foco. A [tooltip] aparece no hover, no foco do teclado e
/// no toque longo, pelo `RebicTooltip`.
///
/// ```dart
/// RebicButton(
///   text: 'Salvar',
///   type: RebicButtonType.emphasized,
///   icon: RebicIcons.accept,
///   onPress: salvar,
/// )
///
/// RebicButton(
///   icon: RebicIcons.edit,
///   tooltip: 'Editar pedido',
///   type: RebicButtonType.transparent,
///   onPress: editar,
/// )
/// ```
class RebicButton extends StatelessWidget {
  /// Cria o botão com [text], [icon] ou os dois, acionado por [onPress].
  const RebicButton({
    this.text,
    this.icon,
    this.tooltip,
    this.type = RebicButtonType.standard,
    this.enabled = true,
    this.onPress,
    this.busy = false,
    super.key,
  }) : assert(
         (text != null && text != '') || icon != null,
         'RebicButton precisa de text não vazio ou de icon',
       ),
       assert(
         text != null || (tooltip != null && tooltip != ''),
         'RebicButton só com ícone precisa de tooltip não vazia',
       );

  /// Texto do botão, também anunciado pelo leitor de tela; nulo para o botão
  /// só com ícone.
  final String? text;

  /// Ícone, antes do texto ou sozinho.
  final IconData? icon;

  /// Dica; no botão só com ícone, também é o rótulo anunciado.
  final String? tooltip;

  /// Tipo, que define as cores.
  final RebicButtonType type;

  /// Se o botão pode ser acionado e focado.
  final bool enabled;

  /// Ação do botão; nula deixa o botão habilitado, sem ação.
  final VoidCallback? onPress;

  /// Se a ação está em andamento: mostra o indicador e ignora acionamentos.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final family = RebicControlColors.of(rebicButtonFamily(type), theme.colors);
    final corners = BorderRadius.circular(theme.radius.button);
    final text = this.text;
    final icon = this.icon;
    final tooltip = this.tooltip;
    final onPress = this.onPress;

    Widget button = RebicInteractable(
      semanticLabel: text ?? tooltip,
      onPressed: !enabled ? null : (busy || onPress == null ? () {} : onPress),
      focusRingBorderRadius: corners,
      builder: (context, states) {
        final c = family.resolve(states);
        final iconSize = theme.icons.control;
        // A trilha some no fundo do botão; só o arco aparece.
        final Widget? leading = busy
            ? RebicProgressView(
                circular: true,
                value: null,
                fill: c.text,
                track: c.background,
                extent: iconSize,
              )
            : (icon == null ? null : Icon(icon, size: iconSize, color: c.text));
        final Widget content = text == null
            ? SizedBox.square(
                dimension: theme.density.controlHeight,
                child: Center(child: leading),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: theme.density.controlHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.spacing.m),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: theme.spacing.xs,
                    children: [
                      ?leading,
                      Flexible(
                        child: Text(
                          text,
                          style: theme.typography.baseSemibold.copyWith(
                            color: c.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
        // O rótulo já está na semântica do botão; o conteúdo é visual.
        return ExcludeSemantics(
          child: Opacity(
            opacity: theme.interaction.opacity(states),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.background,
                // Linha fina padrão do framework, como no RebicContainer.
                border: Border.all(
                  color: c.border,
                  width: const BorderSide().width,
                ),
                borderRadius: corners,
              ),
              child: content,
            ),
          ),
        );
      },
    );
    if (tooltip != null) {
      // A semântica da dica é dada abaixo, no nó do botão.
      button = RebicTooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: button,
      );
    }
    // Um só nó: botão, rótulo, dica (com texto) e, ocupado, "Carregando".
    return MergeSemantics(
      child: Semantics(
        value: busy ? RebicLocalizations.of(context).loading : null,
        tooltip: text != null ? tooltip : null,
        child: button,
      ),
    );
  }
}
