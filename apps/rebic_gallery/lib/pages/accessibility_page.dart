import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';

/// Página "Acessibilidade": meta, limites, movimento reduzido e uma amostra
/// de texto que acompanha a escala do sistema.
class AccessibilityPage extends StatelessWidget {
  /// Cria a página.
  const AccessibilityPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Acessibilidade';

  /// Rota nomeada.
  static const route = '/accessibility';

  /// Texto de amostra exibido no estilo `body`.
  static const sample =
      'Este texto acompanha a escala de texto do sistema e quebra linhas '
      'em vez de estourar o layout.';

  /// Linhas de limites exibidas na página.
  static List<String> limits() => [
    'Meta: ${RebicAccessibility.conformanceTarget}',
    'Contraste de texto ≥ ${RebicAccessibility.minTextContrast}:1',
    'Contraste não textual ≥ ${RebicAccessibility.minNonTextContrast}:1',
    'Escala de texto suportada: '
        '${(RebicAccessibility.minSupportedTextScale * 100).round()}%',
    for (final density in RebicDensity.values)
      'Alvo mínimo (${density.name}): '
          '${RebicAccessibility.minTargetSize(RebicDensityTokens.of(density)).round()} px',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = RebicThemeData.of(context).colors;
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;
    final motion = RebicThemeData.of(context).motion;
    final reduced = RebicAccessibility.resolveMotion(
      motion,
      disableAnimations: true,
    );
    final platformReduces = MediaQuery.disableAnimationsOf(context);

    String durations(RebicMotionTokens m) =>
        'short ${m.short.inMilliseconds} ms · medium ${m.medium.inMilliseconds} ms'
        ' · long ${m.long.inMilliseconds} ms';

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
            Text('Limites', style: typography.subtitle),
            SizedBox(height: spacing.s),
            for (final line in limits())
              Padding(
                padding: EdgeInsets.only(bottom: spacing.xs),
                child: Text(line),
              ),
            SizedBox(height: spacing.sectionGap),
            Text('Movimento', style: typography.subtitle),
            SizedBox(height: spacing.s),
            Text('Normal: ${durations(motion)}'),
            Text('Com redução: ${durations(reduced)}'),
            Text(
              'Plataforma pede redução: ${platformReduces ? 'sim' : 'não'}',
              style: typography.caption.copyWith(color: colors.label),
            ),
            SizedBox(height: spacing.sectionGap),
            Text('Escala de texto', style: typography.subtitle),
            SizedBox(height: spacing.s),
            const Text(sample),
          ],
        ),
      ),
    );
  }
}
