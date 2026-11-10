## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaContainer` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `child` | `Widget?` | nulo |
| `surface` | `GjaSurface` | `none` |
| `border` | `bool` | `false` |
| `radius` | `GjaRadius` | `none` |
| `shadow` | `GjaShadow` | `none` |
| `padding` | `GjaSpace?` | nulo (sem espaço) |

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `GjaApp`
- **WHEN** `GjaContainer(child: GjaText('a'))` é criado
- **THEN** ele não pinta fundo, borda nem sombra, e o filho ocupa a mesma área que ocuparia sem o contêiner

### Requirement: [API] Valores dos papéis
`GjaSurface` SHALL ter `none`, `background`, `base`, `header` e `shell`. `GjaRadius` SHALL ter os passos e papéis do raio (`none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `control`, `container`). `GjaShadow` SHALL ter `none` e os papéis de sombra (`card`, `popover`, `dialog`, `dragged`, `header`).

#### Scenario: Papéis do fundamento
- **WHEN** os valores de `GjaRadius` e os papéis de `GjaShadow` são comparados com os nomes dos tokens de raio e de sombra
- **THEN** cada valor tem um token de mesmo nome

### Requirement: [Aparência] Tokens de componente
`GjaContainer` SHALL obter o fundo de `colors.background`, `colors.base`, `colors.headerBackground` ou `colors.shell`, a borda de `colors.separator` com 1 px, o raio de `radius.<valor>`, a sombra de `shadows.boxShadows(shadows.<papel>, colors.shadow)` e o espaço de `spacing.<valor>`, todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `GjaContainer` com `surface` `base`, `border` e `shadow` `card` no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o fundo, a borda e a cor da sombra passam aos valores do escuro, sem recriar o widget com outros parâmetros

#### Scenario: Superfícies
- **WHEN** cada valor de `GjaSurface` é renderizado no tema claro
- **THEN** o fundo é transparente em `none` e, nos demais, a cor de mesmo papel em `colors`

#### Scenario: Raio e sombra
- **WHEN** cada valor de `GjaRadius` e cada papel de `GjaShadow` são renderizados no tema claro
- **THEN** o raio dos cantos é o token de mesmo nome, e as sombras são as do papel com a cor `shadow`

### Requirement: [Integração] Dependências
`GjaContainer` SHALL depender somente de `gja/foundation/color`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/theming` e `gja/widgets/gja-spacing` (os valores de `GjaSpace`).

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaContainer` é renderizado com todas as superfícies
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Documentação] Exemplos mínimos
`GjaContainer` SHALL ter dartdoc em toda API pública e uma página "GjaContainer" na galeria com as superfícies, a borda, os raios, as sombras e um exemplo de cartão (`base`, borda, raio `container`, sombra `card` e `padding`).

#### Scenario: Página GjaContainer na galeria
- **WHEN** a página "GjaContainer" é aberta
- **THEN** ela exibe as cinco superfícies, os raios, os seis valores de sombra e o exemplo de cartão
