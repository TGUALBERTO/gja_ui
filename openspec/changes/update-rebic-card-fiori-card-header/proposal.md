# Proposal: Card e cabeçalho de cartão no modelo do SAPUI5 (`update-rebic-card-fiori-card-header`)

## Why

O `RebicCard` desenha o próprio cabeçalho, com `title`, `subtitle`, `status`, `leading`, `onHeaderPressed` e um
`padded` que dá margem ao conteúdo. No SAPUI5 o cabeçalho é um controle separado. Conferido no código do OpenUI5
(`sap.f/Card.js`, `CardBase.js`, `cards/BaseHeader.js`, `cards/Header.js`, `themes/base/Card.less` e
`CardHeaders.less`):

- **Cartão:** o `sap.f.Card` tem `header` (um `sap.f.cards.IHeader`), `headerPosition` (`Top` ou `Bottom`), `content`
  e `headingLevel` (padrão H3).
  - Superfície: fundo `sapTile_Background`, borda `sapTile_BorderColor`, raio `sapTile_BorderCornerRadius` e sombra
    `sapContent_Shadow0`.
  - O cabeçalho é separado do conteúdo por uma linha `sapTile_SeparatorColor`.
  - O cartão não dá margem ao conteúdo.
- **Cabeçalho:** o `sap.f.cards.Header` tem:
  - `title` (até `titleMaxLines`, padrão 3) e `subtitle` (até `subtitleMaxLines`, padrão 2);
  - `statusText` e `statusVisible`, e `dataTimestamp`;
  - um ícone (`iconSrc`, `iconInitials`, `iconDisplayShape`, `iconSize` padrão S, `iconAlt`, `iconVisible`);
  - um `toolbar` e o evento `press`.
- **Aparência do cabeçalho:** espaço de 1rem; título com `sapFontHeader5Size` em negrito; subtítulo no tamanho
  base; status e data no tamanho pequeno. Com `press`, há hover e pressionado com as cores de tile.

Hoje o título usa o estilo H4 com no máximo duas linhas, e o subtítulo também tem duas. É o quarto passo do bloco de
layout do realinhamento.

## What Changes

- **BREAKING** `RebicCard` passa à API do `sap.f.Card`:
  - **Propriedades:** `header` (`Widget?`, em geral um `RebicCardHeader`), `headerPosition`
    (`RebicCardHeaderPosition`: `top` ou `bottom`), `content` (`Widget?`) e `headingLevel` (`RebicTitleLevel`,
    padrão `h3`);
  - **Saem:** `child`, `title`, `subtitle`, `status`, `leading`, `padded` e `onHeaderPressed`;
  - **Separador:** a linha entre o cabeçalho e o conteúdo fica embaixo do cabeçalho ou, com `bottom`, em cima;
  - **Conteúdo:** fica sem margem, como no UI5.
- Novo `RebicCardHeader`, como o `sap.f.cards.Header`:
  - textos: `title`, `titleMaxLines`, `subtitle`, `subtitleMaxLines`, `statusText`, `statusVisible` e
    `dataTimestamp`;
  - ícone: `icon`, `iconImage`, `iconInitials`, `iconDisplayShape`, `iconSize`, `iconAlt` e `iconVisible`;
  - `toolbar` e `onPress`.

  O título é anunciado com o `headingLevel` do cartão. Com `onPress`, o cabeçalho é um botão com as cores da família
  `list`.
- A galeria passa a página "RebicCard" à API nova, com exemplos do cabeçalho.

Fora do escopo:
- `sap.f.cards.NumericHeader`, `infoSection`, `bannerLines`, `href`/`target`, `iconBackgroundColor`, `iconState`,
  `iconFitType` e `wrappingType`;
- os conteúdos especializados do UI5 (lista, tabela, analítico) e o `sap.ui.integration.widgets.Card`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-card-header`: `RebicCardHeader`, o `sap.f.cards.Header` do Rebic.

### Modified Capabilities

- `rebic/widgets/rebic-card`: API, posição do cabeçalho e conteúdo sem margem do `sap.f.Card`.

O cartão e o cabeçalho formam uma unidade inseparável, como pede `rebic/spec-governance`: o `header` do cartão é o
cabeçalho, e o cartão sozinho perderia o cabeçalho que hoje desenha.

## Impact

- `packages/rebic_widgets`:
  - `fundacao_layout/card/rebic_card.dart` reescrito;
  - novo `fundacao_layout/card_header/rebic_card_header.dart`, com exportação;
  - testes e goldens dos dois;
  - CHANGELOG com o de/para.
- `apps/rebic_gallery`: a página "RebicCard", única que usa o cartão, com o teste.
- `docs/catalog.yaml`: entrada `rebic/widgets/rebic-card-header` (P1, fase 2, como o cartão) e as dependências do
  cartão.
- `docs/adr/0009-provisional-horizon-values.md`: cores do cabeçalho acionável e espaços entre as linhas do cabeçalho.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
