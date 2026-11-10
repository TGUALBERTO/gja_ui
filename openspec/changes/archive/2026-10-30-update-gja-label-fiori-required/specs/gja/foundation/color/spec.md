# Spec Delta

## MODIFIED Requirements

### Requirement: Escalas primitivas de cor
O fundamento SHALL fornecer escalas primitivas de cor nomeadas por matiz e posição (ex.: `neutral900`, `blue600`), no mínimo para neutro, azul, verde, âmbar, vermelho, ciano e magenta. Em cada escala, a luminância MUST decrescer à medida que a posição cresce. As escalas MUST ficar na biblioteca de primitivos, e nenhuma cor MUST reproduzir a paleta da SAP.

#### Scenario: Ordem de luminância
- **WHEN** as posições de uma escala primitiva são percorridas em ordem crescente
- **THEN** a luminância relativa de cada cor é menor que a da posição anterior

#### Scenario: Escalas fora da API dos widgets
- **WHEN** uma aplicação importa apenas o ponto de entrada do fundamento
- **THEN** as escalas primitivas não estão visíveis, e os papéis semânticos de cor estão

#### Scenario: Escala magenta
- **WHEN** as escalas primitivas são listadas
- **THEN** há a escala `magenta`, de `magenta50` a `magenta900`, usada pelo papel `required`
