# Proposal: Dropdown com os nomes do SAPUI5 (`update-rebic-dropdown-fiori-key-text`)

## Why

`RebicDropdown` e `RebicDropdownItem` são a lista do `sap.m.Select` (`sap.m.SelectList` num popover, com itens
`sap.ui.core.ListItem`), mas ainda usam nomes que não são do UI5: `value` e `label` no item (no UI5, `key` e `text`),
`selected` (no UI5, `selectedKey`) e `onSelected` (no UI5, o evento `selectionChange`). Os outros widgets do Rebic
já usam `key`/`text` (`RebicIconTabFilter`, `RebicNavigationListItem`) e eventos com os nomes do UI5.

## What Changes

- **BREAKING** `RebicDropdownItem`: `value` → `key`, `label` → `text`.
- **BREAKING** `RebicDropdown`: `selected` → `selectedKey`, `onSelected` → `onSelectionChange`.
- `RebicSelect` (que monta o dropdown), a galeria e os testes seguem os novos nomes. A API do `RebicSelect`
  (`selectedKey`, `onChange`) não muda.

Fora do escopo: renomear o próprio `RebicDropdown`, que não tem um controle único equivalente no UI5.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-dropdown`: nomes do UI5 no item e na lista.

## Impact

- `packages/rebic_widgets`: dropdown, select, testes, CHANGELOG.
- `apps/rebic_gallery`: páginas do dropdown, do select e do formulário.
- Portal existente: nenhum impacto.
