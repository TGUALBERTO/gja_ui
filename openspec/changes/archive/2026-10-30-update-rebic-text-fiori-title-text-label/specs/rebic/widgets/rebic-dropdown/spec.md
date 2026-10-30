# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Itens da lista
Os itens SHALL usar as cores da família `list` de `rebic/foundation/interaction-states`, a altura mínima `density.controlHeight`, o espaço horizontal `spacing.m`, o espaço `spacing.s` entre ícone, rótulo e texto adicional, o rótulo em `typography.base` e o texto adicional em `typography.base` com `colors.label`, sem valores literais.

#### Scenario: Itens da lista
- **WHEN** um dropdown com ícones é aberto nos temas claro e escuro, nas duas densidades
- **THEN** cada item tem o fundo e o texto da família `list` no estado normal, a altura `density.controlHeight`, e o ícone começa a `spacing.m` da borda inicial
