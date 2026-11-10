# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Núcleo

- [x] 1.1 `checked`, `mixed`, `toggled` e `inMutuallyExclusiveGroup` em `GjaInteractable` (D1), com dartdoc e
  CHANGELOG. Verificação: "Semântica e cursor — Semântica de marcação e alternância" e a suíte de `gja_core`.

## 2. Caixa de seleção

- [x] 2.1 `GjaCheckBox` em `formularios/check_box/` (D2, D3), com dartdoc e exportação. Verificação: um teste por
  cenário de `gja-check-box`, a bateria de acessibilidade e a rastreabilidade.
- [x] 2.2 Goldens nos temas claro e escuro e nas duas densidades, conferidos à vista; CHANGELOG de `gja_widgets`.

## 3. Galeria e documentação

- [x] 3.1 Página "GjaCheckBox" na galeria, com o teste da página. Verificação: `flutter test -j 2` em
  `apps/gja_gallery`.
- [x] 3.2 Catálogo (`gja/widgets/gja-check-box`, `implemented`), template de spec, ADR 0006 e ADR 0009.
  Verificação: `dart run gja_checks all`.

## 4. Verificação final

- [x] 4.1 Etapas de `tool/ci` (com `flutter test -j 2`) e `--tags golden`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change após a revisão.
