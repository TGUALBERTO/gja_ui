import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../exibicao_dados/progress_indicator/rebic_progress_view.dart';
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
/// Mostra o [label] e, antes dele, o [icon] opcional, com as cores da família
/// de controle do [type] em cada estado (hover, pressionado, foco pelo
/// teclado). Com [onPressed] nulo, fica desabilitado: sem ativação, fora da
/// ordem de foco e com a opacidade de desabilitado. Com [busy], mostra um
/// indicador de progresso no lugar do ícone e ignora os acionamentos, sem
/// mudar as cores nem o foco.
///
/// A altura é `density.controlHeight` (cresce com a escala de texto), e o
/// rótulo fica numa linha, com reticências quando não cabe.
///
/// ```dart
/// RebicButton(
///   label: 'Salvar',
///   type: RebicButtonType.emphasized,
///   icon: RebicIcons.accept,
///   onPressed: salvar,
/// )
/// ```
class RebicButton extends StatelessWidget {
  /// Cria o botão [label], acionado por [onPressed].
  const RebicButton({
    required this.label,
    required this.onPressed,
    this.type = RebicButtonType.standard,
    this.icon,
    this.busy = false,
    super.key,
  }) : assert(label != '', 'label não pode ser vazio');

  /// Rótulo do botão, também anunciado pelo leitor de tela.
  final String label;

  /// Ação do botão; nula desabilita o botão.
  final VoidCallback? onPressed;

  /// Tipo, que define as cores.
  final RebicButtonType type;

  /// Ícone opcional, antes do rótulo.
  final IconData? icon;

  /// Se a ação está em andamento: mostra o indicador e ignora acionamentos.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final family = RebicControlColors.of(rebicButtonFamily(type), theme.colors);
    final corners = BorderRadius.circular(theme.radius.button);
    final onPressed = this.onPressed;
    final icon = this.icon;

    // Um só nó: botão, rótulo e, ocupado, o valor "Carregando".
    return MergeSemantics(
      child: Semantics(
        value: busy ? RebicLocalizations.of(context).loading : null,
        child: RebicInteractable(
          semanticLabel: label,
          onPressed: onPressed == null ? null : (busy ? () {} : onPressed),
          focusRingBorderRadius: corners,
          builder: (context, states) {
            final c = family.resolve(states);
            final iconSize = theme.icons.control;
            // O rótulo já está na semântica do botão; o conteúdo é visual.
            return ExcludeSemantics(
              child: Opacity(
                opacity: theme.interaction.opacity(states),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: theme.density.controlHeight,
                  ),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.m,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: theme.spacing.xs,
                        children: [
                          // A trilha some no fundo do botão; só o arco aparece.
                          if (busy)
                            RebicProgressView(
                              circular: true,
                              value: null,
                              fill: c.text,
                              track: c.background,
                              extent: iconSize,
                            )
                          else if (icon != null)
                            Icon(icon, size: iconSize, color: c.text),
                          Flexible(
                            child: Text(
                              label,
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
