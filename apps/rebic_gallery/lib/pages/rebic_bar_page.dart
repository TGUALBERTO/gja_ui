import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicBar": uma barra de cada desenho e os alinhamentos `none` e
/// `start` do conteúdo central.
class RebicBarPage extends StatelessWidget {
  /// Cria a página.
  const RebicBarPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicBar';

  /// Rota nomeada.
  static const route = '/rebic-bar';

  /// Desenhos exibidos, cada um numa barra.
  static const designs = [
    RebicBarDesign.header,
    RebicBarDesign.subHeader,
    RebicBarDesign.footer,
    RebicBarDesign.floatingFooter,
  ];

  /// Chave da barra de [design].
  static Key designKey(RebicBarDesign design) =>
      Key('rebic-bar-${design.name}');

  /// Chave da barra com o alinhamento [alignment].
  static Key alignmentKey(RebicTitleAlignment alignment) =>
      Key('rebic-bar-alignment-${alignment.name}');

  @override
  Widget build(BuildContext context) {
    Widget sample({
      required Key key,
      required String label,
      RebicBarDesign design = RebicBarDesign.header,
      RebicTitleAlignment alignment = RebicTitleAlignment.none,
    }) => RebicBar(
      key: key,
      design: design,
      titleAlignment: alignment,
      contentLeft: [
        RebicIconButton(
          icon: RebicIcons.navBack,
          tooltip: 'Voltar',
          onPressed: () {},
        ),
      ],
      contentMiddle: [RebicTitle(label)],
      contentRight: [
        RebicIconButton(
          icon: RebicIcons.edit,
          tooltip: 'Editar',
          onPressed: () {},
        ),
      ],
    );
    return RebicPage(
      title: title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        RebicColumn(
          gap: RebicSpace.l,
          children: [
            const RebicTitle(
              'Desenhos',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            for (final design in designs)
              sample(
                key: designKey(design),
                label: design.name,
                design: design,
              ),
            const RebicTitle(
              'Alinhamento do conteúdo central',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            for (final alignment in const [
              RebicTitleAlignment.none,
              RebicTitleAlignment.start,
            ])
              sample(
                key: alignmentKey(alignment),
                label: 'titleAlignment ${alignment.name}',
                alignment: alignment,
              ),
          ],
        ),
      ],
    );
  }
}
