# Proposal: Aviso breve (`add-gja-message-toast`)

## Why

A Fase 3 pede o "Toast". O modelo é o `sap.m.MessageToast` (conferido em `SAP/openui5`, `sap.m/MessageToast.js` e
`themes/base/MessageToast.less`): `MessageToast.show(mensagem, {duration: 3000, width: "15em", my/at: CenterBottom})`,
fundo `sapIndicationColor_9_Background`, texto `sapContent_ContrastTextColor`, espaço de 1rem e raio
`sapElement_BorderCornerRadius`; não recebe foco e some sozinho.

## What Changes

- Novo `GjaMessageToast.show(context, message, {duration})`, com um aviso por vez no `Overlay` da aplicação,
  centralizado embaixo, anunciado como região viva.
- Catálogo: `gja/widgets/gja-snackbar` passa a `gja/widgets/gja-message-toast` (o nome do UI5).

Fora do escopo: posição (`my`, `at`, `offset`), `autoClose` desligado, ação e empilhamento.

## Capabilities

### New Capabilities

- `gja/widgets/gja-message-toast`: `GjaMessageToast`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `feedback_sobreposicoes/message_toast/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaMessageToast".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
