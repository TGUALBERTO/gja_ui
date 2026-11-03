# Design: Faixa de mensagem

## Decisions

### D1. Montagem

`Semantics(container: true, liveRegion: true)` em volta de um `DecoratedBox` (`stateColors(type).background`, borda
fina `border`, `radius.popover`) com `Padding` (`spacing.l` nas laterais, `spacing.s` em cima e embaixo) e uma `Row`:
o ícone (`ExcludeSemantics`), um `Expanded` com um `Wrap` do texto e do link, e o botão de fechar (`RebicButton` só
com ícone, `transparent`). O texto quebra em várias linhas.

### D2. Ícones

`information` e `none`: `RebicIcons.information`; `success`: `sysEnter2`; `warning`: `warning`; `error`: `error`, na
cor `foreground` do tipo e no tamanho `icons.control`.
