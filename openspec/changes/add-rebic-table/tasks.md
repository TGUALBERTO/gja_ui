# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Localização

- [ ] 1.1 `selectAll` e `selectItem` em pt-BR e en. Verificação: teste "Textos do framework — Textos da tabela".

## 2. Tabela

- [ ] 2.1 `RebicTable`, `RebicColumn`, `RebicColumnListItem` e enums em `exibicao_dados/table/` (D1–D5), com
  dartdoc e exportação. Verificação: um teste por cenário de `rebic-table` e a rastreabilidade.
- [ ] 2.2 Goldens nos temas claro e escuro e nas duas densidades, conferidos à vista; CHANGELOG de `rebic_core` e
  `rebic_widgets`; ADR 0009.

## 3. Galeria e documentação

- [ ] 3.1 Página "RebicTable" na galeria, com o teste da página.
- [ ] 3.2 Catálogo. Verificação: `dart run rebic_checks all`.

## 4. Verificação final

- [ ] 4.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
