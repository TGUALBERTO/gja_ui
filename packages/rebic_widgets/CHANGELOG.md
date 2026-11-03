# Changelog

## Não lançado

- Novo `RebicSideNavigation<T>` (`add-rebic-side-navigation`, spec `rebic/widgets/rebic-side-navigation`), como o
  `sap.tnt.SideNavigation`: `items` e `fixedItems` (`RebicNavigationListItem`, com subitens), `selectedKey`,
  `onItemSelect`, `expanded` e `semanticLabel`.
- Novo `RebicIconTabBar<T>` (`add-rebic-icon-tab-bar`, spec `rebic/widgets/rebic-icon-tab-bar`), como o
  `sap.m.IconTabBar`: `items` (`RebicIconTabFilter`), `selectedKey`, `onSelect` e `applyContentPadding`.
- Novo `RebicBreadcrumbs` (`add-rebic-breadcrumbs`, spec `rebic/widgets/rebic-breadcrumbs`), como o
  `sap.m.Breadcrumbs`: `links`, `currentLocationText`, `separatorStyle` e `semanticLabel`.
- Novo `RebicToolbar` (`add-rebic-toolbar`, spec `rebic/widgets/rebic-toolbar`), como o `sap.m.Toolbar`: `content`
  (com `Spacer` e `RebicSeparator.vertical`), `design`, `style`, `onPress`, `enabled` e `semanticLabel`.
- Novo `RebicMessageToast` (`add-rebic-message-toast`, spec `rebic/widgets/rebic-message-toast`), como o
  `sap.m.MessageToast`: `RebicMessageToast.show(context, mensagem)`, que some sozinho depois de 3 segundos.
- Novo `RebicDialog` (`add-rebic-dialog`, spec `rebic/widgets/rebic-dialog`), como o `sap.m.Dialog`: `content`,
  `title`, `state`, `beginButton`, `endButton`, `buttons` e `width`, aberto por `RebicDialog.open` sobre o modal do núcleo.
- Novo `RebicIllustratedMessage` (`add-rebic-illustrated-message`, spec `rebic/widgets/rebic-illustrated-message`),
  como o `sap.m.IllustratedMessage`: `title`, `description`, `illustrationType`, `illustrationSize`, `illustration`,
  `titleLevel` e `additionalContent`.
- Novo `RebicBusyIndicator` (`add-rebic-busy-indicator`, spec `rebic/widgets/rebic-busy-indicator`), como o
  `sap.m.BusyIndicator` e o estado `busy` dos controles: pontos animados, `text` e, com `child`, o conteúdo bloqueado.
- Novo `RebicMessageStrip` (`add-rebic-message-strip`, spec `rebic/widgets/rebic-message-strip`), como o
  `sap.m.MessageStrip`: `text`, `type`, `showIcon`, `showCloseButton`, `onClose` e `link`.
- Novo `RebicSelect<T>` (`add-rebic-select`, spec `rebic/widgets/rebic-select`), como o `sap.m.Select`: controlado
  (`selectedKey` + `onChange`), com os itens de `RebicDropdownItem`, `placeholder`, `enabled`, `editable`,
  `valueState` e `valueStateText`.
- Novo `RebicInput` (`add-rebic-input`, spec `rebic/widgets/rebic-input`), como o `sap.m.Input`: controlado
  (`value` + `onLiveChange`), com `onChange`, `onSubmit`, `placeholder`, `type`, `enabled`, `editable`, `valueState`,
  `valueStateText`, `maxLength`, `showClearIcon` e `focusNode`.
- Novos `RebicRadioButton` e `RebicRadioButtonGroup` (`add-rebic-radio-button`), como o `sap.m.RadioButton` e o
  `sap.m.RadioButtonGroup`: opção controlada (`selected` + `onSelect`) e grupo com `selectedIndex`, `onSelect(índice)`,
  `columns`, setas e Tab pela opção marcada.
- Novo `RebicSwitch` (`add-rebic-switch`, spec `rebic/widgets/rebic-switch`), como o `sap.m.Switch`: controlado
  (`state` + `onChange`), com `semanticLabel` e `enabled`.
- Novo `RebicCheckBox` (`add-rebic-check-box`, spec `rebic/widgets/rebic-check-box`), como o `sap.m.CheckBox`:
  controlado (`selected` + `onSelect`), com texto ou `semanticLabel`, `partiallySelected`, `enabled`, `editable`,
  `valueState` e `wrapping`.
- **BREAKING** `enabled` e `onPress` nas ações (`update-rebic-actions-fiori-enabled-press`), como os eventos `press` do
  SAPUI5. De/para:
  - `RebicLink(onPressed: ...)` → `RebicLink(onPress: ...)`; `onPressed: null` → `enabled: false`;
  - `RebicMenuItem(label:, onPressed:, shortcut:)` → `RebicMenuItem(text:, onPress:, shortcutText:)`; novo `enabled`;
  - `RebicAvatar` e `RebicStatusIndicator`: `onPressed` → `onPress` (sem ele, continuam não interativos).
- **BREAKING** Botão no modelo do SAPUI5 (`update-rebic-button-fiori-button`, spec `rebic/widgets/rebic-button`, que
  absorve `rebic/widgets/rebic-icon-button`): um só `RebicButton`, como o `sap.m.Button`. De/para:
  - `RebicButton(label: ..., onPressed: ...)` → `RebicButton(text: ..., onPress: ...)`;
  - `onPressed: null` (desabilitado) → `enabled: false`; `onPress` nulo agora deixa o botão habilitado, sem ação;
  - `RebicIconButton(icon: ..., tooltip: ..., onPressed: ...)` → `RebicButton(icon: ..., tooltip: ..., onPress: ...)`;
    o tipo padrão passa de `transparent` a `standard`, então passe `type: RebicButtonType.transparent` numa barra;
  - novo `tooltip` também no botão com texto, anunciado como dica; `busy` também no botão só com ícone.

  `RebicPage` e `RebicShellBar` usam o novo botão, sem mudança visual. `RebicLink`, `RebicMenuItem`, `RebicAvatar` e
  `RebicStatusIndicator` ainda usam `onPressed`; mudam na próxima change.
- **BREAKING** Grade no modelo do SAPUI5 (`update-rebic-grid-fiori-layout-grid`, spec `rebic/widgets/rebic-grid`),
  como o `sap.ui.layout.Grid`. De/para:
  - `RebicGrid(children: ...)` e `RebicGrid.cells(cells: ...)` → `RebicGrid(content: ...)`;
  - `RebicGridCell(child: x, span: s)` → `RebicGridData(span: s, child: x)`, um widget que envolve o item em `content`;
  - `gap` → `hSpacing`; `runGap` → `vSpacing`;
  - `basis: RebicLayoutBasis.container` → `containerQuery: true`; o padrão passa a medir a classe pela tela
    (`containerQuery: false`), como no UI5;
  - `defaultSpan` padrão `XL3 L3 M6 S12`: na classe `large`, quatro itens por linha em vez de três.
- **BREAKING** HBox e VBox no modelo do SAPUI5 (`update-rebic-row-column-fiori-hbox-vbox`, specs
  `rebic/widgets/rebic-hbox` e `rebic/widgets/rebic-vbox`, que substituem `rebic/widgets/rebic-row` e
  `rebic/widgets/rebic-column`): `RebicRow` passa a `RebicHBox`, e `RebicColumn` a `RebicVBox`, como o `sap.m.HBox` e o
  `sap.m.VBox`. De/para:
  - `children` → `items`; `mainAlignment` → `justifyContent`; `crossAlignment` → `alignItems`; `shrinkWrap` →
    `displayInline`;
  - `RebicRow.wrap(...)` → `RebicHBox(wrap: RebicFlexWrap.wrap, alignItems: RebicFlexAlignItems.start, ...)`;
  - `RebicMainAlignment` → `RebicFlexJustifyContent`, com o novo `spaceAround`; `RebicCrossAlignment` →
    `RebicFlexAlignItems`, com o novo `baseline` (no `RebicVBox`, vale como `start`); novo `RebicFlexWrap`.

  Os padrões de `gap` e `alignItems` não mudam. Com `wrap`, `alignItems` `stretch` e `baseline` disparam uma asserção.
- **BREAKING** Separador no modelo do SAPUI5 (`update-rebic-divider-fiori-separator`, spec
  `rebic/widgets/rebic-separator`, que substitui `rebic/widgets/rebic-divider`): `RebicDivider` passa a
  `RebicSeparator`, como o `sap.m.ToolbarSeparator`. De/para:
  - `RebicDivider()` → `RebicSeparator()`; `RebicDivider.vertical()` → `RebicSeparator.vertical()`;
  - `tone` e `RebicDividerTone` saem: a linha usa sempre `colors.separator`;
  - `spacing`, `indent` e `endIndent` saem: o espaço vem do contêiner (`gap` de `RebicColumn`, `RebicSpacing`);
  - o vertical deixa de esticar e passa a ter a altura `density.separatorHeight` (32 cozy, 24 compacto), centrado.

  Card, dropdown, menu e popover passam a usar `RebicSeparator`, sem mudança visual.
- Asterisco de obrigatório do `RebicLabel` como no `sap.m.Label` (`update-rebic-label-fiori-required`): tamanho
  `large`, negrito, `spacing.xxs` antes e a nova cor `required` magenta. A altura do rótulo não muda.
- **BREAKING** Card e cabeçalho de cartão no modelo do SAPUI5 (`update-rebic-card-fiori-card-header`, specs
  `rebic/widgets/rebic-card` e `rebic/widgets/rebic-card-header`):
  - `RebicCard` passa à API do `sap.f.Card`: `header`, `headerPosition` (`RebicCardHeaderPosition.top`/`bottom`),
    `content` e `headingLevel` (padrão `h3`). O conteúdo não tem mais margem, como no UI5;
  - novo `RebicCardHeader`, como o `sap.f.cards.Header`: `title` (até 3 linhas, estilo H5), `subtitle` (até 2),
    `statusText`, `statusVisible`, `dataTimestamp`, ícone (`icon`, `iconImage`, `iconInitials`, `iconDisplayShape`,
    `iconSize`, `iconAlt`, `iconVisible`), `toolbar` e `onPress`. Acionável, o título continua anunciado como
    cabeçalho com o nível do cartão.

    | Antes | Agora |
    |---|---|
    | `RebicCard(title:, subtitle:, status:, leading:, onHeaderPressed:, child:)` | `RebicCard(header: RebicCardHeader(title:, subtitle:, statusText:, iconInitials:/icon:, onPress:), content: RebicSpacing.padding(all: RebicSpace.l, child: …))` |
    | `padded: false` | `content` sem `RebicSpacing.padding` |
- **BREAKING** Page e Bar no modelo do SAPUI5 (`update-rebic-page-fiori-page-bar`, specs `rebic/widgets/rebic-page`
  e `rebic/widgets/rebic-bar`):
  - `RebicPage` passa à API do `sap.m.Page`: `title`, `titleLevel`, `titleAlignment`, `showNavButton`,
    `navButtonTooltip`, `onNavButtonPress`, `headerContent`, `customHeader`, `showHeader`, `subHeader`,
    `showSubHeader`, `content`, `enableScrolling`, `backgroundDesign`, `contentPadding`, `footer`, `showFooter` e
    `floatingFooter`. O cabeçalho é uma `RebicBar` com o título no estilo H5, e o conteúdo não tem espaçamento por
    padrão, como no UI5;
  - novo `RebicBar`, como o `sap.m.Bar`: `contentLeft`, `contentMiddle`, `contentRight`, `design` (`RebicBarDesign`)
    e `titleAlignment` (`RebicTitleAlignment`), com a altura `density.barHeight`.

    | Antes | Agora |
    |---|---|
    | `onBack: f` | `showNavButton: true, onNavButtonPress: f` |
    | `actions: [...]` | `headerContent: [...]` |
    | `body: x` | `content: [x]` (com `contentPadding: RebicContentPadding.responsive` no lugar da margem) |
    | `padded: false` | `contentPadding: RebicContentPadding.none` (o padrão) |
    | `scrollable: false` | `enableScrolling: false` |
    | `footerActions: [...]` | `footer: RebicBar(contentRight: [...])` |
    | `subtitle` | removido (é do `sap.f.DynamicPage`) |
- **BREAKING** ToolPage e ShellBar no modelo do SAPUI5 (`update-rebic-scaffold-fiori-tool-page`, specs
  `rebic/widgets/rebic-tool-page` e `rebic/widgets/rebic-shell-bar`; `rebic/widgets/rebic-scaffold` retirada):
  - `RebicScaffold` sai e dá lugar a `RebicToolPage`, como o `sap.tnt.ToolPage`: `header`, `subHeader`,
    `sideContent`, `mainContents`, `sideExpanded` e `onSideExpandedChanged`, com `RebicToolPage.sideExpandedOf` e
    `RebicToolPage.toggleSideContentMode`. O estado automático é decidido na primeira exibição (recolhido só na
    classe `small`) e depois mantido. Na classe `small`, o conteúdo lateral cobre o principal e desliza para fora ao
    recolher. A página não desenha mais separador nem fundo para o conteúdo lateral;
  - novo `RebicShellBar`, como o `sap.f.ShellBar`: voltar, menu, ícone inicial, título e segundo título, pesquisa,
    notificações com contador, conteúdo adicional, perfil e seletor de produtos, cada um com o seu callback.

    | Antes | Agora |
    |---|---|
    | `RebicScaffold(title:, logo:, actions:, navigation:, body:)` | `RebicToolPage(header: RebicShellBar(title:, homeIcon:, additionalContent:, showMenuButton: true, onMenuButtonPressed: …), sideContent:, mainContents: [body])` |
    | `navigationExpanded` / `onNavigationExpandedChanged` | `sideExpanded` / `onSideExpandedChanged` |
    | `RebicScaffold.navigationExpandedOf` | `RebicToolPage.sideExpandedOf` |
    | botão de navegação embutido | botão de menu do `RebicShellBar`, ligado a `RebicToolPage.toggleSideContentMode` |
- **BREAKING** Título, texto e rótulo no modelo do SAPUI5 (`update-rebic-text-fiori-title-text-label`, specs
  `rebic/widgets/rebic-text`, `rebic/widgets/rebic-title` e `rebic/widgets/rebic-label`):
  - `RebicText` passa a ser o `sap.m.Text`: `text`, `maxLines`, `wrapping` (padrão `true`) e `textAlign`, sempre com
    `typography.base` e `colors.text`. Saem `variant` (`RebicTextVariant`), `tone` (`RebicTextTone`) e `heading`;
  - novo `RebicTitle`, como o `sap.m.Title`: `level` (semântica) e `titleStyle` (estilo), ambos `RebicTitleLevel`
    (`auto`, `h1`…`h6`), e `wrapping` (padrão `false`, uma linha com reticências);
  - novo `RebicLabel`, como o `sap.m.Label`: `design` (`RebicLabelDesign.standard`/`bold`), `required` (asterisco na
    cor `required`, anunciado como "Obrigatório"), `showColon` e `wrapping` (padrão `false`);
  - `RebicPopover` e `RebicScaffold` usam `RebicTitle`, `RebicTooltip` usa `RebicText` e `RebicStatusIndicator` usa
    `RebicLabel` com `showColon`. `RebicCard`, `RebicPage` e `RebicBadge` desenham o texto com os tokens do tema.
    Nenhum golden desses widgets mudou.

    | Antes | Agora |
    |---|---|
    | `variant: display` / `headline` / `title` / `subtitle` | `RebicTitle` com `titleStyle` `h1` / `h2` / `h3` / `h4` |
    | `variant: body` | `RebicText` |
    | `variant: bodyStrong` | `RebicLabel` com `design: bold`, quando é rótulo |
    | `variant: label` / `caption`, `tone: muted` | `RebicLabel` |
    | `tone: success` / `warning` / `error` / `information` | `RebicStatusIndicator` |
    | `heading: true` | `RebicTitle` (sempre cabeçalho; nível em `level`) |
- **BREAKING** Sobreposições no modelo do Popup do SAPUI5 (`update-rebic-core-overlay-fiori-popup`): a propriedade
  `side` (`RebicOverlaySide`, padrão `below`) passa a `placement` (`RebicPlacement`, padrão `bottom`) em
  `RebicPopover`, `RebicMenu`, `RebicDropdown` e `RebicTooltip`, como o `placement` do Popover. As posições padrão
  e a aparência não mudam. O popover acompanha a âncora quando ela muda de tamanho.
- Ícones no modelo do IconPool (`update-rebic-foundation-iconography-fiori-iconpool`):
  - os widgets usam os nomes novos de `RebicIcons`: `RebicScaffold` usa `menu2`, `RebicPage` usa `navBack` e o ícone
    padrão de `RebicAvatar` é `personPlaceholder`;
  - ícones de controle (botões, botões de ícone, barra do scaffold, dropdown, menu e o progresso circular padrão)
    passam de 20 a 16;
  - 48 goldens foram regerados.
- **BREAKING** Raios no modelo Fiori (`update-rebic-foundation-radius-fiori-roles`):
  - `RebicRadius` (de `RebicContainer`) troca `control` e `container` por `button`, `field`, `popover`, `element` e
    `tile`.
  - `RebicButton` e `RebicIconButton` passam a ter cantos de 8 (`button`), e `RebicCard` de 16 (`tile`).
  - `RebicPopover` usa `popover` (8, sem mudança visual), e o anel de foco de `RebicLink` usa `xs`.
  - Os goldens de botão, botão de ícone, cartão, contêiner, menu e popover foram regerados.
- Espaçamento no modelo Fiori (`update-rebic-foundation-spacing-fiori-margins`): `RebicPage` usa a margem de página
  da classe de tamanho da própria largura (16, 32, 32 e 48 de S a XL), como a `sap.f.DynamicPage`, no conteúdo, na
  área de título e no rodapé. Na densidade compacta, os widgets passam a ter o mesmo espaçamento da cozy, e os goldens
  compactos e os da página foram regerados.
- **BREAKING** Densidade no modelo Fiori (`update-rebic-foundation-density-fiori-cozy`): `RebicDensity.comfortable`
  passa a `RebicDensity.cozy`, também no parâmetro `density` de `RebicApp`. Botões e botões de ícone medem 36 no cozy
  e 26 no compacto, dentro de uma área de interação de 44 e 32. Os goldens `*_comfortable.png` passam a `*_cozy.png`
  e foram regerados, junto com os compactos que mudaram de medida.
- Movimento no modelo SAPUI5 (`update-rebic-foundation-design-tokens-fiori-motion`): as animações usam as curvas CSS
  do SAPUI5. O `animationMode` do tema também desliga a troca animada de `RebicTheme` e a transição de página de
  `RebicApp`, além do pedido do sistema. Os testes de golden de popover, menu e dropdown passam a capturar cada tema
  numa aplicação nova: antes, a troca animada de densidade deixava a sobreposição na posição de um quadro
  intermediário, e os goldens afetados foram regerados.
- **BREAKING** Sombras no modelo Horizon (`update-rebic-foundation-elevation-horizon-shadows`): `RebicElevation`
  passa a `RebicShadow`, e a propriedade `RebicContainer.elevation` passa a `shadow`, com os mesmos valores. O popover,
  o menu, o dropdown e a dica passam à sombra `shadow2`, com contorno de 1 px. Os goldens de dica, popover, menu,
  dropdown, cartão e contêiner foram regerados.
- Estados de interação no modelo Fiori (`update-rebic-foundation-interaction-states-fiori-alignment`): os botões
  `accept`, `reject` e `attention` de `RebicButton` ficam na própria cor em todos os estados. O hover usa um tom
  claro do estado, em vez do cinza neutro, e o pressionado usa o normal invertido, em vez do azul `highlight`. A API
  não muda, e os goldens existentes não mostram esses estados.
- Tipografia no modelo Fiori (`update-rebic-foundation-typography-fiori-sizes`): os widgets passam aos estilos novos
  de `RebicTypographyTokens`, sem mudar a própria API. `RebicText` mapeia cada variante para um estilo Fiori
  (`display` → `header1`, `headline` → `header2`, `title` → `header3`, `subtitle` → `header4`, `body` e `label` →
  `base`, `bodyStrong` → `baseSemibold`, `caption` → `small`); `RebicButton` usa `baseSemibold`; `RebicLink` usa
  `base` e, enfatizado, `baseBold`; `RebicStatusIndicator` usa `base`; `RebicBadge` usa `small`; as iniciais de
  `RebicAvatar` usam `small` e `header4`…`header1`. Títulos ficam em negrito, e os goldens com texto foram regerados.
- `RebicMenu` e `RebicMenuItem` (`add-rebic-menu`, spec `rebic/widgets/rebic-menu`): menu de ações ancorado no modelo
  do `sap.m.Menu`, com ícone, atalho exibido (`shortcut`), seções (`startsSection`), itens desabilitados
  (`onPressed: null`), navegação pelo teclado e papéis semânticos `menu` e `menuItem`. A lista do `RebicDropdown` passa
  para um widget interno compartilhado (`RebicOptionList`), sem mudar a API dele. O mínimo de
  `RebicPopoverWidth.anchor` passa de 4 para 6 passos `spacing.xxxl` (192 no compacto), para que ícone, rótulo e atalho
  caibam.
- `RebicDropdown` e `RebicDropdownItem` (`add-rebic-dropdown`, spec `rebic/widgets/rebic-dropdown`): lista de itens
  selecionáveis num popover ancorado, no modelo da lista do `sap.m.Select`, com ícone, rótulo em uma linha e texto
  adicional, item selecionado, itens desabilitados, cores da família `list`, navegação por setas, Home, End e
  primeira letra, e semântica de botão com estado de selecionado. Novo valor `RebicPopoverWidth.anchor` (largura da
  âncora, no mínimo 6 passos `spacing.xxxl`). Os testes do popover e do tooltip passam a renderizar de fato a
  densidade compacta (o `RebicApp` recebe `density`), e os goldens compactos foram regenerados.
- `RebicPopoverWidth` e `RebicPopover.width` (`update-rebic-popover-width`): a largura do popover deixa de seguir o
  conteúdo e passa a ser a do tema, igual entre popovers (`standard`, 8 passos `spacing.xxxl`; `wide`, 12 passos,
  para tabelas), ou a da âncora quando ela é mais larga, como a lista do `sap.m.Select`.
- `RebicPopover` e `RebicPopoverController` (`add-rebic-popover`, spec `rebic/widgets/rebic-popover`): painel
  ancorado no modelo do `sap.m.Popover`, sobre a sobreposição ancorada do núcleo, com superfície `base` sem borda,
  raio `container` e sombra `popover`; cabeçalho opcional com título; conteúdo rolável com ou sem margem; rodapé de
  ações alinhadas ao fim; largura entre 4 e 8 passos `spacing.xxxl`; controlador com `open`, `close`, `toggle` e
  `isOpen`; fechamento por toque fora ou Esc (`onDismiss`); foco preso e semântica de rota nomeada.
- `RebicCard` (`add-rebic-card`, spec `rebic/widgets/rebic-card`): cartão no modelo do `sap.f.Card`, com superfície
  `base`, borda `separator`, raio `container` e sombra `card`; cabeçalho opcional com `leading`, título (variante
  `subtitle`, anunciado como cabeçalho), subtítulo, status e divisor; conteúdo com ou sem margem (`padded`); e
  cabeçalho acionável (`onHeaderPressed`), com hover, teclado e semântica de botão "título, subtítulo".
- Galeria (`fix-rebic-gallery-dark-theme`): as 12 páginas dos fundamentos passam a seguir o tema e a densidade
  escolhidos no índice, em vez de tokens claros fixos. As comparações intencionais entre modos e densidades ficam em
  painéis `GalleryComparison`, e um teste abre todas as páginas no tema escuro.
- `RebicAvatar`, `RebicAvatarSize` e `RebicAvatarShape` (`add-rebic-avatar`, spec `rebic/widgets/rebic-avatar`):
  avatar no modelo do `sap.m.Avatar`, com imagem, iniciais (até 3) ou ícone, fallback quando a imagem falha, forma
  circular ou quadrada, cinco tamanhos (1× a 3,5× `icons.xLarge`, os 2/3/4/5/7 rem do UI5), fundo
  `selectionBackground` com `brand`, estado ativo (`onPressed`) e semântica de imagem ou botão.
- `RebicStatusIndicator` (`add-rebic-status-indicator`, spec `rebic/widgets/rebic-status-indicator`): situação de um
  registro no modelo do `sap.m.ObjectStatus`, com `title`, `icon` e `text` na cor de um estado de valor, forma
  invertida (`inverted`), estado ativo (`onPressed`, sublinhado no hover e semântica de botão), quebra de texto com o
  ícone na primeira linha e semântica "título: texto" num só nó.
- `RebicBadge` (`add-rebic-badge`, spec `rebic/widgets/rebic-badge`): contador no modelo do badge dos controles e do
  `count` do `IconTabFilter` do SAPUI5, com as cores de um estado de valor (padrão `error`), limite `max` (`999+`),
  ocultação abaixo de 1, avulso ou centrado no canto superior final de um `child` (sem mudar o tamanho dele nem
  receber toques), e semântica do número, no mesmo nó do elemento.
- `RebicLink` (`add-rebic-link`, spec `rebic/widgets/rebic-link`): link de ação no modelo do `sap.m.Link`, na cor
  `colors.link` (ou `colors.text`, com `subtle`), em negrito com `emphasized`, sublinhado no hover e no pressionado,
  numa linha com reticências ou com quebra (`wrapping`), desabilitado com `onPressed` nulo e anunciado como link.
- `RebicIconButton` (`add-rebic-icon-button`, spec `rebic/widgets/rebic-icon-button`): botão só com ícone, com dica
  obrigatória (rótulo do leitor de tela e `RebicTooltip`), tipos Fiori (padrão `transparent`), estados do núcleo e
  desabilitado. `RebicScaffold` e `RebicPage` passam a usá-lo nos botões de navegação e de voltar, que ganham dica
  visível; o botão interno anterior foi removido. No catálogo, `RebicProgressIndicator`, `RebicTooltip`,
  `RebicButton` e `RebicIconButton` passam a P0/Fase 1, como controles básicos da estrutura das páginas.
- `RebicTooltip`: novo `excludeFromSemantics`, para filhos que já anunciam a mensagem como rótulo; o toque longo
  deixa de expor uma ação sem rótulo na semântica.
- `RebicButton` e `RebicButtonType` (`add-rebic-button`, spec `rebic/widgets/rebic-button`): botão com rótulo, ícone
  opcional, seis tipos no modelo Fiori (`standard`, `emphasized`, `transparent`, `accept`, `reject`, `attention`) sobre
  as famílias de controle, estados do núcleo, desabilitado (`onPressed` nulo) e ocupado (`busy`, com indicador na cor
  do texto e o valor "Carregando" na semântica). A animação do `RebicProgressIndicator` passa a um widget interno
  compartilhado, sem mudança de comportamento.
- `RebicTooltip` (`add-rebic-tooltip`, spec `rebic/widgets/rebic-tooltip`): dica textual de um elemento, aberta pelo
  ponteiro (após `motion.long`), pelo foco do teclado ou por toque longo, e fechada pela saída do ponteiro (após
  `motion.short`), perda de foco, Esc ou toque fora; apontável, uma por vez, posicionada pela sobreposição ancorada
  do núcleo, e anunciada como a dica (`tooltip`) do próprio elemento.
- `RebicProgressIndicator` (`add-rebic-progress-indicator`, spec `rebic/widgets/rebic-progress-indicator`):
  indicador de progresso em barra (`linear`, espessura `spacing.xs`) ou círculo (`circular`, no tamanho de um
  ícone), determinado (`value` de 0 a 1, com transição `motion.short`) ou indeterminado (ciclo de 4 ×
  `motion.long`), com cor por `state`, semântica com o valor em porcentagem e desenho estático no movimento
  reduzido. Primeiro widget da categoria `exibicao-dados`.
- `RebicPage` (`add-rebic-page`, spec `rebic/widgets/rebic-page`): página no modelo do `sap.m.Page`, com área de
  título (`onBack`, `title`, `subtitle`, `actions`) na superfície `base`, conteúdo com a margem `pageMargin`
  (`padded`) que rola entre o título e o rodapé ou recebe a altura disponível (`scrollable: false`), e rodapé fixo
  de ações (`footerActions`). O botão de navegação do `RebicScaffold` passa a usar um botão interno compartilhado,
  sem mudança de comportamento.
- `RebicScaffold` (`add-rebic-scaffold`, spec `rebic/widgets/rebic-scaffold`): estrutura da aplicação no modelo do
  `ToolPage`, com barra superior (`logo`, `title`, `actions` e botão de navegação, na superfície `shell` com sombra
  `header`), navegação lateral expandida ou recolhida ao lado do corpo e, no `small`, sobre o corpo, com estado
  controlado (`navigationExpanded`/`onNavigationExpandedChanged`) ou automático pela classe da tela, e
  `RebicScaffold.navigationExpandedOf`.
- `RebicGrid` (`add-rebic-grid`, spec `rebic/widgets/rebic-grid`): grade de 12 colunas com `defaultSpan` por classe
  de tamanho (padrão `S12 M6 L4 XL3`, com herança), span por item via `RebicGridCell` em `RebicGrid.cells`, fluxo em
  linhas, `gap`/`runGap` por `RebicSpace`, base contêiner ou tela e RTL.
- `RebicResponsiveLayout` (`add-rebic-responsive-layout`, spec `rebic/widgets/rebic-responsive-layout`): um
  construtor por classe de tamanho (`small` obrigatório, demais com herança da classe menor), medido pelo contêiner
  ou pela tela (`RebicLayoutBasis`), com os limiares do tema. Versão básica; colunas flexíveis na Fase 4.
- `RebicDivider` (`add-rebic-divider`, spec `rebic/widgets/rebic-divider`): linha fina horizontal ou vertical
  (`RebicDivider.vertical`), com `tone` (`subtle`/`strong`), `spacing` e recuo direcional (`indent`/`endIndent`) por
  `RebicSpace`; fora da semântica.
- `RebicRow` e `RebicColumn` (`add-rebic-row-column`, specs `rebic/widgets/rebic-row` e `rebic/widgets/rebic-column`):
  `gap` (`RebicSpace`, só entre filhos), `RebicMainAlignment`, `RebicCrossAlignment` e `shrinkWrap`, sobre o
  `spacing` nativo do `Flex`; `RebicRow.wrap` quebra em linhas e rejeita filhos expansíveis.
- `RebicContainer` (`add-rebic-container`, spec `rebic/widgets/rebic-container`): superfície com `surface`
  (`RebicSurface`), `border` (`separator`), `radius` (`RebicRadius`, com recorte do conteúdo), `elevation`
  (`RebicElevation`, papéis de sombra) e `padding` (`RebicSpace`), todos do tema ativo. O suporte de goldens dos
  testes passa a aceitar a superfície de fundo.
- `RebicSpacing` (`add-rebic-spacing`, spec `rebic/widgets/rebic-spacing`): espaço nomeado por `RebicSpace` (passos e
  papéis de layout do tema), com `RebicSpacing.horizontal`, `.vertical`, `.padding` (precedência por lado e
  início/fim pela direção do texto) e `RebicSpacing.resolve`; os valores seguem a densidade ativa.
- `RebicIcon` (`add-rebic-icon`, spec `rebic/widgets/rebic-icon`): ícone com `size` (papéis de `RebicIconTokens`),
  `tone` (texto, rótulo, marca ou estado de valor) e `semanticLabel` (sem ele, decorativo); direcionais espelhados em
  RTL e `inline` acompanhando a escala de texto. Os testes passam a carregar também a Lucide.
- `RebicText` (`add-rebic-text`, spec `rebic/widgets/rebic-text`): texto com `variant` (escala tipográfica), `tone`
  (texto, rótulo ou estado de valor), `maxLines` com reticências, `textAlign` e semântica de cabeçalho nas variantes
  de título.
- Infraestrutura de goldens: fonte Inter nos testes, etiqueta `golden` e referência gerada no Windows (ADR 0008).
- `RebicApp` (`add-rebic-app`, spec `rebic/widgets/rebic-app`): raiz da aplicação sobre `WidgetsApp`, sem Material,
  com navegação por rotas ou `RebicApp.router`, `theme`/`darkTheme` e `RebicThemeMode` (segue o brilho do sistema),
  densidade recomendada pela plataforma, localização do Rebic, escopo de tela, fundo `background` e transição de
  página deslizando do lado final (imediata com movimento reduzido).
- `RebicTheme` (`add-rebic-theme`, spec `rebic/widgets/rebic-theme`), primeiro widget público: aplica o tema à
  subárvore com troca animada, `RebicTheme.density` troca a densidade de uma subárvore, e o texto e o ícone padrão
  seguem o tema.

## 0.0.1

- Estrutura inicial do pacote (Fase 0). Sem API pública.
