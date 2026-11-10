# Spec Delta

## Purpose

`GjaCardHeader` é o cabeçalho de um cartão, como o `sap.f.cards.Header` do SAPUI5: um ícone opcional, o título e o status na primeira linha, o subtítulo e a data na segunda, e uma barra de ferramentas no fim. Pode ser acionável, para levar ao detalhe. É o `header` de `GjaCard`.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaCardHeader` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `title` | `String?` | `null` |
| `titleMaxLines` | `int` | `3` |
| `subtitle` | `String?` | `null` |
| `subtitleMaxLines` | `int` | `2` |
| `statusText` | `String?` | `null` |
| `statusVisible` | `bool` | `true` |
| `dataTimestamp` | `String?` | `null` |
| `toolbar` | `Widget?` | `null` |

`titleMaxLines` e `subtitleMaxLines` MUST ser maiores que zero.

#### Scenario: Cabeçalho completo
- **GIVEN** um ícone, `title`, `statusText`, `subtitle`, `dataTimestamp` e um `toolbar`, em LTR
- **WHEN** o cabeçalho é renderizado
- **THEN** o ícone fica no início; o título e o status ficam na primeira linha, com o status no fim; o subtítulo e a data ficam na segunda linha, com a data no fim; e o `toolbar` fica na borda final

#### Scenario: Linhas inválidas no cabeçalho
- **WHEN** o cabeçalho é criado com `titleMaxLines` 0
- **THEN** a criação falha em modo debug com mensagem que cita `titleMaxLines`

### Requirement: [API] Ícone do cabeçalho
`GjaCardHeader` SHALL expor o ícone como o `sap.f.cards.Header`: `icon` (`IconData?`), `iconImage` (`ImageProvider?`), `iconInitials` (`String?`), `iconDisplayShape` (`GjaAvatarShape`, padrão `circle`), `iconSize` (`GjaAvatarSize`, padrão `s`), `iconAlt` (`String?`) e `iconVisible` (padrão `true`). O ícone SHALL ser um `GjaAvatar` e MUST aparecer só com `iconVisible` e uma das três fontes.

#### Scenario: Ícone por iniciais
- **WHEN** o cabeçalho tem `iconInitials` "MB" e `iconDisplayShape` `square`
- **THEN** o início do cabeçalho mostra um `GjaAvatar` quadrado com "MB" no tamanho `s`

### Requirement: [API] Callbacks e controlador
`GjaCardHeader` SHALL expor `onPress` (`VoidCallback?`), como o evento `press`, e MUST chamá-lo uma vez por ativação por toque, Enter ou Espaço. Sem `onPress`, o cabeçalho SHALL NOT ser interativo. A barra de ferramentas MUST tratar os próprios toques, sem chamar `onPress`.

#### Scenario: Cabeçalho acionado
- **GIVEN** um cabeçalho com `onPress` que conta as chamadas e um botão no `toolbar`
- **WHEN** o cabeçalho é tocado e depois o botão do `toolbar` é tocado
- **THEN** `onPress` foi chamado uma vez

### Requirement: [Comportamento] Linhas dos textos
O título SHALL ter até `titleMaxLines` linhas e o subtítulo até `subtitleMaxLines`, ambos com reticências. O status e a data MUST ficar numa linha, sem quebrar. Com `statusVisible` `false`, o status MUST NOT aparecer.

#### Scenario: Título longo no cabeçalho
- **GIVEN** um cabeçalho de 280 de largura com um título que ocupa cinco linhas
- **WHEN** ele é renderizado
- **THEN** o título ocupa três linhas e termina com reticências

#### Scenario: Status oculto
- **WHEN** o cabeçalho tem `statusText` "3 de 5" e `statusVisible` `false`
- **THEN** o status não aparece

### Requirement: [Aparência] Tokens de componente
O cabeçalho SHALL ter o espaço `spacing.l` em volta, `spacing.m` entre o ícone e os textos e `spacing.s` entre a primeira e a segunda linha. O título SHALL usar `typography.header5` com `colors.text`; o subtítulo `typography.base` com `colors.label`; e o status e a data `typography.small` com `colors.label`. O fundo do cabeçalho acionável SHALL seguir a família `list` de `gja/foundation/interaction-states`, sem valores literais.

#### Scenario: Estilos do cabeçalho
- **WHEN** o cabeçalho completo é renderizado nos temas claro e escuro
- **THEN** o título tem o estilo `header5` e a cor `text`; o subtítulo, `base` e `label`; e o status e a data, `small` e `label`

### Requirement: [Estados] Cabeçalho acionável
Com `onPress`, o cabeçalho SHALL apresentar os estados normal, hover, pressionado e foco do teclado de `gja/core/interaction`, com as cores da família `list`. Sem `onPress`, SHALL NOT apresentar estados nem receber o foco.

#### Scenario: Cabeçalho do cartão em hover
- **WHEN** o ponteiro fica sobre o cabeçalho acionável
- **THEN** o fundo do cabeçalho é o de hover da família `list`

#### Scenario: Cabeçalho sem ação não recebe foco
- **GIVEN** um cabeçalho sem `onPress` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no cabeçalho

### Requirement: [Acessibilidade] Teclado
Com o foco no cabeçalho acionável, Enter e Espaço SHALL ativá-lo, como define `gja/core/interaction`. A barra de ferramentas MUST vir depois do cabeçalho na ordem de foco.

#### Scenario: Cabeçalho do cartão pelo teclado
- **GIVEN** um cabeçalho com `onPress`
- **WHEN** Tab leva o foco ao cabeçalho e Enter é pressionado
- **THEN** `onPress` é chamado uma vez

### Requirement: [Acessibilidade] Semântica
O título SHALL ser um cabeçalho com o `headingLevel` do `GjaCard` em que está, ou de nível 3 fora dele, como o `sap.f.Card`. Com `onPress`, o cabeçalho MUST ser um botão com o rótulo "título, subtítulo" e a ação de toque. O ícone MUST usar `iconAlt` como rótulo, e o status e a data MUST ser lidos.

#### Scenario: Semântica do cabeçalho
- **GIVEN** um cabeçalho acionável com título "Pedidos" e subtítulo "Compras", num `GjaCard` com `headingLevel` `h2`
- **WHEN** a árvore de semântica é lida
- **THEN** há um botão com o rótulo "Pedidos, Compras" e ação de toque, e o título é um cabeçalho de nível 2

### Requirement: [Acessibilidade] Contraste e alvo
Os textos do cabeçalho MUST manter o contraste sobre `colors.base`, e o cabeçalho acionável MUST atender ao alvo mínimo e ao alvo rotulado, conforme `gja/foundation/accessibility`.

#### Scenario: Contraste e alvo do cabeçalho
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a um cabeçalho acionável completo, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção e escala
Em RTL, o ícone MUST ficar à direita, e o status, a data e o `toolbar` à esquerda. Com escala de texto 2,0, o cabeçalho MUST crescer em altura sem estouro.

#### Scenario: Cabeçalho em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um cabeçalho com ícone e status é renderizado
- **THEN** o ícone fica junto da borda direita, e o status junto da esquerda

#### Scenario: Cabeçalho com escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e um espaço de 300 de largura
- **WHEN** um cabeçalho completo é renderizado
- **THEN** não há estouro

### Requirement: [Integração] Dependências
`GjaCardHeader` SHALL depender somente de `gja/widgets/gja-avatar`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/spacing`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Cabeçalho sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um cabeçalho completo e acionável é renderizado e tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaCardHeader` MUST ter um teste de widget por cenário, goldens do cabeçalho completo e do acionável nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do cabeçalho de cartão
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do cabeçalho de cartão
- **WHEN** os goldens do cabeçalho completo e do acionável em hover são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaCardHeader` SHALL ter dartdoc em toda API pública, e a página "GjaCard" da galeria SHALL mostrar um cabeçalho completo, um acionável e um com `toolbar`.

#### Scenario: Cabeçalhos na página GjaCard
- **WHEN** a página "GjaCard" é aberta
- **THEN** ela mostra um cabeçalho com ícone, status e data, um acionável e um com `toolbar`

### Requirement: [Restrições] Fora do escopo
`GjaCardHeader` SHALL NOT oferecer o cabeçalho numérico (`sap.f.cards.NumericHeader`), `infoSection`, `bannerLines`, `href`, cores de fundo ou de estado do ícone, `wrappingType`, nem valores literais.

#### Scenario: Cabeçalho sem valor literal
- **WHEN** a API pública de `GjaCardHeader` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`
