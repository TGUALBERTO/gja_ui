import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../icon/rebic_icon.dart';

/// Botão de ícone da família `transparent`, interno ao pacote (não
/// exportado), usado pelo botão de navegação do `RebicScaffold` e pelo de
/// voltar da `RebicPage` até existir o `RebicIconButton`.
///
/// Expõe um só nó de semântica: botão, [semanticLabel] e, quando [expanded]
/// não é nulo, o estado expandido.
class RebicTransparentIconAction extends StatelessWidget {
  /// Cria o botão de [icon].
  const RebicTransparentIconAction({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.expanded,
    super.key,
  });

  /// Ícone, do catálogo `RebicIcons`.
  final IconData icon;

  /// Rótulo anunciado pelo leitor de tela.
  final String semanticLabel;

  /// Ação do botão.
  final VoidCallback onPressed;

  /// Estado expandido do que o botão controla; nulo não o anuncia.
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final colors = RebicControlColors.of(
      RebicControlFamily.transparent,
      theme.colors,
    );
    // Um só nó: botão, rótulo e estado expandido.
    return MergeSemantics(
      child: Semantics(
        expanded: expanded,
        child: RebicInteractable(
          semanticLabel: semanticLabel,
          onPressed: onPressed,
          builder: (context, states) {
            final c = colors.resolve(states);
            return SizedBox.square(
              dimension: theme.density.controlHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.background,
                  borderRadius: BorderRadius.circular(theme.radius.control),
                ),
                // O ícone toma a cor de texto do estado (ex.: contraste no
                // pressionado), que os tons de `RebicIcon` não cobrem.
                child: Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(c.text, BlendMode.srcIn),
                    child: RebicIcon(icon),
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
