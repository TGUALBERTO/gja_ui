# Proposal: Asterisco de obrigatório no modelo do SAPUI5 (`update-gja-label-fiori-required`)

## Why

A change do rótulo deixou dois valores provisórios no ADR 0009, que agora foram conferidos nas fontes:

- **Cor:** o `sapField_RequiredColor` do Horizon é magenta: `#ba066c` no claro e `#ff78a4` no escuro, conferido em
  `SAP/theming-base-content`, nos `css_variables.css` do `sap_horizon` e do `sap_horizon_dark`. O GJA usa o
  vermelho do estado de erro, que se confunde com ele.
- **Asterisco:** no `sap.m.Label` (`sap.m/themes/base/Label.less`), o asterisco tem `sapFontLargeSize`, negrito e
  margem de 0,125rem antes. O GJA usa o estilo do próprio rótulo, sem margem.

## What Changes

- Fundação de cor:
  - nova escala primitiva `magenta` (50 a 900), com valores próprios, sem reproduzir a paleta da SAP;
  - o papel `required` passa a `magenta600` no claro e a `magenta300` no escuro, com contraste de 6,11 a 7,32
    sobre `background`, `base` e `headerBackground`.
- `GjaLabel`: o asterisco usa `typography.large` em negrito, com `spacing.xxs` antes, na cor `required`.
- ADR 0009: saem as duas linhas provisórias (cor do `required` e tamanho do asterisco).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/color`: escala primitiva `magenta`.
- `gja/widgets/gja-label`: estilo e espaço do asterisco.

## Impact

- `packages/gja_foundation`: escala `magenta` em `GjaColorPrimitives`, mapeamentos de `required`, testes e
  CHANGELOG.
- `packages/gja_widgets`: `GjaLabel`, testes e goldens do rótulo; CHANGELOG.
- `docs/adr/0009-provisional-horizon-values.md`: duas linhas a menos.
- Portal existente: nenhum impacto.
