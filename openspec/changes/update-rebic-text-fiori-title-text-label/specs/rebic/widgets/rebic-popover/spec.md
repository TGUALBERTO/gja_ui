# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências
`RebicPopover` SHALL depender somente de `rebic/core/overlay`, `rebic/core/interaction`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-title`, `rebic/widgets/rebic-divider`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/typography`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Popover sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um `RebicButton` abre um popover com ações, e uma ação o fecha
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
