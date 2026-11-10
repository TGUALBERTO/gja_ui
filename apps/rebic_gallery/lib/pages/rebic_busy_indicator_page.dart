import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicBusyIndicator": um indicador sozinho, um com texto e um cartão
/// que fica ocupado ao tocar "Atualizar".
class RebicBusyIndicatorPage extends StatefulWidget {
  /// Cria a página.
  const RebicBusyIndicatorPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicBusyIndicator';

  /// Rota nomeada.
  static const route = '/rebic-busy-indicator';

  /// Chave do indicador sobre o cartão.
  static const cardKey = Key('busy-card');

  @override
  State<RebicBusyIndicatorPage> createState() => _RebicBusyIndicatorPageState();
}

class _RebicBusyIndicatorPageState extends State<RebicBusyIndicatorPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicBusyIndicatorPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Operações em andamento no modelo do sap.m.BusyIndicator',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicBusyIndicator(),
            const RebicBusyIndicator(text: 'Carregando pedidos'),
            RebicHBox(
              items: [
                RebicButton(
                  text: _busy ? 'Concluir' : 'Atualizar',
                  onPress: () => setState(() => _busy = !_busy),
                ),
              ],
            ),
            SizedBox(
              width: 320,
              child: RebicBusyIndicator(
                key: RebicBusyIndicatorPage.cardKey,
                busy: _busy,
                child: const RebicCard(
                  header: RebicCardHeader(title: 'Pedidos pendentes'),
                  content: RebicSpacing.padding(
                    all: RebicSpace.l,
                    child: RebicText('3 pedidos aguardam aprovação.'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
