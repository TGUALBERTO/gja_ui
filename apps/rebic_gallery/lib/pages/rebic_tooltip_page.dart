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
      subtitle: 'Passe o ponteiro, foque pelo teclado ou toque longamente',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Ícones', variant: RebicTextVariant.title),
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
          const RebicText('Dica longa', variant: RebicTextVariant.title),
          const RebicTooltip(
            message:
                'Pedidos aguardando aprovação há mais de cinco dias úteis são '
                'enviados ao gestor do centro de custo.',
            child: RebicText('Regra de escalonamento'),
          ),
        ],
      ),
    );
  }
}
