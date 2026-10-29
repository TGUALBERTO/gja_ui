## MODIFIED Requirements

### Requirement: Valores do tema ativo
Sem valores recebidos, o elemento interativo MUST usar os do tema ativo: os tokens de interação (opacidade de desabilitado, espessura e afastamento do foco), a cor `focus` e o raio `button` do anel. Um valor recebido MUST ter precedência sobre o do tema.

#### Scenario: Tema com densidade compacta e marca própria
- **GIVEN** um tema ativo compacto com a cor `focus` trocada
- **WHEN** um elemento sem valores recebidos é medido e recebe foco por Tab
- **THEN** ele mede pelo menos o alvo compacto, e o anel usa a cor `focus` do tema

#### Scenario: Valor recebido vence o tema
- **GIVEN** um tema ativo compacto
- **WHEN** um elemento recebe alvo mínimo 48
- **THEN** ele mede pelo menos 48 × 48
