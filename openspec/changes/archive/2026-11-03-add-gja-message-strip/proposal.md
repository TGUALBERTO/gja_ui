# Proposal: Faixa de mensagem (`add-gja-message-strip`)

## Why

A Fase 3 pede a faixa de mensagem. O modelo é o `sap.m.MessageStrip` (conferido em `SAP/openui5`,
`sap.m/MessageStrip.js` e `themes/base/MessageStrip.less`): `text`, `type` (`MessageType`), `showIcon`,
`showCloseButton`, o link e o evento `close`; a faixa usa `sapPopover_BorderCornerRadius`, borda
`sapMessage_BorderWidth` e espaço interno de 1rem nas laterais.

## What Changes

- Novo `GjaMessageStrip`: `text`, `type` (`GjaValueState`, o `MessageType` do GJA), `showIcon`,
  `showCloseButton`, `onClose` e `link` (`GjaLink`), anunciado como região viva.
- Catálogo: `gja/widgets/gja-alert` passa a `gja/widgets/gja-message-strip` (o nome do UI5).

Fora do escopo: `customIcon`, `colorSet`, `colorScheme` e texto formatado.

## Capabilities

### New Capabilities

- `gja/widgets/gja-message-strip`: `GjaMessageStrip`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `feedback_sobreposicoes/message_strip/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaMessageStrip".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
