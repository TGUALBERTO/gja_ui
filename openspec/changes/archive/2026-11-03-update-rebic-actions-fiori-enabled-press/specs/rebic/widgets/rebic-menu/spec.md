# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Itens válidos
`RebicMenuItem` SHALL ter, como o `sap.m.MenuItem`, `text`, `enabled` (padrão `true`), `onPress` (`VoidCallback?`), `icon` (`IconData?`), `shortcutText` (`String?`) e `startsSection` (padrão `false`). `items` MUST NOT ser vazia, os textos e `semanticLabel` MUST NOT ser vazios. Fora disso, a criação MUST falhar em modo debug.

#### Scenario: Menu sem itens
- **WHEN** um `RebicMenu` é criado com `items` vazia
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Acionar um item habilitado SHALL fechar o menu pelo `controller` e chamar o `onPress` dele uma vez, sem chamar `onDismiss`. Itens com `enabled` `false` MUST NOT ser acionados. Fechar por toque fora ou Esc SHALL chamar `onDismiss`, como em `rebic/widgets/rebic-popover`.

#### Scenario: Acionar um item
- **GIVEN** um menu aberto com `onDismiss` e o `onPress` de "Copiar" que registram as chamadas
- **WHEN** o item "Copiar" é tocado
- **THEN** o `onPress` de "Copiar" foi chamado uma vez, o menu fechou, e `onDismiss` não foi chamado

#### Scenario: Item desabilitado
- **GIVEN** um menu aberto com o item "Exportar" com `enabled` `false`
- **WHEN** o item "Exportar" é tocado
- **THEN** nenhuma ação é chamada, e o menu continua aberto

### Requirement: [Acessibilidade] Teclado
Ao abrir, o foco MUST ir ao primeiro item habilitado. As setas, Home, End e a primeira letra MUST navegar entre os itens habilitados, como em `rebic/widgets/rebic-dropdown`. Enter e Espaço MUST acionar o item com o foco, e Esc MUST fechar o menu com o foco de volta na âncora.

#### Scenario: Menu pelo teclado
- **GIVEN** os itens "Editar", "Exportar" (desabilitado) e "Excluir", e uma âncora com foco
- **WHEN** o menu abre, e são pressionados seta para baixo e Enter
- **THEN** o foco passa por "Editar" e "Excluir", o `onPress` de "Excluir" é chamado, e o foco volta à âncora

#### Scenario: Primeira letra no menu
- **GIVEN** um menu aberto com o foco em "Editar"
- **WHEN** a tecla C é pressionada
- **THEN** o foco vai para "Copiar"
