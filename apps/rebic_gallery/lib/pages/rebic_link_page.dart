import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicLink": variantes, um link com quebra e "Ver pedido 4711",
/// que mostra uma mensagem ao ser acionado.
class RebicLinkPage extends StatefulWidget {
  /// Cria a página.
  const RebicLinkPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicLink';

  /// Rota nomeada.
  static const route = '/rebic-link';

  /// Texto do link de exemplo e a mensagem que ele mostra.
  static const orderLink = 'Ver pedido 4711';

  /// Mensagem mostrada ao acionar [orderLink].
  static const opened = 'Pedido 4711 aberto';

  @override
  State<RebicLinkPage> createState() => _RebicLinkPageState();
}

class _RebicLinkPageState extends State<RebicLinkPage> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicLinkPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Navegação secundária e referências a objetos'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicColumn(
          gap: RebicSpace.l,
          children: [
            const RebicTitle(
              'Variantes',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicLink(
              text: RebicLinkPage.orderLink,
              onPressed: () => setState(() => _opened = true),
            ),
            if (_opened) const RebicText(RebicLinkPage.opened),
            RebicLink(text: 'Link sutil', subtle: true, onPressed: () {}),
            RebicLink(
              text: 'Link enfatizado',
              emphasized: true,
              onPressed: () {},
            ),
            const RebicLink(text: 'Link desabilitado', onPressed: null),
            const RebicTitle(
              'Com quebra',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            SizedBox(
              width: 240,
              child: RebicLink(
                text:
                    'Ver todos os pedidos aguardando aprovação do gestor do '
                    'centro de custo',
                wrapping: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
