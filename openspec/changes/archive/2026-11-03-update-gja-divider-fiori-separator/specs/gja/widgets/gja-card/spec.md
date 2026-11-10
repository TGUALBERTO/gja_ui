# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências
`GjaCard` SHALL depender somente de `gja/widgets/gja-container`, `gja/widgets/gja-separator`, `gja/widgets/gja-card-header`, `gja/widgets/gja-title` (`GjaTitleLevel`), `gja/foundation/color`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Cartões numa grade sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** três cartões são renderizados numa `GjaGrid`, um com cabeçalho acionável, e o cabeçalho é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
