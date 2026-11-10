# Proposal: Raios no modelo Fiori (`update-gja-foundation-radius-fiori-roles`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou os raios organizados em dois papéis genéricos: `control`
(4, botões e campos) e `container` (8, cartões, diálogos e menus). O Horizon define o raio por tipo de controle,
com parâmetros próprios: `sapButton_BorderCornerRadius`, `sapField_BorderCornerRadius`,
`sapPopover_BorderCornerRadius`, `sapElement_BorderCornerRadius` e `sapTile_BorderCornerRadius`. Os botões do
Horizon têm cantos de 0.5rem, e não de 0.25rem como os campos. Os cartões têm 1rem.

Esta é a sétima change da série de realinhamento da fundação.

## What Changes

- **BREAKING** `GjaRadiusTokens` troca `control` e `container` pelos papéis do Fiori:

  | Papel | Parâmetro Fiori | Valor de referência | Uso |
  |---|---|---|---|
  | `button` | `sapButton_BorderCornerRadius` (0.5rem) | 8 | botão, botão de ícone, anel de foco padrão |
  | `field` | `sapField_BorderCornerRadius` (0.25rem) | 4 | campos (futuros) |
  | `popover` | `sapPopover_BorderCornerRadius` (0.5rem) | 8 | popover, menu, dropdown |
  | `element` | `sapElement_BorderCornerRadius` (0.75rem) | 12 | diálogos e painéis (futuros) |
  | `tile` | `sapTile_BorderCornerRadius` (1rem) | 16 | cartão |

  Os passos (`none`…`xl`, `full`) não mudam.
- **BREAKING** `GjaRadius`, o enum de `GjaContainer`, passa a ter os papéis novos no lugar de `control` e
  `container`.
- Os widgets e o núcleo passam a usar os papéis novos:
  - `GjaButton` e `GjaIconButton` usam `button`, com cantos de 8 em vez de 4;
  - `GjaCard` usa `tile`, com 16 em vez de 8;
  - `GjaPopover` usa `popover`, com 8, sem mudança visual. Menu e dropdown herdam o raio do popover;
  - `GjaLink` usa `xs` no anel de foco;
  - `GjaInteractable` usa `button` como raio padrão do anel de foco.
- A página "Raios" e as demais páginas da galeria passam aos papéis novos, e os goldens afetados são regerados.
- ADR 0009: os valores dos papéis entram como provisórios.

Fora do escopo:
- Os raios de `GjaTooltip` (`s`), `GjaAvatar` quadrado (`s`) e `GjaStatusIndicator` invertido (`s`). Eles ficam
  para as changes desses widgets, porque dependem de parâmetros próprios do Horizon ainda não mapeados.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/radius`: papéis por tipo de controle do Fiori, interpolação e uso sem literais com `button`, e a
  página da galeria.
- `gja/core/interaction`: raio padrão do anel de foco passa a ser `button`.
- `gja/widgets/gja-container`: valores de `GjaRadius`, recorte e exemplo de cartão com `tile`.
- `gja/widgets/gja-button` e `gja/widgets/gja-icon-button`: raio `button`.
- `gja/widgets/gja-link`: raio `xs` no anel de foco.
- `gja/widgets/gja-card`: raio `tile`.
- `gja/widgets/gja-popover`: raio `popover`.

A change toca seis specs de widget, acima do limite de `gja/spec-governance`. A exceção se justifica como nas
changes de tipografia, sombras e espaçamento: renomear os papéis de um fundamento quebra todas as referências a eles.
Só `GjaContainer` muda de API (os valores do enum `GjaRadius`).

## Impact

- `packages/gja_foundation`: `GjaRadiusTokens` (campos, referência, contrato, diagnóstico), testes e CHANGELOG.
- `packages/gja_core`: `GjaInteractable` e o teste de valores do tema, CHANGELOG.
- `packages/gja_widgets`:
  - código: `GjaContainer` (enum), `GjaButton`, `GjaIconButton`, `GjaLink`, `GjaCard` e `GjaPopover`;
  - testes;
  - goldens de botões, cartão e contêiner;
  - CHANGELOG.
- `apps/gja_gallery`: cerca de 15 páginas que citam `radius.control` ou `radius.container`, a página "Raios" e
  os testes.
- `docs/adr/0009-provisional-horizon-values.md`.
- Sem efeito no catálogo e no portal.
