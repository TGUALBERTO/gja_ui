## MODIFIED Requirements

### Requirement: Temas de referência claro e escuro
O fundamento SHALL fornecer os temas de referência claro e escuro. Eles MUST usar os mapeamentos de cor claro e escuro, respectivamente, e MUST ter os mesmos valores em todos os outros conjuntos. Ambos MUST aceitar a densidade, sendo `cozy` o padrão.

#### Scenario: Claro e escuro diferem só na cor
- **WHEN** os temas claro e escuro de referência são comparados
- **THEN** brilho e cores diferem, e tipografia, densidade, raios, sombras, movimento, ícones, estados e breakpoints são iguais

#### Scenario: Densidade no tema
- **WHEN** o tema claro é criado com densidade `compact`
- **THEN** a densidade e o espaçamento são os compactos, e os demais conjuntos são iguais aos do tema confortável

#### Scenario: Densidade padrão
- **WHEN** o tema claro é criado sem densidade
- **THEN** a densidade é `cozy`
