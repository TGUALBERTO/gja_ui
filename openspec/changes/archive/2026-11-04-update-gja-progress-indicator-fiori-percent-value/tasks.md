# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Indicador

- [x] 1.1 `GjaProgressIndicator(percentValue:)` (D1), sem circular e indeterminado. Verificação: um teste por cenário
  e a rastreabilidade.
- [x] 1.2 Goldens, galeria e CHANGELOG de `gja_widgets`.
- [x] 1.3 Catálogo. Verificação: `dart run gja_checks all`.

## 2. Verificação final

- [x] 2.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
