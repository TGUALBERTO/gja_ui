# Design: Campo de seleção

## Decisions

### D1. Montagem

`StatefulWidget` com um `RebicPopoverController` próprio. O campo é um `RebicDropdown<T>` cuja âncora é um
`RebicInteractable` (botão, rótulo `semanticLabel`, valor o texto do item escolhido) com a moldura dos campos:
`DecoratedBox` com `radius.field`, borda fina e `Padding` horizontal `spacing.s`, uma `Row` com o texto (reticências)
e a seta `slimArrowDown`. O alvo mínimo vem do próprio `RebicInteractable`.

`onPressed` é nulo desabilitado, vazio somente leitura e `controller.toggle` nos demais casos. `onSelected` do
dropdown chama `onChange` quando o valor difere de `selectedKey`.

### D2. Teclado

Um `Focus` com `onKeyEvent` em volta do campo abre a lista com F4 e Alt+seta para baixo; Enter e Espaço já ativam o
`RebicInteractable`. O foco no item escolhido e o retorno do foco ao fechar são do `RebicDropdown`.

### D3. Cores e mensagem

As mesmas do `RebicInput`: borda `brand` em hover, pressionado ou foco; estado de valor por `stateColors`; somente
leitura com fundo `headerBackground`. A mensagem de estado aparece abaixo enquanto o campo tem o foco.
