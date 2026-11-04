# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Base

- [x] 1.1 Localização: `parseDate`, `datePattern`, `formatMonthYear`, `formatLongDate`, `firstDayOfWeek`,
  `shortWeekdays`, `previous` e `next` (D2). Verificação: testes "Datas do calendário — …".
- [x] 1.2 `RebicInput`: `showValueHelp`, `valueHelpIconSrc` e `onValueHelpRequest` (D1). Verificação: teste
  "[Comportamento] Ajuda de valor — Pedir ajuda de valor" e a rastreabilidade do campo.

## 2. Seletor de data

- [x] 2.1 `RebicDatePicker` e o calendário interno em `formularios/date_picker/` (D3–D5), com dartdoc e exportação.
  Verificação: um teste por cenário de `rebic-date-picker` e a rastreabilidade.
- [x] 2.2 Goldens nos temas claro e escuro e nas duas densidades, conferidos à vista; CHANGELOG de `rebic_core` e
  `rebic_widgets`; ADR 0009.

## 3. Galeria e documentação

- [x] 3.1 Página "RebicDatePicker" na galeria, com o teste da página.
- [x] 3.2 Catálogo. Verificação: `dart run rebic_checks all`.

## 4. Verificação final

- [x] 4.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
