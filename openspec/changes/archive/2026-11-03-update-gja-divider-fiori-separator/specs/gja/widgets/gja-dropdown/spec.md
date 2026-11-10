# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências
`GjaDropdown` SHALL depender somente de `gja/widgets/gja-popover`, `gja/widgets/gja-separator`, `gja/widgets/gja-icon`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/typography`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Dropdown sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um `GjaButton` abre um dropdown, e um item é escolhido
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
