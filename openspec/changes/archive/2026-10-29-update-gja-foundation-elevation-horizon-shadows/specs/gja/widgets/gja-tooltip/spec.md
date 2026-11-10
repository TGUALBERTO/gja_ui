## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
A dica SHALL usar a superfície `colors.base` com a borda `colors.separator`, o raio `radius.s`, a sombra `shadows.popover`, os espaços internos `spacing.s` (horizontal) e `spacing.xs` (vertical) e o texto na variante `label` de `gja/widgets/gja-text`. A largura máxima SHALL ser derivada de `spacing.xxxl`, e mensagens mais longas MUST quebrar em linhas.

#### Scenario: Aparência da dica
- **WHEN** a dica aberta é renderizada nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda é `colors.separator`, há a sombra `shadows.popover`, e o texto está na variante `label`

### Requirement: [Integração] Dependências
`GjaTooltip` SHALL depender somente de `gja/core/overlay`, `gja/widgets/gja-text`, `gja/widgets/gja-container`, `gja/foundation/color`, `gja/foundation/shadows`, `gja/foundation/radius`, `gja/foundation/spacing`, `gja/foundation/design-tokens`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Tooltip sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** uma dica é aberta e fechada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
