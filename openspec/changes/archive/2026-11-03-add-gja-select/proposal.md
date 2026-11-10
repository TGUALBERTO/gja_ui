# Proposal: Campo de seleção (`add-gja-select`)

## Why

A Fase 2 pede a seleção. O modelo é o `sap.m.Select` (conferido em `SAP/openui5`, `sap.m/Select.js`): `items`,
`selectedKey`, `enabled`, `editable`, `valueState`, `valueStateText` e o evento `change`; abre por toque, Enter,
Espaço, F4 e Alt+seta para baixo. O GJA já tem a lista do Select em `GjaDropdown`.

## What Changes

- Novo `GjaSelect<T>`, controlado (`selectedKey` + `onChange`), com os itens de `GjaDropdownItem`,
  `semanticLabel`, `placeholder`, `enabled`, `editable`, `valueState` e `valueStateText`; o campo tem a moldura dos
  campos de formulário (a do `GjaInput`) e abre o `GjaDropdown` na largura do campo.
- Catálogo: `gja/widgets/gja-select` passa a `implemented`, sem depender do campo de formulário.

Fora do escopo: o tipo `IconOnly`, `showSecondaryValues`, `forceSelection`, `autoAdjustWidth` e busca.

## Capabilities

### New Capabilities

- `gja/widgets/gja-select`: `GjaSelect`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `formularios/select/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaSelect".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
