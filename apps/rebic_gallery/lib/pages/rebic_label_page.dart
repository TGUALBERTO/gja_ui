import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "RebicLabel": os desenhos `standard` e `bold`, os dois-pontos, o
/// obrigatório e um rótulo truncado.
class RebicLabelPage extends StatelessWidget {
  /// Cria a página.
  const RebicLabelPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'RebicLabel';

  /// Rota nomeada.
  static const route = '/rebic-label';

  /// Chave do rótulo `standard`.
  static const standardKey = Key('rebic-label-standard');

  /// Chave do rótulo `bold`.
  static const boldKey = Key('rebic-label-bold');

  /// Chave do rótulo com dois-pontos.
  static const colonKey = Key('rebic-label-colon');

  /// Chave do rótulo obrigatório.
  static const requiredKey = Key('rebic-label-required');

  /// Chave do rótulo truncado.
  static const truncatedKey = Key('rebic-label-truncated');

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
          'Desenhos',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        const RebicLabel('Fornecedor', key: standardKey),
        const RebicLabel(
          'Fornecedor',
          key: boldKey,
          design: RebicLabelDesign.bold,
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Dois-pontos e obrigatório',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        const RebicLabel('Centro de custo', key: colonKey, showColon: true),
        const RebicLabel(
          'Data de entrega',
          key: requiredKey,
          showColon: true,
          required: true,
        ),
        SizedBox(height: spacing.sectionGap),
        const RebicTitle(
          'Rótulo truncado',
          level: RebicTitleLevel.h2,
          titleStyle: RebicTitleLevel.h3,
        ),
        SizedBox(height: spacing.s),
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: 200,
            child: RebicLabel(
              'Fornecedor responsável pela entrega no depósito central',
              key: truncatedKey,
              showColon: true,
              required: true,
            ),
          ),
        ),
      ],
    );
  }
}
