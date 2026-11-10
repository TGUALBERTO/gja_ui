# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Itens e seções
Os itens SHALL ter a aparência dos itens de `gja/widgets/gja-dropdown`: cores da família `list`, altura mínima `density.controlHeight`, espaço horizontal `spacing.m` e espaço `spacing.s` entre ícone, rótulo e atalho, este em `typography.base` com `colors.label`. O separador de seção SHALL ser o horizontal de `gja/widgets/gja-separator`, sem valores literais.

#### Scenario: Itens do menu
- **WHEN** um menu com ícones e uma seção é aberto nos temas claro e escuro, nas duas densidades
- **THEN** cada item tem o fundo e o texto da família `list` no estado normal, a altura `density.controlHeight`, e o separador de seção é um `GjaSeparator` horizontal

### Requirement: [Integração] Dependências
`GjaMenu` SHALL depender somente de `gja/widgets/gja-dropdown`, `gja/widgets/gja-popover`, `gja/widgets/gja-separator`, `gja/widgets/gja-icon`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/typography`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Menu sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um `GjaButton` abre um menu, e um item é acionado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
