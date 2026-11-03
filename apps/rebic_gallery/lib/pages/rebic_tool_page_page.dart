import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicToolPage": a página é uma página de ferramentas de
/// demonstração, com `RebicShellBar`, navegação no estado automático e
/// conteúdo principal.
class RebicToolPagePage extends StatelessWidget {
  /// Cria a página.
  const RebicToolPagePage({super.key});

  /// Título no índice.
  static const title = 'RebicToolPage';

  /// Rota nomeada.
  static const route = '/rebic-tool-page';

  /// Chave da navegação de demonstração.
  static const navigationKey = Key('tool-page-navigation');

  /// Chave do conteúdo principal.
  static const mainKey = Key('tool-page-main');

  /// Texto do conteúdo principal.
  static const bodyText =
      'A navegação começa expandida, exceto em telas pequenas, e depois só '
      'muda pelo botão de menu da barra. Em telas pequenas, ela cobre o '
      'conteúdo principal.';

  @override
  Widget build(BuildContext context) {
    return RebicToolPage(
      header: Builder(
        builder: (context) => RebicShellBar(
          title: 'Compras',
          homeIcon: const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
          showNavButton: true,
          onNavButtonPressed: () => Navigator.of(context).maybePop(),
          showMenuButton: true,
          onMenuButtonPressed: () =>
              RebicToolPage.toggleSideContentMode(context),
        ),
      ),
      sideContent: const _DemoNavigation(key: navigationKey),
      mainContents: [
        ListView(
          key: mainKey,
          children: const [
            RebicSpacing.padding(
              all: RebicSpace.pageMargin,
              child: RebicVBox(
                gap: RebicSpace.l,
                items: [
                  RebicTitle(
                    title,
                    level: RebicTitleLevel.h1,
                    titleStyle: RebicTitleLevel.h2,
                  ),
                  RebicText(bodyText),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Navegação de demonstração: ícones com rótulo quando expandida e só ícones
/// quando recolhida, sobre a superfície `base`, como a `SideNavigation`.
class _DemoNavigation extends StatelessWidget {
  const _DemoNavigation({super.key});

  static const _items = [
    (RebicIcons.home, 'Início'),
    (RebicIcons.document, 'Pedidos'),
    (RebicIcons.personPlaceholder, 'Fornecedores'),
    (RebicIcons.actionSettings, 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
    final expanded = RebicToolPage.sideExpandedOf(context) ?? true;
    return RebicContainer(
      surface: RebicSurface.base,
      child: RebicSpacing.padding(
        vertical: RebicSpace.s,
        child: RebicVBox(
          gap: RebicSpace.none,
          items: [
            for (final (icon, label) in _items)
              RebicSpacing.padding(
                horizontal: RebicSpace.m,
                vertical: RebicSpace.s,
                child: RebicHBox(
                  items: [
                    RebicIcon(icon, semanticLabel: expanded ? null : label),
                    if (expanded) RebicText(label),
                    // Largura da navegação expandida, como a da Fiori.
                    if (expanded)
                      const RebicSpacing.horizontal(RebicSpace.xxxl),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
