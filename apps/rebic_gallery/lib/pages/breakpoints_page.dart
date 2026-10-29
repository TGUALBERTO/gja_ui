import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "Breakpoints": classe de tamanho da janela atual e os limiares.
///
/// Mede a janela com `MediaQuery` diretamente, o que é aceitável na galeria
/// (aplicação). Os widgets do framework usarão `core/responsive`.
class BreakpointsPage extends StatelessWidget {
  /// Cria a página.
  const BreakpointsPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Breakpoints';

  /// Rota nomeada.
  static const route = '/breakpoints';

  /// Chave do texto que mostra a classe atual.
  static const currentClassKey = Key('breakpoints-current-class');

  @override
  Widget build(BuildContext context) {
    final breakpoints = RebicThemeData.of(context).breakpoints;
    final colors = RebicThemeData.of(context).colors;
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;
    final width = MediaQuery.sizeOf(context).width;
    final current = breakpoints.classify(width);

    return ColoredBox(
      color: colors.base,
      child: DefaultTextStyle(
        style: typography.base.copyWith(color: colors.text),
        child: ListView(
          padding: EdgeInsets.all(spacing.pageMargin),
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Semantics(button: true, child: const Text('← Voltar')),
            ),
            SizedBox(height: spacing.stackGap),
            Text(title, style: typography.header2),
            SizedBox(height: spacing.stackGap),
            Text('Largura da janela: ${width.toStringAsFixed(0)} px'),
            Text(
              'Classe atual: ${current.name}',
              key: currentClassKey,
              style: typography.header3,
            ),
            SizedBox(height: spacing.sectionGap),
            Text('Limiares', style: typography.header4),
            SizedBox(height: spacing.s),
            for (final sizeClass in RebicSizeClass.values)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xs),
                child: Text(
                  '${sizeClass.name} ≥ '
                  '${breakpoints.minWidthOf(sizeClass).toStringAsFixed(0)} px',
                  style: sizeClass == current
                      ? typography.baseSemibold.copyWith(color: colors.brand)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
