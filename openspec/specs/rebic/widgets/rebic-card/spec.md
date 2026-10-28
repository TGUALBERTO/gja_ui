# rebic/widgets/rebic-card Specification

## Purpose

`RebicCard` agrupa informações num cartão, como o `sap.f.Card` do SAPUI5: uma superfície com borda, raio e sombra, um cabeçalho opcional com elemento inicial, título, subtítulo e status, um conteúdo com ou sem margem e um cabeçalho que pode ser acionável para levar ao detalhe.

## Requirements

### Requirement: [API] Propriedades
`RebicCard` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `child` | `Widget` | obrigatória |
| `title` | `String?` | `null` (sem cabeçalho) |
| `subtitle` | `String?` | `null` |
| `status` | `String?` | `null` |
| `leading` | `Widget?` | `null` |
| `padded` | `bool` | `true` |
| `onHeaderPressed` | `VoidCallback?` | `null` |

#### Scenario: Cartão com cabeçalho
- **GIVEN** `leading`, `title` "Pedidos pendentes", `subtitle` "Compras", `status` "3 de 5" e um conteúdo, em LTR
- **WHEN** o cartão é renderizado
- **THEN** o cabeçalho mostra, do início ao fim, o `leading`, o título com o subtítulo abaixo e o status, e o conteúdo fica abaixo de um divisor

#### Scenario: Cartão sem cabeçalho
- **WHEN** o cartão recebe só `child`
- **THEN** não há cabeçalho nem divisor, e o conteúdo começa a `spacing.l` do topo do cartão

### Requirement: [API] Cabeçalho válido
`subtitle`, `status`, `leading` e `onHeaderPressed` MUST ser usados só com `title`. Sem `title`, informá-los MUST falhar em modo debug.

#### Scenario: Subtítulo sem título
- **WHEN** um `RebicCard` é criado com `subtitle` e sem `title`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Com `onHeaderPressed`, o cabeçalho SHALL chamá-lo uma vez por ativação por toque, Enter ou Espaço. Toques no conteúdo MUST NOT chamá-lo. `RebicCard` SHALL NOT ter controlador.

#### Scenario: Cabeçalho acionável
- **GIVEN** um cartão com `onHeaderPressed` que conta as chamadas
- **WHEN** o cabeçalho é tocado e depois o conteúdo é tocado
- **THEN** `onHeaderPressed` foi chamado uma vez

### Requirement: [Comportamento] Largura e texto
O cartão SHALL ocupar a largura disponível. O título e o subtítulo SHALL ter até 2 linhas cada, com reticências, e o status MUST ficar numa linha.

#### Scenario: Cartão na largura disponível
- **GIVEN** um espaço de 300 de largura
- **WHEN** um cartão com título longo é renderizado
- **THEN** o cartão mede 300 de largura, o título ocupa no máximo 2 linhas, e não há estouro

### Requirement: [Aparência] Superfície e cabeçalho
O cartão SHALL usar a superfície `colors.base`, a borda `colors.separator`, o raio `radius.container` e a sombra `elevation.card`. O cabeçalho e o conteúdo com margem SHALL usar o espaço `spacing.l`, e o divisor SHALL ser o sutil de `rebic/widgets/rebic-divider`, sem valores literais.

#### Scenario: Superfície do cartão
- **WHEN** um cartão com cabeçalho é renderizado nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda `colors.separator`, o raio `radius.container`, e há a sombra `elevation.card` de cada tema

#### Scenario: Conteúdo sem margem
- **GIVEN** um cartão com cabeçalho e `padded` `false`
- **WHEN** ele é renderizado
- **THEN** o conteúdo ocupa toda a largura interna do cartão, começando logo abaixo do divisor

### Requirement: [Estados] Interação do cabeçalho
O cabeçalho acionável SHALL usar `colors.hoverBackground` no hover e mostrar o anel de foco só com o foco do teclado. Sem `onHeaderPressed`, o cartão SHALL NOT apresentar estados de interação nem receber o foco.

#### Scenario: Cabeçalho em hover
- **WHEN** o ponteiro fica sobre o cabeçalho acionável e depois sai
- **THEN** o fundo do cabeçalho passa a `colors.hoverBackground` e volta a ser transparente

#### Scenario: Cartão sem ação não recebe foco
- **GIVEN** um cartão sem `onHeaderPressed` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no cartão

### Requirement: [Acessibilidade] Teclado
Com o foco no cabeçalho acionável, Enter e Espaço SHALL ativá-lo, como define `rebic/core/interaction`.

#### Scenario: Cabeçalho pelo teclado
- **GIVEN** um cartão com `onHeaderPressed`
- **WHEN** Tab leva o foco ao cabeçalho e Enter é pressionado
- **THEN** `onHeaderPressed` é chamado uma vez

### Requirement: [Acessibilidade] Semântica
O título SHALL ser exposto como cabeçalho. O cabeçalho acionável MUST ser exposto como botão, com o rótulo "título, subtítulo" e a ação de toque. O conteúdo MUST manter a própria semântica.

#### Scenario: Semântica do cartão
- **WHEN** a árvore de semântica de um cartão com título "Pedidos", subtítulo "Compras" e cabeçalho acionável é lida
- **THEN** há um botão com o rótulo "Pedidos, Compras" e ação de toque, e os textos do conteúdo continuam acessíveis

### Requirement: [Acessibilidade] Contraste e alvo
Os textos do cartão MUST manter o contraste sobre `colors.base`, e o cabeçalho acionável MUST atender ao alvo mínimo e ao alvo rotulado, conforme `rebic/foundation/accessibility`.

#### Scenario: Contraste e alvo do cartão
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a um cartão com cabeçalho acionável, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção e escala
Em RTL, o `leading` MUST ficar à direita e o status à esquerda. Com escala de texto 2,0, o cartão MUST crescer em altura sem estouro.

#### Scenario: Cartão em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um cartão com `leading` e status é renderizado
- **THEN** o `leading` fica junto da borda direita, e o status junto da esquerda

#### Scenario: Cartão com escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e um espaço de 300 de largura
- **WHEN** um cartão com cabeçalho completo e conteúdo de texto é renderizado
- **THEN** não há estouro

### Requirement: [Integração] Dependências
`RebicCard` SHALL depender somente de `rebic/widgets/rebic-container`, `rebic/widgets/rebic-text`, `rebic/widgets/rebic-divider`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/elevation`, `rebic/foundation/typography`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Cartões numa grade sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** três cartões são renderizados numa `RebicGrid`, um com cabeçalho acionável, e o cabeçalho é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicCard` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` aplicável: contraste, semântica e, no cabeçalho acionável, alvo e teclado.

#### Scenario: Rastreabilidade do cartão
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do cartão
- **WHEN** os goldens de um cartão com cabeçalho completo, um sem cabeçalho e um sem margem são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicCard` SHALL ter dartdoc em toda API pública e uma página "RebicCard" na galeria com cartões numa `RebicGrid`, um deles com cabeçalho acionável que mostra uma mensagem.

#### Scenario: Página RebicCard na galeria
- **GIVEN** a página "RebicCard" aberta na galeria
- **WHEN** o cabeçalho do cartão "Pedidos pendentes" é tocado
- **THEN** a página mostra "Abrindo pedidos pendentes"

### Requirement: [Restrições] Fora do escopo
`RebicCard` SHALL NOT aceitar cores, espaços ou tamanhos literais, nem oferecer cabeçalho numérico, rodapé de ações ou o cartão inteiro acionável.

#### Scenario: Cartão sem valor literal
- **WHEN** a API pública de `RebicCard` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `EdgeInsets`
