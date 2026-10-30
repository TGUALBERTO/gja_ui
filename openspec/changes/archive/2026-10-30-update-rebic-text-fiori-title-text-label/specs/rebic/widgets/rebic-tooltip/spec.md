# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
A dica SHALL usar a superfície `colors.base` com a borda `colors.separator`, o raio `radius.s`, a sombra `shadows.popover`, os espaços internos `spacing.s` (horizontal) e `spacing.xs` (vertical) e o texto em `RebicText`, de `rebic/widgets/rebic-text`. A largura máxima SHALL ser derivada de `spacing.xxxl`, e mensagens mais longas MUST quebrar em linhas.

#### Scenario: Aparência da dica
- **WHEN** a dica aberta é renderizada nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda é `colors.separator`, há a sombra `shadows.popover`, e o texto tem o estilo `base` e a cor `text`
