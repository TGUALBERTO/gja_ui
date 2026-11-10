# Design: Page e Bar no modelo do SAPUI5

## Context

A `GjaPage` atual (`fundacao_layout/page/gja_page.dart`, 181 linhas) monta:
- uma área de título com `GjaRow`, `GjaIconButton` de voltar, título `header2` em até duas linhas, subtítulo e
  ações;
- um `GjaDivider`, o conteúdo com margem `pageMarginFor` pela largura da página e `SingleChildScrollView`
  opcional, e um rodapé de ações.

Não pinta fundo. É usada por 12 páginas da galeria e pelos testes de página e de botão de ícone.

No OpenUI5:
- **`PageRenderer`:** cabeçalho (`customHeader` ou a `Bar` interna), subcabeçalho e a `section` de conteúdo (com
  `sapMPageEnableScrolling`), mais o rodapé posicionado no fim. Com `floatingFooter`, o rodapé flutua com margem
  inferior de 0,5rem e cantos de 0,25rem.
- **`Page._getInternalHeader`:** o botão de voltar vai para `contentLeft`, o `Title` (com `titleLevel`) para
  `contentMiddle` e o `headerContent` para `contentRight`.
- **`Bar.less`:** 3rem (2rem no compacto), fundo `sapPageHeader_Background` e `box-shadow: sapContent_HeaderShadow`.
- **Padding:** o mixin `sapUiContainerContentPadding` define os espaçamentos pelas media queries da janela (< 600,
  600–1023 e ≥ 1024).

## Goals / Non-Goals

**Goals:**
- API da página e da barra com os nomes do UI5, e a página montada sobre a barra.
- Nenhum golden de outros widgets muda.

**Non-Goals:**
- `DynamicPage` e `OverflowToolbar`, que terão widgets próprios.
- Um `GjaToolbar` provisório para o rodapé: a galeria usa `GjaBar(contentRight: …)`.

## Decisions

### D1. Arquivos e tipos

- `fundacao_layout/bar/gja_bar.dart`: `GjaBar`, `GjaBarDesign` e `GjaTitleAlignment`. O `GjaTitleAlignment`
  fica na barra, como no UI5, onde é do `sap.m`, e é reusado pela página.
- `fundacao_layout/page/gja_page.dart`: `GjaPage`, `GjaPageBackgroundDesign` e `GjaContentPadding`.

### D2. Layout da barra

Uso um `CustomMultiChildLayout` com três slots (início, meio e fim), na altura `density.barHeight` e com espaço
`spacing.s` nas pontas:
1. dispõe o início e o fim com a largura intrínseca, cada um uma `Row` com `gap` `spacing.xs`;
2. dispõe o meio com a largura que sobra entre eles, menos os `gap`;
3. posiciona o meio:
   - com `none` ou `center`: centrado na barra, se couber entre as pontas; senão, encostado no início;
   - com `start` ou `auto`: logo depois do início.

Em RTL, o delegate espelha as posições pelo `TextDirection`, como o `_TitlesLayout` do ShellBar.

A ordem de foco e de semântica segue a dos filhos (início, meio e fim). A política padrão de leitura do Flutter
segue a geometria, que coincide com essa ordem, então não há `FocusTraversalGroup` próprio.

Alternativa considerada: uma `Row` com `Expanded` no meio. Rejeitada porque não centra o meio na barra quando as
pontas têm larguras diferentes.

### D3. Desenho

O desenho em vigor é `design`. Com `auto`, vem de um `InheritedWidget` privado (`_GjaBarContext`), que a página
coloca em volta do cabeçalho (`header`), do subcabeçalho (`subHeader`) e do rodapé (`footer` ou `floatingFooter`).
Fora dele, `auto` vale `header`.

A decoração é um `DecoratedBox` com os tokens do tema, porque o `GjaContainer` só tem borda nos quatro lados e
o rodapé precisa da borda só no topo:
- `header`: `boxShadow` de `shadows.header`;
- `subHeader`: só o fundo;
- `footer`: `Border(top:)` com `colors.separator`;
- `floatingFooter`: `Border.all` com `colors.separator` e `BorderRadius.circular(radius.s)`.

Com isso, a barra depende só de fundamentos (`color`, `shadows`, `radius`, `spacing` e `density`), e não de
`gja-container`.

### D4. Página

```text
Container (fundo de backgroundDesign)
└─ Stack
   ├─ Column(up): [Expanded(conteúdo), subHeader?, header?]   ← cabeçalho pintado sobre o conteúdo
   └─ rodapé (fixo: no fim da Column; flutuante: Positioned com spacing.s)
```

Com rodapé fixo, ele entra no fim da `Column` (`verticalDirection: up` com a ordem invertida) e o `Stack` não é
usado.

Conteúdo:
- **Com `enableScrolling`:** `SingleChildScrollView(child: Padding(Column(min, stretch, content)))`.
- **Sem `enableScrolling`:** `Padding(Column(Expanded…))`, como os `mainContents` do ToolPage.

A rolagem até o item focado vem do `SingleChildScrollView` (comportamento que já existe).

`contentPadding` é resolvido por `GjaResponsive.screenSizeClassOf(context)`, porque o UI5 usa media queries da
janela:
- `none` → zero;
- `standard` → `EdgeInsets.all(spacing.l)`;
- `responsive` → zero em `small`, `all(l)` em `medium` e `symmetric(horizontal: xxl, vertical: l)` em `large` ou
  maior.

Com rodapé flutuante, soma-se embaixo `density.barHeight + spacing.s * 2`.

O cabeçalho interno é `GjaBar(design: header, titleAlignment: titleAlignment)` com:
- `contentLeft`: o botão de voltar (`GjaIconButton`, `navBack`, dica `navButtonTooltip ?? back`,
  `onNavButtonPress`);
- `contentMiddle`: `GjaTitle(title, level: titleLevel)`;
- `contentRight`: o `headerContent`.

O `customHeader` substitui a barra interna.

O fundo é escolhido por um `switch` em `backgroundDesign` sobre `colors.background`, `colors.base` ou nenhum. O
`assert` de altura limitada continua.

### D5. Token `barHeight`

Novo campo em `GjaDensityTokens` (contrato completo: `copyWith`, `lerp`, `==`, `hashCode`, diagnóstico e `assert`
de valor positivo), com o primitivo `GjaDensityPrimitives.size48`:
- cozy: `size48`;
- compacto: `size32`.

O ShellBar continua com `spacing.xxxl`: o `sap.f.ShellBar` mede 3rem nas duas densidades.

### D6. Migração da galeria

| Antes | Agora |
|---|---|
| `onBack: () => pop()` | `showNavButton: true, onNavButtonPress: () => pop()` |
| `actions: [...]` | `headerContent: [...]` |
| `body: X` | `content: [X]`, com `contentPadding: responsive` onde havia margem |
| `scrollable: false` | `enableScrolling: false` |
| `footerActions: [...]` | `footer: GjaBar(contentRight: [...])` |
| `subtitle` | removido, ou passa ao conteúdo |

### D7. Valores provisórios (ADR 0009)

| Valor | Adotado | Referência |
|---|---|---|
| Fundo das barras | `colors.base` em todos os desenhos | `sapPageHeader_Background`, `sapPageSubheader_Background`, `sapPageFooter_Background` |
| Bordas e sombra por desenho | `header` com `shadows.header`; `footer` com borda superior `separator`; `floatingFooter` com borda e raio `radius.s` | `sapContent_HeaderShadow` e estilos do rodapé flutuante |
| Espaços da barra | `spacing.s` nas pontas e `spacing.xs` entre itens | paddings de 0,25rem dos contêineres da `Bar` |
| Fundos de `backgroundDesign` | `standard`/`solid` → `background`; `list` → `base` | `sapMPageBg*`, sem conferir o Horizon |

## Risks / Trade-offs

- **[Visual da galeria muda, porque o título fica menor (H5) e sem espaçamento por padrão]** → as páginas da galeria
  passam `contentPadding: responsive`. Os goldens afetados são só os da própria página.
- **[O `headerContent` largo empurra o título]** → o meio recebe só o espaço restante, e o `GjaTitle` termina com
  reticências (cenário "Título longo no meio").
- **[O conteúdo sem `Expanded` em `enableScrolling: false` com vários itens]** → os itens dividem a altura, como os
  `mainContents`, e o dartdoc explica isso.
- **[O `Purpose` da spec principal da página ainda cita o scaffold]** → o arquivamento troca o `Purpose` pelo da
  delta, porque a sincronização preserva o existente.

## Migration Plan

**BREAKING** em `gja_widgets`. O CHANGELOG traz a tabela de D6. Para reverter, revertem-se os commits.
