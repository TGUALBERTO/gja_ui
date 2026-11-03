import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicMessageToast": botões que mostram avisos breves.
class RebicMessageToastPage extends StatelessWidget {
  /// Cria a página.
  const RebicMessageToastPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicMessageToast';

  /// Rota nomeada.
  static const route = '/rebic-message-toast';

  /// Mensagem do botão "Salvar".
  static const saved = 'Pedido salvo';

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Avisos breves no modelo do sap.m.MessageToast'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicHBox(
          items: [
            RebicButton(
              text: 'Salvar',
              type: RebicButtonType.emphasized,
              onPress: () => RebicMessageToast.show(context, saved),
            ),
            RebicButton(
              text: 'Enviar',
              onPress: () => RebicMessageToast.show(
                context,
                'O pedido 4711 foi enviado para aprovação do gestor.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
