# Changelog

## Não lançado

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
