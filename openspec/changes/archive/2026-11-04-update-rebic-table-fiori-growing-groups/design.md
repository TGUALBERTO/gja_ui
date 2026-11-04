# Design: Tabela com mais linhas e grupos

## Decisions

### D1. Itens selados

`RebicListItemBase<T>` é `sealed`, com `RebicColumnListItem<T>` e `RebicGroupHeaderListItem<T>`; a tabela usa um
`switch` exaustivo. Seleção, teclado, validação de chaves e `growing` olham só as linhas.

### D2. Crescimento

O estado guarda quantas linhas mostrar (de início, `growingThreshold`). Os itens são percorridos até a última linha
mostrada; um título de grupo só aparece se alguma linha dele aparece. O botão é um `RebicInteractable` na largura da
tabela, na altura `density.listItemHeight`, com o texto em `typography.baseBold` e a contagem em `typography.small`
`colors.label`, formatada no idioma.

### D3. Título de grupo

Um `_Frame` (fundo `colors.base`, borda inferior `colors.separator`, altura `density.listItemHeight`) com o título
em `typography.baseBold` `colors.text` e `Semantics(header: true)`.
