# Proposal: Indicador de progresso no modelo do SAPUI5 (`update-rebic-progress-indicator-fiori-percent-value`)

## Why

`RebicProgressIndicator` junta dois controles do SAPUI5: a barra determinada do `sap.m.ProgressIndicator` e o
indeterminado do `sap.m.BusyIndicator`, além de um círculo que o UI5 não tem. Depois de `add-rebic-busy-indicator`,
o "ocupado" do Rebic é o `RebicBusyIndicator`, e o indeterminado do indicador de progresso ficou redundante. O
`sap.m.ProgressIndicator` (conferido em `SAP/openui5`) é só a barra, com o valor em `percentValue`, de 0 a 100, e o
`state`.

## What Changes

- **BREAKING** `RebicProgressIndicator.linear` e `RebicProgressIndicator.circular` dão lugar ao construtor único
  `RebicProgressIndicator(percentValue:)`, como o `sap.m.ProgressIndicator`: `percentValue` (`double`, obrigatório, de
  0 a 100), `state` e `semanticLabel`. Saem o modo indeterminado (`value` nulo), a forma circular e `size`.
- O indicador circular do `busy` do `RebicButton` continua, interno ao botão; nada muda na spec do botão.
- A galeria e o catálogo seguem a nova API, sem `rebic/widgets/rebic-icon` e `rebic/foundation/iconography` nas
  dependências.

Fora do escopo: `displayValue` e `showValue` (o texto do valor dentro da barra) e `displayOnly`.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-progress-indicator`: só a barra determinada, com `percentValue`.

## Impact

- `packages/rebic_widgets`: indicador, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicProgressIndicator".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
