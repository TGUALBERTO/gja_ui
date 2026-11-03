# rebic/widgets/rebic-menu Specification

## Purpose

`RebicMenu` mostra uma lista de ações num popover ancorado, como o `sap.m.Menu` do SAPUI5: itens com ícone, rótulo e atalho exibido, divisores de seção, itens desabilitados, navegação pelo teclado com busca pela primeira letra e semântica de menu. Reaproveita a lista do `RebicDropdown`, sem item selecionado. Submenus, itens marcáveis e atalhos registrados ficam fora do escopo.

## Requirements


### Requirement: [API] Propriedades
`RebicMenu` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `RebicPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `items` | `List<RebicMenuItem>` | obrigatória |
| `semanticLabel` | `String` | obrigatória |
| `placement` | `RebicPlacement` | `bottom` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Menu com itens
- **GIVEN** os itens "Editar" (ícone e atalho "Ctrl+E"), "Copiar" e "Exportar", em LTR
- **WHEN** o menu é aberto
- **THEN** os itens aparecem nessa ordem, um abaixo do outro, o ícone antes do rótulo e "Ctrl+E" junto da borda final do item

#### Scenario: Separador de seção
- **GIVEN** os itens "Editar", "Copiar" e "Excluir", este com `startsSection`
- **WHEN** o menu é aberto
- **THEN** há um único divisor, entre "Copiar" e "Excluir"

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

### Requirement: [Comportamento] Largura e texto
O menu SHALL usar a largura da âncora, com o mínimo de 6 passos `spacing.xxxl`, como `rebic/widgets/rebic-dropdown`. Cada rótulo SHALL ficar em uma linha, com reticências, e o atalho MUST continuar visível.

#### Scenario: Menu na largura da âncora
- **GIVEN** uma âncora de 300 de largura numa tela larga
- **WHEN** o menu é aberto
- **THEN** o menu e cada item têm 300 de largura

#### Scenario: Menu sob âncora estreita
- **GIVEN** um botão de ícone como âncora, numa tela larga
- **WHEN** o menu é aberto
- **THEN** o menu tem 6 passos `spacing.xxxl` de largura, e a borda inicial dele coincide com a do botão

### Requirement: [Aparência] Itens e seções
Os itens SHALL ter a aparência dos itens de `rebic/widgets/rebic-dropdown`: cores da família `list`, altura mínima `density.controlHeight`, espaço horizontal `spacing.m` e espaço `spacing.s` entre ícone, rótulo e atalho, este em `typography.base` com `colors.label`. O separador de seção SHALL ser o horizontal de `rebic/widgets/rebic-separator`, sem valores literais.

#### Scenario: Itens do menu
- **WHEN** um menu com ícones e uma seção é aberto nos temas claro e escuro, nas duas densidades
- **THEN** cada item tem o fundo e o texto da família `list` no estado normal, a altura `density.controlHeight`, e o separador de seção é um `RebicSeparator` horizontal

### Requirement: [Estados] Hover, ativo e desabilitado
Os itens SHALL mostrar os estados normal, hover, ativo e desabilitado da família `list` e o anel de foco só com o foco do teclado. O menu SHALL NOT ter item selecionado.

#### Scenario: Item do menu em hover
- **WHEN** o ponteiro fica sobre o item "Copiar"
- **THEN** o fundo dele é `colors.hoverBackground`

#### Scenario: Menu sem item selecionado
- **WHEN** um menu é aberto, um item é acionado e o menu é aberto de novo
- **THEN** nenhum item está no estado selecionado nas duas aberturas

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

### Requirement: [Acessibilidade] Semântica
A lista MUST ser exposta com o papel `menu` e cada item com o papel `menuItem` (`SemanticsRole`), com o rótulo do item (mais o atalho, quando há), a ação de toque e o estado habilitado, dentro da rota do popover nomeada por `semanticLabel`.

#### Scenario: Semântica do menu
- **WHEN** a árvore de semântica de um menu aberto com `semanticLabel` "Ações", "Editar" com atalho "Ctrl+E" e "Exportar" desabilitado é lida
- **THEN** há uma rota nomeada "Ações" com um nó de papel `menu`; "Editar, Ctrl+E" tem o papel `menuItem` e está habilitado; "Exportar" tem o papel `menuItem` e não está habilitado

### Requirement: [Acessibilidade] Contraste e alvo
Os textos dos itens MUST manter o contraste, e os itens MUST atender ao alvo mínimo e ao alvo rotulado, conforme `rebic/foundation/accessibility`.

#### Scenario: Contraste e alvo do menu
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a um menu aberto com atalhos e uma seção, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção e escala
Em RTL, o ícone MUST ficar junto da borda direita do item, e o atalho junto da esquerda. Com escala de texto 2,0, os itens MUST crescer em altura, e o menu MUST rolar dentro da tela, sem estouro.

#### Scenario: Menu em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um menu com ícone e atalho é aberto
- **THEN** o ícone fica junto da borda direita do item, e o atalho junto da esquerda

#### Scenario: Menu com escala de texto 2,0
- **GIVEN** a escala de texto 2,0, uma tela de 400 × 400 e 10 itens com uma seção
- **WHEN** o menu é aberto e rolado até o fim
- **THEN** não há estouro, e o último item fica visível

### Requirement: [Integração] Dependências
`RebicMenu` SHALL depender somente de `rebic/widgets/rebic-dropdown`, `rebic/widgets/rebic-popover`, `rebic/widgets/rebic-separator`, `rebic/widgets/rebic-icon`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/typography`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Menu sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um `RebicButton` abre um menu, e um item é acionado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicMenu` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` aplicável: contraste, alvo, semântica e teclado. Os testes do `RebicDropdown` MUST continuar passando após a extração da lista.

#### Scenario: Rastreabilidade do menu
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do menu
- **WHEN** os goldens de um menu aberto, com ícones, atalhos, uma seção e um item desabilitado, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicMenu` e `RebicMenuItem` SHALL ter dartdoc em toda API pública. A galeria SHALL ter uma página "RebicMenu" com um botão "Ações" que abre um menu com seções e mostra a última ação acionada.

#### Scenario: Página RebicMenu na galeria
- **GIVEN** a página "RebicMenu" aberta na galeria
- **WHEN** o botão "Ações" é tocado e o item "Copiar" é acionado
- **THEN** o menu fecha, e a página mostra "Última ação: Copiar"

### Requirement: [Restrições] Fora do escopo
`RebicMenu` SHALL NOT aceitar cores, espaços ou tamanhos literais, nem oferecer submenus, itens marcáveis, item selecionado ou atalhos registrados.

#### Scenario: Menu sem valor literal
- **WHEN** a API pública de `RebicMenu` e de `RebicMenuItem` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `EdgeInsets`
