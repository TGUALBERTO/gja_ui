import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicSideNavigation": navegação com subitens e itens fixos, que
/// pode ser recolhida.
class RebicSideNavigationPage extends StatefulWidget {
  /// Cria a página.
  const RebicSideNavigationPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicSideNavigation';

  /// Rota nomeada.
  static const route = '/rebic-side-navigation';

  @override
  State<RebicSideNavigationPage> createState() =>
      _RebicSideNavigationPageState();
}

class _RebicSideNavigationPageState extends State<RebicSideNavigationPage> {
  String _page = 'inicio';
  String _text = 'Início';
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicSideNavigationPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Navegação lateral no modelo do sap.tnt.SideNavigation',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicButton(
          text: _expanded ? 'Recolher' : 'Expandir',
          onPress: () => setState(() => _expanded = !_expanded),
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        SizedBox(
          height: 420,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RebicSideNavigation<String>(
                semanticLabel: 'Navegação principal',
                selectedKey: _page,
                expanded: _expanded,
                onItemSelect: (key) => setState(() {
                  _page = key;
                  _text = _texts[key]!;
                }),
                items: const [
                  RebicNavigationListItem(
                    key: 'inicio',
                    text: 'Início',
                    icon: RebicIcons.home,
                  ),
                  RebicNavigationListItem(
                    key: 'vendas',
                    text: 'Vendas',
                    icon: RebicIcons.document,
                    selectable: false,
                    items: [
                      RebicNavigationListItem(key: 'pedidos', text: 'Pedidos'),
                      RebicNavigationListItem(key: 'faturas', text: 'Faturas'),
                    ],
                  ),
                  RebicNavigationListItem(
                    key: 'clientes',
                    text: 'Clientes',
                    icon: RebicIcons.personPlaceholder,
                  ),
                  RebicNavigationListItem(
                    key: 'relatorios',
                    text: 'Relatórios',
                    icon: RebicIcons.folderBlank,
                    enabled: false,
                  ),
                ],
                fixedItems: const [
                  RebicNavigationListItem(
                    key: 'configuracoes',
                    text: 'Configurações',
                    icon: RebicIcons.actionSettings,
                  ),
                  RebicNavigationListItem(
                    key: 'ajuda',
                    text: 'Ajuda',
                    icon: RebicIcons.sysHelp,
                  ),
                ],
              ),
              const RebicSpacing.horizontal(RebicSpace.l),
              Expanded(child: RebicText('Página: $_text')),
            ],
          ),
        ),
      ],
    );
  }
}

const _texts = {
  'inicio': 'Início',
  'pedidos': 'Pedidos',
  'faturas': 'Faturas',
  'clientes': 'Clientes',
  'configuracoes': 'Configurações',
  'ajuda': 'Ajuda',
};
