# Proposal: Mensagem ilustrada (`add-gja-illustrated-message`)

## Why

A Fase 3 pede o estado vazio. O modelo é o `sap.m.IllustratedMessage` (conferido em `SAP/openui5`,
`sap.m/IllustratedMessage.js`): `title`, `description`, `illustrationType`, `illustrationSize` (Spot, Dialog, Scene),
`ariaTitleLevel` e `additionalContent` (ações). As ilustrações do UI5 são arquivos SVG da SAP, que o GJA não
reproduz.

## What Changes

- Novo `GjaIllustratedMessage`: `title`, `description`, `illustrationType` (`GjaIllustrationType`),
  `illustrationSize` (`GjaIllustrationSize`), `illustration` (widget próprio), `titleLevel` e `additionalContent`.
  Sem `illustration`, a ilustração é um ícone grande do catálogo, na cor da marca.
- Catálogo: `gja/widgets/gja-empty-state` passa a `gja/widgets/gja-illustrated-message` (o nome do UI5).

Fora do escopo: as ilustrações da SAP, os títulos e descrições padrão por tipo, texto formatado e responsividade
vertical.

## Capabilities

### New Capabilities

- `gja/widgets/gja-illustrated-message`: `GjaIllustratedMessage`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `exibicao_dados/illustrated_message/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaIllustratedMessage".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
