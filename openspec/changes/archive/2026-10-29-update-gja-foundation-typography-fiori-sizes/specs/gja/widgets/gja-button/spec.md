## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
A altura SHALL ser `density.controlHeight`, o espaço horizontal interno `spacing.m`, o espaço entre ícone e rótulo `spacing.xs`, o raio `radius.control`, o ícone `icons.control` e o rótulo `typography.baseSemibold`. A borda SHALL ter a espessura fina do framework. Nenhum valor MUST ser literal.

#### Scenario: Medidas da densidade compacta
- **GIVEN** um botão numa subárvore compacta
- **WHEN** ele é renderizado
- **THEN** a altura é o `controlHeight` compacto, e o rótulo começa a `spacing.m` compacto da borda inicial
