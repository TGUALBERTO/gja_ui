## MODIFIED Requirements

### Requirement: [Aparência] Superfície e cabeçalho
O cartão SHALL usar a superfície `colors.base`, a borda `colors.separator`, o raio `radius.container` e a sombra `shadows.card`. O cabeçalho e o conteúdo com margem SHALL usar o espaço `spacing.l`, e o divisor SHALL ser o sutil de `rebic/widgets/rebic-divider`, sem valores literais.

#### Scenario: Superfície do cartão
- **WHEN** um cartão com cabeçalho é renderizado nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda `colors.separator`, o raio `radius.container`, e há a sombra `shadows.card` de cada tema

#### Scenario: Conteúdo sem margem
- **GIVEN** um cartão com cabeçalho e `padded` `false`
- **WHEN** ele é renderizado
- **THEN** o conteúdo ocupa toda a largura interna do cartão, começando logo abaixo do divisor

### Requirement: [Integração] Dependências
`RebicCard` SHALL depender somente de `rebic/widgets/rebic-container`, `rebic/widgets/rebic-text`, `rebic/widgets/rebic-divider`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/typography`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Cartões numa grade sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** três cartões são renderizados numa `RebicGrid`, um com cabeçalho acionável, e o cabeçalho é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
