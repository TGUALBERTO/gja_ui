# Proposal: Indicador de ocupado (`add-rebic-busy-indicator`)

## Why

A Fase 3 pede o "Loading". O Rebic já tem o `RebicProgressIndicator` para progresso medível; falta o indicador de
operação em andamento, o `sap.m.BusyIndicator` (conferido em `SAP/openui5`: `text`, `size`, `customIcon`), que no
Horizon são três pontos animados, e o estado `busy` que todo controle do UI5 tem, com o indicador sobre o controle
bloqueado.

## What Changes

- Novo `RebicBusyIndicator`: `text`, `busy` e `child`. Sem `child`, três pontos `brand` que pulsam em sequência (parados
  com movimento reduzido); com `child`, o conteúdo esmaecido e bloqueado enquanto `busy`, com os pontos no centro.
- Catálogo: `rebic/widgets/rebic-loading-overlay` passa a `rebic/widgets/rebic-busy-indicator`.

Fora do escopo: `customIcon`, `size` livre e `busyIndicatorDelay`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-busy-indicator`: `RebicBusyIndicator`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `feedback_sobreposicoes/busy_indicator/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicBusyIndicator".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
