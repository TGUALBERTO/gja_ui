# Spec Delta

## Purpose

`RebicCard` agrupa informações num cartão, como o `sap.f.Card` do SAPUI5: uma superfície com borda, raio e sombra, um cabeçalho opcional (em geral um `RebicCardHeader`) em cima ou embaixo, separado do conteúdo por uma linha, e o conteúdo sem margem própria.

## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicCard` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `header` | `Widget?` | `null` |
| `headerPosition` | `RebicCardHeaderPosition` | `top` |
| `content` | `Widget?` | `null` |
| `headingLevel` | `RebicTitleLevel` | `h3` |

`RebicCardHeaderPosition` SHALL ter os valores `top` e `bottom`, como o `sap.f.cards.HeaderPosition`.

#### Scenario: Cartão com cabeçalho
- **GIVEN** um `RebicCardHeader` com ícone, `title` "Pedidos pendentes", `subtitle` "Compras" e `statusText` "3 de 5", e um conteúdo, em LTR
- **WHEN** o cartão é renderizado
- **THEN** o cabeçalho fica no topo, e o conteúdo fica abaixo de uma linha `colors.separator`

#### Scenario: Cartão sem cabeçalho
- **WHEN** o cartão recebe só `content`
- **THEN** não há cabeçalho nem linha, e o conteúdo começa no topo do cartão, sem margem

### Requirement: [API] Callbacks e controlador
`RebicCard` SHALL NOT ter callbacks nem controlador: a ação é a `onPress` do cabeçalho. Toques no conteúdo MUST NOT acionar o cabeçalho.

#### Scenario: Cabeçalho acionável
- **GIVEN** um cartão cujo `RebicCardHeader` tem `onPress` que conta as chamadas
- **WHEN** o cabeçalho é tocado e depois o conteúdo é tocado
- **THEN** `onPress` foi chamado uma vez

### Requirement: [Comportamento] Largura e texto
O cartão SHALL ocupar a largura disponível e crescer em altura com o cabeçalho e o conteúdo, como o `width` e o `height` padrão do `sap.f.Card`.

#### Scenario: Cartão na largura disponível
- **GIVEN** um espaço de 300 de largura
- **WHEN** um cartão com um cabeçalho de título longo é renderizado
- **THEN** o cartão mede 300 de largura, o título ocupa no máximo 3 linhas, e não há estouro

### Requirement: [Aparência] Superfície e cabeçalho
O cartão SHALL usar a superfície `colors.base`, a borda `colors.separator`, o raio `radius.tile` e a sombra `shadows.card`, como o `sapTile_Background`, o `sapTile_BorderColor`, o `sapTile_BorderCornerRadius` e o `sapContent_Shadow0`. A linha entre o cabeçalho e o conteúdo SHALL ser `colors.separator`. O conteúdo SHALL NOT ter margem, sem valores literais.

#### Scenario: Superfície do cartão
- **WHEN** um cartão com cabeçalho é renderizado nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda `colors.separator`, o raio `radius.tile`, e há a sombra `shadows.card` de cada tema

#### Scenario: Conteúdo sem margem
- **GIVEN** um cartão com cabeçalho
- **WHEN** ele é renderizado
- **THEN** o conteúdo ocupa toda a largura interna do cartão, começando logo abaixo da linha do cabeçalho

### Requirement: [Estados] Interação do cabeçalho
O cartão SHALL NOT apresentar estados próprios: os estados são os do cabeçalho, conforme `rebic/widgets/rebic-card-header`. O cartão MUST NOT receber o foco.

#### Scenario: Cabeçalho em hover
- **WHEN** o ponteiro fica sobre o cabeçalho acionável de um cartão e depois sai
- **THEN** o fundo do cabeçalho passa ao de hover da família `list` e volta ao normal, e o fundo do cartão não muda

#### Scenario: Cartão sem ação não recebe foco
- **GIVEN** um cartão com cabeçalho sem `onPress` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no cartão

### Requirement: [Acessibilidade] Teclado
O cabeçalho acionável SHALL ser ativado por Enter e Espaço, conforme `rebic/widgets/rebic-card-header`, e o foco MUST passar do cabeçalho ao conteúdo, ou do conteúdo ao cabeçalho com `headerPosition` `bottom`.

#### Scenario: Cabeçalho pelo teclado
- **GIVEN** um cartão com cabeçalho acionável
- **WHEN** Tab leva o foco ao cabeçalho e Enter é pressionado
- **THEN** o `onPress` do cabeçalho é chamado uma vez

### Requirement: [Acessibilidade] Semântica
O título do cabeçalho SHALL ser anunciado com o `headingLevel` do cartão. O conteúdo MUST manter a própria semântica.

#### Scenario: Semântica do cartão
- **WHEN** a árvore de semântica de um cartão com cabeçalho acionável "Pedidos", "Compras" e conteúdo de texto é lida
- **THEN** há um botão com o rótulo "Pedidos, Compras", o título é um cabeçalho de nível 3, e os textos do conteúdo continuam acessíveis

### Requirement: [Acessibilidade] Contraste e alvo
Os textos do cartão MUST manter o contraste sobre `colors.base`, e o cabeçalho acionável MUST atender ao alvo mínimo e ao alvo rotulado, conforme `rebic/foundation/accessibility`.

#### Scenario: Contraste e alvo do cartão
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a um cartão com cabeçalho acionável, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção e escala
Em RTL, o cabeçalho MUST seguir `rebic/widgets/rebic-card-header`. Com escala de texto 2,0, o cartão MUST crescer em altura sem estouro.

#### Scenario: Cartão em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um cartão com cabeçalho com ícone e status é renderizado
- **THEN** o ícone fica junto da borda direita do cartão, e o status junto da esquerda

#### Scenario: Cartão com escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e um espaço de 300 de largura
- **WHEN** um cartão com cabeçalho completo e conteúdo de texto é renderizado
- **THEN** não há estouro

### Requirement: [Integração] Dependências
`RebicCard` SHALL depender somente de `rebic/widgets/rebic-container`, `rebic/widgets/rebic-divider`, `rebic/widgets/rebic-card-header`, `rebic/widgets/rebic-title` (`RebicTitleLevel`), `rebic/foundation/color`, `rebic/foundation/radius`, `rebic/foundation/shadows`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Cartões numa grade sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** três cartões são renderizados numa `RebicGrid`, um com cabeçalho acionável, e o cabeçalho é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicCard` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, com o cabeçalho em cima e embaixo, e a bateria de `rebic/foundation/accessibility` para o cabeçalho acionável.

#### Scenario: Rastreabilidade do cartão
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do cartão
- **WHEN** os goldens de um cartão com cabeçalho em cima, um com cabeçalho embaixo e um sem cabeçalho são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicCard` SHALL ter dartdoc em toda API pública, com um exemplo de cartão com `RebicCardHeader`, e uma página "RebicCard" na galeria com cartões numa grade, um com cabeçalho acionável e um com o cabeçalho embaixo.

#### Scenario: Página RebicCard na galeria
- **WHEN** a página "RebicCard" é aberta e o cabeçalho acionável é tocado
- **THEN** a página mostra a mensagem da ação, e há um cartão com o cabeçalho embaixo

### Requirement: [Restrições] Fora do escopo
`RebicCard` SHALL NOT aceitar larguras, alturas, cores ou espaços literais, nem embutir o cabeçalho ou os conteúdos especializados do UI5 (lista, tabela, analítico).

#### Scenario: Cartão sem valor literal
- **WHEN** a API pública de `RebicCard` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`, nem `title`, `padded` ou `onHeaderPressed`

## REMOVED Requirements

### Requirement: [API] Cabeçalho válido
**Reason**: o cabeçalho passa a ser um `RebicCardHeader` no `header`, e o cartão não recebe mais título, subtítulo, status nem ação.
**Migration**: use `header: RebicCardHeader(title:, subtitle:, statusText:, onPress:)`; os textos do cabeçalho estão em `rebic/widgets/rebic-card-header`.

## ADDED Requirements

### Requirement: [Comportamento] Posição do cabeçalho
Com `headerPosition` `bottom`, o cabeçalho SHALL ficar embaixo do conteúdo, separado dele por uma linha `colors.separator` em cima do cabeçalho, como o `HeaderPosition.Bottom` do `sap.f.Card`.

#### Scenario: Cabeçalho embaixo
- **GIVEN** um cartão com cabeçalho, conteúdo e `headerPosition` `bottom`
- **WHEN** o cartão é renderizado
- **THEN** o conteúdo fica no topo, e o cabeçalho fica embaixo, depois de uma linha `colors.separator`
