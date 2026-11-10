# Design: Opção de rádio e grupo

## Decisions

### D1. Opção

Como a caixa de seleção: `MergeSemantics` + `GjaInteractable(checked: selected, inMutuallyExclusiveGroup: true,
focusNode: focusNode)` com uma `Row` (círculo e texto). `onPressed` é nulo desabilitada, vazio somente leitura ou já
marcada, e `onSelect(true)` nos demais casos. O círculo é um `DecoratedBox` circular de lado
`icons.control + spacing.xxs`; o ponto, um círculo `brand` de lado `spacing.s`.

### D2. Grupo

`StatefulWidget` com um `FocusNode` por opção. Cada opção é reconstruída com `selected: i == selectedIndex`,
`onSelect` que chama o `onSelect` do grupo com `i`, `enabled`/`editable` do grupo e da opção, `valueState` do grupo
(quando não `none`) e o nó `i`. Os nós que não são o de entrada (a opção marcada ou, sem ela, a primeira habilitada)
recebem `skipTraversal`, para Tab entrar e sair do grupo de uma vez.

As setas são tratadas por um `Focus` em volta das opções: o índice seguinte (ou anterior) que esteja habilitado,
circular, recebe o foco e, se o grupo for editável, é escolhido.

Colunas: com `columns` 1, uma `Column` de largura mínima; senão, linhas de `columns` células `Expanded`, preenchidas
em ordem de leitura.
