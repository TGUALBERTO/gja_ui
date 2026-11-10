## MODIFIED Requirements

### Requirement: [Responsividade] Densidade
O `padding` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `gja/foundation/density`. Raio e sombra MUST ser os mesmos nas duas densidades. O contêiner MUST se ajustar à largura disponível, sem tamanho próprio.

#### Scenario: Densidade compacta
- **GIVEN** um `GjaContainer` com `padding` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço interno é o mesmo `l` dentro e fora, com o mesmo raio e a mesma sombra
