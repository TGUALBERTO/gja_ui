# Design: Tabela

## Decisions

### D1. Configuração e estado

`RebicColumn` e `RebicColumnListItem<T>` são classes imutáveis de configuração; as células são widgets quaisquer.
A seleção é do pai (`selectedKeys` + `onSelectionChange`, como o `selectionChange` do UI5). O estado interno é só um
`FocusNode` por chave de linha acionável.

### D2. Linhas sem `Table`

O `Table` do Flutter não aceita um widget em volta de uma linha inteira (hover, toque e semântica por linha). Cada
linha é uma `Row` de células `Expanded(flex:)`, com a mesma geometria no cabeçalho: na seleção múltipla, uma célula
inicial com o `RebicCheckBox`; nas linhas `navigation`, uma célula final com a seta `slimArrowRight` (o cabeçalho
reserva a mesma largura). Linhas acionáveis (`active`, `navigation` ou o modo `singleSelectMaster`) são um
`RebicInteractable` (`selected` no modo de seleção), que junta os textos das células num nó de botão.

### D3. Largura e popin

Um `LayoutBuilder` classifica a largura da própria tabela com `breakpoints.classify`. Uma coluna com
`minScreenWidth` maior que essa classe some do cabeçalho e das linhas; com `demandPopin`, a célula dela aparece
abaixo das células visíveis, precedida do título da coluna ("Preço:"), com o recuo da primeira célula.

### D4. Teclado

Um `Focus` em volta das linhas trata as setas para cima e para baixo, movendo o foco entre as linhas acionáveis;
Enter e Espaço vêm do `RebicInteractable`.

### D5. Aparência

O título (`headerText`) é um `RebicTitle` H5. O cabeçalho das colunas e as linhas têm a altura mínima
`density.listItemHeight`, células com `spacing.s` nas laterais e `spacing.xs` em cima e embaixo, borda inferior
`colors.separator` e fundo `colors.base`; o texto do cabeçalho é `typography.base` em `colors.label`. Hover
`colors.hoverBackground` nas linhas acionáveis e `colors.selectionBackground` nas escolhidas. Sem itens, uma linha com
`noDataText` (padrão: `noData` da localização) centralizado em `colors.label`.
