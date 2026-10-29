import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../../exibicao_dados/tooltip/rebic_tooltip.dart';
import '../button/rebic_button.dart';
import '../button/rebic_button_family.dart';

/// Botão só com ícone, como o `sap.m.Button` com `icon` e `tooltip` do
/// SAPUI5.
///
/// Quadrado, com o lado `density.controlHeight` e o [icon] no tamanho
/// `icons.control`, nas cores da família de controle do [type] (padrão
/// `transparent`, como nas barras Fiori) em cada estado. A [tooltip] é
/// obrigatória: é o rótulo anunciado pelo leitor de tela e a dica mostrada
/// pelo `RebicTooltip` no hover, no foco do teclado e no toque longo. Com
/// [onPressed] nulo, o botão fica desabilitado.
///
/// ```dart
/// RebicIconButton(
///   icon: RebicIcons.edit,
///   tooltip: 'Editar pedido',
///   onPressed: editar,
/// )
/// ```
class RebicIconButton extends StatelessWidget {
  /// Cria o botão de [icon], descrito por [tooltip].
  const RebicIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.type = RebicButtonType.transparent,
    super.key,
  }) : assert(tooltip != '', 'tooltip não pode ser vazia');

  /// Ícone, do catálogo `RebicIcons` ou da aplicação.
  final IconData icon;

  /// Rótulo do leitor de tela e texto da dica.
  final String tooltip;

  /// Ação do botão; nula desabilita o botão.
  final VoidCallback? onPressed;

  /// Tipo, que define as cores.
  final RebicButtonType type;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final family = RebicControlColors.of(rebicButtonFamily(type), theme.colors);
    final corners = BorderRadius.circular(theme.radius.button);
    // A dica é o rótulo do botão; não é anunciada de novo como dica.
    return RebicTooltip(
      message: tooltip,
      excludeFromSemantics: true,
      // Um só nó: o foco e o toque do detector se juntam ao botão rotulado.
      child: MergeSemantics(
        child: RebicInteractable(
          semanticLabel: tooltip,
          onPressed: onPressed,
          focusRingBorderRadius: corners,
          builder: (context, states) {
            final c = family.resolve(states);
            return ExcludeSemantics(
              child: Opacity(
                opacity: theme.interaction.opacity(states),
                child: SizedBox.square(
                  dimension: theme.density.controlHeight,
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
                    child: Center(
                      child: Icon(
                        icon,
                        size: theme.icons.control,
                        color: c.text,
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
