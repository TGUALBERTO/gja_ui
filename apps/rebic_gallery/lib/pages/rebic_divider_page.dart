import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicDivider": as duas orientações, os dois tons, `spacing` e
/// recuo.
///
/// Os exemplos ficam em `RebicContainer` com superfície `base`. A altura da
/// barra de ações é literal da galeria.
class RebicDividerPage extends StatelessWidget {
  /// Cria a página.
  const RebicDividerPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicDivider';

  /// Rota nomeada.
  static const route = '/rebic-divider';

  @override
  Widget build(BuildContext context) {
    Widget card(Widget child) => RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.tile,
      padding: RebicSpace.l,
      child: child,
    );

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
              const RebicTitle(
                title,
                level: RebicTitleLevel.h1,
                titleStyle: RebicTitleLevel.h2,
              ),
              const RebicTitle(
                'Horizontal, tom sutil e espaço',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              card(
                const RebicColumn(
                  gap: RebicSpace.none,
                  children: [
                    RebicText('Item 1'),
                    RebicDivider(spacing: RebicSpace.s),
                    RebicText('Item 2'),
                    RebicDivider(spacing: RebicSpace.s),
                    RebicText('Item 3'),
                  ],
                ),
              ),
              const RebicTitle(
                'Tom forte com recuo',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              card(
                const RebicColumn(
                  gap: RebicSpace.none,
                  children: [
                    RebicTitle(
                      'Cabeçalho',
                      level: RebicTitleLevel.h3,
                      titleStyle: RebicTitleLevel.h4,
                    ),
                    RebicDivider(
                      tone: RebicDividerTone.strong,
                      spacing: RebicSpace.s,
                      indent: RebicSpace.l,
                      endIndent: RebicSpace.l,
                    ),
                    RebicText('Conteúdo'),
                  ],
                ),
              ),
              const RebicTitle(
                'Vertical',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              card(
                const SizedBox(
                  height: 32,
                  child: RebicRow(
                    crossAlignment: RebicCrossAlignment.stretch,
                    children: [
                      Center(child: RebicText('Salvar')),
                      RebicDivider.vertical(),
                      Center(child: RebicText('Copiar')),
                      RebicDivider.vertical(
                        tone: RebicDividerTone.strong,
                        spacing: RebicSpace.xs,
                      ),
                      Center(child: RebicText('Excluir')),
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
