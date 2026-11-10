# gja/widgets/gja-popover Specification

## Purpose

`GjaPopover` mostra um painel leve junto de uma âncora, como o `sap.m.Popover` do SAPUI5: uma superfície com raio e sombra, um cabeçalho opcional com título, um conteúdo rolável com ou sem margem e um rodapé opcional de ações. Ele abre e fecha por um controlador, fecha sozinho com toque fora ou Esc, prende o foco enquanto aberto e é anunciado como um diálogo nomeado. Seta, modo modal e versão responsiva ficam fora do escopo.

## Requirements


### Requirement: [API] Propriedades
`GjaPopover` SHALL expor, além de `placement`, `alignment` e `width` (ver `[API] Posição e largura`):

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `GjaPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `content` | `Widget` | obrigatória |
| `title` | `String?` | `null` |
| `actions` | `List<Widget>` | `[]` |
| `padded` | `bool` | `true` |
| `semanticLabel` | `String?` | `null` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Popover com cabeçalho e rodapé
- **GIVEN** `title` "Filtros", um conteúdo e as ações "Aplicar" e "Cancelar"
- **WHEN** o popover é aberto
- **THEN** de cima para baixo há o título, um divisor, o conteúdo, um divisor e o rodapé, com as ações juntas da borda final

#### Scenario: Popover só com conteúdo
- **WHEN** o popover é aberto só com `content` e `semanticLabel`
- **THEN** não há cabeçalho, rodapé nem divisores, e o conteúdo começa a `spacing.l` do topo do popover

### Requirement: [API] Posição e largura
`GjaPopover` SHALL expor `placement` (`GjaPlacement`, padrão `bottom`), `alignment` (`GjaOverlayAlignment`, padrão `start`) e `width` (`GjaPopoverWidth`, padrão `standard`). `GjaPopoverWidth` SHALL ter `anchor` (6 passos `spacing.xxxl`, para listas na largura da âncora), `standard` (8 passos) e `wide` (12 passos), para conteúdos largos como tabelas.

#### Scenario: Popover largo
- **GIVEN** `width` `wide` e uma âncora estreita, numa tela larga
- **WHEN** o popover é aberto
- **THEN** o popover tem 12 passos `spacing.xxxl` de largura

#### Scenario: Popover na largura da âncora
- **GIVEN** `width` `anchor`, numa tela larga
- **WHEN** o popover é aberto sob uma âncora de 10 passos `spacing.xxxl` e, em outra abertura, sob uma âncora de 1 passo
- **THEN** o popover tem 10 passos na primeira vez e 6 passos na segunda

### Requirement: [API] Rótulo obrigatório
`title` ou `semanticLabel` MUST ser informado, e nenhum deles pode ser vazio. Sem rótulo, a criação MUST falhar em modo debug.

#### Scenario: Popover sem rótulo
- **WHEN** um `GjaPopover` é criado sem `title` e sem `semanticLabel`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
`GjaPopoverController` SHALL ter `open()`, `close()`, `toggle()` e `isOpen`, e avisar os ouvintes a cada mudança. `onDismiss` SHALL ser chamado uma vez quando o popover fecha por toque fora ou Esc, e MUST NOT ser chamado quando fecha por `close()` ou `toggle()`.

#### Scenario: Abrir e fechar pelo controlador
- **GIVEN** um popover fechado com `onDismiss` que conta as chamadas
- **WHEN** `toggle()` é chamado e depois `close()`
- **THEN** `isOpen` passa a verdadeiro e o conteúdo aparece, depois volta a falso e o conteúdo some, e `onDismiss` não foi chamado

#### Scenario: Dispensa avisada
- **GIVEN** um popover aberto com `onDismiss` que conta as chamadas
- **WHEN** um ponto fora do popover e da âncora é tocado
- **THEN** o popover fecha, `isOpen` é falso, e `onDismiss` foi chamado uma vez

### Requirement: [Comportamento] Posição, largura e rolagem
O popover SHALL abrir na posição e no alinhamento pedidos, com a inversão, o afastamento e o limite de tela de `gja/core/overlay`. A largura SHALL ser a maior entre a de `width` e a da âncora, limitada pela área da sobreposição, e MUST NOT seguir o conteúdo. A altura MUST caber na área: só o conteúdo rola, e cabeçalho e rodapé ficam visíveis.

#### Scenario: Popover abaixo da âncora
- **GIVEN** uma âncora no alto da tela, `placement` `bottom` e `alignment` `start`, em LTR
- **WHEN** o popover é aberto
- **THEN** o topo do popover fica a `spacing.xs` abaixo da base da âncora, e as bordas iniciais coincidem

#### Scenario: Largura padrão
- **WHEN** um popover com o conteúdo "Ok" e outro com um parágrafo longo são abertos numa tela larga, com âncoras estreitas
- **THEN** os dois têm a largura `standard`, e o parágrafo quebra em linhas

#### Scenario: Âncora mais larga que o popover
- **GIVEN** uma âncora mais larga que a largura `standard`, numa tela larga
- **WHEN** o popover é aberto abaixo dela
- **THEN** o popover tem a largura da âncora

#### Scenario: Conteúdo rolável
- **GIVEN** uma tela de 400 de altura e um popover com título, ações e um conteúdo de 30 linhas
- **WHEN** o popover é aberto e o conteúdo é rolado até o fim
- **THEN** não há estouro, o título e as ações continuam visíveis, e a última linha fica visível

### Requirement: [Aparência] Superfície, cabeçalho e rodapé
O popover SHALL usar a superfície `colors.base`, sem borda, o raio `radius.popover` e a sombra `shadows.popover`. Cabeçalho e conteúdo com margem SHALL usar `spacing.l`, o rodapé SHALL usar `spacing.s` com ações separadas por `spacing.xs`, e os separadores SHALL ser os horizontais de `gja/widgets/gja-separator`, sem valores literais.

#### Scenario: Superfície do popover
- **WHEN** um popover com cabeçalho é aberto nos temas claro e escuro
- **THEN** o fundo é `colors.base`, não há borda, o raio é `radius.popover`, e há a sombra `shadows.popover` de cada tema

### Requirement: [Estados] Aberto e fechado
O popover SHALL ter só os estados aberto e fechado. Fechado, ele MUST NOT ocupar a tela nem receber toques ou foco. Ele SHALL NOT ter hover, pressionado ou desabilitado próprios; os estados ficam com os elementos do conteúdo e com a âncora.

#### Scenario: Popover fechado
- **GIVEN** um popover fechado cuja âncora é um botão
- **WHEN** a tela é renderizada e o botão é tocado
- **THEN** o conteúdo do popover não está na árvore, e a ação do botão é chamada

### Requirement: [Acessibilidade] Teclado
Ao abrir, o foco MUST ir ao primeiro elemento focável do conteúdo ou do rodapé. Tab e Shift+Tab MUST circular só dentro do popover. Esc MUST fechá-lo, e o foco MUST voltar à âncora, conforme `gja/core/overlay`.

#### Scenario: Popover pelo teclado
- **GIVEN** uma âncora com foco que abre um popover com dois elementos focáveis
- **WHEN** o popover abre, Tab é pressionado duas vezes e depois Esc
- **THEN** o foco vai ao primeiro, ao segundo e de novo ao primeiro elemento, e depois o popover fecha com o foco de volta na âncora

### Requirement: [Acessibilidade] Semântica
O popover aberto MUST ser exposto como uma rota com nome, rotulada por `title` ou por `semanticLabel`, como o `role="dialog"` do UI5. O título MUST ser exposto como cabeçalho, e o conteúdo e as ações MUST manter a própria semântica.

#### Scenario: Semântica do popover
- **WHEN** a árvore de semântica de um popover aberto com título "Filtros" e a ação "Aplicar" é lida
- **THEN** há um nó que delimita e nomeia a rota com o rótulo "Filtros", e o botão "Aplicar" continua acessível dentro dele

### Requirement: [Acessibilidade] Contraste e alvo
Os textos do popover MUST manter o contraste sobre `colors.base`, e as ações do rodapé MUST atender ao alvo mínimo e ao alvo rotulado, conforme `gja/foundation/accessibility`.

#### Scenario: Contraste e alvo do popover
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a um popover aberto com cabeçalho e ações, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção e escala
Em RTL, o alinhamento `start` MUST juntar as bordas direitas do popover e da âncora, e as ações MUST ficar junto da borda esquerda. Com escala de texto 2,0, o popover MUST continuar dentro da tela, rolando o conteúdo, sem estouro.

#### Scenario: Popover em RTL
- **GIVEN** a direção do texto da direita para a esquerda, `alignment` `start` e ações no rodapé
- **WHEN** o popover é aberto abaixo de uma âncora
- **THEN** as bordas direitas do popover e da âncora coincidem, e a última ação fica junto da borda esquerda do popover

#### Scenario: Popover com escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e uma tela de 400 × 400
- **WHEN** um popover com título, ações e um parágrafo é aberto
- **THEN** não há estouro, e o popover fica dentro da tela

### Requirement: [Integração] Dependências
`GjaPopover` SHALL depender somente de `gja/core/overlay`, `gja/core/interaction`, `gja/widgets/gja-container`, `gja/widgets/gja-title`, `gja/widgets/gja-separator`, `gja/widgets/gja-spacing`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/typography`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Popover sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um `GjaButton` abre um popover com ações, e uma ação o fecha
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaPopover` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` aplicável: contraste, alvo, semântica e teclado.

#### Scenario: Rastreabilidade do popover
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do popover
- **WHEN** os goldens de um popover aberto com cabeçalho, conteúdo e ações, e de outro só com conteúdo, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaPopover` e `GjaPopoverController` SHALL ter dartdoc em toda API pública. A galeria SHALL ter uma página "GjaPopover" com um popover de filtros aberto por um botão, com ações no rodapé, e um popover só com conteúdo.

#### Scenario: Página GjaPopover na galeria
- **GIVEN** a página "GjaPopover" aberta na galeria
- **WHEN** o botão "Filtrar" é tocado e, no popover aberto, a ação "Aplicar" é tocada
- **THEN** o popover fecha, e a página mostra "Filtros aplicados"

### Requirement: [Restrições] Fora do escopo
`GjaPopover` SHALL NOT aceitar cores, espaços ou tamanhos literais, nem oferecer seta, modo modal, versão em tela cheia no telefone ou animação.

#### Scenario: Popover sem valor literal
- **WHEN** a API pública de `GjaPopover` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `EdgeInsets`
