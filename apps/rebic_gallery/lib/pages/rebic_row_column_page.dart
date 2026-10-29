import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicRow e RebicColumn": alinhamentos, filho expandido e quebra.
///
/// Os blocos são `RebicContainer` com superfície `base` e borda; as áreas de
/// demonstração usam `header`, para que o espaço livre fique visível. As
/// dimensões das áreas são literais da galeria.
class RebicRowColumnPage extends StatelessWidget {
  /// Cria a página.
  const RebicRowColumnPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicRow e RebicColumn';

  /// Rota nomeada.
  static const route = '/rebic-row-column';

  /// Chave da linha com o alinhamento principal [alignment].
  static Key rowKey(RebicMainAlignment alignment) =>
      ValueKey('row-${alignment.name}');

  /// Chave da coluna com o alinhamento cruzado [alignment].
  static Key columnKey(RebicCrossAlignment alignment) =>
      ValueKey('column-${alignment.name}');

  /// Chave do filho expandido da linha.
  static const rowExpandedKey = Key('row-expanded');

  /// Chave do filho expandido da coluna.
  static const columnExpandedKey = Key('column-expanded');

  /// Chave da linha com quebra.
  static const wrapKey = Key('row-wrap');

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RebicSpacing.padding(
          all: RebicSpace.pageMargin,
          child: RebicColumn(
            gap: RebicSpace.s,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Semantics(
                  button: true,
                  child: const RebicText('← Voltar'),
                ),
              ),
              const RebicText(title, variant: RebicTextVariant.headline),
              const RebicSpacing.vertical(RebicSpace.l),
              const RebicText(
                'RebicRow: alinhamento principal',
                variant: RebicTextVariant.title,
              ),
              for (final alignment in RebicMainAlignment.values) ...[
                RebicText(alignment.name, variant: RebicTextVariant.caption),
                _Area(
                  child: RebicRow(
                    key: rowKey(alignment),
                    mainAlignment: alignment,
                    children: const [_Block(), _Block(), _Block()],
                  ),
                ),
              ],
              const RebicText('expandido', variant: RebicTextVariant.caption),
              const _Area(
                child: RebicRow(
                  children: [
                    _Block(),
                    Expanded(child: _Block(key: rowExpandedKey)),
                  ],
                ),
              ),
              const RebicText('wrap', variant: RebicTextVariant.caption),
              SizedBox(
                width: 240,
                child: _Area(
                  child: RebicRow.wrap(
                    key: wrapKey,
                    children: [for (var i = 0; i < 8; i++) const _Block()],
                  ),
                ),
              ),
              const RebicSpacing.vertical(RebicSpace.l),
              const RebicText(
                'RebicColumn: alinhamento cruzado',
                variant: RebicTextVariant.title,
              ),
              RebicRow(
                crossAlignment: RebicCrossAlignment.start,
                children: [
                  for (final alignment in RebicCrossAlignment.values)
                    Expanded(
                      child: RebicColumn(
                        gap: RebicSpace.xs,
                        children: [
                          RebicText(
                            alignment.name,
                            variant: RebicTextVariant.caption,
                          ),
                          SizedBox(
                            height: 160,
                            child: _Area(
                              child: RebicColumn(
                                key: columnKey(alignment),
                                crossAlignment: alignment,
                                children: const [_Block(), _Block()],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Expanded(
                    child: RebicColumn(
                      gap: RebicSpace.xs,
                      children: [
                        RebicText(
                          'expandido',
                          variant: RebicTextVariant.caption,
                        ),
                        SizedBox(
                          height: 160,
                          child: _Area(
                            child: RebicColumn(
                              children: [
                                _Block(),
                                Expanded(child: _Block(key: columnExpandedKey)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

/// Área de demonstração com fundo `header`.
class _Area extends StatelessWidget {
  const _Area({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => RebicContainer(
    surface: RebicSurface.header,
    radius: RebicRadius.element,
    padding: RebicSpace.s,
    child: child,
  );
}

/// Bloco de exemplo, com o tamanho do espaço `xl`.
class _Block extends StatelessWidget {
  const _Block({super.key});

  @override
  Widget build(BuildContext context) {
    final size = RebicTheme.of(context).spacing.xl;
    return RebicContainer(
      surface: RebicSurface.base,
      border: true,
      radius: RebicRadius.xs,
      child: SizedBox(width: size, height: size),
    );
  }
}
