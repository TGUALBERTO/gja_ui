# Design: Navegação lateral

## Decisions

### D1. Estado

`StatefulWidget` com o conjunto de chaves abertas (inicialmente, os itens que contêm `selectedKey`) e um `FocusNode`
por chave. Abrir e fechar subitens é estado interno da navegação; a escolha é do pai.

### D2. Montagem

`Semantics(container, label)` com uma `Column`: um `Expanded` com `SingleChildScrollView` dos itens visíveis e, com
`fixedItems`, um `RebicSeparator` e os itens fixos. A largura é `5 × spacing.xxxl` expandida e `density.barHeight`
recolhida. Cada item é um `RebicInteractable` (`selected`, nó próprio) dentro de `Semantics(expanded:)` nos que têm
subitens, com a altura `density.listItemHeight`, o recuo `spacing.s + nível × spacing.l`, ícone, texto e seta
(`slimArrowRight` fechado, `slimArrowDown` aberto). Recolhido, o item mostra só o ícone num `RebicTooltip`.

### D3. Teclado

Um `Focus` em volta da lista trata as setas: para cima e para baixo movem o foco na ordem dos itens visíveis; para a
direita abre e para a esquerda fecha os subitens do item com o foco.
