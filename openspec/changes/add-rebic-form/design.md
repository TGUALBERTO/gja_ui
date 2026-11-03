# Design: Formulário

## Decisions

### D1. Configuração

`RebicFormContainer` e `RebicFormElement` são classes imutáveis de configuração, como `RebicNavigationListItem`, e
não widgets: o formulário decide onde ficam o rótulo e os campos. Os campos são widgets quaisquer (`RebicInput`,
`RebicSelect`…), com o próprio estado e callbacks; o formulário não tem estado nem controlador.

### D2. Largura e colunas

Um `LayoutBuilder` classifica a largura do formulário com `breakpoints.classify` (como o `ColumnLayout`, que olha o
próprio formulário, não a tela). O número de colunas é 1 no S e `columnsM`/`columnsL`/`columnsXL` nas outras
classes, limitado ao número de contêineres; os contêineres preenchem as colunas linha a linha, com `spacing.l` entre
colunas e entre linhas.

### D3. Elemento

Com rótulo ao lado (L, XL, ou M com uma coluna), o elemento é uma `Row`: o rótulo com `labelCellsLarge` partes de 12
da largura da coluna, alinhado ao centro de uma altura mínima `density.controlHeight`, `spacing.s` depois, e os
campos no resto. Com rótulo acima, uma `Column` com `spacing.xs` entre o rótulo e os campos. Vários campos dividem a
largura igualmente, com `spacing.s` entre eles. Entre elementos, `spacing.s`. O rótulo é um `RebicLabel` com
quebra de linha e `required`.

### D4. Títulos

O título do formulário é um `RebicTitle` no estilo H4, e o de cada contêiner no estilo H5, ambos expostos como
cabeçalho, com `spacing.s` abaixo.
