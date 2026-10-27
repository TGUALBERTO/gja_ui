import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicSpacing": cada passo e papel em escala, e o mesmo padding nas
/// densidades confortável e compacta.
///
/// Todo o espaço da página vem de `RebicSpacing`; a altura das barras é a do
/// passo `s`, e a largura, o próprio valor exibido.
class RebicSpacingPage extends StatelessWidget {
  /// Cria a página.
  const RebicSpacingPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicSpacing';

  /// Rota nomeada.
  static const route = '/rebic-spacing';

  /// Chave da barra de [space].
  static Key barKey(RebicSpace space) =>
      ValueKey('rebic-spacing-${space.name}');

  /// Chave do conteúdo do exemplo de padding na densidade [density].
  static Key paddedKey(RebicDensity density) =>
      ValueKey('rebic-spacing-padded-${density.name}');

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RebicSpacing.padding(
          all: RebicSpace.pageMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Semantics(
                  button: true,
                  child: const RebicText('← Voltar'),
                ),
              ),
              const RebicSpacing.vertical(RebicSpace.stackGap),
              const RebicText(title, variant: RebicTextVariant.headline),
              const RebicSpacing.vertical(RebicSpace.sectionGap),
              const RebicText(
                'Passos e papéis',
                variant: RebicTextVariant.title,
              ),
              const RebicSpacing.vertical(RebicSpace.s),
              for (final space in RebicSpace.values) _Bar(space),
              const RebicSpacing.vertical(RebicSpace.sectionGap),
              const RebicText('Densidades', variant: RebicTextVariant.title),
              const RebicSpacing.vertical(RebicSpace.s),
              const Wrap(
                children: [
                  _PaddedSample(RebicDensity.comfortable),
                  RebicSpacing.horizontal(RebicSpace.l),
                  RebicTheme.density(
                    density: RebicDensity.compact,
                    child: _PaddedSample(RebicDensity.compact),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Barra com a largura de [space], o nome e o valor.
class _Bar extends StatelessWidget {
  const _Bar(this.space);

  final RebicSpace space;

  @override
  Widget build(BuildContext context) {
    final theme = RebicTheme.of(context);
    final value = RebicSpacing.resolve(theme.spacing, space);
    return RebicSpacing.padding(
      bottom: RebicSpace.xs,
      child: Row(
        children: [
          SizedBox(
            width: theme.spacing.xxxl * 2,
            child: RebicText(space.name, variant: RebicTextVariant.caption),
          ),
          ColoredBox(
            key: RebicSpacingPage.barKey(space),
            color: theme.colors.selectionBackground,
            child: SizedBox(width: value, height: theme.spacing.s),
          ),
          const RebicSpacing.horizontal(RebicSpace.s),
          RebicText(
            value.toStringAsFixed(0),
            variant: RebicTextVariant.caption,
            tone: RebicTextTone.muted,
          ),
        ],
      ),
    );
  }
}

/// Cartão com padding `l` em volta de um texto, na densidade ativa.
class _PaddedSample extends StatelessWidget {
  const _PaddedSample(this.density);

  final RebicDensity density;

  @override
  Widget build(BuildContext context) {
    final colors = RebicTheme.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.headerBackground,
        border: Border.all(color: colors.separator),
      ),
      child: RebicSpacing.padding(
        all: RebicSpace.l,
        child: RebicText(
          density.name,
          key: RebicSpacingPage.paddedKey(density),
        ),
      ),
    );
  }
}
