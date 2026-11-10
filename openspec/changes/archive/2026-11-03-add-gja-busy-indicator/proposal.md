# Proposal: Indicador de ocupado (`add-gja-busy-indicator`)

## Why

A Fase 3 pede o "Loading". O GJA já tem o `GjaProgressIndicator` para progresso medível; falta o indicador de
operação em andamento, o `sap.m.BusyIndicator` (conferido em `SAP/openui5`: `text`, `size`, `customIcon`), que no
Horizon são três pontos animados, e o estado `busy` que todo controle do UI5 tem, com o indicador sobre o controle
bloqueado.

## What Changes

- Novo `GjaBusyIndicator`: `text`, `busy` e `child`. Sem `child`, três pontos `brand` que pulsam em sequência (parados
  com movimento reduzido); com `child`, o conteúdo esmaecido e bloqueado enquanto `busy`, com os pontos no centro.
- Catálogo: `gja/widgets/gja-loading-overlay` passa a `gja/widgets/gja-busy-indicator`.

Fora do escopo: `customIcon`, `size` livre e `busyIndicatorDelay`.

## Capabilities

### New Capabilities

- `gja/widgets/gja-busy-indicator`: `GjaBusyIndicator`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `feedback_sobreposicoes/busy_indicator/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaBusyIndicator".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
