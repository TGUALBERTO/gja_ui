import 'package:flutter/widgets.dart';
import 'package:rebic_ui/rebic_ui.dart';
import 'gallery_comparison.dart';

/// Página "Estados": cada família de controle em cada estado, nos dois modos.
///
/// As cores vêm de `RebicControlColors.of` (fundo, borda e texto do estado),
/// o desabilitado aplica `disabledOpacity` sobre o normal e o foco desenha o
/// contorno com `focusWidth` e `focusOffset`. As dimensões da amostra são
/// literais da galeria.
class StatesPage extends StatelessWidget {
  /// Cria a página.
  const StatesPage({super.key});

  /// Título no índice e no cabeçalho.
  static const title = 'Estados';

  /// Rota nomeada.
  static const route = '/states';

  /// Amostras exibidas: rótulo e conjunto de estados.
  static const samples = <(String, Set<RebicInteractionState>)>[
    ('normal', {}),
    ('hover', {RebicInteractionState.hovered}),
    ('ativo', {RebicInteractionState.pressed}),
    ('selecionado', {RebicInteractionState.selected}),
    (
      'selecionado com hover',
      {RebicInteractionState.selected, RebicInteractionState.hovered},
    ),
    ('foco', {RebicInteractionState.focused}),
    ('desabilitado', {RebicInteractionState.disabled}),
  ];

  /// Chave do controle da amostra [label] da família [family] no modo
  /// [mode].
  static Key controlKey(String mode, RebicControlFamily family, String label) =>
      ValueKey('states-control-$mode-${family.name}-$label');

  /// Chave do contorno de foco da amostra [label] da família [family] no
  /// modo [mode].
  static Key ringKey(String mode, RebicControlFamily family, String label) =>
      ValueKey('states-ring-$mode-${family.name}-$label');

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
    final spacing = RebicThemeData.of(context).spacing;
    final typography = RebicThemeData.of(context).typography;

    return Container(
      padding: EdgeInsets.all(spacing.xl),
      color: colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mode, style: typography.header3.copyWith(color: colors.text)),
          for (final family in RebicControlFamily.values) ...[
            SizedBox(height: spacing.l),
            Text(
              family.name,
              style: typography.base.copyWith(color: colors.label),
            ),
            SizedBox(height: spacing.s),
            Wrap(
              spacing: spacing.l,
              runSpacing: spacing.l,
              children: [
                for (final (label, states) in StatesPage.samples)
                  _Sample(
                    mode: mode,
                    family: family,
                    label: label,
                    states: states,
                    colors: colors,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Sample extends StatelessWidget {
  const _Sample({
    required this.mode,
    required this.family,
    required this.label,
    required this.states,
    required this.colors,
  });

  final String mode;
  final RebicControlFamily family;
  final String label;
  final Set<RebicInteractionState> states;
  final RebicColorTokens colors;

  @override
  Widget build(BuildContext context) {
    const interaction = RebicInteractionStateTokens.fallback();
    final radius = RebicThemeData.of(context).radius;
    final typography = RebicThemeData.of(context).typography;
    final c = RebicControlColors.of(family, colors).resolve(states);
    final ring = interaction.showsFocusRing(states);
    final outer =
        radius.control + interaction.focusOffset + interaction.focusWidth;

    return Container(
      key: StatesPage.ringKey(mode, family, label),
      padding: EdgeInsets.all(interaction.focusOffset + interaction.focusWidth),
      decoration: ring
          ? BoxDecoration(
              border: Border.all(
                color: colors.focus,
                width: interaction.focusWidth,
              ),
              borderRadius: BorderRadius.circular(outer),
            )
          : null,
      child: Opacity(
        opacity: interaction.opacity(states),
        child: Container(
          key: StatesPage.controlKey(mode, family, label),
          width: 152,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.background,
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(radius.control),
          ),
          child: Text(label, style: typography.base.copyWith(color: c.text)),
        ),
      ),
    );
  }
}
