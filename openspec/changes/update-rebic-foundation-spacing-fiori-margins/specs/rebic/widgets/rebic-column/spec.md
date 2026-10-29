## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
`RebicColumn` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de densidade da coluna
- **GIVEN** `RebicColumn` com `gap` `l` na densidade cozy
- **WHEN** o tema ativo passa para a densidade compacta e, depois, para um tema com `l` de 24
- **THEN** o espaço entre os filhos continua o `l` de referência na compacta e passa a 24 no último tema, sem recriar o widget com outros parâmetros

### Requirement: [Responsividade] Direção e densidade
O alinhamento cruzado de `RebicColumn` SHALL seguir a direção do texto: em RTL, `start` é à direita. O `gap` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `rebic/foundation/density`.

#### Scenario: Coluna em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um `RebicColumn` de 200 de largura com um quadrado é renderizado com `crossAlignment` `start`
- **THEN** o quadrado fica na borda direita

#### Scenario: Densidade compacta na coluna
- **GIVEN** um `RebicColumn` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o mesmo `l` dentro e fora
