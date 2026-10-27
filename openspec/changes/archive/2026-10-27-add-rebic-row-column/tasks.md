# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `rebic/widgets/rebic-row` (17 cenários) e
`rebic/widgets/rebic-column` (16 cenários).

## 1. Base comum

- [x] 1.1 Criar `RebicMainAlignment`, `RebicCrossAlignment` (exportados) e `buildRebicFlex` (interno) em `packages/rebic_widgets/lib/src/fundacao_layout/flex/` (D1, D2). Verificação: `dart analyze` e `rebic_checks tokens` passam.

## 2. RebicRow

- [x] 2.1 Criar `RebicRow` e `RebicRow.wrap` em `fundacao_layout/row/`, com dartdoc e exportados (D1, D2). Verificação: os testes da spec `rebic-row`, menos a página da galeria, e o teste do `assert` de filho expansível em `RebicRow.wrap`.

## 3. RebicColumn

- [x] 3.1 Criar `RebicColumn` em `fundacao_layout/column/`, com dartdoc e exportado (D1, D2). Verificação: os testes da spec `rebic-column`, menos a página da galeria.

## 4. Galeria

- [x] 4.1 Adicionar a página "RebicRow e RebicColumn" (D4). Verificação: testes "[Documentação] Exemplos mínimos — Página RebicRow na galeria" e "— Página RebicColumn na galeria", e os dois testes de rastreabilidade passando.

## 5. Catálogo, changelog e verificação final

- [x] 5.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com as pastas `row` e `column`.
- [x] 5.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-row-column`) após a revisão. O sync cria as duas specs principais.
- Próximo widget: `RebicDivider`.
