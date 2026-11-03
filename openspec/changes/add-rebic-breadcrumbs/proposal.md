# Proposal: Trilha de navegação (`add-rebic-breadcrumbs`)

## Why

A Fase 4 pede a trilha de navegação. O modelo é o `sap.m.Breadcrumbs` (conferido em `SAP/openui5`,
`sap.m/Breadcrumbs.js` e `themes/base/Breadcrumbs.less`): `links` (`sap.m.Link`), `currentLocationText` e
`separatorStyle` (Slash, BackSlash, DoubleSlash, DoubleBackSlash, GreaterThan, DoubleGreaterThan).

## What Changes

- Novo `RebicBreadcrumbs`: `links` (`RebicLink`), `currentLocationText`, `separatorStyle`
  (`RebicBreadcrumbsSeparator`) e `semanticLabel`; os itens quebram em várias linhas quando falta largura.
- Catálogo: `rebic/widgets/rebic-breadcrumbs` passa a `implemented`, sem depender do menu.

Fora do escopo: recolher os primeiros níveis num seletor quando falta largura (o UI5 faz isso) e a página atual como
link (`currentLocation`).

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-breadcrumbs`: `RebicBreadcrumbs`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `acoes_navegacao/breadcrumbs/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicBreadcrumbs".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
