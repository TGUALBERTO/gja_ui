# Proposal: Densidade no modelo Fiori (`update-gja-foundation-density-fiori-cozy`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou a densidade presa ao Material:
- **Nome.** O modo `comfortable` é o nome do Material. No Fiori, as densidades de conteúdo são Cozy (`sapUiSizeCozy`)
  e Compact (`sapUiSizeCompact`).
- **Medidas.** Hoje o confortável tem controle 40, item 48 e alvo 48 (diretriz de toque do Material), e o compacto tem
  controle 32, item 32 e alvo 24. O Horizon define a altura de elemento e a altura de linha:
  - Cozy: `sapElement_Height` 2.25rem (36) e `sapElement_LineHeight` 2.75rem (44);
  - Compact: `sapElement_Compact_Height` 1.625rem (26) e `sapElement_Compact_LineHeight` 2rem (32).

  No `sap.m.Button`, a caixa externa tem a altura de linha, e o botão visível, a altura de elemento, centrado nela.
  É a mesma divisão que o GJA já faz entre `controlHeight` e `minTargetSize`.

Esta é a quinta change da série de realinhamento da fundação.

## What Changes

- **BREAKING** `GjaDensity.comfortable` passa a `GjaDensity.cozy`, e `GjaDensityTokens.comfortable()` passa a
  `GjaDensityTokens.cozy()`. Em português, a spec chama `cozy` de "densidade confortável", e as specs de widget que
  falam em "densidade confortável" continuam válidas.
- **BREAKING** Medidas de referência:

  | Medida | Cozy (antes → agora) | Compact (antes → agora) | Parâmetro Fiori |
  |---|---|---|---|
  | `controlHeight` | 40 → 36 | 32 → 26 | `sapElement_Height` / `_Compact_Height` |
  | `listItemHeight` | 48 → 44 | 32 → 32 | `sapElement_LineHeight` / `_Compact_LineHeight` |
  | `minTargetSize` | 48 → 44 | 24 → 32 | `sapElement_LineHeight` / `_Compact_LineHeight` |

  O piso de alvo continua 24 (WCAG 2.2, 2.5.8).
- Novos primitivos de densidade, `GjaDensityPrimitives` (`size26`, `size32`, `size36` e `size44`), porque 26, 36 e
  44 não estão na grade de 4 px do espaçamento. As dimensões de densidade passam a vir desta escala.
- A regra "o controle comporta o rótulo" passa a usar a linha do estilo `base` mais 2 × `xxs`. Com 2 × `xs`, o
  compacto de 26 não comportaria a linha de 20 e o respiro de 8, e o Fiori também não reserva esse respiro.
- `GjaResponsive` recomenda `cozy` em Android, iOS e Fuchsia.
- Os goldens passam de `*_comfortable.png` a `*_cozy.png` e são regerados: botões, itens e alvos mudam de tamanho nas
  duas densidades.
- A galeria e os testes passam ao nome novo.
- ADR 0009: entra como provisória a equivalência `minTargetSize` = altura de linha.

Fora do escopo:
- A densidade Condensed (`sapUiSizeCondensed`), só de tabelas. Ela fica para o widget de tabela.
- O espaçamento compacto e as margens Fiori, que ficam para a change de espaçamento, a próxima da série.
- Os itens de dropdown e menu usarem `listItemHeight` em vez de `controlHeight`, como os itens de lista do
  `sap.m.Select`. Isso fica para as changes desses widgets.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/density`:
  - modos `cozy` e `compact`;
  - dimensões e primitivos no modelo `sapElement_*`;
  - alvo mínimo de 44 no cozy;
  - regra do rótulo com `xxs`;
  - interpolação de exemplo e página da galeria.
- `gja/foundation/accessibility`: alvo por densidade de 44 e 32.
- `gja/foundation/theming`: densidade padrão `cozy`.
- `gja/framework-architecture`: densidades `cozy` e `compact`.
- `gja/core/responsive`: densidade recomendada `cozy` para toque.
- `gja/widgets/gja-app`: cenário de densidade informada com `cozy`.

A change toca uma spec de widget, dentro do limite de `gja/spec-governance`.

## Impact

- `packages/gja_foundation`: densidade (enum, tokens, primitivos novos em `gja_primitives.dart`), tema, testes e
  CHANGELOG.
- `packages/gja_core`: `GjaResponsive.recommendedDensity` e o teste dela, e CHANGELOG.
- `packages/gja_widgets`:
  - cerca de 20 arquivos de teste com `GjaDensity.comfortable`;
  - o suporte de goldens (`goldenThemes`, que nomeia pelo modo);
  - todos os goldens, renomeados e regerados;
  - CHANGELOG.

  O código dos widgets só muda onde cita `comfortable`: as medidas vêm dos tokens.
- `apps/gja_gallery`: páginas "Densidade", "GjaTheme" e as que citam o modo, com os testes.
- `docs/adr/0009-provisional-horizon-values.md`.
- Sem efeito no catálogo e no portal.
