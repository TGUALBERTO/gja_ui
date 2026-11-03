# Proposal: Mensagem ilustrada (`add-rebic-illustrated-message`)

## Why

A Fase 3 pede o estado vazio. O modelo é o `sap.m.IllustratedMessage` (conferido em `SAP/openui5`,
`sap.m/IllustratedMessage.js`): `title`, `description`, `illustrationType`, `illustrationSize` (Spot, Dialog, Scene),
`ariaTitleLevel` e `additionalContent` (ações). As ilustrações do UI5 são arquivos SVG da SAP, que o Rebic não
reproduz.

## What Changes

- Novo `RebicIllustratedMessage`: `title`, `description`, `illustrationType` (`RebicIllustrationType`),
  `illustrationSize` (`RebicIllustrationSize`), `illustration` (widget próprio), `titleLevel` e `additionalContent`.
  Sem `illustration`, a ilustração é um ícone grande do catálogo, na cor da marca.
- Catálogo: `rebic/widgets/rebic-empty-state` passa a `rebic/widgets/rebic-illustrated-message` (o nome do UI5).

Fora do escopo: as ilustrações da SAP, os títulos e descrições padrão por tipo, texto formatado e responsividade
vertical.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-illustrated-message`: `RebicIllustratedMessage`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `exibicao_dados/illustrated_message/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicIllustratedMessage".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
