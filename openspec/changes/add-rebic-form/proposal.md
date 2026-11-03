# Proposal: Formulário (`add-rebic-form`)

## Why

A Fase 6 pede o formulário. O modelo é o `sap.ui.layout.form.Form` com o `sap.ui.layout.form.ColumnLayout`, o layout
que a SAP recomenda para formulários novos (conferidos em `SAP/openui5`): o formulário tem `title` e
`formContainers`; cada `FormContainer` tem `title` e `formElements`; cada `FormElement` tem `label` e `fields`. O
`ColumnLayout` distribui os contêineres em colunas pela largura do próprio formulário (`columnsM` 1, `columnsL` 2,
`columnsXL` 2) e põe os rótulos ao lado dos campos (`labelCellsLarge` 4 de 12) nas larguras L e XL, e na M com uma
coluna; nas outras, acima. Hoje cada tela monta rótulos e campos à mão.

## What Changes

- Novo `RebicForm`, com `title`, `formContainers` (`RebicFormContainer`, com `title` e `formElements`),
  `columnsM`, `columnsL`, `columnsXL` e `labelCellsLarge`; `RebicFormElement` tem `label`, `required` (o asterisco do
  `RebicLabel`) e `fields`.
- Catálogo: `rebic/widgets/rebic-form` passa a `implemented`, com as dependências da spec; o item
  `rebic/widgets/rebic-form-field` sai (o elemento é uma configuração do formulário, como no UI5), e a validação fica
  para `rebic/core/validation`.
- ADR 0009: estilos dos títulos e espaçamentos.

Fora do escopo: `editable`, `emptyCellsLarge`, os layouts `ResponsiveGridLayout` e `ResponsiveLayout`, a
`SimpleForm`, barras de ferramentas nos títulos, a validação e a distribuição dos elementos de um único contêiner em
várias colunas.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-form`: `RebicForm`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `formularios/form/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicForm".
- `docs/catalog.yaml`, `docs/adr/0009-provisional-horizon-values.md`.
- Portal existente: nenhum impacto.
