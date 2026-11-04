# Proposal: Seletor de data (`add-rebic-date-picker`)

## Why

A Fase 5 pede o seletor de data. O modelo é o `sap.m.DatePicker` (conferido em `SAP/openui5`): um campo de texto
(`InputBase`) com `dateValue`, `minDate`, `maxDate`, `placeholder` (padrão: o padrão da data no idioma),
`valueState`, `enabled`, `editable` e o evento `change`, e um ícone de calendário que abre um
`sap.ui.unified.Calendar` num popover. A data digitada é lida no formato do idioma; F4 e Alt+seta para baixo abrem o
calendário, que se navega pelas setas.

O campo do Rebic (`RebicInput`) ainda não tem o ícone de ajuda de valor do `sap.m.Input` (`showValueHelp`,
`valueHelpIconSrc`, evento `valueHelpRequest`), e a localização não lê datas nem dá os nomes do calendário.

## What Changes

- `rebic/widgets/rebic-input`: `showValueHelp`, `valueHelpIconSrc` e `onValueHelpRequest`, como o `sap.m.Input`.
- `rebic/core/localization`: `parseDate`, `datePattern`, `formatMonthYear`, `formatLongDate`, `firstDayOfWeek`,
  `shortWeekdays` (do CLDR) e os textos `previous` e `next`.
- Novo `RebicDatePicker`, controlado (`dateValue` + `onChange`), com `minDate`, `maxDate`, `placeholder`,
  `semanticLabel`, `enabled`, `editable`, `valueState` e `valueStateText`; o calendário é interno.
- Catálogo: `rebic/widgets/rebic-date-picker` passa a `implemented`, P1 na fase 2 (a lista do usuário põe o seletor
  nos dados básicos), com as dependências da spec.
- ADR 0009: o ícone padrão da ajuda de valor e as cores do calendário.

Fora do escopo: `displayFormat`/`valueFormat` próprios, a escolha de mês e de ano pelo cabeçalho, o botão "Hoje",
`showFooter`, datas especiais e legendas, calendários não gregorianos, intervalos (`DateRangeSelection`) e o
`RebicCalendar` como widget próprio.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-date-picker`: `RebicDatePicker`.

### Modified Capabilities

- `rebic/widgets/rebic-input`: ajuda de valor.
- `rebic/core/localization`: datas e textos do calendário.

## Impact

- `packages/rebic_core`: localização e testes.
- `packages/rebic_widgets`: `RebicInput`, `formularios/date_picker/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicDatePicker".
- `docs/catalog.yaml`, `docs/adr/0009-provisional-horizon-values.md`.
- Portal existente: nenhum impacto.
