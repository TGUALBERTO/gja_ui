# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-grid` (16 cenários).

## 1. Widget

- [x] 1.1 Criar `RebicGridCell` e `RebicGrid` com `RebicGrid.cells` (D1, D2) em `packages/rebic_widgets/lib/src/fundacao_layout/grid/`, com dartdoc e exportados. Verificação: os testes da spec, menos a página da galeria; `rebic_checks tokens` passa.
- [x] 1.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade da grade", com os 16 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "RebicGrid" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicGrid na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `fundacao_layout/grid`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-grid`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `RebicScaffold`.
