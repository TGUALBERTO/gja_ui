import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicProgressIndicator": barras por estado de valor, uma barra
/// indeterminada e círculos indeterminados nos tamanhos de ícone.
class RebicProgressIndicatorPage extends StatelessWidget {
  /// Cria a página.
  const RebicProgressIndicatorPage({super.key});

  /// Título no índice e na página.
  static const title = 'RebicProgressIndicator';

  /// Rota nomeada.
  static const route = '/rebic-progress-indicator';

  /// Tamanhos de ícone mostrados nos círculos.
  static const circleSizes = [
    RebicIconSize.small,
    RebicIconSize.control,
    RebicIconSize.large,
    RebicIconSize.xLarge,
  ];

  @override
  Widget build(BuildContext context) {
    return RebicPage(
      title: title,
      showNavButton: true,
      onNavButtonPress: () => Navigator.of(context).maybePop(),
      contentPadding: RebicContentPadding.responsive,
      content: [
        const RebicText('Barra e círculo, determinados ou indeterminados'),
        const RebicSpacing.vertical(RebicSpace.l),
        RebicVBox(
          gap: RebicSpace.l,
          items: [
            const RebicTitle(
              'Barras por estado',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            for (final (i, state) in RebicValueState.values.indexed)
              RebicVBox(
                gap: RebicSpace.xs,
                items: [
                  RebicText('${state.name} — ${(i + 1) * 15}%'),
                  RebicProgressIndicator.linear(
                    value: (i + 1) * 0.15,
                    state: state,
                  ),
                ],
              ),
            const RebicTitle(
              'Indeterminada',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            const RebicProgressIndicator.linear(
              semanticLabel: 'Carregando pedidos',
            ),
            const RebicTitle(
              'Círculos',
              level: RebicTitleLevel.h2,
              titleStyle: RebicTitleLevel.h3,
            ),
            RebicHBox(
              gap: RebicSpace.l,
              items: [
                for (final size in circleSizes)
                  RebicProgressIndicator.circular(size: size),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
