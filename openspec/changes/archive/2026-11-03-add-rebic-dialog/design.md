# Design: Diálogo

## Decisions

### D1. Painel

Como o painel do `RebicPopover`: `Semantics(scopesRoute, namesRoute, explicitChildNodes, label)` em volta de um
`SizedBox` com a largura de `steps × spacing.xxxl` (8 ou 12), limitada à largura da tela menos `2 × spacing.l`, e um
`RebicContainer` (`base`, `radius.element`, `shadows.dialog`) com uma `Column`: título (com o ícone do estado) e
`RebicSeparator`; o conteúdo num `Flexible` + `SingleChildScrollView` com `spacing.l`; e, com botões,
`RebicSeparator` e um `OverflowBar` alinhado ao fim com `spacing.s` em volta.

### D2. Abertura

`RebicDialog.open<T>(context, {required WidgetBuilder builder, bool dismissible = true})` devolve
`RebicModal.show<T>(context, builder: builder, dismissible: dismissible)`. A camada, o foco preso, o foco inicial, o
retorno do foco e o Esc são do núcleo.

### D3. Ícone do estado

`success`: `sysEnter2`; `warning`: `warning`; `error`: `error`; `information`: `information`; `none`: sem ícone; na
cor `foreground` do estado e no tamanho `icons.control`.
