import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicToolbar": uma barra de cabeçalho de tabela, uma barra de
/// informação acionável e os desenhos.
class RebicToolbarPage extends StatefulWidget {
  /// Cria a página.
  const RebicToolbarPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicToolbar';

  /// Rota nomeada.
  static const route = '/rebic-toolbar';

  /// Texto da barra de informação.
  static const filters = '2 filtros ativos: Status, Data';

  /// Texto mostrado depois de tocar a barra de informação.
  static const cleared = 'Filtros limpos';

  @override
  State<RebicToolbarPage> createState() => _RebicToolbarPageState();
}

class _RebicToolbarPageState extends State<RebicToolbarPage> {
  bool _cleared = false;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicToolbarPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Barras de ferramentas no modelo do sap.m.Toolbar'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          alignItems: RebicFlexAlignItems.stretch,
          items: [
            RebicToolbar(
              content: [
                const RebicTitle(
                  'Pedidos (12)',
                  titleStyle: RebicTitleLevel.h5,
                ),
                const Spacer(),
                RebicButton(
                  icon: RebicIcons.add,
                  tooltip: 'Novo pedido',
                  type: RebicButtonType.transparent,
                  onPress: () {},
                ),
                RebicButton(
                  icon: RebicIcons.sort,
                  tooltip: 'Ordenar',
                  type: RebicButtonType.transparent,
                  onPress: () {},
                ),
                const RebicSeparator.vertical(),
                RebicButton(
                  icon: RebicIcons.actionSettings,
                  tooltip: 'Configurações',
                  type: RebicButtonType.transparent,
                  onPress: () {},
                ),
              ],
            ),
            if (_cleared)
              const RebicText(RebicToolbarPage.cleared)
            else
              RebicToolbar(
                design: RebicToolbarDesign.info,
                semanticLabel: RebicToolbarPage.filters,
                onPress: () => setState(() => _cleared = true),
                content: const [RebicText(RebicToolbarPage.filters)],
              ),
            for (final design in RebicToolbarDesign.values)
              RebicToolbar(
                design: design,
                content: [RebicText('Desenho ${design.name}')],
              ),
            const RebicToolbar(
              style: RebicToolbarStyle.clear,
              content: [RebicText('Estilo clear, sem borda')],
            ),
          ],
        ),
      ],
    );
  }
}
