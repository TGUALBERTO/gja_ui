import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicPage": construída com `RebicPage`, com voltar, conteúdo do
/// cabeçalho, subcabeçalho, conteúdo rolável e rodapé, que pode flutuar, e a
/// escolha do fundo.
class RebicPagePage extends StatefulWidget {
  /// Cria a página.
  const RebicPagePage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicPage';

  /// Rota nomeada.
  static const route = '/rebic-page';

  /// Chave do botão que alterna o rodapé flutuante.
  static const floatingKey = Key('rebic-page-floating');

  /// Chave do botão de cada fundo.
  static Key designKey(RebicPageBackgroundDesign design) =>
      Key('rebic-page-design-${design.name}');

  @override
  State<RebicPagePage> createState() => _RebicPagePageState();
}

class _RebicPagePageState extends State<RebicPagePage> {
  var _design = RebicPageBackgroundDesign.standard;
  var _floating = false;

  @override
  Widget build(BuildContext context) {
    void back() => Navigator.of(context).maybePop();
    return RebicPage(
      title: RebicPagePage.title,
      showNavButton: true,
      onNavButtonPress: back,
      headerContent: [
        RebicIconButton(
          icon: RebicIcons.sysHelp,
          tooltip: 'Ajuda',
          onPressed: () {},
        ),
      ],
      subHeader: const RebicBar(
        contentMiddle: [RebicLabel('Cabeçalho, conteúdo e rodapé')],
      ),
      backgroundDesign: _design,
      contentPadding: RebicContentPadding.responsive,
      floatingFooter: _floating,
      footer: RebicBar(
        contentRight: [
          RebicButton(label: 'Cancelar', onPressed: back),
          RebicButton(
            label: 'Salvar',
            type: RebicButtonType.emphasized,
            onPressed: back,
          ),
        ],
      ),
      content: [
        RebicColumn(
          gap: RebicSpace.l,
          children: [
            const RebicTitle(
              'Quando usar',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicText(
              'Use RebicPage como conteúdo principal do RebicToolPage ou como '
              'página de uma rota. O botão de voltar aparece com '
              'showNavButton, e o rodapé, com footer.',
            ),
            const RebicTitle(
              'Fundo',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicRow.wrap(
              children: [
                for (final design in RebicPageBackgroundDesign.values)
                  RebicButton(
                    key: RebicPagePage.designKey(design),
                    label: design.name,
                    type: design == _design
                        ? RebicButtonType.emphasized
                        : RebicButtonType.standard,
                    onPressed: () => setState(() => _design = design),
                  ),
              ],
            ),
            const RebicTitle(
              'Rodapé',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicButton(
              key: RebicPagePage.floatingKey,
              label: _floating ? 'Rodapé fixo' : 'Rodapé flutuante',
              onPressed: () => setState(() => _floating = !_floating),
            ),
            const RebicTitle(
              'Rolagem',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicText(
              'O conteúdo rola entre o cabeçalho e o rodapé, que ficam fixos. '
              'Para listas e tabelas com rolagem própria, use '
              'enableScrolling: false.',
            ),
          ],
        ),
      ],
    );
  }
}
