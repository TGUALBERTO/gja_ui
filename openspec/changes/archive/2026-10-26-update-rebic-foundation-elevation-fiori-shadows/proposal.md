# Proposal: Sombras no modelo Fiori (`update-rebic-foundation-elevation-fiori-shadows`)

## Why

O fundamento de elevação usa a escala `level0`…`level4`, o vocabulário de níveis de elevação do Material Design. O
Fiori trabalha com parâmetros de sombra nomeados por uso: `sapContent_Shadow0` (cartões e blocos), `Shadow1`
(popovers e menus), `Shadow2` (diálogos), `Shadow3` (item arrastado) e `sapContent_HeaderShadow` (cabeçalhos).
Esta é a segunda parte do realinhamento ao SAPUI5 como modelo, depois de
`update-rebic-foundation-color-fiori-parameters`. Nenhum widget usa elevação ainda.

## What Changes

- **BREAKING** Primitivos: `elevation0`…`elevation4` viram `none` e `shadow0`…`shadow3`. A geometria de
  `shadow0`…`shadow3` é a dos antigos `elevation1`…`elevation4`. Entra o primitivo `header`, uma sombra curta para
  baixo, para cabeçalhos e barras fixas.
- **BREAKING** `RebicElevationTokens`: os níveis `level0`…`level4` viram `none` e `shadow0`…`shadow3`. Os papéis
  ficam `card` (= `shadow0`), `popover` (= `shadow1`) e `dialog` (= `shadow2`), e entram `dragged` (= `shadow3`) e
  `header` (= `header`).
- O papel `dragged` dá ao item arrastado uma sombra explícita, como o Fiori, no lugar do aumento de elevação em
  interação removido na change anterior.
- A página "Elevação" da galeria e os testes passam a usar os nomes novos.

Fora do escopo:
- Cor da sombra: continua o papel `shadow` de `rebic/foundation/color`.
- Uso das sombras por widgets, que entram com os widgets.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/foundation/elevation`: escala primitiva, níveis e papéis, cenário de nível sem sombra, contrato e página da
  galeria passam aos nomes Fiori.

## Impact

- `packages/rebic_foundation`: `elevation_primitives.dart`, `elevation_tokens.dart`, testes de elevação e de tema,
  CHANGELOG.
- `apps/rebic_gallery`: página "Elevação" e o teste dela; a prévia da página "Tema" já usa `card`.
- Sem efeito em `rebic_core`, `rebic_widgets`, catálogo ou verificação de tokens.
