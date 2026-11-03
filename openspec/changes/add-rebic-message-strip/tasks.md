# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Faixa

- [x] 1.1 `RebicMessageStrip` em `feedback_sobreposicoes/message_strip/` (D1, D2), com dartdoc e exportação.
  Verificação: um teste por cenário de `rebic-message-strip` e a rastreabilidade.
- [x] 1.2 Goldens nos temas claro e escuro e nas duas densidades, conferidos à vista; CHANGELOG de `rebic_widgets`.

## 2. Galeria e documentação

- [x] 2.1 Página "RebicMessageStrip" na galeria, com o teste da página.
- [x] 2.2 Catálogo. Verificação: `dart run rebic_checks all`.

## 3. Verificação final

- [x] 3.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
