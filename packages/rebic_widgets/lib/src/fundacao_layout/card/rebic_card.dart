import 'package:flutter/widgets.dart';
import 'package:rebic_core/rebic_core.dart';
import 'package:rebic_foundation/rebic_foundation.dart';

import '../container/rebic_container.dart';
import '../divider/rebic_divider.dart';
import '../spacing/rebic_spacing.dart';
import '../text/rebic_text.dart';

/// Cartão, como o `sap.f.Card` do SAPUI5.
///
/// Uma superfície `base` com borda, raio `container` e sombra `card`, na
/// largura disponível. Com [title], mostra o cabeçalho: o [leading] (ex.: um
/// `RebicAvatar`), o título e o [subtitle] (até 2 linhas cada) e o [status]
/// no fim (ex.: "3 de 5"), separado do conteúdo por um divisor. O [child]
/// tem a margem `spacing.l`, ou nenhuma com [padded] `false` (listas,
/// tabelas). Com [onHeaderPressed], o cabeçalho é acionável e anunciado como
/// botão; o cartão em si não é interativo.
///
/// ```dart
/// RebicCard(
///   leading: const RebicAvatar(initials: 'MB', size: RebicAvatarSize.xs),
///   title: 'Pedidos pendentes',
///   subtitle: 'Compras',
///   status: '3 de 5',
///   onHeaderPressed: abrirPedidos,
///   child: const ListaDePedidos(),
/// )
/// ```
class RebicCard extends StatelessWidget {
  /// Cria o cartão com o conteúdo [child].
  const RebicCard({
    required this.child,
    this.title,
    this.subtitle,
    this.status,
    this.leading,
    this.padded = true,
    this.onHeaderPressed,
    super.key,
  }) : assert(
         title != null ||
             (subtitle == null &&
                 status == null &&
                 leading == null &&
                 onHeaderPressed == null),
         'subtitle, status, leading e onHeaderPressed exigem title',
       );

  /// Conteúdo do cartão.
  final Widget child;

  /// Título do cabeçalho; nulo omite o cabeçalho.
  final String? title;

  /// Texto secundário abaixo do título.
  final String? subtitle;

  /// Situação no fim do cabeçalho (ex.: "3 de 5").
  final String? status;

  /// Elemento no início do cabeçalho (ex.: um avatar ou ícone).
  final Widget? leading;

  /// Se o conteúdo tem a margem `spacing.l`.
  final bool padded;

  /// Ação do cabeçalho acionável; nula deixa o cabeçalho informativo.
  final VoidCallback? onHeaderPressed;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final content = padded
        ? RebicSpacing.padding(all: RebicSpace.l, child: child)
        : child;
    return RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.container,
      elevation: RebicElevation.card,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[_header(context, title), const RebicDivider()],
          content,
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String title) {
    final theme = RebicThemeData.of(context);
    final subtitle = this.subtitle;
    final status = this.status;
    Widget row(Color? background) {
      final header = RebicSpacing.padding(
        all: RebicSpace.l,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: theme.spacing.m,
          children: [
            ?leading,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: theme.spacing.xxs,
                children: [
                  // O título de cartão é menor que o de página, como no Fiori,
                  // e continua anunciado como cabeçalho.
                  RebicText(
                    title,
                    variant: RebicTextVariant.subtitle,
                    heading: true,
                    maxLines: 2,
                  ),
                  if (subtitle != null)
                    RebicText(subtitle, tone: RebicTextTone.muted, maxLines: 2),
                ],
              ),
            ),
            if (status != null)
              RebicText(
                status,
                variant: RebicTextVariant.label,
                tone: RebicTextTone.muted,
                maxLines: 1,
              ),
          ],
        ),
      );
      // Só o hover pinta o fundo; nos demais estados, o da superfície.
      return background == null
          ? header
          : ColoredBox(color: background, child: header);
    }

    final onPressed = onHeaderPressed;
    if (onPressed == null) return row(null);
    // Um só nó: o botão do cabeçalho, rotulado por título e subtítulo.
    return MergeSemantics(
      child: RebicInteractable(
        semanticLabel: subtitle == null ? title : '$title, $subtitle',
        onPressed: onPressed,
        focusRingBorderRadius: BorderRadius.circular(theme.radius.container),
        builder: (context, states) => ExcludeSemantics(
          child: row(
            states.contains(RebicInteractionState.hovered)
                ? theme.colors.hoverBackground
                : null,
          ),
        ),
      ),
    );
  }
}
