# Proposal: ToolPage e ShellBar no modelo do SAPUI5 (`update-rebic-scaffold-fiori-tool-page`)

## Why

O `RebicScaffold` junta dois controles do SAPUI5: o `sap.tnt.ToolPage` (estrutura com cabeçalho, conteúdo lateral e
conteúdo principal) e a barra do `sap.f.ShellBar`, que no scaffold é fixa e só tem logo, título, ações e o botão de
navegação. O nome vem do Material, que o projeto evita, e o comportamento diverge do UI5:
- o ToolPage não desenha a barra: recebe um `header` (em geral um `ShellBar`) e um `subHeader`;
- o estado `sideExpanded` é decidido pela faixa da tela só na primeira exibição e depois mantido; o scaffold volta ao
  padrão a cada troca de classe;
- abaixo de 600 o conteúdo lateral cobre toda a largura e, recolhido, sai da tela; nas demais faixas ele fica ao lado,
  com a largura que ele mesmo define, sem separador do ToolPage;
- o `ShellBar` tem botão de voltar, botão de menu, ícone inicial, título e segundo título, pesquisa, notificações com
  contador, conteúdo adicional, perfil (`Avatar`) e o seletor de produtos, cada um com o seu evento.

É o segundo passo do bloco de layout do realinhamento ao SAPUI5.

## What Changes

- **BREAKING** `RebicScaffold` sai e dá lugar a `RebicToolPage`, como o `sap.tnt.ToolPage`:
  - `header` e `subHeader` (`Widget?`), `sideContent` (`Widget?`) e `mainContents` (`List<Widget>`);
  - `sideExpanded` (`bool?`; nulo é automático) e `onSideExpandedChanged`;
  - `RebicToolPage.sideExpandedOf(context)` e `RebicToolPage.toggleSideContentMode(context)`, como o
    `toggleSideContentMode` do UI5.

  Sem `sideExpanded`, o conteúdo lateral começa expandido, exceto na classe `small`, e o estado é mantido nas trocas
  de classe. Na classe `small`, o conteúdo lateral expandido cobre a largura e desliza para fora ao recolher. Nas
  demais, fica ao lado do conteúdo principal, sem separador nem fundo próprios.
- Novo `RebicShellBar`, como o `sap.f.ShellBar`:
  - `title`, `secondTitle`, `homeIcon` e `homeIconTooltip`;
  - `showNavButton`, `showMenuButton`, `showSearch`, `showNotifications`, `notificationsNumber` e
    `showProductSwitcher`;
  - `profile` (`RebicAvatar`) e `additionalContent`;
  - `onHomeIconPressed`, `onNavButtonPressed`, `onMenuButtonPressed`, `onSearchButtonPressed`,
    `onNotificationsPressed`, `onProductSwitcherPressed` e `onAvatarPressed`.

  A ordem é a do UI5: voltar, menu, ícone inicial, título e segundo título no início; pesquisa, notificações e
  conteúdo adicional, seguidos do perfil e do seletor de produtos, no fim. A margem horizontal segue a faixa da
  barra (16, 32 e 48), como os paddings Phone, Tablet e Desktop do ShellBar.
- Núcleo: novos textos `menu`, `logo`, `notifications`, `profile`, `products` e `shellBar`, como os tooltips do
  ShellBar.
- `RebicPage` passa a citar o `RebicToolPage` como hospedeiro, e o cenário de `RebicIconButton` que usava o scaffold
  passa ao `RebicShellBar`.
- A galeria troca a página "RebicScaffold" por "RebicToolPage" e "RebicShellBar".

Fora do escopo, cada um com controle próprio no UI5:
- o `sap.m.OverflowToolbar` do ShellBar, que move ações para um menu "mais" em telas estreitas;
- o `MegaMenu` do título (`menu`), o `searchManager` e o Joule (`showCopilot`);
- o `contentBackgroundDesign` do ToolPage, que entra com o `PageBackgroundDesign` da change da página;
- o `sap.tnt.SideNavigation` e o recolhimento automático na classe `small` quando um item é escolhido.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-tool-page`: `RebicToolPage`, o `sap.tnt.ToolPage` do Rebic.
- `rebic/widgets/rebic-shell-bar`: `RebicShellBar`, o `sap.f.ShellBar` do Rebic.

### Modified Capabilities

- `rebic/widgets/rebic-scaffold`: retirada (`retire_capabilities`). Todos os requisitos passam a `rebic-tool-page` e
  `rebic-shell-bar`.
- `rebic/core/localization`: textos do ShellBar.
- `rebic/widgets/rebic-page`: hospedeiro `rebic/widgets/rebic-tool-page`.
- `rebic/widgets/rebic-icon-button`: cenário de uso pelo ShellBar e pela página.

O ToolPage e o ShellBar formam uma unidade inseparável, como pede `rebic/spec-governance`: o scaffold atual desenha a
própria barra, e retirá-lo sem o ShellBar deixaria as aplicações sem barra. O ShellBar sozinho duplicaria a barra
que o scaffold ainda desenha. As specs de página e de botão de ícone mudam só por citarem o scaffold.

## Impact

- `packages/rebic_foundation`: ícone `grid` em `RebicIcons` (Lucide `grip`), para o seletor de produtos.
- `packages/rebic_core`: textos novos em `RebicLocalizations` (pt-BR e en), testes e CHANGELOG.
- `packages/rebic_widgets`:
  - `fundacao_layout/scaffold/` sai; entram `fundacao_layout/tool_page/` e `fundacao_layout/shell_bar/`, com
    exportações;
  - testes e goldens do ToolPage e do ShellBar; os testes de página e de botão de ícone que montavam o scaffold;
  - CHANGELOG com o de/para.
- `apps/rebic_gallery`: páginas "RebicToolPage" e "RebicShellBar", e a página de `RebicPage`, que usava o scaffold.
- `docs/catalog.yaml`: sai `rebic/widgets/rebic-scaffold`; entram `rebic/widgets/rebic-tool-page` (P0, fase 1) e
  `rebic/widgets/rebic-shell-bar` (P1, fase 2, por depender de `RebicAvatar` e `RebicBadge`).
- `docs/adr/0009-provisional-horizon-values.md`: cores dos botões da barra e altura da barra.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
