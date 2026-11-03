import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicCard": cartões numa grade, com `RebicCardHeader`: um
/// acionável, um com ícone, status e data, um com o cabeçalho embaixo, um com
/// barra de ferramentas e um com uma lista sem margem.
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

  /// Chave do cabeçalho com ícone, status e data.
  static const fullHeaderKey = Key('card-header-full');

  /// Chave do cartão com o cabeçalho embaixo.
  static const bottomCardKey = Key('card-bottom');

  /// Chave do cabeçalho com barra de ferramentas.
  static const toolbarHeaderKey = Key('card-header-toolbar');

  @override
  State<RebicCardPage> createState() => _RebicCardPageState();
}

class _RebicCardPageState extends State<RebicCardPage> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    Widget padded(Widget child) =>
        RebicSpacing.padding(all: RebicSpace.l, child: child);
    return RebicPage(
      title: RebicCardPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Cartões no modelo do sap.f.Card'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            if (_opened) const RebicText(RebicCardPage.opened),
            RebicGrid(
              content: [
                RebicCard(
                  header: RebicCardHeader(
                    title: RebicCardPage.pendingTitle,
                    subtitle: 'Compras',
                    statusText: '3 de 5',
                    onPress: () => setState(() => _opened = true),
                  ),
                  content: padded(
                    const RebicVBox(
                      gap: RebicSpace.s,
                      items: [
                        RebicStatusIndicator(
                          icon: RebicIcons.warning,
                          text: '2 atrasados',
                          state: RebicValueState.warning,
                        ),
                        RebicText('Toque no cabeçalho para ver os pedidos.'),
                      ],
                    ),
                  ),
                ),
                RebicCard(
                  header: const RebicCardHeader(
                    key: RebicCardPage.fullHeaderKey,
                    iconInitials: 'MB',
                    iconAlt: 'Maria Barros',
                    title: 'Maria Barros',
                    subtitle: 'Fornecedor',
                    statusText: 'Ativo',
                    dataTimestamp: 'Há 5 min',
                  ),
                  content: padded(
                    const RebicText('Entrega média em 4 dias úteis.'),
                  ),
                ),
                RebicCard(
                  key: RebicCardPage.bottomCardKey,
                  headerPosition: RebicCardHeaderPosition.bottom,
                  header: const RebicCardHeader(
                    icon: RebicIcons.calendar,
                    title: 'Entregas de hoje',
                    subtitle: 'Depósito central',
                  ),
                  content: padded(
                    const RebicText('2 entregas previstas até as 18h.'),
                  ),
                ),
                RebicCard(
                  header: RebicCardHeader(
                    key: RebicCardPage.toolbarHeaderKey,
                    title: 'Últimas notas',
                    toolbar: RebicIconButton(
                      icon: RebicIcons.overflow,
                      tooltip: 'Mais',
                      onPressed: () {},
                    ),
                  ),
                  content: RebicVBox(
                    gap: RebicSpace.none,
                    items: [
                      for (final (i, nota) in const [
                        'NF 1021 — R\$ 1.250,00',
                        'NF 1022 — R\$ 980,00',
                        'NF 1023 — R\$ 3.400,00',
                      ].indexed) ...[
                        if (i > 0) const RebicSeparator(),
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
      ],
    );
  }
}
