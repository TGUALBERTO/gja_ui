import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicSwitch": chaves interativas ao lado de rótulos e chaves
/// desabilitadas.
class RebicSwitchPage extends StatefulWidget {
  /// Cria a página.
  const RebicSwitchPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicSwitch';

  /// Rota nomeada.
  static const route = '/rebic-switch';

  /// Rótulo da chave de exemplo.
  static const notifications = 'Notificações';

  @override
  State<RebicSwitchPage> createState() => _RebicSwitchPageState();
}

class _RebicSwitchPageState extends State<RebicSwitchPage> {
  final _settings = <String, bool>{
    RebicSwitchPage.notifications: false,
    'Modo escuro automático': true,
  };

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicSwitchPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Chaves no modelo do sap.m.Switch'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.s,
          items: [
            for (final entry in _settings.entries)
              RebicHBox(
                items: [
                  RebicSwitch(
                    semanticLabel: entry.key,
                    state: entry.value,
                    onChange: (value) =>
                        setState(() => _settings[entry.key] = value),
                  ),
                  RebicLabel(entry.key),
                ],
              ),
            const RebicHBox(
              items: [
                RebicSwitch(semanticLabel: 'Desabilitada', enabled: false),
                RebicSwitch(
                  semanticLabel: 'Desabilitada ligada',
                  state: true,
                  enabled: false,
                ),
                RebicLabel('Desabilitadas'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
