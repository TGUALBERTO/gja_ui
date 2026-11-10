import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicMessageStrip": uma faixa de cada tipo, uma com link e uma que
/// pode ser fechada.
class RebicMessageStripPage extends StatefulWidget {
  /// Cria a página.
  const RebicMessageStripPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicMessageStrip';

  /// Rota nomeada.
  static const route = '/rebic-message-strip';

  /// Texto da faixa que pode ser fechada.
  static const closable = 'Esta faixa pode ser fechada.';

  @override
  State<RebicMessageStripPage> createState() => _RebicMessageStripPageState();
}

class _RebicMessageStripPageState extends State<RebicMessageStripPage> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicMessageStripPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Mensagens no modelo do sap.m.MessageStrip'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.s,
          alignItems: RebicFlexAlignItems.stretch,
          items: [
            for (final type in RebicValueState.values)
              RebicMessageStrip(
                text: 'Mensagem do tipo ${type.name}.',
                type: type,
                showIcon: true,
              ),
            RebicMessageStrip(
              text: 'O pedido 4711 aguarda aprovação.',
              type: RebicValueState.warning,
              showIcon: true,
              link: RebicLink(text: 'Abrir pedido', onPress: () {}),
            ),
            if (_visible)
              RebicMessageStrip(
                text: RebicMessageStripPage.closable,
                showCloseButton: true,
                onClose: () => setState(() => _visible = false),
              ),
          ],
        ),
      ],
    );
  }
}
