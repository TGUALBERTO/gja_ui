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
        RebicButton(
          icon: RebicIcons.sysHelp,
          tooltip: 'Ajuda',
          onPress: () {},
          type: RebicButtonType.transparent,
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
          RebicButton(text: 'Cancelar', onPress: back),
          RebicButton(
            text: 'Salvar',
            type: RebicButtonType.emphasized,
            onPress: back,
          ),
        ],
      ),
      content: [
        RebicVBox(
          gap: RebicSpace.l,
          items: [
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
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                for (final design in RebicPageBackgroundDesign.values)
                  RebicButton(
                    key: RebicPagePage.designKey(design),
                    text: design.name,
                    type: design == _design
                        ? RebicButtonType.emphasized
                        : RebicButtonType.standard,
                    onPress: () => setState(() => _design = design),
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
              text: _floating ? 'Rodapé fixo' : 'Rodapé flutuante',
              onPress: () => setState(() => _floating = !_floating),
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
