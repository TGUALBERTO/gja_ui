# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências
`RebicDropdown` SHALL depender somente de `rebic/widgets/rebic-popover`, `rebic/widgets/rebic-separator`, `rebic/widgets/rebic-icon`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/typography`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Dropdown sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um `RebicButton` abre um dropdown, e um item é escolhido
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
