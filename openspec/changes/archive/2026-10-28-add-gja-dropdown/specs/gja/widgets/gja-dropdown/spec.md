## Purpose

`GjaDropdown` mostra uma lista de itens selecionáveis num popover ancorado, como a lista do `sap.m.Select` do SAPUI5: itens com ícone, rótulo e texto adicional, um item selecionado, itens desabilitados, navegação pelo teclado com busca pela primeira letra e a lista na largura da âncora. É a base de `GjaSelect`, `GjaSearchField` e `GjaMenu`; o campo, a seleção múltipla e o filtro por texto ficam fora do escopo.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaDropdown<T>` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `GjaPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `items` | `List<GjaDropdownItem<T>>` | obrigatória |
| `onSelected` | `ValueChanged<T>` | obrigatória |
| `semanticLabel` | `String` | obrigatória |
| `selected` | `T?` | `null` |
| `side` | `GjaOverlaySide` | `below` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Dropdown com itens
- **GIVEN** os itens "Em aberto" (com ícone), "Aprovado" (com o texto adicional "12") e "Rejeitado", em LTR
- **WHEN** o dropdown é aberto
- **THEN** os itens aparecem nessa ordem, um abaixo do outro, o ícone antes do rótulo e "12" junto da borda final do item

#### Scenario: Item selecionado
- **GIVEN** `selected` igual ao valor de "Aprovado"
- **WHEN** o dropdown é aberto
- **THEN** só o item "Aprovado" está no estado selecionado

### Requirement: [API] Itens válidos
`GjaDropdownItem<T>` SHALL ter `value`, `label`, `icon` (`IconData?`), `additionalText` (`String?`) e `enabled` (padrão `true`). `items` MUST NOT ser vazia, os valores MUST ser distintos e os rótulos MUST NOT ser vazios, e `semanticLabel` MUST NOT ser vazio. Fora disso, a criação MUST falhar em modo debug.

#### Scenario: Valores repetidos
- **WHEN** um `GjaDropdown` é criado com dois itens de mesmo valor
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Escolher um item habilitado SHALL chamar `onSelected` uma vez com o valor dele e fechar o dropdown pelo `controller`, sem chamar `onDismiss`. Itens desabilitados MUST NOT ser escolhidos. Fechar por toque fora ou Esc SHALL chamar `onDismiss`, como em `gja/widgets/gja-popover`.

#### Scenario: Escolha de um item
- **GIVEN** um dropdown aberto com `onSelected` e `onDismiss` que registram as chamadas
- **WHEN** o item "Aprovado" é tocado
- **THEN** `onSelected` foi chamado uma vez com o valor de "Aprovado", o dropdown fechou, e `onDismiss` não foi chamado

#### Scenario: Item desabilitado
- **GIVEN** um dropdown aberto com o item "Arquivado" desabilitado
- **WHEN** o item "Arquivado" é tocado
- **THEN** `onSelected` não é chamado, e o dropdown continua aberto

### Requirement: [Comportamento] Largura e texto
O dropdown SHALL usar o popover com `width` `anchor`, sem título, sem ações e sem margem. A lista fica na largura da âncora, com o mínimo do popover. Cada rótulo SHALL ficar em uma linha, com reticências, e o texto adicional MUST continuar visível.

#### Scenario: Lista na largura da âncora
- **GIVEN** uma âncora de 300 de largura numa tela larga
- **WHEN** o dropdown é aberto
- **THEN** a lista e cada item têm 300 de largura

#### Scenario: Âncora estreita
- **GIVEN** uma âncora de 40 de largura numa tela larga
- **WHEN** o dropdown é aberto
- **THEN** a lista tem 4 passos `spacing.xxxl` de largura

#### Scenario: Rótulo longo
- **GIVEN** um item com rótulo muito maior que a lista e o texto adicional "12"
- **WHEN** o dropdown é aberto
- **THEN** o rótulo fica em uma linha com reticências, "12" está visível, e não há estouro

### Requirement: [Aparência] Itens da lista
Os itens SHALL usar as cores da família `list` de `gja/foundation/interaction-states`, a altura mínima `density.controlHeight`, o espaço horizontal `spacing.m`, o espaço `spacing.s` entre ícone, rótulo e texto adicional, o rótulo na variante `body` e o texto adicional no tom `muted`, sem valores literais.

#### Scenario: Itens da lista
- **WHEN** um dropdown com ícones é aberto nos temas claro e escuro, nas duas densidades
- **THEN** cada item tem o fundo e o texto da família `list` no estado normal, a altura `density.controlHeight`, e o ícone começa a `spacing.m` da borda inicial

### Requirement: [Estados] Hover, ativo, selecionado e desabilitado
Os itens SHALL mostrar os estados normal, hover, ativo, selecionado, selecionado com hover e desabilitado da família `list`, e o anel de foco só com o foco do teclado. O item desabilitado MUST usar a aparência desabilitada de `gja/foundation/interaction-states`.

#### Scenario: Item em hover
- **WHEN** o ponteiro fica sobre um item não selecionado e depois sobre o item selecionado
- **THEN** o primeiro usa `colors.hoverBackground`, e o segundo usa `colors.selectionHoverBackground`

#### Scenario: Aparência do item desabilitado
- **WHEN** um dropdown com um item desabilitado é aberto
- **THEN** o item desabilitado tem a aparência desabilitada, e os demais não

### Requirement: [Acessibilidade] Teclado
Ao abrir, o foco MUST ir ao item selecionado habilitado ou, sem ele, ao primeiro item habilitado. As setas MUST mover entre itens habilitados, sem dar a volta; Home e End MUST ir ao primeiro e ao último. Uma letra MUST levar ao próximo item cujo rótulo começa com ela. Enter e Espaço MUST escolher, e Esc MUST fechar com o foco de volta na âncora.

#### Scenario: Navegação pelas setas
- **GIVEN** os itens "Em aberto", "Aprovado", "Arquivado" (desabilitado) e "Rejeitado", com "Aprovado" selecionado
- **WHEN** o dropdown abre, e são pressionados seta para baixo, seta para baixo, Home e Enter
- **THEN** o foco passa por "Aprovado", "Rejeitado", "Rejeitado" e "Em aberto", `onSelected` recebe o valor de "Em aberto", e o foco volta à âncora

#### Scenario: Busca pela primeira letra
- **GIVEN** um dropdown aberto com o foco em "Em aberto"
- **WHEN** a tecla R é pressionada
- **THEN** o foco vai para "Rejeitado"

### Requirement: [Acessibilidade] Semântica
Cada item MUST ser exposto como botão com o rótulo do item (mais o texto adicional, quando há), o estado selecionado e o estado habilitado, dentro da rota do popover nomeada por `semanticLabel`.

#### Scenario: Semântica dos itens
- **WHEN** a árvore de semântica de um dropdown aberto com `semanticLabel` "Status", "Aprovado" selecionado e "Arquivado" desabilitado é lida
- **THEN** há uma rota nomeada "Status"; "Aprovado" é um botão selecionado e habilitado; "Arquivado" é um botão não habilitado

### Requirement: [Acessibilidade] Contraste e alvo
Os textos dos itens MUST manter o contraste nos estados normal e selecionado, e os itens MUST atender ao alvo mínimo e ao alvo rotulado, conforme `gja/foundation/accessibility`.

#### Scenario: Contraste e alvo do dropdown
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a um dropdown aberto com um item selecionado, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção e escala
Em RTL, o ícone MUST ficar junto da borda direita do item, e o texto adicional junto da esquerda. Com escala de texto 2,0, os itens MUST crescer em altura, e a lista MUST rolar dentro da tela, sem estouro.

#### Scenario: Dropdown em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um dropdown com ícone e texto adicional é aberto
- **THEN** o ícone fica junto da borda direita do item, e o texto adicional junto da esquerda

#### Scenario: Dropdown com escala de texto 2,0
- **GIVEN** a escala de texto 2,0, uma tela de 400 × 400 e 12 itens
- **WHEN** o dropdown é aberto e rolado até o fim
- **THEN** não há estouro, e o último item fica visível

### Requirement: [Integração] Dependências
`GjaDropdown` SHALL depender somente de `gja/widgets/gja-popover`, `gja/widgets/gja-text`, `gja/widgets/gja-icon`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/typography`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Dropdown sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um `GjaButton` abre um dropdown, e um item é escolhido
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaDropdown` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` aplicável: contraste, alvo, semântica e teclado.

#### Scenario: Rastreabilidade do dropdown
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do dropdown
- **WHEN** os goldens de um dropdown aberto, com ícones, texto adicional, um item selecionado e um desabilitado, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaDropdown` e `GjaDropdownItem` SHALL ter dartdoc em toda API pública. A galeria SHALL ter uma página "GjaDropdown" com um botão "Status" que abre um dropdown de situações e mostra a escolhida.

#### Scenario: Página GjaDropdown na galeria
- **GIVEN** a página "GjaDropdown" aberta na galeria
- **WHEN** o botão "Status: Em aberto" é tocado e o item "Aprovado" é escolhido
- **THEN** o dropdown fecha, e o botão passa a mostrar "Status: Aprovado"

### Requirement: [Restrições] Fora do escopo
`GjaDropdown` SHALL NOT aceitar cores, espaços ou tamanhos literais, nem oferecer seleção múltipla, grupos, separadores, filtro por texto ou itens com conteúdo livre.

#### Scenario: Dropdown sem valor literal
- **WHEN** a API pública de `GjaDropdown` e de `GjaDropdownItem` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `EdgeInsets`
