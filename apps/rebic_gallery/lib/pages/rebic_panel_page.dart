import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicPanel": painel fixo e acordeão de painéis expansíveis.
class RebicPanelPage extends StatefulWidget {
  /// Cria a página.
  const RebicPanelPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicPanel';

  /// Rota nomeada.
  static const route = '/rebic-panel';

  @override
  State<RebicPanelPage> createState() => _RebicPanelPageState();
}

class _RebicPanelPageState extends State<RebicPanelPage> {
  /// Painel aberto do acordeão; só um por vez.
  String? _open = 'itens';

  RebicPanel _section(String key, String title, String text) => RebicPanel(
    headerText: title,
    expandable: true,
    expanded: _open == key,
    onExpand: (value) => setState(() => _open = value ? key : null),
    content: [RebicText(text)],
  );

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicPanelPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Painel no modelo do sap.m.Panel'),
        const RebicSpacing.vertical(RebicSpace.l),
        const RebicPanel(
          headerText: 'Endereço de entrega',
          content: [RebicText('Rua das Flores, 10 — Centro, Belo Horizonte')],
        ),
        const RebicSpacing.vertical(RebicSpace.xl),
        const RebicTitle('Acordeão: painéis expansíveis empilhados'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          alignItems: RebicFlexAlignItems.stretch,
          items: [
            _section('itens', 'Itens', '12 itens no pedido 4711.'),
            _section('pagamento', 'Pagamento', 'Boleto em 30 dias'),
            _section(
              'entrega',
              'Entrega',
              'Transportadora, em até 5 dias úteis.',
            ),
          ],
        ),
      ],
    );
  }
}
