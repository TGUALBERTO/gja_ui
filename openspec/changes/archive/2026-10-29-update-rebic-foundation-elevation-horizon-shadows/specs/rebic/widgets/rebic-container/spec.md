## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicContainer` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `child` | `Widget?` | nulo |
| `surface` | `RebicSurface` | `none` |
| `border` | `bool` | `false` |
| `radius` | `RebicRadius` | `none` |
| `shadow` | `RebicShadow` | `none` |
| `padding` | `RebicSpace?` | nulo (sem espaço) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp`
- **WHEN** `RebicContainer(child: RebicText('a'))` é criado
- **THEN** ele não pinta fundo, borda nem sombra, e o filho ocupa a mesma área que ocuparia sem o contêiner

### Requirement: [API] Valores dos papéis
`RebicSurface` SHALL ter `none`, `background`, `base`, `header` e `shell`. `RebicRadius` SHALL ter os passos e papéis do raio (`none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `control`, `container`). `RebicShadow` SHALL ter `none` e os papéis de sombra (`card`, `popover`, `dialog`, `dragged`, `header`).

#### Scenario: Papéis do fundamento
- **WHEN** os valores de `RebicRadius` e os papéis de `RebicShadow` são comparados com os nomes dos tokens de raio e de sombra
- **THEN** cada valor tem um token de mesmo nome

### Requirement: [Aparência] Tokens de componente
`RebicContainer` SHALL obter o fundo de `colors.background`, `colors.base`, `colors.headerBackground` ou `colors.shell`, a borda de `colors.separator` com 1 px, o raio de `radius.<valor>`, a sombra de `shadows.boxShadows(shadows.<papel>, colors.shadow)` e o espaço de `spacing.<valor>`, todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `RebicContainer` com `surface` `base`, `border` e `shadow` `card` no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o fundo, a borda e a cor da sombra passam aos valores do escuro, sem recriar o widget com outros parâmetros

#### Scenario: Superfícies
- **WHEN** cada valor de `RebicSurface` é renderizado no tema claro
- **THEN** o fundo é transparente em `none` e, nos demais, a cor de mesmo papel em `colors`

#### Scenario: Raio e sombra
- **WHEN** cada valor de `RebicRadius` e cada papel de `RebicShadow` são renderizados no tema claro
- **THEN** o raio dos cantos é o token de mesmo nome, e as sombras são as do papel com a cor `shadow`

### Requirement: [Integração] Dependências
`RebicContainer` SHALL depender somente de `rebic/foundation/color`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/theming` e `rebic/widgets/rebic-spacing` (os valores de `RebicSpace`).

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicContainer` é renderizado com todas as superfícies
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Documentação] Exemplos mínimos
`RebicContainer` SHALL ter dartdoc em toda API pública e uma página "RebicContainer" na galeria com as superfícies, a borda, os raios, as sombras e um exemplo de cartão (`base`, borda, raio `container`, sombra `card` e `padding`).

#### Scenario: Página RebicContainer na galeria
- **WHEN** a página "RebicContainer" é aberta
- **THEN** ela exibe as cinco superfícies, os raios, os seis valores de sombra e o exemplo de cartão
