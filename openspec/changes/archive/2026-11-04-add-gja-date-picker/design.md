# Design: Seletor de data

## Decisions

### D1. Ajuda de valor no campo

`GjaInput` ganha, como o `sap.m.Input`, `showValueHelp`, `valueHelpIconSrc` (padrão `GjaIcons.popupWindow`: o
conjunto Lucide não tem o glifo `value-help`; ADR 0009) e `onValueHelpRequest`. O ícone fica no fim, depois do botão
de limpar, e, como ele, é um ícone acionável fora da ordem de tabulação; F4 e Alt+seta para baixo, com o foco no
campo, também chamam `onValueHelpRequest`. Sem `enabled` ou `editable`, o ícone some.

### D2. Datas na localização

`parseDate` usa `DateFormat.yMd(idioma).parseStrict` (nulo se inválida), `datePattern` o padrão desse formato,
`formatMonthYear` o `yMMMM`, `formatLongDate` o `yMMMMEEEEd` (nome de cada dia para o leitor de tela),
`firstDayOfWeek` o `FIRSTDAYOFWEEK` do CLDR convertido para `DateTime.weekday`, e `shortWeekdays` os
`SHORTWEEKDAYS` girados para começar nesse dia. Nada é fixado no código.

### D3. Campo e texto

`GjaDatePicker` é um `StatefulWidget` que guarda o texto do campo: `dateValue` formatado com `formatDate` (e
reformatado quando o pai muda `dateValue`). No `change` do campo (Enter ou perda de foco), texto vazio chama
`onChange(null)`; uma data lida e dentro de `minDate`–`maxDate` chama `onChange(data)`; senão o campo mostra o estado
`error` com o texto `valueState(error)` da localização, até a próxima edição, sem chamar `onChange`. Um
`valueState` do pai diferente de `none` prevalece.

### D4. Calendário

Um `GjaPopover` (largura `standard`, sem margem, com o nome `semanticLabel` ou o `placeholder`) ancorado no campo
mostra o calendário privado `_Calendar`: cabeçalho com `GjaButton`s de ícone (`previous`/`next`,
setas `slimArrowLeft`/`slimArrowRight`) e o mês (`formatMonthYear`, `typography.baseBold`); a linha dos dias da
semana (`shortWeekdays`, `typography.small`, `colors.label`, fora da semântica); e 6 semanas × 7 dias, cada dia um
`GjaInteractable` com a altura `density.minTargetSize`, o nome `formatLongDate` e `selected`. O dia escolhido tem
fundo `colors.brand` e texto `colors.contrastText`; hoje, borda `colors.brand`; dias de outros meses, texto
`colors.label`; fora dos limites, desabilitados.

### D5. Teclado do calendário

Só o dia focado está na ordem de tabulação (foco itinerante). As setas movem um dia (para os lados, trocadas em
RTL) ou uma semana (para cima e para baixo), PageUp e PageDown um mês, trocando o mês mostrado quando preciso; Enter e
Espaço escolhem. Ao abrir, o foco vai ao dia escolhido, ou a hoje.
