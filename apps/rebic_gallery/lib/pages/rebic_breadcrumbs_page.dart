import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicBreadcrumbs": uma trilha navegável e os separadores.
class RebicBreadcrumbsPage extends StatefulWidget {
  /// Cria a página.
  const RebicBreadcrumbsPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicBreadcrumbs';

  /// Rota nomeada.
  static const route = '/rebic-breadcrumbs';

  /// Chave da trilha navegável.
  static const trailKey = Key('breadcrumbs-trail');

  @override
  State<RebicBreadcrumbsPage> createState() => _RebicBreadcrumbsPageState();
}

class _RebicBreadcrumbsPageState extends State<RebicBreadcrumbsPage> {
  static const _levels = ['Início', 'Vendas', 'Pedidos', 'Pedido 4711'];
  int _depth = _levels.length - 1;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicBreadcrumbsPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Trilhas no modelo do sap.m.Breadcrumbs'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            RebicBreadcrumbs(
              key: RebicBreadcrumbsPage.trailKey,
              semanticLabel: 'Caminho',
              links: [
                for (var i = 0; i < _depth; i++)
                  RebicLink(
                    text: _levels[i],
                    onPress: () => setState(() => _depth = i),
                  ),
              ],
              currentLocationText: _levels[_depth],
            ),
            if (_depth < _levels.length - 1)
              RebicButton(
                text: 'Voltar ao pedido',
                onPress: () => setState(() => _depth = _levels.length - 1),
              ),
            const RebicTitle(
              'Separadores',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            for (final style in RebicBreadcrumbsSeparator.values)
              RebicBreadcrumbs(
                separatorStyle: style,
                links: [
                  RebicLink(text: 'Início', onPress: () {}),
                  RebicLink(text: 'Pedidos', onPress: () {}),
                ],
                currentLocationText: style.name,
              ),
          ],
        ),
      ],
    );
  }
}
