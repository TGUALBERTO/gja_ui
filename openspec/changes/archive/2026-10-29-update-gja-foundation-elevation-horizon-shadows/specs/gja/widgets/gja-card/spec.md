## MODIFIED Requirements

### Requirement: [Aparência] Superfície e cabeçalho
O cartão SHALL usar a superfície `colors.base`, a borda `colors.separator`, o raio `radius.container` e a sombra `shadows.card`. O cabeçalho e o conteúdo com margem SHALL usar o espaço `spacing.l`, e o divisor SHALL ser o sutil de `gja/widgets/gja-divider`, sem valores literais.

#### Scenario: Superfície do cartão
- **WHEN** um cartão com cabeçalho é renderizado nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda `colors.separator`, o raio `radius.container`, e há a sombra `shadows.card` de cada tema

#### Scenario: Conteúdo sem margem
- **GIVEN** um cartão com cabeçalho e `padded` `false`
- **WHEN** ele é renderizado
- **THEN** o conteúdo ocupa toda a largura interna do cartão, começando logo abaixo do divisor

### Requirement: [Integração] Dependências
`GjaCard` SHALL depender somente de `gja/widgets/gja-container`, `gja/widgets/gja-text`, `gja/widgets/gja-divider`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/typography`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Cartões numa grade sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** três cartões são renderizados numa `GjaGrid`, um com cabeçalho acionável, e o cabeçalho é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
