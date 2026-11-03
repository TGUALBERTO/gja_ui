import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicHBox e RebicVBox": alinhamentos, linha de base, item
/// expandido e quebra.
///
/// Os blocos são `RebicContainer` com superfície `base` e borda; as áreas de
/// demonstração usam `header`, para que o espaço livre fique visível. As
/// dimensões das áreas são literais da galeria.
class RebicHBoxVBoxPage extends StatelessWidget {
  /// Cria a página.
  const RebicHBoxVBoxPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicHBox e RebicVBox';

  /// Rota nomeada.
  static const route = '/rebic-hbox-vbox';

  /// Chave da caixa horizontal com o alinhamento principal [alignment].
  static Key rowKey(RebicFlexJustifyContent alignment) =>
      ValueKey('row-${alignment.name}');

  /// Chave da caixa vertical com o alinhamento cruzado [alignment].
  static Key columnKey(RebicFlexAlignItems alignment) =>
      ValueKey('column-${alignment.name}');

  /// Chave do item expandido da caixa horizontal.
  static const rowExpandedKey = Key('row-expanded');

  /// Chave do item expandido da caixa vertical.
  static const columnExpandedKey = Key('column-expanded');

  /// Chave da caixa horizontal com quebra.
  static const wrapKey = Key('row-wrap');

  /// Chave da caixa horizontal alinhada pela linha de base.
  static const baselineKey = Key('row-baseline');

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RebicSpacing.padding(
          all: RebicSpace.pageMargin,
          child: RebicVBox(
            gap: RebicSpace.s,
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
              const RebicSpacing.vertical(RebicSpace.l),
              const RebicTitle(
                'RebicHBox: alinhamento principal',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              for (final alignment in RebicFlexJustifyContent.values) ...[
                RebicLabel(alignment.name),
                _Area(
                  child: RebicHBox(
                    key: rowKey(alignment),
                    justifyContent: alignment,
                    items: const [_Block(), _Block(), _Block()],
                  ),
                ),
              ],
              const RebicLabel('baseline'),
              const _Area(
                child: RebicHBox(
                  key: baselineKey,
                  alignItems: RebicFlexAlignItems.baseline,
                  items: [
                    RebicTitle('Pedido 4711', titleStyle: RebicTitleLevel.h2),
                    RebicText('Aguardando aprovação'),
                  ],
                ),
              ),
              const RebicLabel('expandido'),
              const _Area(
                child: RebicHBox(
                  items: [
                    _Block(),
                    Expanded(child: _Block(key: rowExpandedKey)),
                  ],
                ),
              ),
              const RebicLabel('wrap'),
              SizedBox(
                width: 240,
                child: _Area(
                  child: RebicHBox(
                    wrap: RebicFlexWrap.wrap,
                    alignItems: RebicFlexAlignItems.start,
                    key: wrapKey,
                    items: [for (var i = 0; i < 8; i++) const _Block()],
                  ),
                ),
              ),
              const RebicSpacing.vertical(RebicSpace.l),
              const RebicTitle(
                'RebicVBox: alinhamento cruzado',
                level: RebicTitleLevel.h2,
                titleStyle: RebicTitleLevel.h3,
              ),
              RebicHBox(
                alignItems: RebicFlexAlignItems.start,
                items: [
                  for (final alignment in RebicFlexAlignItems.values)
                    if (alignment != RebicFlexAlignItems.baseline)
                      Expanded(
                        child: RebicVBox(
                          gap: RebicSpace.xs,
                          items: [
                            RebicLabel(alignment.name),
                            SizedBox(
                              height: 160,
                              child: _Area(
                                child: RebicVBox(
                                  key: columnKey(alignment),
                                  alignItems: alignment,
                                  items: const [_Block(), _Block()],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  const Expanded(
                    child: RebicVBox(
                      gap: RebicSpace.xs,
                      items: [
                        RebicLabel('expandido'),
                        SizedBox(
                          height: 160,
                          child: _Area(
                            child: RebicVBox(
                              items: [
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
