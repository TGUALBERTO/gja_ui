# Proposal: Campo de texto (`add-gja-input`)

## Why

A Fase 2 pede o campo de texto. O modelo é o `sap.m.Input` (conferido em `SAP/openui5`, `sap.m/InputBase.js` e
`Input.js`): `value`, `placeholder`, `type`, `enabled`, `editable`, `valueState`, `valueStateText`, `maxLength`,
`showClearIcon` e os eventos `liveChange`, `change` e `submit`. No Horizon, `sapField_Background` é branco,
`sapField_BorderColor` cinza-azulado, `sapField_Hover_BorderColor` a cor da marca, `sapField_BorderCornerRadius`
0,25rem e `sapField_ReadOnly_Background` cinza claro.

## What Changes

- Novo `GjaInput`, controlado (`value` + `onLiveChange`), com `onChange`, `onSubmit`, `placeholder`,
  `semanticLabel`, `type` (`GjaInputType`), `enabled`, `editable`, `valueState`, `valueStateText`, `maxLength`,
  `showClearIcon` (ícone acionável, fora do Tab, como no UI5) e `focusNode`, desenhado com o `EditableText` do Flutter, sem Material.
- A mensagem de estado de valor aparece abaixo do campo enquanto ele tem o foco (no UI5, num popup abaixo do campo).
- Catálogo: `gja/widgets/gja-text-field` passa a `gja/widgets/gja-input` (o nome do UI5), sem depender do
  campo de formulário; quem citava o campo de texto passa a citar o novo id.
- ADR 0009: fundo somente leitura, borda de foco e mensagem de estado em linha.

Fora do escopo: sugestões, `showValueHelp`, `description`, `width`, máscara e várias linhas (`GjaTextArea`).

## Capabilities

### New Capabilities

- `gja/widgets/gja-input`: `GjaInput`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `formularios/input/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaInput".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
