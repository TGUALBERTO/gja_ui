# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change. Os goldens são gerados nos temas claro e
escuro e nas duas densidades (`goldenThemes`).

## 1. GjaCardHeader

- [x] 1.1 `GjaCardHeader` e `GjaCardHeadingScope` em `fundacao_layout/card_header/` (D1, D3, D4): textos,
  ícone, `toolbar`, `onPress`, cores da família `list` e semântica, com dartdoc e exportação (ocultando o escopo).
  Verificação: os cenários de "[API]", "[Comportamento]", "[Aparência]", "[Estados]", "[Acessibilidade] Teclado",
  "[Acessibilidade] Semântica", "[Responsividade]", "[Integração]" e "[Restrições]" da spec `gja-card-header`.
- [x] 1.2 Contraste e alvo (sem a fonte Inter, em arquivo próprio), goldens do cabeçalho completo e do acionável em
  hover, e teste de rastreabilidade. Verificação: "[Acessibilidade] Contraste e alvo — Contraste e alvo do
  cabeçalho" e os cenários de "[Testes]"; a rastreabilidade só passa depois de 3.1.

## 2. GjaCard

- [x] 2.1 Reescrever `GjaCard` com `header`, `headerPosition`, `content` e `headingLevel` (D2), com dartdoc.
  Verificação: os cenários da spec `gja-card`, incluindo "[Comportamento] Posição do cabeçalho — Cabeçalho
  embaixo", com os testes de acessibilidade e os goldens (cabeçalho em cima, embaixo e sem cabeçalho) regerados.
- [x] 2.2 `docs/catalog.yaml` (`gja/widgets/gja-card-header`, P1/fase 2, `implemented`, e as dependências do
  cartão), ADR 0009 (D6) e CHANGELOG de `gja_widgets` com a tabela de migração (**BREAKING**). Verificação: `dart
  run gja_checks all` sem erros; `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`, com
  mudança só nos goldens do cartão e nos novos do cabeçalho.

## 3. Galeria

- [x] 3.1 Página "GjaCard" com a API nova (D5): cartões numa grade, um com cabeçalho acionável, um com o cabeçalho
  embaixo e um cabeçalho com `toolbar`, com o teste. Verificação: "[Documentação] Exemplos mínimos — Página
  GjaCard na galeria" e "— Cabeçalhos na página GjaCard"; `flutter test` em `apps/gja_gallery` sem falhas.

## 4. Verificação final

- [x] 4.1 Executar `tool/ci` e `flutter test --tags golden` em `packages/gja_widgets`. Verificação: código de
  saída 0 nos dois.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-card-fiori-card-header`) após a revisão, trocando o `## Purpose` da
  spec principal `gja-card` pelo da delta.
- Próximas changes do bloco de layout: Separator, FlexBox, Grid L3.
