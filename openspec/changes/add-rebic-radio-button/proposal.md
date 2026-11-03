# Proposal: Opção de rádio e grupo (`add-rebic-radio-button`)

## Why

A Fase 2 pede o rádio. O SAPUI5 tem o `sap.m.RadioButton` (`selected`, `text`, `enabled`, `editable`, `valueState`,
`wrapping`, `groupName`, evento `select`) e o `sap.m.RadioButtonGroup` (`buttons`, `selectedIndex`, `columns`,
`enabled`, `editable`, `valueState`, evento `select` com o índice), conferidos em `SAP/openui5`. O círculo tem
1,375rem (cozy) e 1rem (compacto) em `RadioButton.less`.

## What Changes

- Novo `RebicRadioButton`, controlado (`selected` + `onSelect`), com texto ou `semanticLabel`, `enabled`, `editable`,
  `valueState`, `wrapping` e `focusNode`.
- Novo `RebicRadioButtonGroup`: `buttons`, `selectedIndex`, `onSelect(índice)`, `columns`, `enabled`, `editable` e
  `valueState`; setas escolhem a opção seguinte ou anterior, e Tab entra pela opção marcada.
- Catálogo: `rebic/widgets/rebic-radio-group` dá lugar a `rebic/widgets/rebic-radio-button` e
  `rebic/widgets/rebic-radio-button-group`.
- ADR 0009: lado do círculo igual ao da caixa de seleção nas duas densidades.

Os dois widgets são inseparáveis: no UI5 o agrupamento das opções avulsas vem do `groupName`, que o Rebic não tem; a
escolha única e as setas existem só no grupo, e o grupo é feito das opções.

Fora do escopo: `groupName`, `width`, `useEntireWidth`, `required` e o texto de estado de valor.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-radio-button`: `RebicRadioButton`.
- `rebic/widgets/rebic-radio-button-group`: `RebicRadioButtonGroup`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `formularios/radio_button/`, exportações, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicRadioButton".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
