# Proposal: Chave liga/desliga (`add-rebic-switch`)

## Why

A Fase 2 pede a chave liga/desliga. O modelo é o `sap.m.Switch` (conferido em `SAP/openui5`, `sap.m/Switch.js`):
`state`, `enabled`, `customTextOn`/`Off`, `type` e o evento `change`. No Horizon, o trilho usa
`sapButton_Track_Background` (cinza) e `sapButton_Track_Selected_Background` (a cor da marca), e a alça
`sapButton_Handle_Background`.

## What Changes

- Novo `RebicSwitch`, controlado (`state` + `onChange`), com `semanticLabel` obrigatório e `enabled`, exposto ao leitor
  de tela como alternância (`toggled`, do núcleo).
- Catálogo: `rebic/widgets/rebic-switch` passa a `implemented`, sem depender do campo de formulário.
- ADR 0009: medidas do trilho e da alça e cores de hover provisórias.

Fora do escopo: `customTextOn`/`Off`, o tipo `AcceptReject` e `name`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-switch`: `RebicSwitch`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `formularios/switch/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicSwitch".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
