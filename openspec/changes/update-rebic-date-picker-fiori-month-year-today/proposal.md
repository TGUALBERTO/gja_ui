# Proposal: Seletor de data com mês, ano e Hoje (`update-rebic-date-picker-fiori-month-year-today`)

## Why

No `sap.m.DatePicker` (conferido em `SAP/openui5`), o cabeçalho do `sap.ui.unified.Calendar` mostra o mês e o ano
como botões: o mês abre a escolha dos doze meses, e o ano a escolha de vinte anos. Sem isso, chegar a uma data
distante exige tocar "Próximo" muitas vezes. O DatePicker também tem `showCurrentDateButton`, um botão "Hoje" no
cabeçalho que escolhe a data atual. As duas coisas ficaram de fora de `add-rebic-date-picker`.

## What Changes

- O cabeçalho do calendário passa a ter o mês e o ano como botões, com as escolhas de mês (3 × 4) e de ano (4 × 5).
- `RebicDatePicker` ganha `showCurrentDateButton`.
- `rebic/core/localization`: `monthNames`, `formatYear` e o texto `today`.
- Galeria, goldens e CHANGELOG.

Fora do escopo: intervalos de datas (`sap.m.DateRangeSelection`, outro controle) e o cabeçalho com dois meses.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-date-picker`: escolha de mês e ano, botão Hoje.
- `rebic/core/localization`: meses, ano e `today`.

## Impact

- `packages/rebic_core`: localização e testes.
- `packages/rebic_widgets`: seletor, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicDatePicker".
- Portal existente: nenhum impacto.
