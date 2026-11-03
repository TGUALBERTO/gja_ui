# Design: Barra de ferramentas

## Decisions

### D1. Montagem

`ClipRect` + `DecoratedBox` (fundo pelo desenho; borda inferior fina `separator` no estilo `standard`) com a altura
`density.barHeight` e `Padding` horizontal `spacing.s`, em volta de uma `Row` com `spacing.xs` e os itens centrados.
A `Row` fica num `OverflowBox` sem largura máxima, alinhado ao início, para que itens que não cabem sejam cortados
pelo `ClipRect`, sem estouro.

### D2. Barra acionável

Com `onPress`, a barra fica num `RebicInteractable` (rótulo `semanticLabel`), que dá foco, Enter/Espaço, hover e
desabilitado; o fundo de hover ou pressionado é `hoverBackground`. Sem `onPress`, um `Semantics(container: true,
label: semanticLabel)` agrupa os itens.

### D3. Cores

| Desenho | Fundo |
|---|---|
| `transparent` | nenhum |
| `solid` | `base` (`sapToolbar_Background`) |
| `info` | `stateColors(information).background` (`sapInfobar_Background`) |

A borda inferior do estilo padrão é `separator` (`sapGroup_TitleBorderColor` no UI5, sem papel no Rebic).
