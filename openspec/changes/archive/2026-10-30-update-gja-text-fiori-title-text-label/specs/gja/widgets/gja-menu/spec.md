# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Itens e seções
Os itens SHALL ter a aparência dos itens de `gja/widgets/gja-dropdown`: cores da família `list`, altura mínima `density.controlHeight`, espaço horizontal `spacing.m` e espaço `spacing.s` entre ícone, rótulo e atalho, este em `typography.base` com `colors.label`. O divisor de seção SHALL ser o sutil de `gja/widgets/gja-divider`, sem valores literais.

#### Scenario: Itens do menu
- **WHEN** um menu com ícones e uma seção é aberto nos temas claro e escuro, nas duas densidades
- **THEN** cada item tem o fundo e o texto da família `list` no estado normal, a altura `density.controlHeight`, e o divisor de seção é um `GjaDivider` sutil
