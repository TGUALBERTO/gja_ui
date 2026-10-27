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
      subtitle: 'Barra e círculo, determinados ou indeterminados',
      onBack: () => Navigator.of(context).maybePop(),
      body: RebicColumn(
        gap: RebicSpace.l,
        children: [
          const RebicText('Barras por estado', variant: RebicTextVariant.title),
          for (final (i, state) in RebicValueState.values.indexed)
            RebicColumn(
              gap: RebicSpace.xs,
              children: [
                RebicText('${state.name} — ${(i + 1) * 15}%'),
                RebicProgressIndicator.linear(
                  value: (i + 1) * 0.15,
                  state: state,
                ),
              ],
            ),
          const RebicText('Indeterminada', variant: RebicTextVariant.title),
          const RebicProgressIndicator.linear(
            semanticLabel: 'Carregando pedidos',
          ),
          const RebicText('Círculos', variant: RebicTextVariant.title),
          RebicRow(
            gap: RebicSpace.l,
            children: [
              for (final size in circleSizes)
                RebicProgressIndicator.circular(size: size),
            ],
          ),
        ],
      ),
    );
  }
}
