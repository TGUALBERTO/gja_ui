# Spec Delta

## ADDED Requirements

### Requirement: [Comportamento] Ajuda de valor
Com `showValueHelp` (padrão `false`), habilitado e editável, o campo SHALL mostrar no fim, depois do botão de limpar, o ícone acionável `valueHelpIconSrc` (padrão `GjaIcons.popupWindow`), fora da ordem de tabulação. Tocá-lo, ou pressionar F4 ou Alt+seta para baixo com o foco no campo, SHALL chamar `onValueHelpRequest` (`VoidCallback?`), como o evento `valueHelpRequest` do `sap.m.Input`.

#### Scenario: Pedir ajuda de valor
- **GIVEN** um campo com `showValueHelp` e o ícone `GjaIcons.calendar`
- **WHEN** o ícone é tocado, e depois F4 é pressionado com o foco no campo
- **THEN** `onValueHelpRequest` é chamado duas vezes
