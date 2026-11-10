import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicResponsiveLayout": o mesmo formulário de exemplo pela classe
/// da tela e pela classe de um painel de 400.
///
/// O formulário tem uma coluna em `small` e duas a partir de `medium`. A
/// largura do painel é literal da galeria.
class RebicResponsiveLayoutPage extends StatelessWidget {
  /// Cria a página.
  const RebicResponsiveLayoutPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicResponsiveLayout';

  /// Rota nomeada.
  static const route = '/rebic-responsive-layout';

  /// Chave do exemplo de base `screen`.
  static const screenKey = Key('responsive-layout-screen');

  /// Chave do exemplo de base `container`.
  static const containerKey = Key('responsive-layout-container');

  /// Rótulo exibido pelo formulário de uma coluna.
  static const oneColumn = 'uma coluna';

  /// Rótulo exibido pelo formulário de duas colunas.
  static const twoColumns = 'duas colunas';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RebicSpacing.padding(
          all: RebicSpace.pageMargin,
          child: RebicVBox(
            gap: RebicSpace.l,
            items: [
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
                'Pela classe da tela',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              const _Form(key: screenKey, basis: RebicLayoutBasis.screen),
              const RebicTitle(
                'Pela classe de um painel de 400',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              const SizedBox(
                width: 400,
                child: _Form(
                  key: containerKey,
                  basis: RebicLayoutBasis.container,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Formulário de exemplo: uma coluna em `small`, duas a partir de `medium`.
class _Form extends StatelessWidget {
  const _Form({required this.basis, super.key});

  final RebicLayoutBasis basis;

  static const _fields = [
    _Field('Fornecedor'),
    _Field('Centro de custo'),
    _Field('Data de entrega'),
    _Field('Valor'),
  ];

  @override
  Widget build(BuildContext context) {
    return RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.tile,
      padding: RebicSpace.l,
      child: RebicResponsiveLayout(
        basis: basis,
        small: (context) => const RebicVBox(
          items: [RebicLabel(RebicResponsiveLayoutPage.oneColumn), ..._fields],
        ),
        medium: (context) => RebicVBox(
          items: [
            const RebicLabel(RebicResponsiveLayoutPage.twoColumns),
            for (var i = 0; i < _fields.length; i += 2)
              RebicHBox(
                gap: RebicSpace.l,
                items: [
                  Expanded(child: _fields[i]),
                  Expanded(child: _fields[i + 1]),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Campo de exemplo: rótulo e uma caixa vazia.
class _Field extends StatelessWidget {
  const _Field(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final height = RebicTheme.of(context).density.controlHeight;
    return RebicVBox(
      gap: RebicSpace.xs,
      items: [
        RebicLabel(label),
        RebicContainer(
          border: true,
          radius: RebicRadius.field,
          child: SizedBox(height: height, width: double.infinity),
        ),
      ],
    );
  }
}
