# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências
`RebicCard` SHALL depender somente de `rebic/widgets/rebic-container`, `rebic/widgets/rebic-separator`, `rebic/widgets/rebic-card-header`, `rebic/widgets/rebic-title` (`RebicTitleLevel`), `rebic/foundation/color`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Cartões numa grade sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** três cartões são renderizados numa `RebicGrid`, um com cabeçalho acionável, e o cabeçalho é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
