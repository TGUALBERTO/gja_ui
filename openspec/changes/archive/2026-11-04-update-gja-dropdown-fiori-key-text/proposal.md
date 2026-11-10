# Proposal: Dropdown com os nomes do SAPUI5 (`update-gja-dropdown-fiori-key-text`)

## Why

`GjaDropdown` e `GjaDropdownItem` são a lista do `sap.m.Select` (`sap.m.SelectList` num popover, com itens
`sap.ui.core.ListItem`), mas ainda usam nomes que não são do UI5: `value` e `label` no item (no UI5, `key` e `text`),
`selected` (no UI5, `selectedKey`) e `onSelected` (no UI5, o evento `selectionChange`). Os outros widgets do GJA
já usam `key`/`text` (`GjaIconTabFilter`, `GjaNavigationListItem`) e eventos com os nomes do UI5.

## What Changes

- **BREAKING** `GjaDropdownItem`: `value` → `key`, `label` → `text`.
- **BREAKING** `GjaDropdown`: `selected` → `selectedKey`, `onSelected` → `onSelectionChange`.
- `GjaSelect` (que monta o dropdown), a galeria e os testes seguem os novos nomes. A API do `GjaSelect`
  (`selectedKey`, `onChange`) não muda.

Fora do escopo: renomear o próprio `GjaDropdown`, que não tem um controle único equivalente no UI5.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-dropdown`: nomes do UI5 no item e na lista.

## Impact

- `packages/gja_widgets`: dropdown, select, testes, CHANGELOG.
- `apps/gja_gallery`: páginas do dropdown, do select e do formulário.
- Portal existente: nenhum impacto.
