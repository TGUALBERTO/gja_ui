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

### D3. Altura com o botão de fechar

O botão de fechar mantém o alvo mínimo da densidade (`minTargetSize`), como todo `RebicButton`; por isso a faixa com
ele fica mais alta que a faixa só com texto (no UI5, o botão da faixa é compacto). A alternativa, um ícone acionável
sem alvo mínimo, deixaria a ação fora da bateria de acessibilidade.
