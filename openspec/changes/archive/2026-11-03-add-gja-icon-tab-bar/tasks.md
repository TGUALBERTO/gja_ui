# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Abas

- [x] 1.1 `GjaIconTabBar` e `GjaIconTabFilter` em `acoes_navegacao/icon_tab_bar/` (D1, D2, D3), com dartdoc e
  exportação. Verificação: um teste por cenário de `gja-icon-tab-bar` e a rastreabilidade.
- [x] 1.2 Goldens nos temas claro e escuro e nas duas densidades, conferidos à vista; CHANGELOG de `gja_widgets`.

## 2. Galeria e documentação

- [x] 2.1 Página "GjaIconTabBar" na galeria, com o teste da página.
- [x] 2.2 Catálogo e ADR 0009. Verificação: `dart run gja_checks all`.

## 3. Verificação final

- [x] 3.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
