import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

/// Link de ação, como o `sap.m.Link` do SAPUI5.
///
/// Mostra o [text] na cor `colors.link` (ou `colors.text`, com [subtle]) e no
/// estilo `typography.base` (ou `baseBold`, com [emphasized]), sublinhado
/// no hover e no pressionado. Sem [wrapping], fica numa linha e termina com
/// reticências quando não cabe. Com [onPressed] nulo, fica desabilitado. O
/// leitor de tela o anuncia como link, não como botão.
///
/// Abrir URLs fica fora do escopo: a ação é sempre [onPressed].
///
/// ```dart
/// RebicLink(text: 'Ver pedido 4711', onPressed: () => abrirPedido(4711))
/// ```
class RebicLink extends StatelessWidget {
  /// Cria o link [text], acionado por [onPressed].
  const RebicLink({
    required this.text,
    required this.onPressed,
    this.emphasized = false,
    this.subtle = false,
    this.wrapping = false,
    super.key,
  }) : assert(text != '', 'text não pode ser vazio');

  /// Texto do link, também anunciado pelo leitor de tela.
  final String text;

  /// Ação do link; nula desabilita o link.
  final VoidCallback? onPressed;

  /// Se o texto fica em negrito (`typography.baseBold`).
  final bool emphasized;

  /// Se o texto usa a cor do texto (`colors.text`) em vez da de link.
  final bool subtle;

  /// Se o texto quebra em várias linhas, em vez de terminar com reticências.
  final bool wrapping;

  @override
  Widget build(BuildContext context) {
    final theme = RebicThemeData.of(context);
    final base = emphasized
        ? theme.typography.baseBold
        : theme.typography.base;
    final color = subtle ? theme.colors.text : theme.colors.link;
    // Um só nó: o foco e o toque do detector se juntam ao link rotulado.
    return MergeSemantics(
      child: RebicInteractable(
        link: true,
        semanticLabel: text,
        onPressed: onPressed,
        focusRingBorderRadius: BorderRadius.circular(theme.radius.xs),
        builder: (context, states) {
          final underline =
              states.contains(RebicInteractionState.hovered) ||
              states.contains(RebicInteractionState.pressed);
          // O texto já está na semântica do link; o conteúdo é visual.
          return ExcludeSemantics(
            child: Opacity(
              opacity: theme.interaction.opacity(states),
              child: Text(
                text,
                style: base.copyWith(
                  color: color,
                  decoration: underline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: color,
                ),
                maxLines: wrapping ? null : 1,
                overflow: wrapping ? null : TextOverflow.ellipsis,
                softWrap: wrapping,
              ),
            ),
          );
        },
      ),
    );
  }
}
