# Proposal: Espaçamento no modelo Fiori (`update-rebic-foundation-spacing-fiori-margins`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 deixou o espaçamento para depois da densidade. A análise achou duas
diferenças em relação ao Fiori:
- **Margem de página fixa.** `pageMargin` vale 16 em qualquer largura. No Fiori, o conteúdo da página tem padding
  responsivo (`sapUiResponsivePadding`, `sap.f.DynamicPage`): 1rem em S, 2rem em M e L, e 3rem em XL, conforme a
  largura da própria página.
- **Espaçamento compacto reduzido.** A densidade compacta reduz todos os passos e papéis (`l` 16 → 12, `pageMargin`
  16 → 12). É o padrão "dense" do Material. No Fiori, a densidade de conteúdo muda só as alturas de elemento: as
  classes de margem (`sapUiTinyMargin`, `sapUiSmallMargin`, `sapUiMediumMargin`, `sapUiLargeMargin`) valem o mesmo em
  Cozy e Compact.

Os passos de referência já coincidem com as classes de margem: `s` = 8 (Tiny), `l` = 16 (Small), `xxl` = 32 (Medium) e
`xxxl` = 48 (Large). Falta tornar essa correspondência explícita na spec.

Esta é a sexta change da série de realinhamento da fundação.

## What Changes

- `RebicSpacingTokens`:
  - `pageMarginMedium`, `pageMarginLarge` e `pageMarginExtraLarge` novos;
  - `pageMarginFor(RebicSizeClass)` novo;
  - `pageMargin` continua sendo a margem da classe S.

  Na referência, os valores são 16, 32, 32 e 48, como `sapUiResponsivePadding`. Os três campos novos ficam fora do mapa
  de passos e papéis, que continua com os treze nomes de `RebicSpace`.
- Requisito novo de correspondência entre passos e classes de margem do Fiori:

  | Passo | Valor | Classe Fiori |
  |---|---|---|
  | `s` | 8 | `sapUiTinyMargin` |
  | `l` | 16 | `sapUiSmallMargin` |
  | `xxl` | 32 | `sapUiMediumMargin` |
  | `xxxl` | 48 | `sapUiLargeMargin` |

- **BREAKING (visual)** A densidade compacta passa a usar o mesmo espaçamento de referência da cozy. O espaçamento
  compacto reduzido deixa de existir. Botões e controles compactos continuam menores pelas alturas de elemento
  (`update-rebic-foundation-density-fiori-cozy`).
- `RebicPage` passa a usar a margem de página da classe de tamanho da própria largura, como a `sap.f.DynamicPage`.
- A página "Espaçamentos" da galeria mostra as margens por classe.
- Os goldens compactos que dependem de espaçamento são regerados, e o de `RebicPage` também.

Fora do escopo:
- `RebicSpacing` com `RebicSpace.pageMargin` continua usando a margem da classe S. A spec de `RebicSpacing` já diz que
  margens responsivas não são dele.
- As páginas da galeria que usam `spacing.pageMargin` direto (cerca de 18) continuam com a margem S. Elas não são
  `RebicPage`, e passam a ser páginas `RebicPage` na change que realinhar a galeria.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/foundation/spacing`: margens de página por classe de tamanho, correspondência com as classes de margem do
  Fiori e página da galeria.
- `rebic/foundation/density`: as duas densidades usam o mesmo espaçamento de referência.
- `rebic/widgets/rebic-page`: margem do conteúdo pela classe de tamanho da página, e dependência de
  `rebic/foundation/breakpoints`.

## Impact

- `packages/rebic_foundation`: `RebicSpacingTokens` (campos, `pageMarginFor`, contrato, diagnóstico), densidade (sem
  `_compactSpacing`), testes e CHANGELOG.
- `packages/rebic_widgets`:
  - `RebicPage`: `LayoutBuilder` e classificação pela largura;
  - os testes que esperam valores compactos menores passam a conferir os tokens;
  - goldens compactos afetados;
  - CHANGELOG.
- `apps/rebic_gallery`: página "Espaçamentos" e seu teste.
- `docs/adr/0009-provisional-horizon-values.md`: margens de página XL e M/L.
- Sem efeito em `rebic_core`, no catálogo e no portal.
