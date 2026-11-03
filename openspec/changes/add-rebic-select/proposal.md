# Proposal: Campo de seleção (`add-rebic-select`)

## Why

A Fase 2 pede a seleção. O modelo é o `sap.m.Select` (conferido em `SAP/openui5`, `sap.m/Select.js`): `items`,
`selectedKey`, `enabled`, `editable`, `valueState`, `valueStateText` e o evento `change`; abre por toque, Enter,
Espaço, F4 e Alt+seta para baixo. O Rebic já tem a lista do Select em `RebicDropdown`.

## What Changes

- Novo `RebicSelect<T>`, controlado (`selectedKey` + `onChange`), com os itens de `RebicDropdownItem`,
  `semanticLabel`, `placeholder`, `enabled`, `editable`, `valueState` e `valueStateText`; o campo tem a moldura dos
  campos de formulário (a do `RebicInput`) e abre o `RebicDropdown` na largura do campo.
- Catálogo: `rebic/widgets/rebic-select` passa a `implemented`, sem depender do campo de formulário.

Fora do escopo: o tipo `IconOnly`, `showSecondaryValues`, `forceSelection`, `autoAdjustWidth` e busca.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-select`: `RebicSelect`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `formularios/select/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicSelect".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
