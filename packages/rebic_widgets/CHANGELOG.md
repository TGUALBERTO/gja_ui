# Changelog

## Não lançado

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
