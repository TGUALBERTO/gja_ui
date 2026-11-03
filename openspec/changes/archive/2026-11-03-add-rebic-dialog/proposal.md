# Proposal: Diálogo (`add-rebic-dialog`)

## Why

A Fase 3 pede o diálogo. O modelo é o `sap.m.Dialog` (conferido em `SAP/openui5`, `sap.m/Dialog.js`): `title`,
`state` (com o ícone do estado nas mensagens), `content`, `beginButton`, `endButton`, `buttons`, `contentWidth`,
`escapeHandler` e a abertura modal. O núcleo já tem o modal do `sap.ui.core.Popup` (`RebicModal`, com camada de
bloqueio, foco preso e Esc); falta o painel do diálogo.

## What Changes

- Novo `RebicDialog`: `content`, `title`, `semanticLabel`, `state`, `beginButton`, `endButton`, `buttons` e `width`
  (`RebicDialogWidth`), com `RebicDialog.open` sobre `RebicModal.show`.
- Catálogo: `rebic/widgets/rebic-dialog` passa a `implemented`.

Fora do escopo: arrastar, redimensionar, tela cheia (`stretch`), `subHeader`, `customHeader` e o diálogo de
confirmação pronto (`rebic/widgets/rebic-confirmation-dialog`, que continua planejado).

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-dialog`: `RebicDialog`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `feedback_sobreposicoes/dialog/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicDialog".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
