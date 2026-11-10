# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Títulos e botões
O título SHALL usar o estilo `header5` e o segundo título o estilo `small`, ambos com `colors.text`. Os botões SHALL ser `GjaButton` só com ícone, do tipo `transparent`, com os ícones `navBack`, `menu2`, `search`, `bell` e `grid` de `gja/foundation/iconography`. O perfil SHALL ser exibido no tamanho `xs` de `GjaAvatar`, como o `Avatar` do ShellBar.

#### Scenario: Ícones dos botões
- **WHEN** a barra completa é renderizada
- **THEN** voltar, menu, pesquisa, notificações e seletor de produtos são `GjaButton` só com ícone, do tipo `transparent` com os ícones `navBack`, `menu2`, `search`, `bell` e `grid`, e o segundo título tem o estilo `small`, e o perfil tem o tamanho `xs`

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `GjaShellBar` SHALL depender somente de `gja/widgets/gja-button`, `gja/widgets/gja-avatar`, `gja/widgets/gja-badge`, `gja/widgets/gja-tooltip`, `gja/widgets/gja-title`, `gja/widgets/gja-container`, `gja/core/interaction`, `gja/core/localization` e `gja/core/responsive`.

#### Scenario: Barra sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** a barra completa é renderizada e seus botões são tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
