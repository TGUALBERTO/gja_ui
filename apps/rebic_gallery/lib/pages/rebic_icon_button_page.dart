import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicIconButton": uma barra de ações de ícone, um botão de cada
/// tipo e um desabilitado.
class RebicIconButtonPage extends StatelessWidget {
  /// Cria a página.
  const RebicIconButtonPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicIconButton';

  /// Rota nomeada.
  static const route = '/rebic-icon-button';

  /// Ações da barra de exemplo.
  static const actions = [
    (RebicIcons.edit, 'Editar pedido'),
    (RebicIcons.delete, 'Excluir pedido'),
    (RebicIcons.download, 'Baixar PDF'),
    (RebicIcons.overflow, 'Mais ações'),
  ];

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Ações só com ícone, sempre com dica'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicColumn(
          gap: RebicSpace.l,
          children: [
            const RebicTitle(
              'Barra de ações',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicRow(
              gap: RebicSpace.xs,
              children: [
                for (final (icon, tooltip) in actions)
                  RebicIconButton(
                    icon: icon,
                    tooltip: tooltip,
                    onPressed: () {},
                  ),
              ],
            ),
            const RebicTitle(
              'Tipos',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicRow.wrap(
              children: [
                for (final type in RebicButtonType.values)
                  RebicIconButton(
                    icon: RebicIcons.accept,
                    tooltip: type.name,
                    type: type,
                    onPressed: () {},
                  ),
                const RebicIconButton(
                  icon: RebicIcons.accept,
                  tooltip: 'Desabilitado',
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
