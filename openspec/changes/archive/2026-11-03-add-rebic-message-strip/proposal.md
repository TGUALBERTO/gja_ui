# Proposal: Faixa de mensagem (`add-rebic-message-strip`)

## Why

A Fase 3 pede a faixa de mensagem. O modelo é o `sap.m.MessageStrip` (conferido em `SAP/openui5`,
`sap.m/MessageStrip.js` e `themes/base/MessageStrip.less`): `text`, `type` (`MessageType`), `showIcon`,
`showCloseButton`, o link e o evento `close`; a faixa usa `sapPopover_BorderCornerRadius`, borda
`sapMessage_BorderWidth` e espaço interno de 1rem nas laterais.

## What Changes

- Novo `RebicMessageStrip`: `text`, `type` (`RebicValueState`, o `MessageType` do Rebic), `showIcon`,
  `showCloseButton`, `onClose` e `link` (`RebicLink`), anunciado como região viva.
- Catálogo: `rebic/widgets/rebic-alert` passa a `rebic/widgets/rebic-message-strip` (o nome do UI5).

Fora do escopo: `customIcon`, `colorSet`, `colorScheme` e texto formatado.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-message-strip`: `RebicMessageStrip`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `feedback_sobreposicoes/message_strip/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicMessageStrip".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
