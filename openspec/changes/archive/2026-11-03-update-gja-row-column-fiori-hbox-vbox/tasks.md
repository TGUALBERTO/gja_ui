# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. HBox e VBox

- [x] 1.1 Enums `GjaFlexJustifyContent`, `GjaFlexAlignItems` e `GjaFlexWrap` em
  `fundacao_layout/flex/gja_flex_enums.dart`, e a montagem interna com `spaceAround`, `baseline` e o
  `alignItems` do `Wrap` com asserção (D1, D2), com dartdoc.
- [x] 1.2 `GjaHBox` em `fundacao_layout/hbox/` e `GjaVBox` em `fundacao_layout/vbox/` (D1, D3), com dartdoc
  (incluindo os padrões diferentes do UI5) e as exportações no lugar das de `GjaRow`/`GjaColumn`; os diretórios
  `row/` e `column/` saem. Verificação: um teste por cenário de `gja-hbox` e de `gja-vbox` em
  `test/fundacao_layout/hbox/` e `test/fundacao_layout/vbox/`, com a rastreabilidade das duas specs.

## 2. Migração

- [x] 2.1 Trocar os usos em `packages/gja_widgets` (dartdoc e testes) e o cenário do separador (D4).
  Verificação: `dart analyze` sem erros; "[Comportamento] Orientação — Separador vertical numa linha esticada" e a
  suíte de `gja_widgets` com `flutter test -j 2`, e `flutter test -j 2 --tags golden` sem diferença.
- [x] 2.2 CHANGELOG de `gja_widgets` com o de/para.

## 3. Galeria e catálogo

- [x] 3.1 Trocar os usos da galeria e a página "GjaHBox e GjaVBox" no lugar de "GjaRow e GjaColumn" (D5),
  com os testes "[Documentação] Exemplos mínimos — Página GjaHBox na galeria" e "— Página GjaVBox na galeria".
  Verificação: `flutter test -j 2` em `apps/gja_gallery`.
- [x] 3.2 `docs/catalog.yaml`: saem `gja/widgets/gja-row` e `gja/widgets/gja-column`; entram
  `gja/widgets/gja-hbox` e `gja/widgets/gja-vbox` (P0, fase 1, `fundacao-layout`, `implemented`, com as
  dependências das specs). Verificação: `dart run gja_checks all` sem erros.

## 4. Verificação final

- [x] 4.1 Executar as etapas de `tool/ci` (com `flutter test -j 2`) e `flutter test -j 2 --tags golden` em
  `packages/gja_widgets`. Verificação: código de saída 0 em todas, e nenhum golden muda.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-row-column-fiori-hbox-vbox`) após a revisão, com o merge dos
  deltas e a retirada de `gja/widgets/gja-row` e `gja/widgets/gja-column`.
- Próxima change do bloco de layout: Grid L3.
