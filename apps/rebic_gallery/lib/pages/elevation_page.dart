import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';
import 'gallery_comparison.dart';

/// Página "Elevação": uma superfície por sombra e por papel, nos dois modos.
///
/// As sombras vêm de `RebicElevationTokens.shadowsFor` com a cor `shadow` de
/// cada modo. As dimensões do cartão são literais da galeria.
class ElevationPage extends StatelessWidget {
  /// Cria a página.
  const ElevationPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Elevação';

  /// Rota nomeada.
  static const route = '/elevation';

  /// Chave do cartão da sombra ou papel [level] no modo [mode].
  static Key cardKey(String mode, String level) =>
      ValueKey('elevation-$mode-$level');

  @override
  Widget build(BuildContext context) {
    final light = RebicThemeData.of(context).colors;
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;

    return ColoredBox(
      color: light.base,
      child: DefaultTextStyle(
        style: typography.base.copyWith(color: light.text),
        child: ListView(
          padding: EdgeInsets.all(spacing.pageMargin),
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Semantics(button: true, child: const Text('← Voltar')),
            ),
            SizedBox(height: spacing.stackGap),
            Text(title, style: typography.header2),
            SizedBox(height: spacing.sectionGap),
            const GalleryComparison(
              child: _ModeStrip(
                mode: 'claro',
                colors: RebicColorTokens.light(),
              ),
            ),
            SizedBox(height: spacing.sectionGap),
            const GalleryComparison(
              child: _ModeStrip(
                mode: 'escuro',
                colors: RebicColorTokens.dark(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeStrip extends StatelessWidget {
  const _ModeStrip({required this.mode, required this.colors});

  final String mode;
  final RebicColorTokens colors;

  @override
  Widget build(BuildContext context) {
    final elevation = RebicThemeData.of(context).elevation;
    final radius = RebicThemeData.of(context).radius;
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;

    return Container(
      padding: EdgeInsets.all(spacing.xl),
      color: colors.background,
      child: DefaultTextStyle(
        style: typography.base.copyWith(color: colors.text),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mode, style: typography.header3),
            SizedBox(height: spacing.l),
            Wrap(
              spacing: spacing.xl,
              runSpacing: spacing.xl,
              children: [
                for (final MapEntry(key: name, value: level)
                    in elevation.values.entries)
                  Container(
                    key: ElevationPage.cardKey(mode, name),
                    width: 120,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.base,
                      borderRadius: BorderRadius.circular(radius.container),
                      boxShadow: elevation.shadowsFor(level, colors.shadow),
                    ),
                    child: Text(name, style: typography.base),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
