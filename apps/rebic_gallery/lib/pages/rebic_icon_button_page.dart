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
      subtitle: 'Ações só com ícone, sempre com dica',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Barra de ações', variant: RebicTextVariant.title),
          RebicRow(
            gap: RebicSpace.xs,
            children: [
              for (final (icon, tooltip) in actions)
                RebicIconButton(icon: icon, tooltip: tooltip, onPressed: () {}),
            ],
          ),
          const RebicText('Tipos', variant: RebicTextVariant.title),
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
    );
  }
}
