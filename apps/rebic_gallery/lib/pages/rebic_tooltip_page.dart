import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicTooltip": ícones com dica e um texto com dica longa.
class RebicTooltipPage extends StatelessWidget {
  /// Cria a página.
  const RebicTooltipPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicTooltip';

  /// Rota nomeada.
  static const route = '/rebic-tooltip';

  /// Ícones de exemplo e as dicas deles.
  static const examples = [
    (RebicIcons.edit, 'Editar pedido'),
    (RebicIcons.delete, 'Excluir pedido'),
    (RebicIcons.download, 'Baixar PDF'),
  ];

  /// Chave do primeiro ícone de exemplo.
  static const firstIconKey = Key('tooltip-first-icon');

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Passe o ponteiro, foque pelo teclado ou toque longamente',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicColumn(
          gap: RebicSpace.l,
          children: [
            const RebicTitle(
              'Ícones',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicRow(
              gap: RebicSpace.l,
              children: [
                for (final (i, (icon, message)) in examples.indexed)
                  RebicTooltip(
                    message: message,
                    child: RebicIcon(
                      icon,
                      key: i == 0 ? firstIconKey : null,
                      tone: RebicIconTone.brand,
                      size: RebicIconSize.large,
                    ),
                  ),
              ],
            ),
            const RebicTitle(
              'Dica longa',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicTooltip(
              message:
                  'Pedidos aguardando aprovação há mais de cinco dias úteis são '
                  'enviados ao gestor do centro de custo.',
              child: RebicText('Regra de escalonamento'),
            ),
          ],
        ),
      ],
    );
  }
}
