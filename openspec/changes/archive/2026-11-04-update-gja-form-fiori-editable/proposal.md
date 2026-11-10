# Proposal: Formulário de exibição (`update-gja-form-fiori-editable`)

## Why

O `sap.ui.layout.form.Form` (conferido em `SAP/openui5`) tem `editable`, com padrão `false`: o formulário Fiori
serve tanto para mostrar valores (objeto em exibição, com `sap.m.Text`) quanto para editá-los (com campos de entrada).
No `ColumnLayout`, o modo muda o alinhamento do rótulo: na edição, ele acompanha a altura dos campos; na exibição,
fica alinhado ao topo do texto. O `GjaForm` só tinha o alinhamento da edição, o que desalinha rótulo e texto em
telas de exibição.

## What Changes

- **BREAKING (leve)** `GjaForm` ganha `editable`, com o padrão `false` do UI5; formulários com campos de entrada
  passam `editable: true` para manter o alinhamento de hoje.
- A galeria mostra um formulário de exibição e o de edição; testes, goldens e CHANGELOG.

Fora do escopo: trocar os campos sozinho (no UI5 também é a aplicação que põe `Text` ou `Input`) e o anúncio de
formulário editável ao leitor de tela.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-form`: `editable`.

## Impact

- `packages/gja_widgets`: formulário, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: páginas "GjaForm" e "GjaDatePicker".
- Portal existente: nenhum impacto.
