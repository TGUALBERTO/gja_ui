import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicButton": um botão de cada tipo, com e sem ícone, um
/// desabilitado e "Enviar", que fica ocupado ao ser tocado.
class RebicButtonPage extends StatefulWidget {
  /// Cria a página.
  const RebicButtonPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicButton';

  /// Rota nomeada.
  static const route = '/rebic-button';

  /// Chave do botão "Enviar".
  static const sendKey = Key('button-send');

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
        const RebicText('Tipos Fiori, ícone, desabilitado e ocupado'),
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
                  RebicButton(label: type.name, type: type, onPressed: () {}),
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
                  label: 'Salvar',
                  type: RebicButtonType.emphasized,
                  icon: RebicIcons.accept,
                  onPressed: () {},
                ),
                RebicButton(
                  label: 'Editar',
                  icon: RebicIcons.edit,
                  onPressed: () {},
                ),
                RebicButton(
                  label: 'Excluir',
                  type: RebicButtonType.reject,
                  icon: RebicIcons.delete,
                  onPressed: () {},
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
                const RebicButton(label: 'Aprovar', onPressed: null),
                RebicButton(
                  key: RebicButtonPage.sendKey,
                  label: 'Enviar',
                  type: RebicButtonType.emphasized,
                  icon: RebicIcons.upload,
                  busy: _sending,
                  onPressed: () => setState(() => _sending = true),
                ),
                if (_sending)
                  RebicButton(
                    label: 'Concluir envio',
                    type: RebicButtonType.transparent,
                    onPressed: () => setState(() => _sending = false),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
