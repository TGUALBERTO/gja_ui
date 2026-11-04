# Design: Barra de shell com menu "mais" e menu no título

## Decisions

### D1. Estado

A barra continua `StatelessWidget`: o menu do título e o menu "mais" são widgets privados com estado, cada um com o
próprio `RebicPopoverController`.

### D2. Menu "mais" pela classe de largura

O `LayoutBuilder` que já escolhe a margem classifica a largura; na classe S, as notificações e os `RebicButton` de
`additionalContent` saem da linha e viram `RebicMenuItem`s de um `RebicMenu` ancorado num `RebicButton` transparente
com `RebicIcons.overflow` e a dica `more`. Outros widgets de `additionalContent` ficam na barra, como os controles sem
representação no menu do `OverflowToolbar`. O UI5 mede o espaço; a classe de largura dá o mesmo resultado nas
larguras típicas sem medir a linha (ADR 0009).

### D3. Título com menu

Com `menu`, o título (no lugar do `RebicTitle`) é um `RebicInteractable` com o texto no estilo H5 e a seta
`slimArrowDown`, ancorado num `RebicMenu`; o segundo título continua ao lado.
