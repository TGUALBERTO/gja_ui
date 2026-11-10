# Design: Seletor de data com mês, ano e Hoje

## Decisions

### D1. Vistas do calendário

O `_Calendar` ganha uma vista (`dias`, `meses`, `anos`). O cabeçalho tem "Anterior", o botão do mês (só na vista
de dias), o botão do ano (nos dias e meses; nos anos, o intervalo "2016 – 2035" sem ação), o botão "Hoje" (opcional)
e "Próximo". Os botões do mês e do ano são `GjaButton` transparentes com o texto; "Anterior" e "Próximo" andam um
mês, um ano ou vinte anos conforme a vista.

### D2. Grades

Meses em 3 colunas × 4 linhas (`monthNames`), anos em 4 × 5 a partir de dez anos antes do ano mostrado. Cada
célula é um `GjaInteractable` na altura `density.minTargetSize`, com o fundo `colors.brand` no mês ou ano mostrado
e desabilitada fora dos limites. Escolher volta à vista de dias desse mês; o foco vai ao dia do mesmo número, limitado
ao fim do mês.

### D3. Hoje

O botão "Hoje" é um `GjaButton` transparente só com o ícone `GjaIcons.calendar` e a dica `today` (o texto não cabe no cabeçalho compacto, e o UI5 também usa um botão de ícone); chama a mesma escolha de um dia, com a data
atual, e fica desabilitado com hoje fora dos limites.
