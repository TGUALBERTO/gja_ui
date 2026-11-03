import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicAvatar": tamanhos, formas, iniciais, ícone e um avatar ativo
/// que mostra uma mensagem.
class RebicAvatarPage extends StatefulWidget {
  /// Cria a página.
  const RebicAvatarPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicAvatar';

  /// Rota nomeada.
  static const route = '/rebic-avatar';

  /// Nome da pessoa do avatar ativo.
  static const person = 'Maria Barros';

  /// Mensagem mostrada ao acionar o avatar ativo.
  static const opened = 'Perfil de Maria Barros';

  @override
  State<RebicAvatarPage> createState() => _RebicAvatarPageState();
}

class _RebicAvatarPageState extends State<RebicAvatarPage> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicAvatarPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Imagem, iniciais ou ícone, como o sap.m.Avatar'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicTitle(
              'Tamanhos',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                for (final size in RebicAvatarSize.values)
                  RebicAvatar(initials: 'MB', size: size),
              ],
            ),
            const RebicTitle(
              'Formas e ícones',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicHBox(
              wrap: RebicFlexWrap.wrap,
              alignItems: RebicFlexAlignItems.start,
              items: [
                RebicAvatar(initials: 'JS', shape: RebicAvatarShape.square),
                RebicAvatar(),
                RebicAvatar(icon: RebicIcons.folderBlank),
                RebicAvatar(
                  icon: RebicIcons.document,
                  shape: RebicAvatarShape.square,
                ),
              ],
            ),
            const RebicTitle(
              'Ativo',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicAvatar(
              initials: 'MB',
              size: RebicAvatarSize.m,
              semanticLabel: RebicAvatarPage.person,
              onPress: () => setState(() => _opened = true),
            ),
            if (_opened) const RebicText(RebicAvatarPage.opened),
          ],
        ),
      ],
    );
  }
}
