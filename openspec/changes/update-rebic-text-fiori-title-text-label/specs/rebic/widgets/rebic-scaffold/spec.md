# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `RebicScaffold` SHALL depender somente de `rebic/widgets/rebic-app`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-divider`, `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-icon-button`, `rebic/widgets/rebic-title`, `rebic/core/responsive`, `rebic/core/interaction` e `rebic/core/localization`.

#### Scenario: Scaffold sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um scaffold com barra, navegação e corpo é a página inicial
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
