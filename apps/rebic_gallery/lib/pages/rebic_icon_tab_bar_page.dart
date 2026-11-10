import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicIconTabBar": abas de texto e abas com ícone e contagem.
class RebicIconTabBarPage extends StatefulWidget {
  /// Cria a página.
  const RebicIconTabBarPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicIconTabBar';

  /// Rota nomeada.
  static const route = '/rebic-icon-tab-bar';

  /// Conteúdo da aba "Anexos".
  static const attachments = 'Contrato.pdf e Nota fiscal.xml';

  @override
  State<RebicIconTabBarPage> createState() => _RebicIconTabBarPageState();
}

class _RebicIconTabBarPageState extends State<RebicIconTabBarPage> {
  String _text = 'itens';
  String _icons = 'abertos';

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicIconTabBarPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Abas no modelo do sap.m.IconTabBar'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.xl,
          alignItems: RebicFlexAlignItems.stretch,
          items: [
            RebicIconTabBar<String>(
              selectedKey: _text,
              onSelect: (key) => setState(() => _text = key),
              items: const [
                RebicIconTabFilter(
                  key: 'itens',
                  text: 'Itens',
                  content: RebicText('12 itens no pedido 4711.'),
                ),
                RebicIconTabFilter(
                  key: 'notas',
                  text: 'Notas',
                  content: RebicText('Entregar no período da manhã.'),
                ),
                RebicIconTabFilter(
                  key: 'anexos',
                  text: 'Anexos',
                  content: RebicText(RebicIconTabBarPage.attachments),
                ),
              ],
            ),
            RebicIconTabBar<String>(
              selectedKey: _icons,
              onSelect: (key) => setState(() => _icons = key),
              items: const [
                RebicIconTabFilter(
                  key: 'abertos',
                  text: 'Abertos',
                  icon: RebicIcons.pending,
                  count: '8',
                  content: RebicText('8 pedidos abertos.'),
                ),
                RebicIconTabFilter(
                  key: 'aprovados',
                  text: 'Aprovados',
                  icon: RebicIcons.sysEnter2,
                  count: '21',
                  content: RebicText('21 pedidos aprovados.'),
                ),
                RebicIconTabFilter(
                  key: 'arquivados',
                  text: 'Arquivados',
                  icon: RebicIcons.folderBlank,
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
