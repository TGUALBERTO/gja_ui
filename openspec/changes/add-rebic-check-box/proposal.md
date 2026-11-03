# Proposal: Caixa de seleção (`add-rebic-check-box`)

## Why

A Fase 2 (componentes básicos) pede a caixa de seleção, e o Rebic não tem nenhum controle de formulário. O modelo é o
`sap.m.CheckBox` (conferido em `SAP/openui5`, `sap.m/CheckBox.js` e `themes/base/CheckBox.less`): `selected`,
`partiallySelected`, `enabled`, `editable`, `valueState`, `text`, `wrapping` e o evento `select`; a caixa tem
1,125rem e a borda `sapField_BorderColor`.

## What Changes

- Novo `RebicCheckBox`, controlado (`selected` + `onSelect`), com texto opcional (ou `semanticLabel`), estado parcial,
  somente leitura, estado de valor e quebra do texto.
- Núcleo: `RebicInteractable` ganha `checked`, `mixed`, `toggled` e `inMutuallyExclusiveGroup`, para expor caixa,
  chave e opção de rádio ao leitor de tela sem o papel de botão; serve também ao `RebicSwitch` e ao
  `RebicRadioButton`.
- Catálogo: `rebic/widgets/rebic-checkbox` passa a `rebic/widgets/rebic-check-box` (o nome do UI5), sem depender do
  campo de formulário, que o UI5 não tem; o template de spec e o ADR 0006 passam a citar a regra de nomes revisada
  (`enabled` e evento do UI5, como `selected` + `onSelect`).
- ADR 0009: fundo e borda de somente leitura provisórios.

Fora do escopo: `displayOnly`, `required`, `width`, `useEntireWidth`, `name` e o texto de estado de valor.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-check-box`: `RebicCheckBox`.

### Modified Capabilities

- `rebic/core/interaction`: semântica de marcação e alternância.

## Impact

- `packages/rebic_core`: `RebicInteractable`, testes, CHANGELOG.
- `packages/rebic_widgets`: `formularios/check_box/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicCheckBox".
- `docs/catalog.yaml`, `docs/specs/widget-spec-template.md`, `docs/adr/0006-…`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
