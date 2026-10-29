## MODIFIED Requirements

### Requirement: [API] Valores dos papéis
`RebicSurface` SHALL ter `none`, `background`, `base`, `header` e `shell`. `RebicRadius` SHALL ter os passos e papéis do raio (`none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `button`, `field`, `popover`, `element`, `tile`). `RebicShadow` SHALL ter `none` e os papéis de sombra (`card`, `popover`, `dialog`, `dragged`, `header`).

#### Scenario: Papéis do fundamento
- **WHEN** os valores de `RebicRadius` e os papéis de `RebicShadow` são comparados com os nomes dos tokens de raio e de sombra
- **THEN** cada valor tem um token de mesmo nome

### Requirement: [Comportamento] Recorte nos cantos
Com `radius` diferente de `none`, `RebicContainer` SHALL recortar o conteúdo no contorno arredondado, para que filhos com fundo próprio não ultrapassem os cantos. Com `radius` `none`, MUST NOT recortar.

#### Scenario: Filho recortado
- **GIVEN** `RebicContainer` com `radius` `tile` e um filho que pinta toda a área
- **WHEN** o contêiner é renderizado
- **THEN** o conteúdo é recortado com o raio `tile` do tema

#### Scenario: Sem raio, sem recorte
- **WHEN** `RebicContainer` é criado com `radius` `none`
- **THEN** não há recorte do conteúdo

### Requirement: [Documentação] Exemplos mínimos
`RebicContainer` SHALL ter dartdoc em toda API pública e uma página "RebicContainer" na galeria com as superfícies, a borda, os raios, as sombras e um exemplo de cartão (`base`, borda, raio `tile`, sombra `card` e `padding`).

#### Scenario: Página RebicContainer na galeria
- **WHEN** a página "RebicContainer" é aberta
- **THEN** ela exibe as cinco superfícies, os raios, os seis valores de sombra e o exemplo de cartão
