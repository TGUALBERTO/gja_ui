# Proposal: Tabela com mais linhas e grupos (`update-gja-table-fiori-growing-groups`)

## Why

Duas partes do `sap.m.Table` (conferido em `SAP/openui5`) que listas Fiori usam o tempo todo ficaram de fora de
`add-gja-table`:

- `growing`, `growingThreshold` (padrão 20) e `growingTriggerText`: a tabela mostra as primeiras linhas e um botão
  "Mais" com a contagem "[20 / 45]" para as próximas;
- `sap.m.GroupHeaderListItem`: títulos de grupo entre as linhas (com contagem opcional), que não são escolhidos nem
  acionados.

## What Changes

- `GjaTable` ganha `growing`, `growingThreshold` e `growingTriggerText`.
- **BREAKING (leve)** `items` passa a `List<GjaListItemBase<T>>` (sealed, como o `sap.m.ListItemBase`), com
  `GjaColumnListItem<T>` e o novo `GjaGroupHeaderListItem<T>` (`title`, `count`). Listas só de
  `GjaColumnListItem` continuam valendo.
- Galeria, goldens e CHANGELOG.

Fora do escopo: `growingScrollToLoad` (crescer ao rolar), o cabeçalho fixo (`sticky`, que depende da rolagem da
página), ordenação (no UI5 vem da aplicação) e o agrupamento automático por um campo (no UI5 vem do `sorter` do
binding; aqui a aplicação insere os títulos).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-table`: mais linhas e títulos de grupo.

## Impact

- `packages/gja_widgets`: tabela, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaTable".
- Portal existente: nenhum impacto.
