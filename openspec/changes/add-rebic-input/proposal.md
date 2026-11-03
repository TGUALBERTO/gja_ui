# Proposal: Campo de texto (`add-rebic-input`)

## Why

A Fase 2 pede o campo de texto. O modelo é o `sap.m.Input` (conferido em `SAP/openui5`, `sap.m/InputBase.js` e
`Input.js`): `value`, `placeholder`, `type`, `enabled`, `editable`, `valueState`, `valueStateText`, `maxLength`,
`showClearIcon` e os eventos `liveChange`, `change` e `submit`. No Horizon, `sapField_Background` é branco,
`sapField_BorderColor` cinza-azulado, `sapField_Hover_BorderColor` a cor da marca, `sapField_BorderCornerRadius`
0,25rem e `sapField_ReadOnly_Background` cinza claro.

## What Changes

- Novo `RebicInput`, controlado (`value` + `onLiveChange`), com `onChange`, `onSubmit`, `placeholder`,
  `semanticLabel`, `type` (`RebicInputType`), `enabled`, `editable`, `valueState`, `valueStateText`, `maxLength`,
  `showClearIcon` e `focusNode`, desenhado com o `EditableText` do Flutter, sem Material.
- A mensagem de estado de valor aparece abaixo do campo enquanto ele tem o foco (no UI5, num popup abaixo do campo).
- Catálogo: `rebic/widgets/rebic-text-field` passa a `rebic/widgets/rebic-input` (o nome do UI5), sem depender do
  campo de formulário; quem citava o campo de texto passa a citar o novo id.
- ADR 0009: fundo somente leitura, borda de foco e mensagem de estado em linha.

Fora do escopo: sugestões, `showValueHelp`, `description`, `width`, máscara e várias linhas (`RebicTextArea`).

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-input`: `RebicInput`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `formularios/input/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicInput".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
