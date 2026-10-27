import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "RebicText": as oito variantes, os seis tons e um texto truncado.
///
/// Todo o texto da página, inclusive o cabeçalho, usa `RebicText`.
class RebicTextPage extends StatelessWidget {
  /// Cria a página.
  const RebicTextPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicText';

  /// Rota nomeada.
  static const route = '/rebic-text';

  /// Texto longo do exemplo de limite de linhas.
  static const longText =
      'O pedido de compra 4711 aguarda aprovação do centro de custo antes de '
      'ser enviado ao fornecedor, e a entrega prevista depende da confirmação '
      'do estoque no depósito central.';

  /// Chave do exemplo truncado.
  static const truncatedKey = Key('rebic-text-truncated');

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
        const RebicText(title, variant: RebicTextVariant.headline),
        SizedBox(height: spacing.sectionGap),
        const RebicText('Variantes', variant: RebicTextVariant.title),
        SizedBox(height: spacing.s),
        for (final variant in RebicTextVariant.values)
          RebicText(variant.name, variant: variant),
        SizedBox(height: spacing.sectionGap),
        const RebicText('Tons', variant: RebicTextVariant.title),
        SizedBox(height: spacing.s),
        for (final tone in RebicTextTone.values)
          RebicText('tom ${tone.name}', tone: tone),
        SizedBox(height: spacing.sectionGap),
        const RebicText('Limite de linhas', variant: RebicTextVariant.title),
        SizedBox(height: spacing.s),
        const SizedBox(
          width: 320,
          child: RebicText(longText, key: truncatedKey, maxLines: 2),
        ),
      ],
    );
  }
}
