# Design: Trilha de navegação

## Decisions

### D1. Montagem

`Semantics(container: true, label: semanticLabel)` em volta de um `Wrap` com `WrapCrossAlignment.center`. Cada link
vira um item com o link e, depois dele, o separador (`ExcludeSemantics`, `colors.label`, com `spacing.xs` de cada lado)
numa `Row` de largura mínima, para que link e separador quebrem juntos. A página atual é um `Text` com `colors.text`.

### D2. Separadores

`slash` `/`, `backSlash` `\`, `doubleSlash` `//`, `doubleBackSlash` `\`, `greaterThan` `>` e
`doubleGreaterThan` `>>`, como o `BreadcrumbsSeparatorStyle` do UI5.
