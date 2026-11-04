# Spec Delta

## MODIFIED Requirements

### Requirement: [Comportamento] Calendário
O calendário SHALL mostrar o mês de `dateValue` (ou o atual), com botões para o mês anterior e o seguinte, o mês e o ano como botões que abrem a escolha deles, os dias da semana a partir de `firstDayOfWeek` e seis semanas de dias. O ícone, F4 e Alt+seta para baixo SHALL abrir o calendário; Esc ou um toque fora o fecham.

#### Scenario: Navegar entre meses
- **GIVEN** o calendário de março de 2026 aberto em pt-BR
- **WHEN** o botão "Próximo" é tocado
- **THEN** o calendário mostra "abril de 2026"

### Requirement: [Aparência] Tokens de componente
O campo SHALL ser um `RebicInput` com `valueHelpIconSrc` `RebicIcons.calendar`. No calendário, cada dia SHALL ter a altura `density.minTargetSize`; o escolhido, o fundo `colors.brand` e o texto `colors.contrastText`; hoje, a borda `colors.brand`; os de outros meses, o texto `colors.label`. O mês e o ano do cabeçalho SHALL usar `typography.baseBold`, os meses e anos das escolhas a altura `density.minTargetSize`, e os dias da semana `typography.small` em `colors.label`.

#### Scenario: Dia escolhido
- **WHEN** o calendário de um seletor com `dateValue` 5 de março de 2026 é aberto no tema claro
- **THEN** o dia 5 tem o fundo `brand` e o texto `contrastText`, e o dia 1º de abril o texto `label`

### Requirement: [Restrições] Fora do escopo
`RebicDatePicker` SHALL NOT aceitar larguras ou cores literais, nem ter `displayFormat`, `valueFormat`, datas especiais, outros calendários ou intervalos.

#### Scenario: Seletor sem valor literal
- **WHEN** a API pública de `RebicDatePicker` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`

### Requirement: [Documentação] Exemplos mínimos
`RebicDatePicker` SHALL ter dartdoc em toda API pública e uma página "RebicDatePicker" na galeria com um seletor de data de entrega com limite mínimo e o botão "Hoje".

#### Scenario: Página RebicDatePicker na galeria
- **GIVEN** a página "RebicDatePicker" aberta na galeria
- **WHEN** "20/03/2030" é digitado no seletor e Enter é pressionado
- **THEN** a página mostra "Entrega: 20/03/2030"

## ADDED Requirements

### Requirement: [Comportamento] Escolha de mês e ano
Tocar o mês do cabeçalho SHALL mostrar os doze meses (três por linha), e tocar o ano SHALL mostrar vinte anos (quatro por linha), como o `sap.ui.unified.Calendar`; escolher um deles SHALL voltar aos dias desse mês. Nessas escolhas, "Anterior" e "Próximo" SHALL andar um ano e vinte anos, e os meses e anos fora de `minDate`–`maxDate` SHALL ficar desabilitados.

#### Scenario: Escolher mês e ano
- **GIVEN** o calendário de março de 2026 aberto em pt-BR
- **WHEN** "março", "julho", "2026" e "2028" são tocados, nessa ordem
- **THEN** o calendário mostra os dias de julho de 2028

### Requirement: [Comportamento] Botão Hoje
Com `showCurrentDateButton` (padrão `false`), o cabeçalho do calendário SHALL ter um botão de ícone (`RebicIcons.calendar`) com a dica `today` da localização, como o do `sap.m.DatePicker`; acioná-lo SHALL chamar `onChange` com a data de hoje e fechar o calendário. Com hoje fora de `minDate`–`maxDate`, o botão MUST ficar desabilitado.

#### Scenario: Escolher hoje
- **GIVEN** um seletor com `showCurrentDateButton`, com o calendário aberto em pt-BR
- **WHEN** o botão com a dica "Hoje" é tocado
- **THEN** `onChange` recebe a data de hoje, e o calendário fecha
