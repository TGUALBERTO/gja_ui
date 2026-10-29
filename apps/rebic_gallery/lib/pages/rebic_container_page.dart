import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicContainer": superfícies, raios, sombras e um cartão de
/// exemplo.
///
/// A página fica sobre `background`, para que as superfícies `base` e as
/// sombras apareçam. Todo o layout usa `RebicSpacing` e `RebicText`.
class RebicContainerPage extends StatelessWidget {
  /// Cria a página.
  const RebicContainerPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicContainer';

  /// Rota nomeada.
  static const route = '/rebic-container';

  /// Chave do cartão de exemplo.
  static const cardKey = Key('rebic-container-card');

  @override
  Widget build(BuildContext context) {
    Widget sample(String label, RebicContainer box) => RebicSpacing.padding(
      end: RebicSpace.l,
      bottom: RebicSpace.l,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          box,
          const RebicSpacing.vertical(RebicSpace.xs),
          RebicText(label, variant: RebicTextVariant.caption),
        ],
      ),
    );

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
              const RebicText('Superfícies', variant: RebicTextVariant.title),
              const RebicSpacing.vertical(RebicSpace.s),
              Wrap(
                children: [
                  for (final surface in RebicSurface.values)
                    sample(
                      surface.name,
                      RebicContainer(
                        surface: surface,
                        border: true,
                        padding: RebicSpace.xl,
                      ),
                    ),
                ],
              ),
              const RebicSpacing.vertical(RebicSpace.sectionGap),
              const RebicText('Raios', variant: RebicTextVariant.title),
              const RebicSpacing.vertical(RebicSpace.s),
              Wrap(
                children: [
                  for (final radius in RebicRadius.values)
                    sample(
                      radius.name,
                      RebicContainer(
                        surface: RebicSurface.base,
                        border: true,
                        radius: radius,
                        padding: RebicSpace.xl,
                      ),
                    ),
                ],
              ),
              const RebicSpacing.vertical(RebicSpace.sectionGap),
              const RebicText('Sombras', variant: RebicTextVariant.title),
              const RebicSpacing.vertical(RebicSpace.s),
              Wrap(
                children: [
                  for (final shadow in RebicShadow.values)
                    sample(
                      shadow.name,
                      RebicContainer(
                        surface: RebicSurface.base,
                        radius: RebicRadius.tile,
                        shadow: shadow,
                        padding: RebicSpace.xl,
                      ),
                    ),
                ],
              ),
              const RebicSpacing.vertical(RebicSpace.sectionGap),
              const RebicText('Cartão', variant: RebicTextVariant.title),
              const RebicSpacing.vertical(RebicSpace.s),
              const Align(
                alignment: Alignment.centerLeft,
                child: RebicContainer(
                  key: cardKey,
                  surface: RebicSurface.base,
                  border: true,
                  radius: RebicRadius.tile,
                  shadow: RebicShadow.card,
                  padding: RebicSpace.l,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RebicText('Pedido 4711', variant: RebicTextVariant.title),
                      RebicSpacing.vertical(RebicSpace.xs),
                      RebicText(
                        'Aguardando aprovação',
                        tone: RebicTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
