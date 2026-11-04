# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Renomeação

- [x] 1.1 `RebicObjectStatus` em `exibicao_dados/object_status/` (D1), com exportação, testes e goldens movidos.
  Verificação: os testes do status e a rastreabilidade de `rebic-object-status`.
- [x] 1.2 Galeria: página "RebicObjectStatus" e página do cartão. CHANGELOG de `rebic_widgets`.
- [x] 1.3 Catálogo. Verificação: `dart run rebic_checks all`.

## 2. Verificação final

- [x] 2.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
