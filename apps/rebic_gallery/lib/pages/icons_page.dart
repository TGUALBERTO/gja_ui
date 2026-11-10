import 'package:flutter/widgets.dart';
import 'package:gja_ui/gja_ui.dart';

/// Página "Ícones": todos os ícones do catálogo semântico, com o nome.
///
/// Os valores visuais vêm dos tokens. A largura da célula é literal da
/// galeria, que é aplicação, fora da verificação de tokens.
class IconsPage extends StatelessWidget {
  /// Cria a página.
  const IconsPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Ícones';

  /// Rota nomeada.
  static const route = '/icons';

  @override
  Widget build(BuildContext context) {
    final colors = RebicThemeData.of(context).colors;
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;
    final iconSizes = RebicThemeData.of(context).icons;

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
            SizedBox(height: spacing.sectionGap),
            Wrap(
              spacing: spacing.l,
              runSpacing: spacing.l,
              children: [
                for (final MapEntry(key: name, value: icon)
                    in RebicIcons.all.entries)
                  SizedBox(
                    width: 112,
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          size: iconSizes.large,
                          color: colors.text,
                          semanticLabel: name,
                        ),
                        SizedBox(height: spacing.xs),
                        Text(
                          name,
                          style: typography.small.copyWith(color: colors.label),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'sap-icon://${RebicIcons.iconPoolNames[name]}',
                          style: typography.small.copyWith(color: colors.label),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
