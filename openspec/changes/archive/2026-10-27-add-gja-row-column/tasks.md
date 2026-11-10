# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `gja/widgets/gja-row` (17 cenários) e
`gja/widgets/gja-column` (16 cenários).

## 1. Base comum

- [x] 1.1 Criar `GjaMainAlignment`, `GjaCrossAlignment` (exportados) e `buildGjaFlex` (interno) em `packages/gja_widgets/lib/src/fundacao_layout/flex/` (D1, D2). Verificação: `dart analyze` e `gja_checks tokens` passam.

## 2. GjaRow

- [x] 2.1 Criar `GjaRow` e `GjaRow.wrap` em `fundacao_layout/row/`, com dartdoc e exportados (D1, D2). Verificação: os testes da spec `gja-row`, menos a página da galeria, e o teste do `assert` de filho expansível em `GjaRow.wrap`.

## 3. GjaColumn

- [x] 3.1 Criar `GjaColumn` em `fundacao_layout/column/`, com dartdoc e exportado (D1, D2). Verificação: os testes da spec `gja-column`, menos a página da galeria.

## 4. Galeria

- [x] 4.1 Adicionar a página "GjaRow e GjaColumn" (D4). Verificação: testes "[Documentação] Exemplos mínimos — Página GjaRow na galeria" e "— Página GjaColumn na galeria", e os dois testes de rastreabilidade passando.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, com as pastas `row` e `column`.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-row-column`) após a revisão. O sync cria as duas specs principais.
- Próximo widget: `GjaDivider`.
