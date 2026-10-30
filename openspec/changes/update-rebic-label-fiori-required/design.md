# Design: Asterisco de obrigatório no modelo do SAPUI5

## Context

- O papel `required` usa `red600` (claro) e `red300` (escuro), os mesmos primitivos do `error`.
- No `RebicLabel`, o asterisco é um `Text('*')` (ou um `TextSpan`, com `wrapping`) com o estilo do rótulo e a cor
  `required`.

Veja proposal.md para os valores do Horizon conferidos.

## Goals / Non-Goals

**Goals:**
- Asterisco com a cor, o tamanho, o peso e a margem do UI5.

**Non-Goals:**
- Reproduzir os valores hexadecimais da SAP: a spec de cor proíbe isso.

## Decisions

### D1. Escala `magenta`

`RebicColorPrimitives` ganha `magenta50` a `magenta900`, com o mapa `magenta` e a entrada em `scales`:

| Posição | Valor |
|---|---|
| 50 | `#FCEFF6` |
| 100 | `#F9D7E8` |
| 200 | `#F2AFD2` |
| 300 | `#EA82B8` |
| 400 | `#DD559C` |
| 500 | `#C4307F` |
| 600 | `#A81A68` |
| 700 | `#861453` |
| 800 | `#640F3E` |
| 900 | `#430A2A` |

A luminância decresce com a posição. `required` passa a `magenta600` no claro (6,97, 6,56 e 6,11 sobre `base`,
`background` e `headerBackground`) e a `magenta300` no escuro (6,54, 7,32 e 5,09).

### D2. Asterisco

O estilo do asterisco é `typography.large.copyWith(fontWeight: typography.baseBold.fontWeight, color:
colors.required)`. O peso vem do token `baseBold`, para não usar um valor literal.

Antes do asterisco há `spacing.xxs` (2, o 0,125rem do UI5):
- sem `wrapping`: é o espaçamento entre o `Text(':')` e o `Text('*')` na `Row` (`Padding` só no asterisco);
- com `wrapping`: um `WidgetSpan` de `SizedBox(width: xxs)` antes do `TextSpan` do asterisco.

A `Row` alinha pela linha de base, então o asterisco maior não desalinha o texto.

## Risks / Trade-offs

- **[Os goldens do rótulo, da galeria e de quem usa `required` mudam]** → só o rótulo usa `required` hoje. Os goldens
  do rótulo são regerados e conferidos.
