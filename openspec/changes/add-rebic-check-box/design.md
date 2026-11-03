# Design: Caixa de seleção

## Decisions

### D1. Semântica no núcleo

`RebicInteractable` recebe `bool? checked`, `bool mixed = false`, `bool? toggled` e `bool inMutuallyExclusiveGroup =
false`. No `Semantics` do elemento, `button` passa a `!link && checked == null && toggled == null && !mixed`, e os
novos valores vão a `checked`, `mixed`, `toggled` e `inMutuallyExclusiveGroup`. Os usos atuais não mudam.

### D2. Montagem

`MergeSemantics` + `RebicInteractable(checked: …, mixed: …)` envolvendo uma `Row` (caixa e texto), para que tocar o
texto acione a caixa e o alvo mínimo cubra o conjunto. `onPressed` é nulo quando `enabled` é `false`; quando
`editable` é `false`, é `() {}` (focável, sem ação); senão, chama `onSelect(partiallySelected || !selected)`. No modo
somente leitura, a caixa continua com a ação de toque na semântica (vazia) e é marcada com `Semantics(readOnly: true)`,
para o leitor de tela anunciar que o valor não muda.

A caixa é um `DecoratedBox` de lado `icons.control + spacing.xxs`, com `Border.all` fino e `radius.field`; a marca é
`Icon(RebicIcons.accept, size: icons.control)` e a parcial um `ColoredBox` com `Padding(spacing.xs)`.

### D3. Cores

| Situação | Fundo | Borda | Marca |
|---|---|---|---|
| normal | `base` | `fieldBorder` | `brand` |
| hover / pressionado | `base` | `brand` | `brand` |
| estado de valor | `stateColors.background` | `stateColors.border` | `brand` |
| somente leitura | `background` | `separator` | `label` |

Somente leitura no UI5 usa `sapField_ReadOnly_Background`/`_BorderColor`, sem papel próprio no Rebic; os valores
adotados entram no ADR 0009.

## Risks / Trade-offs

- **[`editable: false` com ação vazia]** → o detector ainda reage ao ponteiro (hover); é o comportamento do UI5, em que
  a caixa somente leitura é focável.
