# Spec Delta

## MODIFIED Requirements

### Requirement: [Aparência] Títulos e botões
O título SHALL usar o estilo `header5` e o segundo título o estilo `small`, ambos com `colors.text`. Os botões SHALL ser `RebicButton` só com ícone, do tipo `transparent`, com os ícones `navBack`, `menu2`, `search`, `bell` e `grid` de `rebic/foundation/iconography`. O perfil SHALL ser exibido no tamanho `xs` de `RebicAvatar`, como o `Avatar` do ShellBar.

#### Scenario: Ícones dos botões
- **WHEN** a barra completa é renderizada
- **THEN** voltar, menu, pesquisa, notificações e seletor de produtos são `RebicButton` só com ícone, do tipo `transparent` com os ícones `navBack`, `menu2`, `search`, `bell` e `grid`, e o segundo título tem o estilo `small`, e o perfil tem o tamanho `xs`

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `RebicShellBar` SHALL depender somente de `rebic/widgets/rebic-button`, `rebic/widgets/rebic-avatar`, `rebic/widgets/rebic-badge`, `rebic/widgets/rebic-tooltip`, `rebic/widgets/rebic-title`, `rebic/widgets/rebic-container`, `rebic/core/interaction`, `rebic/core/localization` e `rebic/core/responsive`.

#### Scenario: Barra sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** a barra completa é renderizada e seus botões são tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
