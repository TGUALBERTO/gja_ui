# Proposal: Tabela (`add-gja-table`)

## Why

A Fase 5 pede a tabela. O modelo é o `sap.m.Table` (conferido em `SAP/openui5`), a tabela responsiva do Fiori:
`columns` (`sap.m.Column`, com `header`, `hAlign`, `width`, `minScreenWidth` e `demandPopin`), `items`
(`sap.m.ColumnListItem`, com `cells` e `type` `Inactive`/`Active`/`Navigation`), `headerText`, `noDataText`, `mode`
(`None`, `SingleSelectMaster`, `MultiSelect`) e os eventos `itemPress` e `selectionChange`. Nas larguras pequenas,
as colunas com `demandPopin` descem para baixo da linha ("popin"), com o título da coluna.

## What Changes

- Novo `GjaTable<T>`, controlado (`selectedKeys` + `onSelectionChange`), com `columns` (`GjaColumn`), `items`
  (`GjaColumnListItem<T>`), `headerText`, `noDataText`, `mode` e `onItemPress`; colunas com `hAlign`, `flex`,
  `minScreenWidth` e `demandPopin`; teclado pelas setas.
- `gja/core/localization`: novos textos `selectAll` e `selectItem` ("Selecionar tudo" e "Selecionar item"), os
  nomes das caixas de seleção da tabela.
- Catálogo: `gja/widgets/gja-table` passa a `implemented`, P1 na fase 2 (a lista do usuário põe a tabela nos
  dados básicos), com as dependências da spec.
- ADR 0009: textos dos cabeçalhos e espaçamentos das células.

Fora do escopo: `growing`, cabeçalho fixo, `headerToolbar`, `infoToolbar`, rodapé das colunas, agrupamento,
ordenação, `alternateRowColors`, `highlight` das linhas, os modos `Delete` e `SingleSelectLeft` e larguras em CSS
(`flex` substitui `width`).

## Capabilities

### New Capabilities

- `gja/widgets/gja-table`: `GjaTable`.

### Modified Capabilities

- `gja/core/localization`: textos `selectAll` e `selectItem`.

## Impact

- `packages/gja_core`: textos novos e testes.
- `packages/gja_widgets`: `exibicao_dados/table/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaTable".
- `docs/catalog.yaml`, `docs/adr/0009-provisional-horizon-values.md`.
- Portal existente: nenhum impacto.
