# Design: Densidade no modelo Fiori

## Context

`GjaDensityTokens` (em `gja_foundation/lib/src/density/`) tem `controlHeight`, `listItemHeight`, `minTargetSize`
e o espaçamento da densidade. As dimensões vêm de `GjaSpacingPrimitives` (grade de 4 px).

Como os widgets usam as dimensões:
- `GjaInteractable`, em `gja_core`, envolve o visual num `ConstrainedBox` com mínimo `minTargetSize` e o centra. É
  a caixa externa do `sap.m.Button`.
- `GjaButton` e `GjaIconButton` usam `controlHeight` para o visual.
- Os itens do dropdown e do menu usam `controlHeight` como altura mínima.

Onde o nome `comfortable` aparece:
- `gja_core`: `GjaResponsive.recommendedDensity`;
- a galeria (`main.dart`, páginas de espaçamento, tema e `GjaTheme`);
- cerca de 20 arquivos de teste de widgets;
- o suporte de goldens, que nomeia os arquivos por `density.name`. Por isso há 38 arquivos `*_comfortable.png`.

## Goals / Non-Goals

**Goals:**
- Nomes e medidas das densidades de conteúdo do Fiori.
- Widgets sem mudança de código além da renomeação: as medidas novas chegam pelos tokens.

**Non-Goals:**
- Densidade Condensed.
- Espaçamento compacto e margens Fiori (change de espaçamento).
- Mudar `GjaInteractable` ou a forma como os widgets usam as dimensões.

## Decisions

### D1. Renomeação

`GjaDensity.comfortable` → `GjaDensity.cozy` e `GjaDensityTokens.comfortable()` → `GjaDensityTokens.cozy()`,
sem alias. A API é 0.x e a renomeação é a mesma em todo o repositório. O dartdoc de `cozy` diz "densidade
confortável, como `sapUiSizeCozy`", para que a prosa das specs de widget continue correspondendo.

### D2. Primitivos de densidade

Nova classe `GjaDensityPrimitives`, em `src/density/primitives/density_primitives.dart`, exportada por
`gja_primitives.dart`:

| Primitivo | Valor | Parâmetro Fiori |
|---|---|---|
| `size26` | 26 | `sapElement_Compact_Height` (1.625rem) |
| `size32` | 32 | `sapElement_Compact_LineHeight` (2rem) |
| `size36` | 36 | `sapElement_Height` (2.25rem) |
| `size44` | 44 | `sapElement_LineHeight` (2.75rem) |

O mapa `sizes` lista os quatro em ordem crescente.

Alternativa considerada: acrescentar 26, 36 e 44 à escala de espaçamento. Rejeitada porque quebraria a grade de 4 px
que a spec de espaçamento exige, e porque são medidas de elemento, não de espaço.

### D3. Mapeamentos de referência

- `cozy()`: `controlHeight` = `size36`, `listItemHeight` = `size44`, `minTargetSize` = `size44` e o espaçamento de
  referência.
- `compact()`: `controlHeight` = `size26`, `listItemHeight` = `size32`, `minTargetSize` = `size32` e o espaçamento
  compacto atual.

O alvo compacto passa de 24 a 32 porque a caixa externa do `sap.m.Button` compacto tem `sapElement_Compact_LineHeight`.
Continua acima do piso de 24.

### D4. Regra do rótulo

A spec passa a exigir `controlHeight ≥ base.height × base.fontSize + 2 × spacing.xxs`. Isso dá 36 ≥ 24 no cozy e
26 ≥ 24 no compacto. O teste usa o estilo `base` de `GjaTypographyTokens.fallback()`.

### D5. Goldens

`goldenThemes` já nomeia pelo `density.name`, então os arquivos novos saem como `*_cozy.png`. Os `*_comfortable.png`
são apagados com `git rm`. Todos os goldens são regerados no Windows (ADR 0008), porque botões, itens e alvos mudam
nas duas densidades. A revisão confere por amostragem:
- o botão cozy de 36 dentro de uma caixa de 44;
- o botão compacto de 26 dentro de 32;
- os itens de dropdown e menu.

### D6. Testes com valores literais

Testes de widgets que conferem medidas por número (40, 48, 32, 24) passam a comparar com os tokens
(`theme.density.controlHeight` etc.) sempre que possível, para não depender de novo dos valores de referência.

### D7. ADR 0009

Nova linha provisória: `minTargetSize` igual à altura de linha (`sapElement_LineHeight`), aplicada também à largura
pela `GjaInteractable`. No SAPUI5, a caixa externa só tem a altura de linha, e a largura segue o botão.

## Risks / Trade-offs

- **[Largura mínima de 44 em botões de ícone]** A `GjaInteractable` aplica o alvo também na largura. Com isso, botões
  de ícone cozy ficam com caixa de 44 × 44 e visual de 36, e um espaço lateral aparece entre botões vizinhos, maior do
  que numa barra do SAPUI5. O comportamento atual já é esse, com 48 e 40. → A ADR 0009 registra a diferença, e a
  correção (alvo só na altura) fica para a change de `GjaIconButton`.
- **[Volume de goldens]** Todos mudam. → A regeração é mecânica, e a revisão por amostragem segue D5.
- **[Quebra de API 0.x]** `comfortable` deixa de existir. → O CHANGELOG traz o de/para.
- **[Compacto de 26 com texto de 20]** Sobra pouco respiro vertical, mas é a medida do Horizon. A escala de texto 2,0
  continua coberta pelos testes de estouro dos widgets, que deixam o controle crescer.
