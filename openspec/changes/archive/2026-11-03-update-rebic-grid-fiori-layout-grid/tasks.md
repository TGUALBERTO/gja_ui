# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Grade

- [x] 1.1 `RebicGrid(content:)` com `defaultSpan` `XL3 L3 M6 S12`, `hSpacing`, `vSpacing` e `containerQuery`, e o
  novo `RebicGridData` no lugar de `RebicGridCell` e de `RebicGrid.cells` (D1, D2, D3), com dartdoc (incluindo a
  ausência de margem externa e quando usar `containerQuery: true`). Verificação: um teste por cenário de
  `rebic-grid`, com os novos "Grade sem margem externa" e "Classe pela tela", e a rastreabilidade da spec.
- [x] 1.2 Teste do cartão que monta uma grade com `content`. Verificação: os testes de `rebic-card` e
  `flutter test -j 2 --tags golden` sem diferença em `packages/rebic_widgets`.
- [x] 1.3 CHANGELOG de `rebic_widgets` com o de/para.

## 2. Galeria e catálogo

- [x] 2.1 Páginas "RebicGrid" e "RebicCard" com `content` e `RebicGridData` (D4), e o teste "[Documentação] Exemplos
  mínimos — Página RebicGrid na galeria" com quatro cartões por linha. Verificação: `flutter test -j 2` em
  `apps/rebic_gallery`.
- [x] 2.2 `docs/catalog.yaml`: `rebic/widgets/rebic-grid` sem `rebic/widgets/rebic-responsive-layout`. Verificação:
  `dart run rebic_checks all` sem erros.

## 3. Verificação final

- [x] 3.1 Executar as etapas de `tool/ci` (com `flutter test -j 2`) e `flutter test -j 2 --tags golden` em
  `packages/rebic_widgets`. Verificação: código de saída 0 em todas.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-grid-fiori-layout-grid`) após a revisão.
- Bloco de layout completo; próximo bloco: ações e dados (Button/IconButton, `text`/`enabled`, SelectList, Popover
  begin/endButton, tooltip, Progress/Busy, Avatar, Badge).
