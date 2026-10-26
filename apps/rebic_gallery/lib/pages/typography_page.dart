import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "Tipografia": uma amostra de cada estilo semântico, com medidas.
///
/// Todos os valores visuais vêm dos tokens de tipografia, cor e espaçamento.
class TypographyPage extends StatelessWidget {
  /// Cria a página.
  const TypographyPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Tipografia';

  /// Rota nomeada.
  static const route = '/typography';

  /// Frase de amostra exibida em cada estilo.
  static const sample = 'Relatório de materiais — 1.234 itens';

  /// Medidas de [style] no formato `tamanho/altura · peso`.
  static String measures(TextStyle style) {
    final size = style.fontSize!;
    final lineHeight = size * style.height!;
    return '${size.toStringAsFixed(0)}/${lineHeight.toStringAsFixed(0)}'
        ' · ${style.fontWeight!.value}';
  }

  @override
  Widget build(BuildContext context) {
    const typography = RebicTypographyTokens.fallback();
    const colors = RebicColorTokens.light();
    const spacing = RebicSpacingTokens.fallback();
    final caption = typography.caption.copyWith(color: colors.label);

    return ColoredBox(
      color: colors.base,
      child: DefaultTextStyle(
        style: typography.body.copyWith(color: colors.text),
        child: ListView(
          padding: EdgeInsets.all(spacing.pageMargin),
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Semantics(button: true, child: const Text('← Voltar')),
            ),
            SizedBox(height: spacing.stackGap),
            Text(title, style: typography.headline),
            SizedBox(height: spacing.sectionGap),
            for (final MapEntry(key: name, value: style)
                in typography.styles.entries)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$name · ${measures(style)}', style: caption),
                    SizedBox(height: spacing.xs),
                    Text(sample, style: style),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
