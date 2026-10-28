import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "Raios": uma amostra de cada passo e papel de raio de borda.
///
/// Os valores visuais vêm dos tokens. As dimensões da amostra são literais da
/// galeria, que é aplicação, fora da verificação de tokens.
class RadiusPage extends StatelessWidget {
  /// Cria a página.
  const RadiusPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Raios';

  /// Rota nomeada.
  static const route = '/radius';

  /// Valor exibido para [value]: "pílula" para o formato de pílula.
  static String label(String name, double value) =>
      name == 'full' ? 'pílula' : '${value.toStringAsFixed(0)} px';

  @override
  Widget build(BuildContext context) {
    final radius = RebicThemeData.of(context).radius;
    final colors = RebicThemeData.of(context).colors;
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;

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
            Wrap(
              spacing: spacing.l,
              runSpacing: spacing.l,
              children: [
                for (final MapEntry(key: name, value: value)
                    in radius.values.entries)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colors.selectionBackground,
                          border: Border.all(color: colors.brand),
                          borderRadius: BorderRadius.circular(value),
                        ),
                      ),
                      SizedBox(height: spacing.xs),
                      Text(name, style: typography.label),
                      Text(
                        label(name, value),
                        style: typography.caption.copyWith(color: colors.label),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
