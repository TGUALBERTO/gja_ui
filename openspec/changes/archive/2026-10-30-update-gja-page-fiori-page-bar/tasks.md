# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change. Os goldens são gerados nos temas claro e
escuro e nas duas densidades (`goldenThemes`).

## 1. Fundação

- [x] 1.1 `barHeight` em `GjaDensityTokens` e primitivo `size48` em `GjaDensityPrimitives` (D5), com o contrato
  completo e o CHANGELOG de `gja_foundation`. Verificação: os cenários de "Dimensões de controle por densidade"
  ("Valores de referência", "Compacto não maior que confortável" e "Escala primitiva de densidade") e os testes de
  contrato; `flutter test` em `packages/gja_foundation`.

## 2. GjaBar

- [x] 2.1 `GjaBar`, `GjaBarDesign` e `GjaTitleAlignment` em `fundacao_layout/bar/`: layout de três áreas
  (D2), desenho com o contexto da página (D3), dartdoc e exportação. Verificação: os cenários de "[API]",
  "[Comportamento]", "[Aparência]", "[Estados]", "[Acessibilidade] Teclado e foco", "[Responsividade]",
  "[Integração]" e "[Restrições]" da spec `gja-bar`.
- [x] 2.2 Contraste (sem a fonte Inter, em arquivo próprio), goldens dos quatro desenhos e teste de rastreabilidade
  da barra. Verificação: "[Acessibilidade] Semântica e contraste — Contraste na barra" e os cenários de "[Testes]";
  a rastreabilidade só passa depois de 4.1.

## 3. GjaPage

- [x] 3.1 Reescrever `GjaPage` com a API do `sap.m.Page` (D4): cabeçalho interno com `GjaBar`, `customHeader`,
  áreas condicionais, `content`, `enableScrolling`, `contentPadding` pela classe da tela, `backgroundDesign`,
  `footer`, `showFooter` e `floatingFooter`, com dartdoc. Verificação: os cenários de "[API]", "[Comportamento]",
  "[Aparência] Fundo e cabeçalho", "[Estados]", "[Acessibilidade]", "[Responsividade]", "[Integração]" e
  "[Restrições]" da spec `gja-page`.
- [x] 3.2 Goldens da página (completa e com rodapé flutuante) e testes de acessibilidade e de rastreabilidade; o
  teste "[Integração] Dependências e uso — Barra e página usam o botão de ícone" passa a usar `showNavButton`.
  Verificação: `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`, com mudança só nos goldens da
  página e nos novos da barra.
- [x] 3.3 `docs/catalog.yaml` (`gja/widgets/gja-bar`, P0/fase 1, `implemented`, e as dependências da página),
  ADR 0009 (D7) e CHANGELOG de `gja_widgets` com a tabela de D6 (**BREAKING**). Verificação: `dart run
  gja_checks all` sem erros.

## 4. Galeria

- [x] 4.1 Página "GjaBar" (quatro desenhos e alinhamentos `none` e `start`) registrada em `main.dart`, com o
  teste "[Documentação] Exemplos mínimos — Página GjaBar na galeria".
- [x] 4.2 Migrar as 12 páginas que usam `GjaPage` pela tabela de D6. A página "GjaPage" ganha o rodapé
  flutuante e a escolha de `backgroundDesign`. Verificação: "[Documentação] Exemplos mínimos — Página GjaPage na
  galeria"; `flutter test` em `apps/gja_gallery` sem falhas.

## 5. Verificação final

- [x] 5.1 Executar `tool/ci` e `flutter test --tags golden` em `packages/gja_widgets`. Verificação: código de
  saída 0 nos dois.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-page-fiori-page-bar`) após a revisão, trocando o `## Purpose` da
  spec principal `gja-page` pelo da delta, que tira a citação ao `GjaScaffold`.
- Próximas changes do bloco de layout: Card, Separator, FlexBox, Grid L3.
