## MODIFIED Requirements

### Requirement: [API] Valores dos papéis
`GjaSurface` SHALL ter `none`, `background`, `base`, `header` e `shell`. `GjaRadius` SHALL ter os passos e papéis do raio (`none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `button`, `field`, `popover`, `element`, `tile`). `GjaShadow` SHALL ter `none` e os papéis de sombra (`card`, `popover`, `dialog`, `dragged`, `header`).

#### Scenario: Papéis do fundamento
- **WHEN** os valores de `GjaRadius` e os papéis de `GjaShadow` são comparados com os nomes dos tokens de raio e de sombra
- **THEN** cada valor tem um token de mesmo nome

### Requirement: [Comportamento] Recorte nos cantos
Com `radius` diferente de `none`, `GjaContainer` SHALL recortar o conteúdo no contorno arredondado, para que filhos com fundo próprio não ultrapassem os cantos. Com `radius` `none`, MUST NOT recortar.

#### Scenario: Filho recortado
- **GIVEN** `GjaContainer` com `radius` `tile` e um filho que pinta toda a área
- **WHEN** o contêiner é renderizado
- **THEN** o conteúdo é recortado com o raio `tile` do tema

#### Scenario: Sem raio, sem recorte
- **WHEN** `GjaContainer` é criado com `radius` `none`
- **THEN** não há recorte do conteúdo

### Requirement: [Documentação] Exemplos mínimos
`GjaContainer` SHALL ter dartdoc em toda API pública e uma página "GjaContainer" na galeria com as superfícies, a borda, os raios, as sombras e um exemplo de cartão (`base`, borda, raio `tile`, sombra `card` e `padding`).

#### Scenario: Página GjaContainer na galeria
- **WHEN** a página "GjaContainer" é aberta
- **THEN** ela exibe as cinco superfícies, os raios, os seis valores de sombra e o exemplo de cartão
