import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicTitle": os sete estilos, um título de nível H1 com estilo H5
/// e os títulos truncado e com quebra.
class RebicTitlePage extends StatelessWidget {
  /// Cria a página.
  const RebicTitlePage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicTitle';

  /// Rota nomeada.
  static const route = '/rebic-title';

  /// Título longo dos exemplos de quebra.
  static const longTitle =
      'Pedidos de compra em aberto aguardando aprovação do centro de custo';

  /// Chave do exemplo de nível diferente do estilo.
  static const levelKey = Key('rebic-title-level');

  /// Chave do exemplo truncado.
  static const truncatedKey = Key('rebic-title-truncated');

  /// Chave do exemplo com quebra.
  static const wrappingKey = Key('rebic-title-wrapping');

  /// Texto do exemplo de cada estilo.
  static String styleLabel(RebicTitleLevel style) => 'Estilo ${style.name}';

  @override
  Widget build(BuildContext context) {
    final spacing = RebicTheme.of(context).spacing;
    return ListView(
      padding: EdgeInsets.all(spacing.pageMargin),
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Semantics(button: true, child: const RebicText('← Voltar')),
        ),
        SizedBox(height: spacing.stackGap),
        const RebicTitle(
          title,
          level: RebicTitleLevel.h1,
          titleStyle: RebicTitleLevel.h2,
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Estilos',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        for (final style in RebicTitleLevel.values)
          RebicTitle(styleLabel(style), titleStyle: style),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Nível diferente do estilo',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        const RebicTitle(
          'Nível H1 com estilo H5',
          key: levelKey,
          level: RebicTitleLevel.h1,
          titleStyle: RebicTitleLevel.h5,
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Quebra de linhas',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: 240,
            child: RebicTitle(longTitle, key: truncatedKey),
          ),
        ),
        SizedBox(height: spacing.s),
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: 240,
            child: RebicTitle(longTitle, key: wrappingKey, wrapping: true),
          ),
        ),
      ],
    );
  }
}
