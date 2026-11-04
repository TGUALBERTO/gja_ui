# Proposal: Status no nome do SAPUI5 (`update-rebic-status-indicator-fiori-object-status`)

## Why

`RebicStatusIndicator` segue o `sap.m.ObjectStatus` (título, ícone e texto na cor de um estado, normal ou invertido,
e ativo com o evento `press`), mas tem o nome de outro controle: o `sap.m.StatusIndicator` do SAPUI5 é um indicador
gráfico de preenchimento (uma forma que enche de 0 a 100 %). O nome confunde quem conhece o UI5 e bloqueia o nome
certo caso o indicador gráfico venha a existir.

## What Changes

- **BREAKING** `RebicStatusIndicator` passa a se chamar `RebicObjectStatus`, com as mesmas propriedades e o mesmo
  comportamento; a capability `rebic/widgets/rebic-status-indicator` é retirada e dá lugar a
  `rebic/widgets/rebic-object-status`, com os mesmos requisitos.
- A pasta `exibicao_dados/status_indicator/` vira `exibicao_dados/object_status/`, com testes e goldens.
- A galeria troca a página "RebicStatusIndicator" por "RebicObjectStatus".
- Catálogo: o item muda de id e de nome.

Fora do escopo: o `sap.m.StatusIndicator` gráfico.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-object-status`: `RebicObjectStatus`.

### Modified Capabilities

- `rebic/widgets/rebic-status-indicator`: retirada.

## Impact

- `packages/rebic_widgets`: renomeação, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicObjectStatus" e a página do cartão, que usa o status.
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
