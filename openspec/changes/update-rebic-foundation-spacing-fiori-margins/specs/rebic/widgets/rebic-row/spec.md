## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
`RebicRow` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de densidade da linha
- **GIVEN** `RebicRow` com `gap` `l` na densidade cozy
- **WHEN** o tema ativo passa para a densidade compacta e, depois, para um tema com `l` de 24
- **THEN** o espaço entre os filhos continua o `l` de referência na compacta e passa a 24 no último tema, sem recriar o widget com outros parâmetros

### Requirement: [Responsividade] Direção e densidade
`RebicRow` SHALL seguir a direção do texto: em RTL, o início é à direita. O `gap` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `rebic/foundation/density`. Para larguras pequenas, `RebicRow.wrap` é a forma de evitar estouro.

#### Scenario: Linha em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** `RebicRow` com dois quadrados é renderizado com `mainAlignment` `start`
- **THEN** o primeiro quadrado fica na borda direita

#### Scenario: Densidade compacta na linha
- **GIVEN** um `RebicRow` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o mesmo `l` dentro e fora
