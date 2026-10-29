## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
`RebicSpacing` SHALL obter cada valor de `spacing.<passo ou papel>` do tema ativo, sem valores literais, e SHALL NOT pintar nada: o espaço é vazio e transparente.

#### Scenario: Troca de densidade
- **GIVEN** `RebicSpacing.vertical(RebicSpace.sectionGap)` renderizado na densidade cozy
- **WHEN** o tema ativo passa para a densidade compacta e, depois, para um tema com `sectionGap` de 48
- **THEN** a altura continua o `sectionGap` de referência na compacta e passa a 48 no último tema, sem recriar o widget com outros parâmetros

#### Scenario: Todos os passos e papéis
- **WHEN** cada valor de `RebicSpace` é usado em `RebicSpacing.vertical` no tema claro
- **THEN** a altura é o valor de mesmo nome em `spacing`

### Requirement: [Responsividade] Densidade
`RebicSpacing` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `rebic/foundation/density`. A classe de tamanho da tela MUST NOT alterar os valores; margens responsivas são de `RebicResponsiveLayout` e `RebicPage`.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `RebicSpacing.horizontal(RebicSpace.l)` é renderizado dentro e fora dela
- **THEN** a largura é o mesmo `l` dentro e fora
