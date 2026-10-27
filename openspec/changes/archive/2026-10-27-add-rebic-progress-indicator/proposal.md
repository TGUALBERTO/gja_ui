# Proposal: RebicProgressIndicator (`rebic/widgets/rebic-progress-indicator`)

## Why

A Fase 2 começa pelos widgets de ação. `RebicButton` precisa mostrar "ocupado", e `RebicLoadingOverlay` e
`RebicFileUpload` precisam mostrar progresso. Hoje o Rebic não tem nenhum indicador de progresso.

No SAPUI5, isso fica com dois controles:
- `sap.m.ProgressIndicator`, uma barra determinada com `percentValue` e `state` (ValueState);
- `sap.m.BusyIndicator`, um indicador indeterminado, com tamanho próprio.

O design da Fase 0 previu um só widget, `RebicProgressIndicator`, dependente de `foundation/color`, e o colocou
antes de `RebicButton` na ordem de implementação.

## What Changes

- Widget `RebicProgressIndicator` em `rebic_widgets` (categoria `exibicao-dados`), com duas formas:
  - `RebicProgressIndicator.linear`: uma barra na largura disponível, como o `ProgressIndicator`;
  - `RebicProgressIndicator.circular`: um círculo no tamanho de um ícone do tema (`RebicIconSize`, padrão
    `control`), como o `BusyIndicator` e o estado ocupado de botões.
- `value` (`double?`, de 0 a 1): com valor, o indicador é determinado; sem valor, é indeterminado e animado.
- `state` (`RebicValueState`): a cor do preenchimento. `none` usa `brand`, e os demais usam a cor do estado.
- `semanticLabel`: o padrão é o texto `loading` do núcleo. O valor é anunciado em porcentagem.
- Movimento reduzido: o indeterminado fica parado, num desenho estático distinto do determinado.
- Página "RebicProgressIndicator" na galeria.

Fora do escopo:
- Texto do valor dentro ou ao lado da barra (`displayValue` do UI5).
- Barra com buffer ou segmentos.
- Atraso de exibição (`busyIndicatorDelay`) e camada de bloqueio, que são do `RebicLoadingOverlay`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-progress-indicator`: indicador de progresso linear ou circular, determinado ou
  indeterminado, com cor por estado de valor, semântica de progresso e movimento reduzido.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/exibicao_dados/progress_indicator/` (primeira pasta da categoria) e
  testes, com goldens.
- **Galeria:** nova página "RebicProgressIndicator".
- **Catálogo:** `rebic/widgets/rebic-progress-indicator` → `implemented`. Além de `foundation/color`, as
  dependências passam a incluir:
  - `rebic/widgets/rebic-icon` (`RebicIconSize`);
  - `rebic/core/localization`;
  - os fundamentos `spacing`, `density`, `iconography`, `design-tokens` (movimento), `theming` e `accessibility`.
- **Portal existente:** sem impacto.
