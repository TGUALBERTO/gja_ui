# Proposal: Diálogo (`add-gja-dialog`)

## Why

A Fase 3 pede o diálogo. O modelo é o `sap.m.Dialog` (conferido em `SAP/openui5`, `sap.m/Dialog.js`): `title`,
`state` (com o ícone do estado nas mensagens), `content`, `beginButton`, `endButton`, `buttons`, `contentWidth`,
`escapeHandler` e a abertura modal. O núcleo já tem o modal do `sap.ui.core.Popup` (`GjaModal`, com camada de
bloqueio, foco preso e Esc); falta o painel do diálogo.

## What Changes

- Novo `GjaDialog`: `content`, `title`, `semanticLabel`, `state`, `beginButton`, `endButton`, `buttons` e `width`
  (`GjaDialogWidth`), com `GjaDialog.open` sobre `GjaModal.show`.
- Catálogo: `gja/widgets/gja-dialog` passa a `implemented`.

Fora do escopo: arrastar, redimensionar, tela cheia (`stretch`), `subHeader`, `customHeader` e o diálogo de
confirmação pronto (`gja/widgets/gja-confirmation-dialog`, que continua planejado).

## Capabilities

### New Capabilities

- `gja/widgets/gja-dialog`: `GjaDialog`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `feedback_sobreposicoes/dialog/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaDialog".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
