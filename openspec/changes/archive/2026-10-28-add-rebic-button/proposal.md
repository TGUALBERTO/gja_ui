# Proposal: RebicButton (`rebic/widgets/rebic-button`)

## Why

O Rebic ainda não tem um botão. As páginas da galeria usam `RebicText` tocável para "Salvar" e "Cancelar". Um botão é
pré-requisito de quase todo o restante da Fase 2 e das fases seguintes:
- `RebicToolbar`, `RebicPagination`, `RebicEmptyState` e `RebicFileUpload`;
- os diálogos.

No SAPUI5, o `sap.m.Button` tem os tipos Default, Emphasized, Transparent, Accept, Reject e Attention. O design da
Fase 0 os mapeou num enum de variantes do `RebicButton`, com dependência de `core/interaction`, `RebicText`,
`RebicIcon` e `RebicProgressIndicator` (estado ocupado).

O fundamento `interaction-states` já define as famílias `standard`, `emphasized` e `transparent`. Faltam as cores de
estado dos tipos Accept, Reject e Attention.

## What Changes

- Widget `RebicButton` em `rebic_widgets` (categoria `acoes-navegacao`):
  - `label` (obrigatório, não vazio) e `onPressed` (`null` desabilita);
  - `type` (`RebicButtonType`): `standard`, `emphasized`, `transparent`, `accept`, `reject` e `attention`, com padrão
    `standard`;
  - `icon` opcional, antes do rótulo;
  - `busy`: mostra um indicador circular no lugar do ícone (ou antes do rótulo), ignora acionamentos e anuncia
    "Carregando".
  - Estados de `core/interaction`: hover, pressionado, foco pelo teclado e desabilitado (opacidade). A altura é
    `density.controlHeight`, e o rótulo fica numa linha, com reticências.
- Em `rebic/foundation/interaction-states`, as famílias `accept`, `reject` e `attention`, derivadas das cores dos
  estados de valor `success`, `error` e `warning`. Elas entram no teste de contraste já existente, que percorre todas
  as famílias.
- Refatoração interna, sem mudança de comportamento: a animação e a pintura do `RebicProgressIndicator` passam a um
  widget interno não exportado, que aceita as cores. O botão o usa com a cor do texto do estado, para o indicador
  ficar visível sobre fundos `brand`.
- Página "RebicButton" na galeria.

Fora do escopo:
- Botão só de ícone (`RebicIconButton`, a seguir).
- Botão de alternância (`ToggleButton`), botão de menu (`MenuButton`) e botão dividido.
- Ícone depois do rótulo (`iconFirst: false`) e largura configurável.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-button`: botão com rótulo, ícone opcional, seis tipos no modelo Fiori, estados de interação,
  desabilitado e ocupado.

### Modified Capabilities

- `rebic/foundation/interaction-states`: o requisito "Famílias de controle" ganha `accept`, `reject` e `attention`.

## Impact

- **Código:**
  - `packages/rebic_foundation/lib/src/interaction_states/control_colors.dart`: três valores novos em
    `RebicControlFamily`, que é aditivo. Os `switch` exaustivos fora do fundamento não existem; a galeria percorre
    `values`.
  - `packages/rebic_widgets/lib/src/acoes_navegacao/button/`: o widget e os testes, com goldens.
  - `packages/rebic_widgets/lib/src/exibicao_dados/progress_indicator/`: a extração interna da animação. Os testes e
    goldens do indicador continuam sem mudança.
- **Galeria:**
  - a página "Estados" passa a mostrar as três famílias novas automaticamente;
  - nova página "RebicButton".
- **Catálogo:** `rebic/widgets/rebic-button` → `implemented`. As dependências passam a ser as usadas de fato:
  - `core/interaction`, `core/localization`, `rebic-progress-indicator`;
  - os fundamentos `interaction-states`, `color`, `typography`, `iconography`, `density`, `spacing`, `radius`,
    `theming` e `accessibility`.

  `rebic-text` e `rebic-icon` saem da lista, porque o botão desenha rótulo e ícone com os tokens de tipografia e
  iconografia na cor do estado, que os tons desses widgets não cobrem.
- **Portal existente:** sem impacto.
