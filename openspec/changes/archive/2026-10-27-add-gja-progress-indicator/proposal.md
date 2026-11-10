# Proposal: GjaProgressIndicator (`gja/widgets/gja-progress-indicator`)

## Why

A Fase 2 começa pelos widgets de ação. `GjaButton` precisa mostrar "ocupado", e `GjaLoadingOverlay` e
`GjaFileUpload` precisam mostrar progresso. Hoje o GJA não tem nenhum indicador de progresso.

No SAPUI5, isso fica com dois controles:
- `sap.m.ProgressIndicator`, uma barra determinada com `percentValue` e `state` (ValueState);
- `sap.m.BusyIndicator`, um indicador indeterminado, com tamanho próprio.

O design da Fase 0 previu um só widget, `GjaProgressIndicator`, dependente de `foundation/color`, e o colocou
antes de `GjaButton` na ordem de implementação.

## What Changes

- Widget `GjaProgressIndicator` em `gja_widgets` (categoria `exibicao-dados`), com duas formas:
  - `GjaProgressIndicator.linear`: uma barra na largura disponível, como o `ProgressIndicator`;
  - `GjaProgressIndicator.circular`: um círculo no tamanho de um ícone do tema (`GjaIconSize`, padrão
    `control`), como o `BusyIndicator` e o estado ocupado de botões.
- `value` (`double?`, de 0 a 1): com valor, o indicador é determinado; sem valor, é indeterminado e animado.
- `state` (`GjaValueState`): a cor do preenchimento. `none` usa `brand`, e os demais usam a cor do estado.
- `semanticLabel`: o padrão é o texto `loading` do núcleo. O valor é anunciado em porcentagem.
- Movimento reduzido: o indeterminado fica parado, num desenho estático distinto do determinado.
- Página "GjaProgressIndicator" na galeria.

Fora do escopo:
- Texto do valor dentro ou ao lado da barra (`displayValue` do UI5).
- Barra com buffer ou segmentos.
- Atraso de exibição (`busyIndicatorDelay`) e camada de bloqueio, que são do `GjaLoadingOverlay`.

## Capabilities

### New Capabilities

- `gja/widgets/gja-progress-indicator`: indicador de progresso linear ou circular, determinado ou
  indeterminado, com cor por estado de valor, semântica de progresso e movimento reduzido.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/exibicao_dados/progress_indicator/` (primeira pasta da categoria) e
  testes, com goldens.
- **Galeria:** nova página "GjaProgressIndicator".
- **Catálogo:** `gja/widgets/gja-progress-indicator` → `implemented`. Além de `foundation/color`, as
  dependências passam a incluir:
  - `gja/widgets/gja-icon` (`GjaIconSize`);
  - `gja/core/localization`;
  - os fundamentos `spacing`, `density`, `iconography`, `design-tokens` (movimento), `theming` e `accessibility`.
- **Portal existente:** sem impacto.
