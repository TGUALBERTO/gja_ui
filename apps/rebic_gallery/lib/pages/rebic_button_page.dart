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
      subtitle: 'Tipos Fiori, ícone, desabilitado e ocupado',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Tipos', variant: RebicTextVariant.title),
          RebicRow.wrap(
            children: [
              for (final type in RebicButtonType.values)
                RebicButton(label: type.name, type: type, onPressed: () {}),
            ],
          ),
          const RebicText('Com ícone', variant: RebicTextVariant.title),
          RebicRow.wrap(
            children: [
              RebicButton(
                label: 'Salvar',
                type: RebicButtonType.emphasized,
                icon: RebicIcons.check,
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
          const RebicText(
            'Desabilitado e ocupado',
            variant: RebicTextVariant.title,
          ),
          RebicRow.wrap(
            children: [
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
    );
  }
}
