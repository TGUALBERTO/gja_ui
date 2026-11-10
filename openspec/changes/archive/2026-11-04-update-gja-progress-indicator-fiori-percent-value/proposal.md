# Proposal: Indicador de progresso no modelo do SAPUI5 (`update-gja-progress-indicator-fiori-percent-value`)

## Why

`GjaProgressIndicator` junta dois controles do SAPUI5: a barra determinada do `sap.m.ProgressIndicator` e o
indeterminado do `sap.m.BusyIndicator`, além de um círculo que o UI5 não tem. Depois de `add-gja-busy-indicator`,
o "ocupado" do GJA é o `GjaBusyIndicator`, e o indeterminado do indicador de progresso ficou redundante. O
`sap.m.ProgressIndicator` (conferido em `SAP/openui5`) é só a barra, com o valor em `percentValue`, de 0 a 100, e o
`state`.

## What Changes

- **BREAKING** `GjaProgressIndicator.linear` e `GjaProgressIndicator.circular` dão lugar ao construtor único
  `GjaProgressIndicator(percentValue:)`, como o `sap.m.ProgressIndicator`: `percentValue` (`double`, obrigatório, de
  0 a 100), `state` e `semanticLabel`. Saem o modo indeterminado (`value` nulo), a forma circular e `size`.
- O indicador circular do `busy` do `GjaButton` continua, interno ao botão; nada muda na spec do botão.
- A galeria e o catálogo seguem a nova API, sem `gja/widgets/gja-icon` e `gja/foundation/iconography` nas
  dependências.

Fora do escopo: `displayValue` e `showValue` (o texto do valor dentro da barra) e `displayOnly`.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-progress-indicator`: só a barra determinada, com `percentValue`.

## Impact

- `packages/gja_widgets`: indicador, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaProgressIndicator".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
