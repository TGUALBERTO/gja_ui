# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Callbacks e controlador
`RebicIcon` SHALL NOT ter callbacks nem controlador: é um widget de exibição. Ícones clicáveis são o `RebicButton` só com ícone.

#### Scenario: Sem ação
- **GIVEN** `RebicIcon` com `semanticLabel`
- **WHEN** o ícone é tocado
- **THEN** nada é executado, e a semântica não informa ação de toque
