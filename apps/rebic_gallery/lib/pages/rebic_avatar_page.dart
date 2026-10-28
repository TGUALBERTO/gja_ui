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
      subtitle: 'Imagem, iniciais ou ícone, como o sap.m.Avatar',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Tamanhos', variant: RebicTextVariant.title),
          RebicRow.wrap(
            children: [
              for (final size in RebicAvatarSize.values)
                RebicAvatar(initials: 'MB', size: size),
            ],
          ),
          const RebicText('Formas e ícones', variant: RebicTextVariant.title),
          const RebicRow.wrap(
            children: [
              RebicAvatar(initials: 'JS', shape: RebicAvatarShape.square),
              RebicAvatar(),
              RebicAvatar(icon: RebicIcons.folder),
              RebicAvatar(
                icon: RebicIcons.file,
                shape: RebicAvatarShape.square,
              ),
            ],
          ),
          const RebicText('Ativo', variant: RebicTextVariant.title),
          RebicAvatar(
            initials: 'MB',
            size: RebicAvatarSize.m,
            semanticLabel: RebicAvatarPage.person,
            onPressed: () => setState(() => _opened = true),
          ),
          if (_opened) const RebicText(RebicAvatarPage.opened),
        ],
      ),
    );
  }
}
