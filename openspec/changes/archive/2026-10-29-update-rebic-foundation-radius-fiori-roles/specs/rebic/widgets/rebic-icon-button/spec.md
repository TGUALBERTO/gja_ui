## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
O lado SHALL ser `density.controlHeight`, o raio `radius.button` e o ícone `icons.control`, com a borda fina do framework, sem valores literais. A escala de texto MUST NOT alterar o tamanho.

#### Scenario: Botão de ícone na densidade compacta
- **GIVEN** um botão de ícone numa subárvore compacta, com escala de texto 2,0
- **WHEN** ele é renderizado
- **THEN** ele é um quadrado com o lado `controlHeight` compacto, e o ícone mede `icons.control`
