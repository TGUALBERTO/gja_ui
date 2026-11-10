# Spec Delta

## MODIFIED Requirements

### Requirement: Dimensões de controle por densidade
O conjunto semântico de densidade SHALL ter a altura de controle (`sapElement_Height`), a altura de item de lista, o alvo mínimo de interação (`sapElement_LineHeight`), a altura de barra (`barHeight`, a altura do `sap.m.Bar`) e a altura do separador vertical (`separatorHeight`, a do `sap.m.ToolbarSeparator`). Nos mapeamentos de referência, cada dimensão compacta MUST ser menor ou igual à cozy, e todas MUST ser valores da escala primitiva de densidade.

#### Scenario: Valores de referência
- **WHEN** os mapeamentos de referência são inspecionados
- **THEN** o cozy tem controle 36, item 44, alvo 44, barra 48 e separador 32; o compacto tem controle 26, item 32, alvo 32, barra 32 e separador 24

#### Scenario: Compacto não maior que confortável
- **WHEN** cada dimensão do compacto é comparada com a do cozy
- **THEN** nenhuma dimensão compacta é maior

#### Scenario: Escala primitiva de densidade
- **WHEN** a escala primitiva de densidade é inspecionada
- **THEN** ela tem 24, 26, 32, 36, 44 e 48 em ordem crescente, cada um nomeado pelo valor
