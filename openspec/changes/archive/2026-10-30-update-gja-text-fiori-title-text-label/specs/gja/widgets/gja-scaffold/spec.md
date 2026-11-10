# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `GjaScaffold` SHALL depender somente de `gja/widgets/gja-app`, `gja/widgets/gja-container`, `gja/widgets/gja-divider`, `gja/widgets/gja-icon`, `gja/widgets/gja-icon-button`, `gja/widgets/gja-title`, `gja/core/responsive`, `gja/core/interaction` e `gja/core/localization`.

#### Scenario: Scaffold sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um scaffold com barra, navegação e corpo é a página inicial
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
