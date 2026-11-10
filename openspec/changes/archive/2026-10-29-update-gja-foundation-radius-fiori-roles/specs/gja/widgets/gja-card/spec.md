## MODIFIED Requirements

### Requirement: [Aparência] Superfície e cabeçalho
O cartão SHALL usar a superfície `colors.base`, a borda `colors.separator`, o raio `radius.tile` e a sombra `shadows.card`. O cabeçalho e o conteúdo com margem SHALL usar o espaço `spacing.l`, e o divisor SHALL ser o sutil de `gja/widgets/gja-divider`, sem valores literais.

#### Scenario: Superfície do cartão
- **WHEN** um cartão com cabeçalho é renderizado nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda `colors.separator`, o raio `radius.tile`, e há a sombra `shadows.card` de cada tema

#### Scenario: Conteúdo sem margem
- **GIVEN** um cartão com cabeçalho e `padded` `false`
- **WHEN** ele é renderizado
- **THEN** o conteúdo ocupa toda a largura interna do cartão, começando logo abaixo do divisor
