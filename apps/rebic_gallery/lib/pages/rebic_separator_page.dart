import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicSeparator": separadores horizontais entre itens de uma coluna
/// e um separador vertical entre ações de um `RebicBar`.
class RebicSeparatorPage extends StatelessWidget {
  /// Cria a página.
  const RebicSeparatorPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicSeparator';

  /// Rota nomeada.
  static const route = '/rebic-separator';

  /// Chave da coluna com separadores horizontais.
  static const listKey = Key('separator-list');

  /// Chave da barra com separador vertical.
  static const barKey = Key('separator-bar');

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Separadores no modelo do sap.m.ToolbarSeparator'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicTitle(
              'Horizontal',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicVBox(
              key: listKey,
              gap: RebicSpace.s,
              items: [
                RebicText('Item 1'),
                RebicSeparator(),
                RebicText('Item 2'),
                RebicSeparator(),
                RebicText('Item 3'),
              ],
            ),
            const RebicTitle(
              'Vertical numa barra',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicBar(
              key: barKey,
              contentLeft: [
                RebicButton(label: 'Salvar', onPressed: () {}),
                const RebicSeparator.vertical(),
                RebicButton(label: 'Copiar', onPressed: () {}),
                RebicButton(label: 'Excluir', onPressed: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
