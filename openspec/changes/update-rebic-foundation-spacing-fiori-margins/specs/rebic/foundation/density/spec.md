## MODIFIED Requirements

### Requirement: Espaçamento por densidade
Cada mapeamento de densidade SHALL conter um conjunto de espaçamento completo. Os mapeamentos de referência cozy e compacto MUST usar o mesmo mapeamento de referência de espaçamento: como no Fiori, a densidade muda as alturas de elemento, e as classes de margem valem o mesmo em Cozy e Compact.

#### Scenario: Espaçamento confortável
- **WHEN** o espaçamento do mapeamento cozy é comparado com o mapeamento de referência de espaçamento
- **THEN** eles são iguais

#### Scenario: Espaçamento compacto
- **WHEN** o espaçamento compacto é comparado com o mapeamento de referência de espaçamento
- **THEN** eles são iguais, e o compacto difere do cozy só nas dimensões de controle, item e alvo
