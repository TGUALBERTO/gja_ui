# gja/widgets/gja-toolbar Specification

## Purpose

`GjaToolbar` agrupa ações e controles numa linha horizontal, como o `sap.m.Toolbar` do SAPUI5: os itens ficam lado a lado na altura de barra, com `Spacer` para empurrar itens ao fim e `GjaSeparator.vertical` entre grupos, em três desenhos e dois estilos, e pode ser acionável inteira, como uma barra de informação.

## Requirements

### Requirement: [API] Propriedades
`GjaToolbar` SHALL expor, como o `sap.m.Toolbar`:

| Prop | Tipo | Padrão |
|---|---|---|
| `content` | `List<Widget>` | obrigatória |
| `design` | `GjaToolbarDesign` | `transparent` |
| `style` | `GjaToolbarStyle` | `standard` |
| `onPress` | `VoidCallback?` | `null` |
| `enabled` | `bool` | `true` |
| `semanticLabel` | `String?` | `null` |

`GjaToolbarDesign` SHALL ter `transparent`, `solid` e `info`; `GjaToolbarStyle`, `standard` e `clear`.

#### Scenario: Barra mínima
- **WHEN** `GjaToolbar(content: [título, Spacer(), botão])` é renderizada numa largura de 600
- **THEN** ela tem a altura `density.barHeight`, o título fica no início, e o botão termina perto da borda final

### Requirement: [API] Callbacks e controlador
Com `onPress`, a barra SHALL ser acionável inteira, como o `active` do UI5: toque, Enter e Espaço chamam `onPress` uma vez. Com `enabled` `false`, MUST NOT ser acionada. Sem `onPress`, a barra SHALL NOT ser acionável. `GjaToolbar` SHALL NOT ter controlador.

#### Scenario: Barra acionável
- **GIVEN** uma barra de informação com `onPress` que conta as chamadas
- **WHEN** ela é tocada e, com o foco nela, Enter é pressionado
- **THEN** `onPress` é chamado duas vezes

### Requirement: [Comportamento] Disposição dos itens
Os itens SHALL ficar numa linha, centralizados na altura, com `spacing.xs` entre eles e `spacing.s` nas pontas. Um `Spacer` SHALL ocupar o espaço livre, empurrando os itens seguintes ao fim. Itens que não cabem MUST ser cortados na borda final, sem estouro.

#### Scenario: Barra estreita
- **WHEN** uma barra com cinco botões é renderizada numa largura de 200
- **THEN** não há estouro, e os botões que não cabem ficam cortados na borda final

### Requirement: [Aparência] Desenhos e estilos
`transparent` SHALL ter fundo transparente; `solid`, `colors.base`; `info`, o fundo `background` de `stateColors(information)`. O estilo `standard` SHALL ter uma borda inferior fina `colors.separator`; `clear` nenhuma. Nenhum valor MUST ser literal.

#### Scenario: Desenhos da barra
- **WHEN** barras `transparent`, `solid` e `info`, com estilo `standard`, e uma `clear` são renderizadas no tema claro
- **THEN** os fundos são transparente, `base` e o de `information`, as três primeiras têm a borda inferior `separator`, e a `clear` não tem borda

### Requirement: [Estados] Interação da barra acionável
A barra acionável SHALL apresentar hover e pressionado com o fundo `colors.hoverBackground`, o anel de foco do teclado e, com `enabled` `false`, a opacidade de desabilitado, de `gja/core/interaction`. A barra não acionável SHALL NOT ter estados próprios.

#### Scenario: Hover na barra acionável
- **WHEN** o ponteiro fica sobre uma barra acionável
- **THEN** o fundo passa a `colors.hoverBackground`

### Requirement: [Acessibilidade] Semântica e teclado
A barra SHALL agrupar os itens num nó com o nome `semanticLabel`, quando dado; a acionável SHALL ser exposta como botão. A ordem de foco SHALL seguir a ordem visual dos itens.

#### Scenario: Ordem de foco na barra
- **GIVEN** uma barra com três botões
- **WHEN** Tab é pressionado três vezes a partir do elemento anterior
- **THEN** o foco passa pelos três botões, nessa ordem

#### Scenario: Semântica da barra acionável
- **WHEN** a árvore de semântica de uma barra acionável com o texto "2 filtros ativos" é lida
- **THEN** há um botão com o rótulo "2 filtros ativos" e ação de toque

### Requirement: [Responsividade] Direção e densidade
Em RTL, os itens MUST começar na borda direita. A altura SHALL seguir `density.barHeight` da densidade ativa.

#### Scenario: Barra em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** uma barra com um título e um botão depois de um `Spacer` é renderizada
- **THEN** o título fica à direita, e o botão à esquerda

### Requirement: [Integração] Dependências
`GjaToolbar` SHALL depender somente de `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Barra sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** barras de cada desenho, com botões, separador e `Spacer`, são renderizadas e uma acionável é tocada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaToolbar` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`.

#### Scenario: Rastreabilidade da barra
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da barra
- **WHEN** os goldens de barras de cada desenho e estilo, com título, botões e separador, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaToolbar` SHALL ter dartdoc em toda API pública e uma página "GjaToolbar" na galeria com uma barra de cabeçalho de tabela, uma barra de informação acionável e os desenhos.

#### Scenario: Página GjaToolbar na galeria
- **GIVEN** a página "GjaToolbar" aberta na galeria
- **WHEN** a barra de informação é tocada
- **THEN** a página mostra "Filtros limpos"

### Requirement: [Restrições] Fora do escopo
`GjaToolbar` SHALL NOT aceitar alturas, larguras ou cores literais, nem mover itens para um menu "mais" (o `sap.m.OverflowToolbar`), nem ter `ariaHasPopup`.

#### Scenario: Barra sem valor literal
- **WHEN** a API pública de `GjaToolbar` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
