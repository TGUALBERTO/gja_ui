## MODIFIED Requirements

### Requirement: [Responsividade] Densidade
O `spacing` e o recuo SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `gja/foundation/density`. A espessura MUST ser a mesma nas duas densidades e em qualquer escala de texto.

#### Scenario: Densidade compacta do divisor
- **GIVEN** um `GjaDivider(spacing: l)`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** a altura é a linha fina mais 2 × `l` nos dois casos
