# Design: Breakpoints no modelo SAPUI5

## Context

`RebicBreakpointPrimitives` (em `rebic_foundation/lib/src/breakpoints/primitives/`) tem sete larguras e o mapa
`values`. `RebicBreakpointTokens.fallback()` usa só `width600`, `width1024` e `width1440`. Fora do próprio arquivo e
do teste da escala, nenhum código lê os primitivos.

O teste "Escala primitiva de larguras — Escala em ordem" exige `containsAll([360, 600, 840, 1024, 1280, 1440, 1920])`.

## Goals / Non-Goals

**Goals:**
- Escala primitiva só com os limites de faixa do SAPUI5.
- Documentação das classes com a nomenclatura do SAPUI5.

**Non-Goals:**
- Mudar nomes de classes (`small`…`extraLarge`), limiares ou classificação: eles já correspondem a S/M/L/XL.
- Acrescentar outros conjuntos de faixas do `sap.ui.Device.media`, como `SAP_STANDARD` com três faixas.

## Decisions

### D1. Escala primitiva

`width360`, `width840`, `width1280` e `width1920` são removidos da classe e de `values`. O dartdoc da classe passa a
citar `sap.ui.Device.media.RANGESETS.SAP_STANDARD_EXTENDED`.

Alternativa considerada: manter os primitivos para temas personalizados. Rejeitada porque são valores de outros
sistemas de design. Uma aplicação que precise de outro limiar pode passá-lo direto ao `RebicBreakpointTokens`.

### D2. Documentação das classes

Cada valor de `RebicSizeClass` cita a faixa do SAPUI5:
- `small`: S, Phone, < 600;
- `medium`: M, Tablet, 600–1023;
- `large`: L, Desktop, 1024–1439;
- `extraLarge`: XL, LargeDesktop, ≥ 1440.

O dartdoc de `RebicBreakpointTokens.fallback` cita o mesmo conjunto.

### D3. Testes

O teste da escala passa a exigir exatamente `[600, 1024, 1440]` e ganha o cenário "Faixas do SAPUI5". O teste de
"Valores vêm dos primitivos" do mapeamento de referência continua válido.

## Risks / Trade-offs

- **[Quebra de API 0.x]** Quatro primitivos públicos saem. Ninguém no repositório os usa. → O CHANGELOG lista a
  remoção.
