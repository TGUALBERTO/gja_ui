# Proposal: Fundamento de estados visuais de interação (`rebic/foundation/interaction-states`)

## Why

Todo widget interativo precisa mostrar hover, pressionado, foco, seleção, arrasto e desabilitado de forma igual
em todo o framework. A seção `[Estados]` do template de spec de widget pede isso a cada widget. Hoje não há
valores comuns, então cada widget inventaria opacidades e espessuras próprias. `core/interaction` (que detecta os
estados e desenha o anel de foco), a acessibilidade e todos os controles dependem deste item. Cor e elevação, as
dependências dele, já estão prontas.

## What Changes

- Primitivos (`RebicInteractionPrimitives`) em `rebic_primitives.dart`: uma escala de opacidades (0 a 100%) e uma
  escala de espessuras de traço (1 a 3 px).
- Enum `RebicInteractionState` (`hovered`, `focused`, `pressed`, `selected`, `dragged`, `disabled`).
- Conjunto semântico `RebicInteractionStateTokens`, com:
  - a opacidade da camada de estado de hover, pressionado, selecionado e arrastado;
  - a opacidade de conteúdo desabilitado;
  - a espessura e o afastamento do anel de foco;
  - o aumento de elevação em hover e arrasto.

  O mapeamento de referência é `fallback()`.
- Regras de combinação, como funções puras testadas:
  - a camada de estado resultante de um conjunto de estados;
  - quando o anel de foco aparece;
  - o nível de elevação resultante.
- Garantia de contraste: o texto continua ≥ 4,5:1 sobre a superfície com a camada de estado mais forte, nos dois modos de
  cor. Para isso, a soma das camadas é limitada a um teto (16%). Sem o teto, o texto sobre `primary` cairia para 3,7:1.
- Página "Estados" na galeria, com uma superfície simulada em cada estado, nos dois modos.

Fora do escopo:
- Detectar estados (ponteiro, teclado, toque) e desenhar o anel de foco (`add-rebic-core-interaction`).
- Animação entre estados, que usa as durações de movimento já existentes.
- Estados de valor (erro, sucesso etc.), já definidos em `rebic/foundation/color`.

## Capabilities

### New Capabilities

- `rebic/foundation/interaction-states`: estados de interação, camada de estado, anel de foco, aparência desabilitada,
  elevação em interação, regras de combinação e preservação de contraste.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/interaction_states/`, exportações em `rebic_foundation.dart` e em
  `rebic_primitives.dart`, e testes em `packages/rebic_foundation/test/interaction_states/`.
- **Galeria:** nova página "Estados".
- **Catálogo:** `rebic/foundation/interaction-states` → `implemented`.
- **Dependências:** `rebic/foundation/color` e `rebic/foundation/elevation` (ambas já são specs principais), P0 e fase 1,
  coerente com o catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto.
