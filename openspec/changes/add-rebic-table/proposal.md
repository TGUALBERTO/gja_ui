# Proposal: Tabela (`add-rebic-table`)

## Why

A Fase 5 pede a tabela. O modelo é o `sap.m.Table` (conferido em `SAP/openui5`), a tabela responsiva do Fiori:
`columns` (`sap.m.Column`, com `header`, `hAlign`, `width`, `minScreenWidth` e `demandPopin`), `items`
(`sap.m.ColumnListItem`, com `cells` e `type` `Inactive`/`Active`/`Navigation`), `headerText`, `noDataText`, `mode`
(`None`, `SingleSelectMaster`, `MultiSelect`) e os eventos `itemPress` e `selectionChange`. Nas larguras pequenas,
as colunas com `demandPopin` descem para baixo da linha ("popin"), com o título da coluna.

## What Changes

- Novo `RebicTable<T>`, controlado (`selectedKeys` + `onSelectionChange`), com `columns` (`RebicColumn`), `items`
  (`RebicColumnListItem<T>`), `headerText`, `noDataText`, `mode` e `onItemPress`; colunas com `hAlign`, `flex`,
  `minScreenWidth` e `demandPopin`; teclado pelas setas.
- `rebic/core/localization`: novos textos `selectAll` e `selectItem` ("Selecionar tudo" e "Selecionar item"), os
  nomes das caixas de seleção da tabela.
- Catálogo: `rebic/widgets/rebic-table` passa a `implemented`, P1 na fase 2 (a lista do usuário põe a tabela nos
  dados básicos), com as dependências da spec.
- ADR 0009: textos dos cabeçalhos e espaçamentos das células.

Fora do escopo: `growing`, cabeçalho fixo, `headerToolbar`, `infoToolbar`, rodapé das colunas, agrupamento,
ordenação, `alternateRowColors`, `highlight` das linhas, os modos `Delete` e `SingleSelectLeft` e larguras em CSS
(`flex` substitui `width`).

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-table`: `RebicTable`.

### Modified Capabilities

- `rebic/core/localization`: textos `selectAll` e `selectItem`.

## Impact

- `packages/rebic_core`: textos novos e testes.
- `packages/rebic_widgets`: `exibicao_dados/table/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicTable".
- `docs/catalog.yaml`, `docs/adr/0009-provisional-horizon-values.md`.
- Portal existente: nenhum impacto.
