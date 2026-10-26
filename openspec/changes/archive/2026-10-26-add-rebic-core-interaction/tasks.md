# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/core/interaction`. É infraestrutura do núcleo, sem
página de widget público nem goldens. A galeria demonstra o comportamento.

## 1. Anel de foco e alvo padrão

- [x] 1.1 Adicionar `RebicAccessibility.defaultMinTargetSize` (D2) em `rebic_foundation`, com teste de igualdade com `RebicDensityTokens.comfortable().minTargetSize`, e criar `RebicFocusRing` (D3) em `packages/rebic_core/lib/src/interaction/focus_ring.dart`, com dartdoc e exportado em `rebic_core.dart`. Verificação: o teste de igualdade passa, e um teste de widget mostra que o anel visível tem a espessura e a cor recebidas e não muda o tamanho do conteúdo.

## 2. Elemento interativo

- [x] 2.1 Implementar `RebicInteractable` (D1) em `packages/rebic_core/lib/src/interaction/interactable.dart`, com dartdoc, e exportá-lo. Verificação: testes "Detecção de estados — Hover e pressionado" e "— Seleção recebida"; "Ativação por toque e teclado — Ativação por teclado" e "— Toque cancelado"; "Elemento desabilitado — Desabilitado ignora interação"; "Anel de foco pelo teclado — Foco por teclado" e "— Foco por toque"; "Ordem de foco — Tab entre três elementos"; "Área mínima de interação — Conteúdo menor que o alvo"; e "Semântica e cursor — Semântica de botão", além de um teste do cursor de clique e do cursor padrão.

## 3. Galeria

- [x] 3.1 Adicionar a página "Interação" (`pages/interaction_page.dart`) ao índice (D5). Verificação: teste "Testes e documentação da interação — Página na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`rebic/core/interaction` → `implemented`) e os `CHANGELOG.md` de `rebic_core` e `rebic_foundation`. Verificação: `dart run rebic_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0. O `rebic_checks architecture` confirma que `rebic_core` não importa primitivos nem Material.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-core-interaction`) após a revisão.
- Próximas changes do núcleo: `add-rebic-core-localization`, `-responsive` e depois `-overlay` (que depende desta).
