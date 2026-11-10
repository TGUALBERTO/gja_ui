import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicButton": um botão de cada tipo, com e sem ícone, uma barra
/// de ações só com ícone, um desabilitado e "Enviar", que fica ocupado ao
/// ser tocado.
class RebicButtonPage extends StatefulWidget {
  /// Cria a página.
  const RebicButtonPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicButton';

  /// Rota nomeada.
  static const route = '/rebic-button';

  /// Chave do botão "Enviar".
  static const sendKey = Key('button-send');

  /// Ações da barra só com ícone.
  static const actions = [
    (RebicIcons.edit, 'Editar pedido'),
    (RebicIcons.delete, 'Excluir pedido'),
    (RebicIcons.download, 'Baixar PDF'),
    (RebicIcons.overflow, 'Mais ações'),
  ];

  @override
  State<RebicButtonPage> createState() => _RebicButtonPageState();
}

class _RebicButtonPageState extends State<RebicButtonPage> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicButtonPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Tipos Fiori, ícone, só ícone, desabilitado e ocupado'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicTitle(
              'Tipos',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                for (final type in RebicButtonType.values)
                  RebicButton(text: type.name, type: type, onPress: () {}),
              ],
            ),
            const RebicTitle(
              'Com ícone',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                RebicButton(
                  text: 'Salvar',
                  type: RebicButtonType.emphasized,
                  icon: RebicIcons.accept,
                  onPress: () {},
                ),
                RebicButton(
                  text: 'Editar',
                  icon: RebicIcons.edit,
                  onPress: () {},
                ),
                RebicButton(
                  text: 'Excluir',
                  type: RebicButtonType.reject,
                  icon: RebicIcons.delete,
                  onPress: () {},
                ),
              ],
            ),
            const RebicTitle(
              'Barra de ações só com ícone',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              gap: RebicSpace.xs,
              items: [
                for (final (icon, tooltip) in RebicButtonPage.actions)
                  RebicButton(
                    icon: icon,
                    tooltip: tooltip,
                    type: RebicButtonType.transparent,
                    onPress: () {},
                  ),
              ],
            ),
            const RebicTitle(
              'Tipos só com ícone',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                for (final type in RebicButtonType.values)
                  RebicButton(
                    icon: RebicIcons.accept,
                    tooltip: type.name,
                    type: type,
                    onPress: () {},
                  ),
              ],
            ),
            const RebicTitle(
              'Desabilitado e ocupado',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                const RebicButton(text: 'Aprovar', enabled: false),
                RebicButton(
                  key: RebicButtonPage.sendKey,
                  text: 'Enviar',
                  type: RebicButtonType.emphasized,
                  icon: RebicIcons.upload,
                  busy: _sending,
                  onPress: () => setState(() => _sending = true),
                ),
                if (_sending)
                  RebicButton(
                    text: 'Concluir envio',
                    type: RebicButtonType.transparent,
                    onPress: () => setState(() => _sending = false),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
