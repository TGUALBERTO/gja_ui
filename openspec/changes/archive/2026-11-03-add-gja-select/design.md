# Design: Campo de seleção

## Decisions

### D1. Montagem

`StatefulWidget` com um `GjaPopoverController` próprio. O campo é um `GjaDropdown<T>` cuja âncora é um
`GjaInteractable` (botão, rótulo `semanticLabel`, valor o texto do item escolhido) com a moldura dos campos:
`DecoratedBox` com `radius.field`, borda fina e `Padding` horizontal `spacing.s`, uma `Row` com o texto (reticências)
e a seta `slimArrowDown`. O alvo mínimo vem do próprio `GjaInteractable`.

`onPressed` é nulo desabilitado, vazio somente leitura e `controller.toggle` nos demais casos. `onSelected` do
dropdown chama `onChange` quando o valor difere de `selectedKey`.

### D2. Teclado

Um `Focus` com `onKeyEvent` em volta do campo abre a lista com F4 e Alt+seta para baixo; Enter e Espaço já ativam o
`GjaInteractable`. O foco no item escolhido e o retorno do foco ao fechar são do `GjaDropdown`.

### D3. Cores e mensagem

As mesmas do `GjaInput`: borda `brand` em hover, pressionado ou foco; estado de valor por `stateColors`; somente
leitura com fundo `headerBackground`. A mensagem de estado aparece abaixo enquanto o campo tem o foco.
