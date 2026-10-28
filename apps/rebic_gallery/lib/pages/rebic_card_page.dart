import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicCard": cartões numa grade, um com cabeçalho acionável, um com
/// avatar e um sem margem com uma lista.
class RebicCardPage extends StatefulWidget {
  /// Cria a página.
  const RebicCardPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicCard';

  /// Rota nomeada.
  static const route = '/rebic-card';

  /// Título do cartão com cabeçalho acionável.
  static const pendingTitle = 'Pedidos pendentes';

  /// Mensagem mostrada ao acionar o cabeçalho.
  static const opened = 'Abrindo pedidos pendentes';

  @override
  State<RebicCardPage> createState() => _RebicCardPageState();
}

class _RebicCardPageState extends State<RebicCardPage> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicCardPage.title,
      subtitle: 'Cartões no modelo do sap.f.Card',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          if (_opened) const RebicText(RebicCardPage.opened),
          RebicGrid(
            children: [
              RebicCard(
                title: RebicCardPage.pendingTitle,
                subtitle: 'Compras',
                status: '3 de 5',
                onHeaderPressed: () => setState(() => _opened = true),
                child: const RebicColumn(
                  gap: RebicSpace.s,
                  children: [
                    RebicStatusIndicator(
                      icon: RebicIcons.warning,
                      text: '2 atrasados',
                      state: RebicValueState.warning,
                    ),
                    RebicText('Toque no cabeçalho para ver os pedidos.'),
                  ],
                ),
              ),
              const RebicCard(
                leading: RebicAvatar(initials: 'MB', size: RebicAvatarSize.xs),
                title: 'Maria Barros',
                subtitle: 'Fornecedor',
                child: RebicText('Entrega média em 4 dias úteis.'),
              ),
              RebicCard(
                title: 'Últimas notas',
                padded: false,
                child: RebicColumn(
                  gap: RebicSpace.none,
                  children: [
                    for (final (i, nota) in const [
                      'NF 1021 — R\$ 1.250,00',
                      'NF 1022 — R\$ 980,00',
                      'NF 1023 — R\$ 3.400,00',
                    ].indexed) ...[
                      if (i > 0) const RebicDivider(),
                      RebicSpacing.padding(
                        all: RebicSpace.m,
                        child: RebicText(nota),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
