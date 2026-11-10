# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Superfície, cabeçalho e rodapé
O popover SHALL usar a superfície `colors.base`, sem borda, o raio `radius.popover` e a sombra `shadows.popover`. Cabeçalho e conteúdo com margem SHALL usar `spacing.l`, o rodapé SHALL usar `spacing.s` com ações separadas por `spacing.xs`, e os separadores SHALL ser os horizontais de `gja/widgets/gja-separator`, sem valores literais.

#### Scenario: Superfície do popover
- **WHEN** um popover com cabeçalho é aberto nos temas claro e escuro
- **THEN** o fundo é `colors.base`, não há borda, o raio é `radius.popover`, e há a sombra `shadows.popover` de cada tema

### Requirement: [Integração] Dependências
`GjaPopover` SHALL depender somente de `gja/core/overlay`, `gja/core/interaction`, `gja/widgets/gja-container`, `gja/widgets/gja-title`, `gja/widgets/gja-separator`, `gja/widgets/gja-spacing`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/typography`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Popover sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um `GjaButton` abre um popover com ações, e uma ação o fecha
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
