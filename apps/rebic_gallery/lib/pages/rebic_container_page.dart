import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

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
          RebicLabel(label),
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
              const RebicTitle(
                title,
                level: RebicTitleLevel.h1,
                titleStyle: RebicTitleLevel.h2,
              ),
              const RebicSpacing.vertical(RebicSpace.sectionGap),
              const RebicTitle(
                'Superfícies',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
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
              const RebicTitle(
                'Raios',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
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
              const RebicTitle(
                'Sombras',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
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
              const RebicTitle(
                'Cartão',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
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
                      RebicTitle(
                        'Pedido 4711',
                        level: RebicTitleLevel.h2,
                        titleStyle: RebicTitleLevel.h3,
                      ),
                      RebicSpacing.vertical(RebicSpace.xs),
                      RebicLabel('Aguardando aprovação'),
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
