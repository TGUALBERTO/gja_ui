# Proposal: Caixa de seleção (`add-gja-check-box`)

## Why

A Fase 2 (componentes básicos) pede a caixa de seleção, e o GJA não tem nenhum controle de formulário. O modelo é o
`sap.m.CheckBox` (conferido em `SAP/openui5`, `sap.m/CheckBox.js` e `themes/base/CheckBox.less`): `selected`,
`partiallySelected`, `enabled`, `editable`, `valueState`, `text`, `wrapping` e o evento `select`; a caixa tem
1,125rem e a borda `sapField_BorderColor`.

## What Changes

- Novo `GjaCheckBox`, controlado (`selected` + `onSelect`), com texto opcional (ou `semanticLabel`), estado parcial,
  somente leitura, estado de valor e quebra do texto.
- Núcleo: `GjaInteractable` ganha `checked`, `mixed`, `toggled` e `inMutuallyExclusiveGroup`, para expor caixa,
  chave e opção de rádio ao leitor de tela sem o papel de botão; serve também ao `GjaSwitch` e ao
  `GjaRadioButton`.
- Catálogo: `gja/widgets/gja-checkbox` passa a `gja/widgets/gja-check-box` (o nome do UI5), sem depender do
  campo de formulário, que o UI5 não tem; o template de spec e o ADR 0006 passam a citar a regra de nomes revisada
  (`enabled` e evento do UI5, como `selected` + `onSelect`).
- ADR 0009: fundo e borda de somente leitura provisórios.

Fora do escopo: `displayOnly`, `required`, `width`, `useEntireWidth`, `name` e o texto de estado de valor.

## Capabilities

### New Capabilities

- `gja/widgets/gja-check-box`: `GjaCheckBox`.

### Modified Capabilities

- `gja/core/interaction`: semântica de marcação e alternância.

## Impact

- `packages/gja_core`: `GjaInteractable`, testes, CHANGELOG.
- `packages/gja_widgets`: `formularios/check_box/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaCheckBox".
- `docs/catalog.yaml`, `docs/specs/widget-spec-template.md`, `docs/adr/0006-…`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
