# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaDropdown<T>`, a lista do `sap.m.Select`, SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `GjaPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `items` | `List<GjaDropdownItem<T>>` | obrigatória |
| `onSelectionChange` | `ValueChanged<T>` | obrigatória |
| `semanticLabel` | `String` | obrigatória |
| `selectedKey` | `T?` | `null` |
| `placement` | `GjaPlacement` | `bottom` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Dropdown com itens
- **GIVEN** os itens "Em aberto" (com ícone), "Aprovado" (com o texto adicional "12") e "Rejeitado", em LTR
- **WHEN** o dropdown é aberto
- **THEN** os itens aparecem nessa ordem, um abaixo do outro, o ícone antes do texto e "12" junto da borda final do item

#### Scenario: Item selecionado
- **GIVEN** `selectedKey` igual à chave de "Aprovado"
- **WHEN** o dropdown é aberto
- **THEN** só o item "Aprovado" está no estado selecionado

### Requirement: [API] Itens válidos
`GjaDropdownItem<T>`, como o `sap.ui.core.ListItem`, SHALL ter `key`, `text`, `icon` (`IconData?`), `additionalText` (`String?`) e `enabled` (padrão `true`). `items` MUST NOT ser vazia, as chaves MUST ser distintas e os textos MUST NOT ser vazios, e `semanticLabel` MUST NOT ser vazio. Fora disso, a criação MUST falhar em modo debug.

#### Scenario: Valores repetidos
- **WHEN** um `GjaDropdown` é criado com dois itens de mesma chave
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Escolher um item habilitado SHALL chamar `onSelectionChange` uma vez com a chave dele, como o evento `selectionChange`, e fechar o dropdown pelo `controller`, sem chamar `onDismiss`. Itens desabilitados MUST NOT ser escolhidos. Fechar por toque fora ou Esc SHALL chamar `onDismiss`, como em `gja/widgets/gja-popover`.

#### Scenario: Escolha de um item
- **GIVEN** um dropdown aberto com `onSelectionChange` e `onDismiss` que registram as chamadas
- **WHEN** o item "Aprovado" é tocado
- **THEN** `onSelectionChange` foi chamado uma vez com a chave de "Aprovado", o dropdown fechou, e `onDismiss` não foi chamado

#### Scenario: Item desabilitado
- **GIVEN** um dropdown aberto com o item "Arquivado" desabilitado
- **WHEN** o item "Arquivado" é tocado
- **THEN** `onSelectionChange` não é chamado, e o dropdown continua aberto

### Requirement: [Acessibilidade] Teclado
Ao abrir, o foco MUST ir ao item selecionado habilitado ou, sem ele, ao primeiro item habilitado. As setas MUST mover entre itens habilitados, sem dar a volta; Home e End MUST ir ao primeiro e ao último. Uma letra MUST levar ao próximo item cujo texto começa com ela. Enter e Espaço MUST escolher, e Esc MUST fechar com o foco de volta na âncora.

#### Scenario: Navegação pelas setas
- **GIVEN** os itens "Em aberto", "Aprovado", "Arquivado" (desabilitado) e "Rejeitado", com "Aprovado" selecionado
- **WHEN** o dropdown abre, e são pressionados seta para baixo, seta para baixo, Home e Enter
- **THEN** o foco passa por "Aprovado", "Rejeitado", "Rejeitado" e "Em aberto", `onSelectionChange` recebe a chave de "Em aberto", e o foco volta à âncora

#### Scenario: Busca pela primeira letra
- **GIVEN** um dropdown aberto com o foco em "Em aberto"
- **WHEN** a tecla R é pressionada
- **THEN** o foco vai para "Rejeitado"
