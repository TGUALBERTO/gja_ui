## MODIFIED Requirements

### Requirement: Alvo mínimo de interação por densidade
A área de interação de cada widget interativo MUST ter, em largura e altura, pelo menos o alvo mínimo da densidade ativa. A API de convenções SHALL fornecer esse valor a partir do conjunto de densidade.

#### Scenario: Alvo por densidade
- **WHEN** o alvo mínimo é pedido para os mapeamentos de densidade de referência
- **THEN** o cozy retorna 44 e o compacto, 32
