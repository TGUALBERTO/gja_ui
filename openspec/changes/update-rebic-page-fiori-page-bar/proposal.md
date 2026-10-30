# Proposal: Page e Bar no modelo do SAPUI5 (`update-rebic-page-fiori-page-bar`)

## Why

A `RebicPage` mistura o `sap.m.Page` e o `sap.f.DynamicPage` e diverge dos dois. Conferido no código do OpenUI5
(`sap.m/Page.js`, `PageRenderer.js`, `themes/base/Page.less` e `Bar.less`, e `sap.ui.core/themes/base/global.less`):

- **Estrutura:** o `sap.m.Page` é um `sap.m.Bar` de cabeçalho, um subcabeçalho opcional, o conteúdo e um rodapé. O
  rodapé é qualquer barra (`IBar`), em geral com as ações à direita. A página não tem subtítulo, que é do
  `DynamicPage`.
- **Barra:** a `sap.m.Bar` tem três áreas, `contentLeft`, `contentMiddle` e `contentRight`. Mede 3rem no cozy e 2rem
  no compacto. O desenho (`Header`, `SubHeader`, `Footer`, `FloatingFooter`) depende de onde ela está.
- **Cabeçalho da página:** é uma `Bar` com o botão de voltar à esquerda (`showNavButton`, `navButtonTooltip`, evento
  `navButtonPress`), o título no meio (`sap.m.Title` com `titleLevel` e `titleAlignment`) e o `headerContent` à
  direita. Há também `customHeader`, `showHeader` e `showSubHeader`.
- **Conteúdo:** a página não tem espaçamento por padrão. As aplicações aplicam `sapUiContentPadding` (1rem) ou
  `sapUiResponsiveContentPadding` (0, 1rem, e 1rem por 2rem, pela largura da janela). A página tem ainda
  `enableScrolling`, `backgroundDesign` (`Standard`, `Solid`, `List`, `Transparent`), `showFooter` e
  `floatingFooter`.

Hoje a página tem `subtitle`, `onBack`, `actions`, `footerActions` e um espaçamento sempre ligado, além de uma área
de título própria com o estilo H2. É o terceiro passo do bloco de layout do realinhamento.

## What Changes

- **BREAKING** `RebicPage` passa a ter a API do `sap.m.Page`:
  - **Cabeçalho:** `title`, `titleLevel`, `titleAlignment`, `showNavButton`, `navButtonTooltip`,
    `onNavButtonPress`, `headerContent`, `customHeader`, `showHeader`, `subHeader` e `showSubHeader`;
  - **Conteúdo e rodapé:** `content` (lista), `enableScrolling`, `backgroundDesign`, `contentPadding` (`none`,
    `standard` ou `responsive`, como as classes de padding do UI5; padrão `none`), `footer`, `showFooter` e
    `floatingFooter`;
  - **Saem:** `subtitle`, `onBack`, `actions`, `body`, `padded`, `scrollable` e `footerActions`.

  O cabeçalho é uma `RebicBar` com o voltar, o título (`RebicTitle`, estilo H5) e o `headerContent`. O rodapé
  flutuante fica sobre o conteúdo, com margem e cantos arredondados.
- Novo `RebicBar`, como o `sap.m.Bar`:
  - `contentLeft`, `contentMiddle` e `contentRight`;
  - `design` (`RebicBarDesign`: `auto`, `header`, `subHeader`, `footer` e `floatingFooter`). Com `auto`, o desenho é
    o da área da página em que a barra está;
  - `titleAlignment` (`RebicTitleAlignment`: `none`, `start`, `center` e `auto`).

  A altura vem do novo token de densidade `barHeight`.
- Fundação: `barHeight` em `RebicDensityTokens` (48 no cozy, 32 no compacto), com o valor 48 na escala primitiva de
  densidade.
- O cenário de `RebicIconButton` que usava `onBack` passa a usar `showNavButton`.
- A galeria ganha a página "RebicBar", e as 12 páginas feitas com `RebicPage` passam à API nova.

Fora do escopo:
- o `sap.f.DynamicPage` (cabeçalho expansível, subtítulo e snapping), que terá widget próprio;
- o `OverflowToolbar` do rodapé (`RebicToolbar`, já previsto no catálogo);
- `contentOnlyBusy` e `landmarkInfo`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-bar`: `RebicBar`, o `sap.m.Bar` do Rebic.

### Modified Capabilities

- `rebic/widgets/rebic-page`: API, áreas, espaçamento, fundo e rodapé do `sap.m.Page`.
- `rebic/foundation/density`: token `barHeight`.
- `rebic/widgets/rebic-icon-button`: cenário de uso pela página com `showNavButton`.

A página e a barra formam uma unidade inseparável, como pede `rebic/spec-governance`. O cabeçalho, o subcabeçalho e
o rodapé da página são barras, e a página sozinha teria de duplicar a barra por dentro. A spec do botão de ícone muda
só por citar a API antiga da página.

## Impact

- `packages/rebic_foundation`: `barHeight` e primitivo 48 na densidade, com testes e CHANGELOG.
- `packages/rebic_widgets`:
  - `fundacao_layout/page/rebic_page.dart` reescrito;
  - novo `fundacao_layout/bar/rebic_bar.dart`, com exportação;
  - testes e goldens da página e da barra; o teste do botão de ícone que usava `onBack`;
  - CHANGELOG com o de/para.
- `apps/rebic_gallery`: página "RebicBar" e as 12 páginas que usam `RebicPage`, com os testes.
- `docs/catalog.yaml`: entrada `rebic/widgets/rebic-bar` (P0, fase 1) e as dependências da página.
- `docs/adr/0009-provisional-horizon-values.md`: cores e bordas das barras, espaços internos da barra, raio do rodapé
  flutuante e fundos de `backgroundDesign`.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
