## MODIFIED Requirements

### Requirement: [Comportamento] Margem do conteúdo
Com `padded` `true`, o conteúdo SHALL ter nos quatro lados a margem de página da classe de tamanho da largura da própria página (`spacing.pageMarginFor`), como o padding responsivo da `sap.f.DynamicPage`. Com `padded` `false`, MUST NOT haver margem.

#### Scenario: Conteúdo sem margem
- **GIVEN** uma página com `padded` `false`
- **WHEN** a página é renderizada
- **THEN** o conteúdo começa na borda inicial da página, logo abaixo da área de título

#### Scenario: Margem pela largura da página
- **WHEN** páginas com `padded` `true` são renderizadas com larguras de 400, 800, 1200 e 1600
- **THEN** o conteúdo começa a 16, 32, 32 e 48 da borda inicial, respectivamente

### Requirement: [Aparência] Tokens de componente
A área de título e o rodapé SHALL usar o fundo `colors.base` e ser separados do conteúdo por divisores sutis de `gja/widgets/gja-divider`. O conteúdo SHALL NOT pintar fundo próprio. O título SHALL usar a variante `headline` e o subtítulo a variante `body` com o tom `muted` de `gja/widgets/gja-text`. Os espaços SHALL vir de `spacing`, sem valores literais.

#### Scenario: Cores da página
- **WHEN** a página com rodapé é renderizada nos temas claro e escuro
- **THEN** a área de título e o rodapé têm o fundo `colors.base` de cada tema, e o conteúdo não pinta fundo

#### Scenario: Margem da densidade compacta
- **GIVEN** uma página numa subárvore compacta
- **WHEN** a página é renderizada
- **THEN** o conteúdo começa à margem de página do espaçamento compacto para a classe de tamanho da página, igual à da densidade cozy

### Requirement: [Integração] Dependências de núcleo e fundamentos
Do núcleo e dos fundamentos, `GjaPage` SHALL depender somente de `gja/core/interaction`, `gja/core/localization`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/breakpoints`, `gja/foundation/iconography`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Página pelo tema da subárvore
- **GIVEN** uma página numa subárvore com o tema escuro, dentro de uma aplicação clara
- **WHEN** a página é renderizada
- **THEN** a área de título tem o fundo `colors.base` do tema escuro
