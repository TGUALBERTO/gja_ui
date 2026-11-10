import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicText": um parágrafo livre, o mesmo truncado em duas linhas e
/// em uma linha sem quebra.
class RebicTextPage extends StatelessWidget {
  /// Cria a página.
  const RebicTextPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicText';

  /// Rota nomeada.
  static const route = '/rebic-text';

  /// Texto longo dos exemplos.
  static const longText =
      'O pedido de compra 4711 aguarda aprovação do centro de custo antes de '
      'ser enviado ao fornecedor, e a entrega prevista depende da confirmação '
      'do estoque no depósito central.';

  /// Chave do exemplo livre.
  static const freeKey = Key('rebic-text-free');

  /// Chave do exemplo truncado em duas linhas.
  static const truncatedKey = Key('rebic-text-truncated');

  /// Chave do exemplo sem quebra.
  static const noWrapKey = Key('rebic-text-no-wrap');

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
        for (final (heading, example) in const [
          ('Texto livre', RebicText(longText, key: freeKey)),
          (
            'Limite de duas linhas',
            RebicText(longText, key: truncatedKey, maxLines: 2),
          ),
          ('Sem quebra', RebicText(longText, key: noWrapKey, wrapping: false)),
        ]) ...[
          RebicTitle(
            heading,
            level: RebicTitleLevel.h2,
            titleStyle: RebicTitleLevel.h3,
          ),
          SizedBox(height: spacing.s),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(width: 320, child: example),
          ),
          SizedBox(height: spacing.sectionGap),
        ],
      ],
    );
  }
}
