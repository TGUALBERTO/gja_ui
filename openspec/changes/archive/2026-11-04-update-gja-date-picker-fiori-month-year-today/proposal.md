# Proposal: Seletor de data com mês, ano e Hoje (`update-gja-date-picker-fiori-month-year-today`)

## Why

No `sap.m.DatePicker` (conferido em `SAP/openui5`), o cabeçalho do `sap.ui.unified.Calendar` mostra o mês e o ano
como botões: o mês abre a escolha dos doze meses, e o ano a escolha de vinte anos. Sem isso, chegar a uma data
distante exige tocar "Próximo" muitas vezes. O DatePicker também tem `showCurrentDateButton`, um botão "Hoje" no
cabeçalho que escolhe a data atual. As duas coisas ficaram de fora de `add-gja-date-picker`.

## What Changes

- O cabeçalho do calendário passa a ter o mês e o ano como botões, com as escolhas de mês (3 × 4) e de ano (4 × 5).
- `GjaDatePicker` ganha `showCurrentDateButton`.
- `gja/core/localization`: `monthNames`, `formatYear` e o texto `today`.
- Galeria, goldens e CHANGELOG.

Fora do escopo: intervalos de datas (`sap.m.DateRangeSelection`, outro controle) e o cabeçalho com dois meses.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-date-picker`: escolha de mês e ano, botão Hoje.
- `gja/core/localization`: meses, ano e `today`.

## Impact

- `packages/gja_core`: localização e testes.
- `packages/gja_widgets`: seletor, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaDatePicker".
- Portal existente: nenhum impacto.
