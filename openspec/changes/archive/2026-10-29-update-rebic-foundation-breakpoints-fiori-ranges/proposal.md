# Proposal: Breakpoints no modelo SAPUI5 (`update-rebic-foundation-breakpoints-fiori-ranges`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou primitivos sem uso nos breakpoints.

Os limiares semânticos (600, 1024 e 1440) já são os do SAPUI5: `sap.ui.Device.media`, no conjunto
`SAP_STANDARD_EXTENDED`, define Phone < 600, Tablet < 1024, Desktop < 1440 e LargeDesktop. Mas a escala primitiva
também tem 360, 840, 1280 e 1920. O 840 é o limiar "medium" das window size classes do Material 3, e os outros três
vêm de tamanhos de tela comuns. Nenhum deles é usado, e a spec exige todos.

Esta é a nona e última change da série de realinhamento da fundação.

## What Changes

- **BREAKING** `RebicBreakpointPrimitives` passa a ter só `width600`, `width1024` e `width1440`. Saem `width360`,
  `width840`, `width1280` e `width1920`.
- O dartdoc de `RebicSizeClass` e de `RebicBreakpointTokens` passa a citar as faixas S/M/L/XL do SAPUI5 (Phone,
  Tablet, Desktop e LargeDesktop) e o conjunto `SAP_STANDARD_EXTENDED`.
- Os limiares, a classificação e a página "Breakpoints" da galeria não mudam.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/foundation/breakpoints`: a escala primitiva passa a ser exatamente 600, 1024 e 1440, e as classes de tamanho
  citam as faixas do SAPUI5.

## Impact

- `packages/rebic_foundation`: primitivos e dartdoc de breakpoints, o teste da escala e o CHANGELOG.
- Sem efeito em `rebic_core`, `rebic_widgets`, na galeria (que não usa os primitivos removidos), nos goldens, no
  catálogo e no portal.
