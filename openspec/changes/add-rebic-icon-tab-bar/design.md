# Design: Barra de abas

## Decisions

### D1. Cabeçalho

`StatefulWidget` com um `FocusNode` por aba. O cabeçalho é um `SingleChildScrollView` horizontal com uma `Row` das
abas, sobre uma borda inferior fina `separator`. Cada aba é um `RebicInteractable` (rótulo com texto e contagem,
`selected`, nó próprio) com a altura `density.barHeight`, `spacing.l` nas laterais, ícone, texto e contagem, e um
traço `brand` de `spacing.xxs` na base quando escolhida. O fundo de hover ou pressionado é `hoverBackground`.

### D2. Foco itinerante

Como no `RebicRadioButtonGroup`: só o nó da aba escolhida (ou da primeira habilitada) fica na ordem de Tab
(`skipTraversal` nos demais). Um `Focus` em volta do cabeçalho trata as setas para a direita e para a esquerda,
movendo o foco à aba habilitada seguinte, circular, sem escolher; Enter e Espaço são do `RebicInteractable`.

### D3. Conteúdo

Abaixo do cabeçalho, o `content` da aba escolhida, com `spacing.l` em volta quando `applyContentPadding`.
