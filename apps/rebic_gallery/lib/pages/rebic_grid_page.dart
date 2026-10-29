import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicGrid": cartões no `defaultSpan` padrão, pela classe da tela,
/// e uma grade com uma célula de destaque de span próprio.
class RebicGridPage extends StatelessWidget {
  /// Cria a página.
  const RebicGridPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicGrid';

  /// Rota nomeada.
  static const route = '/rebic-grid';

  /// Chave do cartão de índice [index] da primeira grade.
  static Key cardKey(int index) => ValueKey('grid-card-$index');

  /// Chave da célula de destaque.
  static const highlightKey = Key('grid-highlight');

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RebicSpacing.padding(
          all: RebicSpace.pageMargin,
          child: RebicColumn(
            gap: RebicSpace.l,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Semantics(
                  button: true,
                  child: const RebicText('← Voltar'),
                ),
              ),
              const RebicText(title, variant: RebicTextVariant.headline),
              const RebicText(
                'Span padrão (1, 2, 3 e 4 por linha), pela tela',
                variant: RebicTextVariant.title,
              ),
              RebicGrid(
                basis: RebicLayoutBasis.screen,
                children: [
                  for (var i = 0; i < 6; i++)
                    _Card(key: cardKey(i), label: 'Pedido ${4711 + i}'),
                ],
              ),
              const RebicText(
                'Célula de destaque (small 12, large 8)',
                variant: RebicTextVariant.title,
              ),
              const RebicGrid.cells(
                basis: RebicLayoutBasis.screen,
                cells: [
                  RebicGridCell(
                    child: _Card(key: highlightKey, label: 'Resumo do mês'),
                    span: RebicResponsiveValue(small: 12, large: 8),
                  ),
                  RebicGridCell(child: _Card(label: 'Atalhos')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Cartão de exemplo.
class _Card extends StatelessWidget {
  const _Card({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.tile,
      shadow: RebicShadow.card,
      padding: RebicSpace.l,
      child: RebicColumn(
        gap: RebicSpace.xs,
        children: [
          RebicText(label, variant: RebicTextVariant.subtitle),
          const RebicText('Aguardando aprovação', tone: RebicTextTone.muted),
        ],
      ),
    );
  }
}
