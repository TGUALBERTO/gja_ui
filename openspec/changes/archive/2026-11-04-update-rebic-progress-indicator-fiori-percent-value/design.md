# Design: Indicador de progresso no modelo do SAPUI5

## Decisions

### D1. Uma barra

O widget público passa a ter só o construtor padrão, que monta o `RebicProgressView` linear com
`percentValue / 100`. O `RebicProgressView` e o pintor continuam com a forma circular e a indeterminada, que o
`busy` do `RebicButton` usa; são internos e não exportados.

### D2. Requisitos

Os requisitos do indeterminado e do movimento reduzido saem; um novo requisito de comportamento cobre a animação
até o novo valor (`motion.short`) e a troca imediata com movimento reduzido. Os demais são ajustados para a barra
e para `percentValue`, mantendo os nomes de cenário que continuam valendo.
