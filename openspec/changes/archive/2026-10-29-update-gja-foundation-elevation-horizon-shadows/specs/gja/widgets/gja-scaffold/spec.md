## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
A barra SHALL usar o fundo `colors.shell` e a sombra `shadows.header`. A área de navegação SHALL usar o fundo `colors.base`, e o separador SHALL ser o de `gja/widgets/gja-divider` com tom sutil. Os espaços internos da barra SHALL vir de `spacing`, o botão MUST ter a família `transparent` de `gja/foundation/interaction-states` e o ícone `menu` de `gja/foundation/iconography`, sem valores literais.

#### Scenario: Cores da barra e da navegação
- **WHEN** o scaffold com barra e navegação é renderizado nos temas claro e escuro
- **THEN** o fundo da barra é `colors.shell`, o da navegação é `colors.base`, e a barra tem a sombra `shadows.header` de cada tema

### Requirement: [Integração] Dependências de fundamentos
Dos fundamentos, `GjaScaffold` SHALL depender somente de `gja/foundation/color`, `gja/foundation/shadows`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/iconography`, `gja/foundation/interaction-states`, `gja/foundation/design-tokens`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Barra pelo tema da subárvore
- **GIVEN** um scaffold numa subárvore com o tema escuro e densidade compacta, dentro de uma aplicação clara e confortável
- **WHEN** a barra é renderizada
- **THEN** o fundo da barra é o `colors.shell` escuro, e o botão de navegação mede a altura de controle compacta
