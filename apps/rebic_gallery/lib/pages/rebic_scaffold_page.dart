import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicScaffold": a página é um scaffold de demonstração, com barra,
/// navegação no estado automático e corpo.
class RebicScaffoldPage extends StatelessWidget {
  /// Cria a página.
  const RebicScaffoldPage({super.key});

  /// Título no índice.
  static const title = 'RebicScaffold';

  /// Rota nomeada.
  static const route = '/rebic-scaffold';

  /// Chave da navegação de demonstração.
  static const navigationKey = Key('scaffold-navigation');

  /// Texto do corpo.
  static const bodyText =
      'Redimensione a janela: a navegação fica expandida em telas grandes, '
      'recolhida em ícones em telas médias e, em telas pequenas, abre sobre o '
      'corpo pelo botão de navegação.';

  @override
  Widget build(BuildContext context) {
    return RebicScaffold(
      logo: const RebicIcon(RebicIcons.home, tone: RebicIconTone.brand),
      title: 'Compras',
      actions: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Semantics(button: true, child: const RebicText('← Voltar')),
        ),
      ],
      navigation: const _DemoNavigation(key: navigationKey),
      body: ListView(
        children: const [
          RebicSpacing.padding(
            all: RebicSpace.pageMargin,
            child: RebicColumn(
              gap: RebicSpace.l,
              children: [
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
    );
  }
}

/// Navegação de demonstração: ícones com rótulo quando expandida e só ícones
/// quando recolhida.
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
    final expanded = RebicScaffold.navigationExpandedOf(context) ?? true;
    return RebicSpacing.padding(
      vertical: RebicSpace.s,
      child: RebicColumn(
        gap: RebicSpace.none,
        children: [
          for (final (icon, label) in _items)
            RebicSpacing.padding(
              horizontal: RebicSpace.m,
              vertical: RebicSpace.s,
              child: RebicRow(
                children: [
                  RebicIcon(icon, semanticLabel: expanded ? null : label),
                  if (expanded) RebicText(label),
                  // Largura da navegação expandida, como a da Fiori.
                  if (expanded) const RebicSpacing.horizontal(RebicSpace.xxxl),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
