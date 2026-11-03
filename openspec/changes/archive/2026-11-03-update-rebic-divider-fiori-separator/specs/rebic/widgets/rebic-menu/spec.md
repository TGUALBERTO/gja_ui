# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Itens e seções
Os itens SHALL ter a aparência dos itens de `rebic/widgets/rebic-dropdown`: cores da família `list`, altura mínima `density.controlHeight`, espaço horizontal `spacing.m` e espaço `spacing.s` entre ícone, rótulo e atalho, este em `typography.base` com `colors.label`. O separador de seção SHALL ser o horizontal de `rebic/widgets/rebic-separator`, sem valores literais.

#### Scenario: Itens do menu
- **WHEN** um menu com ícones e uma seção é aberto nos temas claro e escuro, nas duas densidades
- **THEN** cada item tem o fundo e o texto da família `list` no estado normal, a altura `density.controlHeight`, e o separador de seção é um `RebicSeparator` horizontal

### Requirement: [Integração] Dependências
`RebicMenu` SHALL depender somente de `rebic/widgets/rebic-dropdown`, `rebic/widgets/rebic-popover`, `rebic/widgets/rebic-separator`, `rebic/widgets/rebic-icon`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/typography`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Menu sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um `RebicButton` abre um menu, e um item é acionado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
