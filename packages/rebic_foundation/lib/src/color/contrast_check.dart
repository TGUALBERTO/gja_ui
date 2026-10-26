import 'dart:ui' show Color;

import 'color_tokens.dart';
import 'contrast.dart';
import 'value_state.dart';

/// Par de papéis abaixo do contraste mínimo.
///
/// [foreground] e [background] são os nomes dos papéis (ex.: `text`,
/// `error.foreground`), [ratio] é a razão encontrada e [minimum], a exigida.
typedef RebicContrastIssue = ({
  String foreground,
  String background,
  double ratio,
  double minimum,
});

/// Contraste mínimo para texto (WCAG 2.1 AA).
const double rebicTextContrastMinimum = 4.5;

/// Contraste mínimo para elementos não textuais (WCAG 2.1 AA).
const double rebicNonTextContrastMinimum = 3;

/// Verifica os pares de papéis de [tokens] contra os mínimos do WCAG 2.1 AA.
///
/// Texto (≥ 4,5:1): `text` sobre `background`, `base`, `headerBackground`,
/// `hoverBackground`, `selectionBackground` e `selectionHoverBackground`;
/// `label` e `link` sobre `background`, `base` e `headerBackground`; `brand`
/// sobre `background`, `base`, `hoverBackground`, `selectionBackground` e
/// `selectionHoverBackground`; `contrastText` sobre `brand`, `brandHover` e
/// `highlight`; o `foreground` de cada estado de valor sobre `base`,
/// `background` e o `background` do estado.
///
/// Não textual (≥ 3:1): `fieldBorder`, `focus` e `brand` sobre `background`,
/// `base` e `headerBackground`; o `border` de cada estado sobre `base` e
/// `background`.
///
/// `separator`, `shadow` e `blockLayer` são decorativos e isentos. Retorna os
/// pares abaixo do mínimo; a lista vazia significa conformidade.
List<RebicContrastIssue> rebicCheckContrast(RebicColorTokens tokens) {
  final issues = <RebicContrastIssue>[];
  void pair(String fgName, String bgName, double minimum) {
    final fg = tokens.roles[fgName]!;
    final bg = tokens.roles[bgName]!;
    final ratio = rebicContrastRatioOver(fg, bg);
    if (ratio < minimum) {
      issues.add((
        foreground: fgName,
        background: bgName,
        ratio: ratio,
        minimum: minimum,
      ));
    }
  }

  const text = rebicTextContrastMinimum;
  const nonText = rebicNonTextContrastMinimum;
  const containers = ['background', 'base', 'headerBackground'];
  for (final bg in [
    ...containers,
    'hoverBackground',
    'selectionBackground',
    'selectionHoverBackground',
  ]) {
    pair('text', bg, text);
  }
  for (final bg in containers) {
    pair('label', bg, text);
    pair('link', bg, text);
    pair('fieldBorder', bg, nonText);
    pair('focus', bg, nonText);
    pair('brand', bg, nonText);
  }
  for (final bg in [
    'background',
    'base',
    'hoverBackground',
    'selectionBackground',
    'selectionHoverBackground',
  ]) {
    pair('brand', bg, text);
  }
  for (final bg in ['brand', 'brandHover', 'highlight']) {
    pair('contrastText', bg, text);
  }

  for (final state in RebicValueState.values) {
    final colors = tokens.stateColors(state);
    final name = state.name;
    void statePair(
      String fgName,
      Color fg,
      String bgName,
      Color bg,
      double min,
    ) {
      final ratio = rebicContrastRatioOver(fg, bg);
      if (ratio < min) {
        issues.add((
          foreground: fgName,
          background: bgName,
          ratio: ratio,
          minimum: min,
        ));
      }
    }

    for (final bgName in ['base', 'background']) {
      final bg = tokens.roles[bgName]!;
      statePair('$name.foreground', colors.foreground, bgName, bg, text);
      statePair('$name.border', colors.border, bgName, bg, nonText);
    }
    statePair(
      '$name.foreground',
      colors.foreground,
      '$name.background',
      colors.background,
      text,
    );
  }
  return issues;
}
