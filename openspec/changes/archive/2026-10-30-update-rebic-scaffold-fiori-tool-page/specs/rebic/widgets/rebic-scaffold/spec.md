# Spec Delta

## REMOVED Requirements

### Requirement: [API] Propriedades
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `RebicToolPage` com `header` (um `RebicShellBar`), `sideContent` e `mainContents`; `navigationExpanded` passa a `sideExpanded`, `navigationExpandedOf` a `sideExpandedOf`, e o botão de navegação ao botão de menu do `RebicShellBar`, que chama `RebicToolPage.toggleSideContentMode`.

### Requirement: [API] Barra condicional
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `RebicToolPage` com `header` (um `RebicShellBar`), `sideContent` e `mainContents`; `navigationExpanded` passa a `sideExpanded`, `navigationExpandedOf` a `sideExpandedOf`, e o botão de navegação ao botão de menu do `RebicShellBar`, que chama `RebicToolPage.toggleSideContentMode`.

### Requirement: [API] Callbacks e controlador
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `RebicToolPage` com `header` (um `RebicShellBar`), `sideContent` e `mainContents`; `navigationExpanded` passa a `sideExpanded`, `navigationExpandedOf` a `sideExpandedOf`, e o botão de navegação ao botão de menu do `RebicShellBar`, que chama `RebicToolPage.toggleSideContentMode`.

### Requirement: [Comportamento] Estado automático por classe
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `RebicToolPage`, cujo estado automático é decidido na primeira exibição e mantido, como no `sap.tnt.ToolPage`.

### Requirement: [Comportamento] Navegação ao lado do corpo
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `RebicToolPage`, cujo estado automático é decidido na primeira exibição e mantido, como no `sap.tnt.ToolPage`.

### Requirement: [Comportamento] Navegação na tela small
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Use `RebicToolPage`, cujo estado automático é decidido na primeira exibição e mantido, como no `sap.tnt.ToolPage`.

### Requirement: [Aparência] Tokens de componente
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Aparência] Movimento da navegação
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Estados] Botão de navegação
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Acessibilidade] Teclado e foco
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Acessibilidade] Semântica e contraste
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Responsividade] Tela e direção
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Integração] Dependências de widgets e núcleo
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Integração] Dependências de fundamentos
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Testes] Cobertura exigida
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Documentação] Exemplos mínimos
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).

### Requirement: [Restrições] Fora do escopo
**Reason**: `RebicScaffold` dá lugar a `RebicToolPage` e `RebicShellBar`, como o `sap.tnt.ToolPage` e o `sap.f.ShellBar` do SAPUI5.
**Migration**: Os requisitos equivalentes estão em `rebic/widgets/rebic-tool-page` (estrutura) e `rebic/widgets/rebic-shell-bar` (barra).
