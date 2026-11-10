# Design: Barra de ferramentas

## Decisions

### D1. Montagem

`DecoratedBox` (fundo pelo desenho; borda inferior fina `separator` no estilo `standard`) com a altura
`density.barHeight` e `Padding` horizontal `spacing.s`, em volta da linha de itens.

A linha é um `RenderObject` próprio (`_RenderToolbarRow`), não uma `Row`: o `Spacer` precisa de largura limitada para
dividir o espaço livre, e itens que não cabem precisam ser cortados sem o erro de estouro que o `RenderFlex` relata
mesmo com `clipBehavior`. A linha mede os itens fixos no tamanho natural, dá aos flexíveis (os `Spacer`, marcados por
um `ParentDataWidget` interno) a parte do espaço livre, centraliza os itens na altura, segue a direção do texto e,
quando a soma passa da largura, corta a pintura com `pushClipRect`.

### D2. Barra acionável

Com `onPress`, a barra fica num `GjaInteractable` (rótulo `semanticLabel`), que dá foco, Enter/Espaço, hover e
desabilitado; o fundo de hover ou pressionado é `hoverBackground`. Sem `onPress`, um `Semantics(container: true,
label: semanticLabel)` agrupa os itens.

### D3. Cores

| Desenho | Fundo |
|---|---|
| `transparent` | nenhum |
| `solid` | `base` (`sapToolbar_Background`) |
| `info` | `stateColors(information).background` (`sapInfobar_Background`) |

A borda inferior do estilo padrão é `separator` (`sapGroup_TitleBorderColor` no UI5, sem papel no GJA).
