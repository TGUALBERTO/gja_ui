## MODIFIED Requirements

### Requirement: [Aparência] Superfície, cabeçalho e rodapé
O popover SHALL usar a superfície `colors.base`, sem borda, o raio `radius.popover` e a sombra `shadows.popover`. Cabeçalho e conteúdo com margem SHALL usar `spacing.l`, o rodapé SHALL usar `spacing.s` com ações separadas por `spacing.xs`, e os divisores SHALL ser os sutis de `gja/widgets/gja-divider`, sem valores literais.

#### Scenario: Superfície do popover
- **WHEN** um popover com cabeçalho é aberto nos temas claro e escuro
- **THEN** o fundo é `colors.base`, não há borda, o raio é `radius.popover`, e há a sombra `shadows.popover` de cada tema
