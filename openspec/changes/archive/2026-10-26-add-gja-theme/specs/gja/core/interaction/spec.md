## MODIFIED Requirements

### Requirement: Área mínima de interação
O elemento MUST ocupar e responder ao toque em uma área de pelo menos o alvo mínimo recebido, em largura e altura, mesmo quando o conteúdo é menor. Sem alvo recebido, o alvo é o da densidade do tema ativo de `gja/foundation/theming`.

#### Scenario: Conteúdo menor que o alvo
- **GIVEN** um elemento com conteúdo de 16 × 16 e alvo mínimo 48
- **WHEN** ele é medido e tocado a 20 px do centro
- **THEN** ele mede pelo menos 48 × 48, e a ação é chamada

## ADDED Requirements

### Requirement: Valores do tema ativo
Sem valores recebidos, o elemento interativo MUST usar os do tema ativo: os tokens de interação (opacidade de desabilitado, espessura e afastamento do foco), a cor `focus` e o raio `control` do anel. Um valor recebido MUST ter precedência sobre o do tema.

#### Scenario: Tema com densidade compacta e marca própria
- **GIVEN** um tema ativo compacto com a cor `focus` trocada
- **WHEN** um elemento sem valores recebidos é medido e recebe foco por Tab
- **THEN** ele mede pelo menos o alvo compacto, e o anel usa a cor `focus` do tema

#### Scenario: Valor recebido vence o tema
- **GIVEN** um tema ativo compacto
- **WHEN** um elemento recebe alvo mínimo 48
- **THEN** ele mede pelo menos 48 × 48
