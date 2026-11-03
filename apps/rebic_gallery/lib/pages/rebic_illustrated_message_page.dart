import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicIllustratedMessage": os tipos em tamanho `spot`, uma
/// mensagem `dialog` e uma de busca sem resultados com a ação "Limpar
/// filtros", que mostra a lista.
class RebicIllustratedMessagePage extends StatefulWidget {
  /// Cria a página.
  const RebicIllustratedMessagePage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicIllustratedMessage';

  /// Rota nomeada.
  static const route = '/rebic-illustrated-message';

  /// Texto da ação que limpa os filtros.
  static const clear = 'Limpar filtros';

  /// Texto mostrado depois de limpar os filtros.
  static const list = 'Pedidos 4711, 4712 e 4713';

  @override
  State<RebicIllustratedMessagePage> createState() =>
      _RebicIllustratedMessagePageState();
}

class _RebicIllustratedMessagePageState
    extends State<RebicIllustratedMessagePage> {
  bool _filtered = true;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicIllustratedMessagePage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Estados vazios no modelo do sap.m.IllustratedMessage'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.xl,
          alignItems: RebicFlexAlignItems.stretch,
          items: [
            if (_filtered)
              RebicIllustratedMessage(
                illustrationType: RebicIllustrationType.noFilterResults,
                title: 'Nenhum pedido com esses filtros',
                description: 'Limpe os filtros para ver todos os pedidos.',
                additionalContent: [
                  RebicButton(
                    text: RebicIllustratedMessagePage.clear,
                    type: RebicButtonType.emphasized,
                    onPress: () => setState(() => _filtered = false),
                  ),
                ],
              )
            else
              const RebicText(RebicIllustratedMessagePage.list),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              gap: RebicSpace.l,
              items: [
                for (final type in RebicIllustrationType.values)
                  SizedBox(
                    width: 160,
                    child: RebicIllustratedMessage(
                      title: type.name,
                      illustrationType: type,
                      illustrationSize: RebicIllustrationSize.spot,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
