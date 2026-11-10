import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicProgressIndicator": barras por estado de valor e uma barra
/// que avança.
class RebicProgressIndicatorPage extends StatefulWidget {
  /// Cria a página.
  const RebicProgressIndicatorPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicProgressIndicator';

  /// Rota nomeada.
  static const route = '/rebic-progress-indicator';

  /// Chave da barra que avança.
  static const advancingKey = ValueKey('advancing');

  @override
  State<RebicProgressIndicatorPage> createState() =>
      _RebicProgressIndicatorPageState();
}

class _RebicProgressIndicatorPageState
    extends State<RebicProgressIndicatorPage> {
  double _sent = 30;

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: RebicProgressIndicatorPage.title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText(
          'Barra no modelo do sap.m.ProgressIndicator. Para operações sem '
          'andamento medível, use RebicBusyIndicator.',
        ),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          alignItems: RebicFlexAlignItems.stretch,
          items: [
            const RebicTitle(
              'Barras por estado',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            for (final (i, state) in RebicValueState.values.indexed)
              RebicVBox(
                gap: RebicSpace.xs,
                alignItems: RebicFlexAlignItems.stretch,
                items: [
                  RebicText('${state.name} — ${(i + 1) * 15}%'),
                  RebicProgressIndicator(
                    percentValue: (i + 1) * 15,
                    state: state,
                  ),
                ],
              ),
            const RebicTitle(
              'Envio de arquivos',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicProgressIndicator(
              key: RebicProgressIndicatorPage.advancingKey,
              percentValue: _sent,
              semanticLabel: 'Envio de arquivos',
            ),
            RebicHBox(
              gap: RebicSpace.s,
              items: [
                RebicButton(
                  text: 'Avançar',
                  enabled: _sent < 100,
                  onPress: () =>
                      setState(() => _sent = (_sent + 10).clamp(0, 100)),
                ),
                RebicButton(
                  text: 'Reiniciar',
                  type: RebicButtonType.transparent,
                  onPress: () => setState(() => _sent = 0),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
