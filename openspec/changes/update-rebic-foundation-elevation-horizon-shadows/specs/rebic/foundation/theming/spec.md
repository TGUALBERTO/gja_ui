## MODIFIED Requirements

### Requirement: Tema centralizado
O fundamento SHALL fornecer um objeto de tema imutável que reúna o brilho e um conjunto de cada fundamento: `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/density` (com o espaçamento de `rebic/foundation/spacing`), `rebic/foundation/radius`, `rebic/foundation/shadows`, o movimento de `rebic/foundation/design-tokens`, `rebic/foundation/iconography`, `rebic/foundation/interaction-states` e `rebic/foundation/breakpoints`.

#### Scenario: Tema completo
- **WHEN** o tema claro de referência é inspecionado
- **THEN** ele expõe brilho, cores, tipografia, densidade, espaçamento, raios, sombras, movimento, ícones, estados de interação e breakpoints, e o espaçamento é o da densidade

### Requirement: Temas de referência claro e escuro
O fundamento SHALL fornecer os temas de referência claro e escuro. Eles MUST usar os mapeamentos de cor claro e escuro, respectivamente, e MUST ter os mesmos valores em todos os outros conjuntos. Ambos MUST aceitar a densidade, sendo `comfortable` o padrão.

#### Scenario: Claro e escuro diferem só na cor
- **WHEN** os temas claro e escuro de referência são comparados
- **THEN** brilho e cores diferem, e tipografia, densidade, raios, sombras, movimento, ícones, estados e breakpoints são iguais

#### Scenario: Densidade no tema
- **WHEN** o tema claro é criado com densidade `compact`
- **THEN** a densidade e o espaçamento são os compactos, e os demais conjuntos são iguais aos do tema confortável
