# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências
`GjaPopover` SHALL depender somente de `gja/core/overlay`, `gja/core/interaction`, `gja/widgets/gja-container`, `gja/widgets/gja-title`, `gja/widgets/gja-divider`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/typography`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Popover sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um `GjaButton` abre um popover com ações, e uma ação o fecha
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
