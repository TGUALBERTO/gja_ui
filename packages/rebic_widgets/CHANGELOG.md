# Changelog

## Não lançado

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
