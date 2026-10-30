# Design: ToolPage e ShellBar no modelo do SAPUI5

## Context

`RebicScaffold` (em `fundacao_layout/scaffold/rebic_scaffold.dart`, cerca de 235 linhas):
- é um `StatefulWidget` com o estado automático da navegação, que volta ao padrão da classe a cada troca;
- desenha a própria barra (`RebicContainer` shell com o botão `menu2`, o logo, um `RebicTitle` H3 e as ações);
- desenha a navegação ao lado (`AnimatedSize` mais um `RebicDivider.vertical`) ou sobre o corpo na classe `small`;
- usa uma `Column` com `verticalDirection.up` para pintar a barra sobre a área, com a sombra visível.

Referências ao scaffold fora dele:
- a mensagem do `assert` de altura da `RebicPage`;
- os testes de página e de botão de ícone;
- as páginas da galeria "RebicScaffold" e "RebicPage".

No OpenUI5 (código conferido em `sap.tnt/ToolPage.js`, `ToolPageRenderer.js`, `themes/base/ToolPage.less`,
`sap.f/ShellBar.js`, `ShellBarRenderer.js` e `themes/base/ShellBar.less`):
- **Estado inicial:** o ToolPage define `sideExpanded` como `!isLayoutS()` só enquanto a propriedade é inicial. A
  própria atribuição a torna não inicial, então o estado se mantém depois.
- **Faixa S (< 600):** o `aside` é absoluto, com 100% de largura; recolhido, sai com `translateX(-100%)` em 0,3 s.
- **Faixa M (≥ 600):** o `aside` fica no fluxo, sem largura, borda ou fundo próprios.
- **Fundo:** o do ToolPage é `sapBackgroundColor`.
- **`mainContents`:** os itens são renderizados em sequência num invólucro de altura 100%.
- **Barra:** o ShellBar mede 3rem e tem padding de 1, 2 e 3rem (Phone, Tablet e Desktop, pela largura da própria
  barra).
- **Títulos:** o título usa `sapMFontMediumSize` em negrito e o segundo título `sapFontSmallSize`, ambos em
  `sapShell_TextColor`.
- **Ordem e semântica:** a ordem é a de `_assignControls`. O título é um `heading` de nível 1 e a barra tem o rótulo
  `SHELLBAR_CONTAINER_LABEL`.

## Goals / Non-Goals

**Goals:**
- API e comportamento do ToolPage e do ShellBar com os nomes do UI5.
- A página de ferramentas não sabe nada da barra: a ligação entre o botão de menu e o conteúdo lateral fica na
  aplicação, como no UI5.

**Non-Goals:**
- Um `RebicSideNavigation` provisório. A galeria usa uma navegação de demonstração.
- O `OverflowToolbar`, que é um controle próprio com change própria.

## Decisions

### D1. Arquivos e nomes

- Sai `fundacao_layout/scaffold/`.
- Entram `fundacao_layout/tool_page/rebic_tool_page.dart` e `fundacao_layout/shell_bar/rebic_shell_bar.dart`, com
  testes espelhados e exportações no barrel.
- Sem alias de `RebicScaffold`: a API é 0.x.

O ShellBar fica em `fundacao_layout`, ao lado do ToolPage, e não em `acoes_navegacao`, porque é estrutura da
aplicação (`sap.f`).

### D2. Estado do conteúdo lateral

O `State` guarda `bool? _automatic`. No primeiro `build`, ele recebe `sizeClass != small`, com a classe da tela por
`RebicResponsive.screenSizeClassOf`, e depois só muda pela alternância. Com `widget.sideExpanded` não nulo, o valor
em vigor é o do widget.

Um `InheritedWidget` privado expõe:
- `expanded`;
- `toggle`, que chama `onSideExpandedChanged` e, sem controle, muda `_automatic`.

`sideExpandedOf` lê o escopo com dependência. `toggleSideContentMode` lê sem dependência
(`getInheritedWidgetOfExactType`) e não faz nada fora do escopo.

Alternativa considerada: um `RebicToolPageController`. Rejeitada porque o UI5 expõe só `sideExpanded` e
`toggleSideContentMode`, e o padrão controlado do Rebic já cobre o caso.

### D3. Layout

A estrutura é uma `Column(verticalDirection: up)`, como no scaffold, para pintar o cabeçalho sobre o conteúdo:
`[Expanded(área), subHeader?, header?]`.

A área depende da classe:
- **Fora de `small`:** `Row([sideContent, Expanded(principal)])`. O conteúdo lateral recebe largura livre e se
  dimensiona pelo `sideExpandedOf`, como a `SideNavigation` no UI5. O ToolPage não anima a largura.
- **Em `small`:** um `Stack` com o principal e, por cima, o lateral com a largura toda. O lateral fica num
  `AnimatedSlide`, com o deslocamento `-1` (ou `+1` em RTL), a duração `motion.long` (300 ms, a mesma do UI5) e a
  curva `standard`. Com `motion` em modo `none`, a duração é zero.

Exclusões na classe `small`:
- **Lateral expandido, ao fim da animação:** o principal recebe `ExcludeSemantics` e `ExcludeFocus` e continua
  montado, o que preserva o estado.
- **Lateral recolhido, ao fim da animação:** o lateral recebe `Offstage` (com o estado mantido) e `ExcludeFocus`.

Para saber quando a animação termina, uso o `onEnd` do `AnimatedSlide`.

`mainContents` vira uma `Column` de `Expanded`, um por item, com flex 1. O caso usual é um só item, que ocupa toda a
área.

### D4. ShellBar: estrutura

A barra é um `RebicContainer(surface: shell, shadow: header)` com altura `spacing.xxxl` e um `LayoutBuilder`, que
classifica a largura com `theme.breakpoints.classify`, como a `RebicPage`.

A margem é escolhida por um `switch`:
- `small` → `spacing.pageMargin`;
- `medium` → `spacing.xxl`;
- `large` e `extraLarge` → `spacing.xxxl`.

Dentro, há uma `Row` com `gap: spacing.xs` e:
1. voltar, menu e ícone inicial;
2. `Expanded` com os títulos (D5);
3. pesquisa, notificações, `additionalContent`, perfil e seletor de produtos.

Em RTL, a `Row` espelha a ordem sozinha.

O título é `RebicTitle(level: h1, titleStyle: h5)`, que já é cabeçalho de nível 1 e usa `header5` com `colors.text`.
O segundo título é um `Text` com `typography.small` e `colors.text`, em uma linha com reticências, porque nenhum
controle de texto tem o estilo `small`.

### D5. Títulos: o segundo encolhe primeiro

Uso uma `CustomMultiChildLayout`, com altura fixa, a da barra sem margens. O delegate:
1. dispõe o título com largura máxima igual à disponível;
2. dispõe o segundo título com o que sobrar;
3. centraliza os dois verticalmente.

Não há `RenderObject` próprio.

Alternativa considerada: dois `Flexible` com flex desigual. Rejeitada porque o `Flexible` frouxo limita cada filho à
sua parcela e truncaria o segundo título mesmo com espaço sobrando.

### D6. Botões, ícone inicial e perfil

- **Botões:** `RebicIconButton(type: transparent)`, com as dicas de `RebicLocalizations`: `back`, `menu`, `search`,
  `notifications` e `products`. Sem callback, ficam desabilitados.
- **Notificações:** `MergeSemantics(child: RebicBadge(count: notificationsNumber, child: botão))`, para o contador
  entrar no rótulo do botão. Com zero, o `RebicBadge` já mostra só o filho.
- **Ícone inicial:** `RebicInteractable` com a família `transparent` e o raio `button`, dentro de `RebicTooltip`.
  Sem `onHomeIconPressed`, é só o widget, com `Semantics(label:)`.
- **Perfil:** é recriado como `RebicAvatar` com os mesmos `image`, `initials`, `icon`, `shape` e `semanticLabel`, o
  tamanho `xs` e `onPressed: onAvatarPressed`, como o ShellBar faz com o `displaySize` do `Avatar`. O `onPressed`
  do avatar recebido é ignorado. O dartdoc diz isso.

Os ícones `bell`, `search`, `navBack` e `menu2` já existem. Entra `RebicIcons.grid` (Lucide `grip`, nove pontos;
IconPool `grid`) em `rebic_foundation`, com a entrada em `iconPoolNames` e no mapa por nome.

### D7. Semântica da barra

`Semantics(container: true, explicitChildNodes: true, label: shellBar)` envolve a barra. No Flutter não há papel
`banner`, então o rótulo cumpre a função do `aria-label` do UI5.

### D8. Textos do núcleo

`menu`, `logo`, `notifications`, `profile`, `products` e `shellBar` entram em `RebicLocalizations` (pt-BR e en), com
os textos do `messagebundle` do `sap.f`. Para a pesquisa, fica o `search` existente ("Pesquisar"), em vez de
"Procurar". Um único texto para a pesquisa evita duas traduções no framework. `profile` fica para o rótulo padrão
do perfil sem `semanticLabel`.

### D9. Valores provisórios (ADR 0009)

| Valor | Adotado | Referência |
|---|---|---|
| Altura da barra | `spacing.xxxl` (48), igual nas duas densidades | `.sapFShellBar { height: 3rem }` |
| Hover e pressionado dos botões da barra | família `transparent` | `sapShell_Hover_Background` e `sapShell_Active_Background` |
| Espaço entre elementos da barra | `spacing.xs` | margens internas dos botões do ShellBar, não conferidas |

## Risks / Trade-offs

- **[Sem OverflowToolbar, muitos itens à direita podem não caber]** → os títulos encolhem até zero, e os testes cobrem
  a barra de 360 com o caso comum. O excesso fica para a change do `OverflowToolbar`, citada nas restrições da spec.
- **[Quem usava `RebicScaffold` quebra]** → o CHANGELOG traz o de/para, e o requisito REMOVED da spec traz a
  migração.
- **[`Offstage` com `AnimatedSlide` pode deixar o lateral visível um quadro a mais]** → o teste de movimento reduzido
  verifica o primeiro quadro, e o de semântica verifica o estado final.
- **[Conteúdo lateral sem largura própria ocupa a área toda fora de `small`]** → o dartdoc pede um conteúdo lateral
  com largura definida. A `RebicSideNavigation` futura terá as larguras do UI5.

## Migration Plan

**BREAKING** em `rebic_widgets`.

| Antes | Agora |
|---|---|
| `RebicScaffold(title:, logo:, actions:, navigation:, body:)` | `RebicToolPage(header: RebicShellBar(title:, homeIcon:, showMenuButton: true, onMenuButtonPressed: () => RebicToolPage.toggleSideContentMode(context), additionalContent:), sideContent:, mainContents: [body])` |
| `navigationExpanded` | `sideExpanded` |
| `navigationExpandedOf` | `sideExpandedOf` |
| `onNavigationExpandedChanged` | `onSideExpandedChanged` |

Para reverter, revertem-se os commits da change.
