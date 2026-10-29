## MODIFIED Requirements

### Requirement: [Aparência] Superfície, cabeçalho e rodapé
O popover SHALL usar a superfície `colors.base`, sem borda, o raio `radius.container` e a sombra `shadows.popover`. Cabeçalho e conteúdo com margem SHALL usar `spacing.l`, o rodapé SHALL usar `spacing.s` com ações separadas por `spacing.xs`, e os divisores SHALL ser os sutis de `rebic/widgets/rebic-divider`, sem valores literais.

#### Scenario: Superfície do popover
- **WHEN** um popover com cabeçalho é aberto nos temas claro e escuro
- **THEN** o fundo é `colors.base`, não há borda, o raio é `radius.container`, e há a sombra `shadows.popover` de cada tema

### Requirement: [Integração] Dependências
`RebicPopover` SHALL depender somente de `rebic/core/overlay`, `rebic/core/interaction`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-text`, `rebic/widgets/rebic-divider`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/typography`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Popover sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um `RebicButton` abre um popover com ações, e uma ação o fecha
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
