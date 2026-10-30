# Spec Delta

## MODIFIED Requirements

### Requirement: [Integração] Dependências e uso
`RebicIconButton` SHALL depender somente de `rebic/core/interaction`, `rebic/widgets/rebic-tooltip`, `rebic/widgets/rebic-button` (`RebicButtonType`), `rebic/foundation/interaction-states`, `rebic/foundation/iconography`, `rebic/foundation/density`, `rebic/foundation/radius`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Botão de ícone sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um botão de ícone de cada tipo e um desabilitado são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

#### Scenario: Barra e página usam o botão de ícone
- **WHEN** um `RebicShellBar` com o botão de menu e uma `RebicPage` com `showNavButton` são renderizados, em pt-BR
- **THEN** o botão de menu e o de voltar são `RebicIconButton` com as dicas "Menu" e "Voltar"
