# Spec Delta

## REMOVED Requirements

### Requirement: [API] Propriedades
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `GjaToolPage` com `header` (um `GjaShellBar`), `sideContent` e `mainContents`; `navigationExpanded` passa a `sideExpanded`, `navigationExpandedOf` a `sideExpandedOf`, e o botão de navegação ao botão de menu do `GjaShellBar`, que chama `GjaToolPage.toggleSideContentMode`.

### Requirement: [API] Barra condicional
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `GjaToolPage` com `header` (um `GjaShellBar`), `sideContent` e `mainContents`; `navigationExpanded` passa a `sideExpanded`, `navigationExpandedOf` a `sideExpandedOf`, e o botão de navegação ao botão de menu do `GjaShellBar`, que chama `GjaToolPage.toggleSideContentMode`.

### Requirement: [API] Callbacks e controlador
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `GjaToolPage` com `header` (um `GjaShellBar`), `sideContent` e `mainContents`; `navigationExpanded` passa a `sideExpanded`, `navigationExpandedOf` a `sideExpandedOf`, e o botão de navegação ao botão de menu do `GjaShellBar`, que chama `GjaToolPage.toggleSideContentMode`.

### Requirement: [Comportamento] Estado automático por classe
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `GjaToolPage`, cujo estado automático é decidido na primeira exibição e mantido, como no `sap.tnt.ToolPage`.

### Requirement: [Comportamento] Navegação ao lado do corpo
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `GjaToolPage`, cujo estado automático é decidido na primeira exibição e mantido, como no `sap.tnt.ToolPage`.

### Requirement: [Comportamento] Navegação na tela small
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `GjaToolPage`, cujo estado automático é decidido na primeira exibição e mantido, como no `sap.tnt.ToolPage`.

### Requirement: [Aparência] Tokens de componente
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Aparência] Movimento da navegação
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Estados] Botão de navegação
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Acessibilidade] Teclado e foco
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Acessibilidade] Semântica e contraste
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Responsividade] Tela e direção
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Integração] Dependências de widgets e núcleo
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Integração] Dependências de fundamentos
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Testes] Cobertura exigida
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Documentação] Exemplos mínimos
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).

### Requirement: [Restrições] Fora do escopo
**Reason**: `GjaScaffold` dá lugar a `GjaToolPage` e `GjaShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `gja/widgets/gja-tool-page` (estrutura) e `gja/widgets/gja-shell-bar` (barra).
