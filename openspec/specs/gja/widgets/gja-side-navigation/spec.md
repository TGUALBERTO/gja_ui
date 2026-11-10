# gja/widgets/gja-side-navigation Specification

## Purpose

`GjaSideNavigation` é a navegação lateral do GJA, como o `sap.tnt.SideNavigation` do SAPUI5: uma lista de itens com ícone, que podem ter subitens recolhíveis, itens fixos no pé, o item escolhido destacado e um modo recolhido só com ícones, no padrão controlado (`selectedKey` + `onItemSelect`), para o conteúdo lateral de `GjaToolPage`.

## Requirements

### Requirement: [API] Propriedades
`GjaSideNavigation<T>` SHALL expor, como o `sap.tnt.SideNavigation`:

| Prop | Tipo | Padrão |
|---|---|---|
| `items` | `List<GjaNavigationListItem<T>>` | obrigatória |
| `fixedItems` | `List<GjaNavigationListItem<T>>` | `[]` |
| `selectedKey` | `T?` | `null` |
| `onItemSelect` | `ValueChanged<T>?` | `null` |
| `expanded` | `bool` | `true` |


#### Scenario: Navegação mínima
- **WHEN** uma navegação com os itens "Início", "Pedidos" e "Clientes" e o item fixo "Ajuda" é renderizada numa altura de 600
- **THEN** os três itens ficam empilhados no topo, e "Ajuda" fica no pé, separada por uma linha

### Requirement: [API] Itens válidos
`GjaNavigationListItem<T>`, como o `sap.tnt.NavigationListItem`, SHALL ter `key`, `text`, `icon` (`IconData?`), `enabled` (padrão `true`), `selectable` (padrão `true`) e `items` (subitens, padrão `[]`). `items` MUST NOT ser vazia, as chaves de todos os itens e subitens MUST ser distintas, e os textos MUST NOT ser vazios, ou a renderização MUST falhar em modo debug.

#### Scenario: Navegação com chave repetida
- **WHEN** uma navegação com dois itens de mesma chave é renderizada
- **THEN** a renderização falha em modo debug

### Requirement: [API] Callbacks e controlador
Acionar um item selecionável e habilitado diferente do atual (toque, Enter ou Espaço) SHALL chamar `onItemSelect` com a chave dele, como o evento `itemSelect`. A navegação MUST NOT mudar a escolha sozinha. `GjaSideNavigation` SHALL NOT ter controlador.

#### Scenario: Escolher um item
- **GIVEN** uma navegação cujo `onItemSelect` atualiza `selectedKey`
- **WHEN** "Clientes" é tocado
- **THEN** `onItemSelect` recebe a chave de "Clientes", e ele fica destacado

### Requirement: [Comportamento] Subitens
Um item com subitens SHALL mostrar uma seta no fim e abrir ou fechar os subitens ao ser acionado; os subitens SHALL ficar abaixo dele, recuados. Começam abertos os itens que contêm o `selectedKey`.

#### Scenario: Abrir subitens
- **GIVEN** um item "Vendas" com os subitens "Pedidos" e "Faturas", fechado
- **WHEN** "Vendas" é tocado, e depois "Faturas"
- **THEN** os subitens aparecem recuados, e `onItemSelect` recebe a chave de "Faturas"

### Requirement: [Comportamento] Modo recolhido
Com `expanded` `false`, a navegação SHALL mostrar só os ícones dos itens de primeiro nível, sem subitens (o pai do subitem escolhido fica destacado), com o texto como dica (`GjaTooltip`) e como nome no leitor de tela.

#### Scenario: Navegação recolhida
- **WHEN** uma navegação recolhida é renderizada
- **THEN** ela tem a largura `density.barHeight`, mostra só os ícones, e "Pedidos" é anunciado pelo nome

### Requirement: [Comportamento] Teclado
Com o foco num item, as setas para cima e para baixo SHALL mover o foco ao item visível anterior ou seguinte; a seta para a direita SHALL abrir os subitens, e a seta para a esquerda fechá-los.

#### Scenario: Setas na navegação
- **GIVEN** o foco em "Início", com "Vendas" fechado depois dele
- **WHEN** a seta para baixo e depois a seta para a direita são pressionadas
- **THEN** o foco vai a "Vendas", e os subitens dele aparecem

### Requirement: [Aparência] Tokens de componente
Expandida, a navegação SHALL ter a largura de 5 passos `spacing.xxxl` e o fundo `colors.base`. Cada item SHALL ter a altura `density.listItemHeight`, `spacing.s` no início (mais `icons.control` e `spacing.s` por nível de subitem, alinhando o texto ao do item pai), o ícone `icons.control`, `spacing.s` entre o ícone e o texto e o texto `typography.base` com `colors.text`. O item escolhido SHALL ter o fundo `colors.selectionBackground` e o texto e o ícone `colors.brand`.

#### Scenario: Item escolhido
- **WHEN** uma navegação com "Pedidos" escolhido é renderizada no tema claro
- **THEN** "Pedidos" tem o fundo `selectionBackground` e o texto `brand`, e "Início" o texto `text`

### Requirement: [Estados] Interação
Os itens SHALL apresentar hover (fundo `colors.hoverBackground`), pressionado, foco pelo teclado e desabilitado (opacidade `interaction.disabledOpacity`), de `gja/core/interaction`.

#### Scenario: Item desabilitado
- **GIVEN** um item "Relatórios" com `enabled` `false`
- **WHEN** ele é tocado
- **THEN** `onItemSelect` não é chamado, e ele tem a opacidade `interaction.disabledOpacity`

### Requirement: [Acessibilidade] Semântica e contraste
Cada item SHALL ser exposto como botão com o texto, o estado selecionado, o habilitado e, nos que têm subitens, o estado aberto ou fechado. A navegação SHALL agrupar os itens num nó com o nome `semanticLabel` (`String?`), quando dado. Os textos MUST ter o contraste de texto, e os itens o alvo mínimo.

#### Scenario: Semântica da navegação
- **WHEN** a árvore de semântica de uma navegação com "Pedidos" escolhido e "Vendas" fechado é lida
- **THEN** "Pedidos" é botão selecionado, e "Vendas" é botão com o estado de expansão fechado

#### Scenario: Contraste e alvo da navegação
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a uma navegação, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Altura e direção
A lista de itens SHALL rolar quando passar da altura disponível, com os itens fixos sempre visíveis no pé. Em RTL, o ícone MUST ficar à direita do texto, e a seta à esquerda.

#### Scenario: Navegação em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a navegação é renderizada
- **THEN** o ícone de cada item fica à direita do texto

### Requirement: [Integração] Dependências
`GjaSideNavigation` SHALL depender somente de `gja/core/interaction`, `gja/widgets/gja-tooltip`, `gja/widgets/gja-separator`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Navegação sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** uma navegação com subitens e itens fixos é aberta, recolhida e tocada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaSideNavigation` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da navegação
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da navegação
- **WHEN** os goldens de uma navegação expandida, com subitens abertos e item escolhido, e de uma recolhida são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaSideNavigation` SHALL ter dartdoc em toda API pública e uma página "GjaSideNavigation" na galeria com uma navegação com subitens e itens fixos, que pode ser recolhida.

#### Scenario: Página GjaSideNavigation na galeria
- **GIVEN** a página "GjaSideNavigation" aberta na galeria
- **WHEN** o item "Clientes" é tocado
- **THEN** a página mostra "Página: Clientes"

### Requirement: [Restrições] Fora do escopo
`GjaSideNavigation` SHALL NOT aceitar larguras ou cores literais, nem ter `href`, o popover de subitens no modo recolhido, o desenho `Decorated` ou o item de ação (`design` `Action`).

#### Scenario: Navegação sem valor literal
- **WHEN** a API pública de `GjaSideNavigation` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
