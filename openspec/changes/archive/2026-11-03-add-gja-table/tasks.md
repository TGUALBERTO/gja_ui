# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Localização

- [x] 1.1 `selectAll` e `selectItem` em pt-BR e en. Verificação: teste "Textos do framework — Textos da tabela".

## 2. Tabela

- [x] 2.1 `GjaTable`, `GjaColumn`, `GjaColumnListItem` e enums em `exibicao_dados/table/` (D1–D5), com
  dartdoc e exportação. Verificação: um teste por cenário de `gja-table` e a rastreabilidade.
- [x] 2.2 Goldens nos temas claro e escuro e nas duas densidades, conferidos à vista; CHANGELOG de `gja_core` e
  `gja_widgets`; ADR 0009.

## 3. Galeria e documentação

- [x] 3.1 Página "GjaTable" na galeria, com o teste da página.
- [x] 3.2 Catálogo. Verificação: `dart run gja_checks all`.

## 4. Verificação final

- [x] 4.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
