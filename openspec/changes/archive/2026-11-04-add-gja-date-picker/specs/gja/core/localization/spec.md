# Spec Delta

## ADDED Requirements

### Requirement: Datas do calendário
Os textos SHALL ler uma data curta no formato do idioma (`parseDate`, nula se inválida) e fornecer o padrão desse formato (`datePattern`), o mês com o ano (`formatMonthYear`), a data por extenso com o dia da semana (`formatLongDate`), o primeiro dia da semana (`firstDayOfWeek`, como `DateTime.weekday`), os nomes curtos dos dias a partir dele (`shortWeekdays`) e os textos `previous` e `next`, tudo do CLDR.

#### Scenario: Ler e escrever datas
- **WHEN** "05/03/2026" e "31/02/2026" são lidos em pt-BR, e 5 de março de 2026 é formatada como mês e como data por extenso
- **THEN** a primeira é 5 de março de 2026 e a segunda é nula, e os textos são "março de 2026" e "quinta-feira, 5 de março de 2026"

#### Scenario: Semana do calendário
- **WHEN** `firstDayOfWeek`, `shortWeekdays` e `datePattern` são lidos em pt-BR e em en
- **THEN** a semana começa no domingo nos dois, o primeiro nome é "dom." em pt-BR e "Sun" em en, e o padrão é "dd/MM/y" em pt-BR e "M/d/y" em en

#### Scenario: Textos do calendário
- **WHEN** `previous` e `next` são lidos em pt-BR e em en
- **THEN** eles são "Anterior" e "Próximo" em pt-BR, e "Previous" e "Next" em en
