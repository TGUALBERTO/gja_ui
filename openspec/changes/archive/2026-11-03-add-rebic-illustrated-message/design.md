# Design: Mensagem ilustrada

## Decisions

### D1. Montagem

Uma `Column` centralizada com `spacing.m` entre os filhos: a ilustração (o `illustration` dado ou um `Icon` do tipo,
em `ExcludeSemantics`), o `RebicTitle` centralizado e com quebra (`titleStyle` pelo tamanho, `level` de
`titleLevel`), a descrição (`RebicText` centralizado) e um `Wrap` centralizado com `additionalContent`.

### D2. Tamanhos

| Tamanho | Ícone | Estilo do título |
|---|---|---|
| `spot` | `icons.xLarge` | `h4` |
| `dialog` | `2 × icons.xLarge` | `h3` |
| `scene` | `4 × icons.xLarge` | `h2` |
