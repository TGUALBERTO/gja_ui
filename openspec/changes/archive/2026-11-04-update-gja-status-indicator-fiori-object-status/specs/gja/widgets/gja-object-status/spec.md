# Spec Delta

## Purpose

`GjaObjectStatus` mostra a situação de um registro, como o `sap.m.ObjectStatus` do SAPUI5: um título opcional, um ícone e um texto na cor de um estado de valor, normal ou invertido (etiqueta preenchida), opcionalmente clicável, com semântica num só nó.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaObjectStatus` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String?` | `null` |
| `icon` | `IconData?` | `null` |
| `title` | `String?` | `null` |
| `state` | `GjaValueState` | `none` |
| `inverted` | `bool` | `false` |
| `onPress` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Status mínimo
- **WHEN** `GjaObjectStatus(text: 'Aprovado', state: GjaValueState.success)` é renderizado
- **THEN** "Aprovado" aparece na cor de frente do estado `success`, no estilo `typography.base`, sem fundo

#### Scenario: Status com título e ícone
- **GIVEN** `title` "Situação", `icon` e `text` "Aprovado", em LTR
- **WHEN** o status é renderizado
- **THEN** aparecem, do início ao fim, "Situação:" no `GjaLabel` com `showColon`, o ícone e "Aprovado"

### Requirement: [API] Conteúdo válido
O status MUST ter `text` não vazio ou `icon`. Sem nenhum dos dois, MUST falhar em modo debug.

#### Scenario: Status vazio
- **WHEN** um `GjaObjectStatus` é criado sem `text` e sem `icon`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Com `onPress`, o status SHALL ser ativo e chamar `onPress` uma vez por ativação por toque, Enter ou Espaço, como o evento `press` do SAPUI5. Sem `onPress`, não há ação, e o status MUST NOT receber o foco nem reagir ao ponteiro. `GjaObjectStatus` SHALL NOT ter controlador.

#### Scenario: Status ativo
- **WHEN** um status com `onPress` é tocado e, com o foco nele, Enter é pressionado
- **THEN** `onPress` é chamado duas vezes

#### Scenario: Status inativo
- **GIVEN** um status sem `onPress` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no status

### Requirement: [Comportamento] Quebra do texto
O texto SHALL quebrar em várias linhas quando não cabe, como no `ObjectStatus`. O ícone e o título MUST ficar alinhados à primeira linha.

#### Scenario: Texto longo quebra
- **GIVEN** um status com ícone e texto longo num espaço de 160 de largura
- **WHEN** ele é renderizado
- **THEN** o texto ocupa mais de uma linha, sem reticências, e o ícone fica na altura da primeira linha

### Requirement: [Aparência] Cores por estado
O texto e o ícone SHALL usar a cor de frente do `state` em `colors.stateColors`. No estado `none`, SHALL usar `colors.text`. O título SHALL usar `colors.label`.

#### Scenario: Cores do status por estado
- **WHEN** um status com ícone e texto de cada estado de valor é renderizado
- **THEN** o texto e o ícone de cada um têm a cor de frente do estado, exceto `none`, que usa `colors.text`

### Requirement: [Aparência] Status invertido
Com `inverted`, o status SHALL ser uma etiqueta com o fundo, a borda fina e a cor de frente do `state`, raio `radius.s` e espaço horizontal `spacing.xs`. Sem `inverted`, MUST NOT pintar fundo.

#### Scenario: Status invertido
- **WHEN** um status `inverted` do estado `error` é renderizado
- **THEN** ele tem o fundo e a borda do estado `error`, raio `radius.s`, e o texto na cor de frente do estado

### Requirement: [Aparência] Tokens de componente
O texto SHALL usar `typography.base`, o ícone `icons.inline`, o espaço entre título, ícone e texto `spacing.xs`, sem valores literais.

#### Scenario: Ícone acompanha a escala de texto
- **GIVEN** a escala de texto 2,0
- **WHEN** um status com ícone é renderizado
- **THEN** o ícone é maior que `icons.inline`, e não há estouro

### Requirement: [Estados] Interação do status ativo
O status ativo SHALL mostrar o texto sublinhado no hover e no pressionado e o anel de foco só com o foco do teclado. O status inativo SHALL NOT apresentar estados de interação.

#### Scenario: Status ativo em hover
- **WHEN** o ponteiro fica sobre um status ativo e depois sai
- **THEN** o texto fica sublinhado e volta sem sublinhado

### Requirement: [Acessibilidade] Semântica
O status SHALL ser exposto num só nó, com o rótulo "título: texto" (ou só o texto). Sem texto, o rótulo MUST ser o `title`, quando houver. O ícone MUST ficar fora da semântica quando há texto. O status ativo MUST ser exposto como botão com a ação de toque.

#### Scenario: Semântica do status
- **WHEN** a árvore de semântica de um status com título "Situação" e texto "Aprovado", e de um ativo com texto "Atrasado", é lida
- **THEN** o primeiro tem o rótulo "Situação: Aprovado" e não é botão, e o segundo é botão com o rótulo "Atrasado" e ação de toque

### Requirement: [Acessibilidade] Contraste e alvo
O texto de cada estado, normal e invertido, MUST manter o contraste, e o status ativo MUST atender ao alvo mínimo e ao alvo rotulado, conforme `gja/foundation/accessibility`.

#### Scenario: Contraste e alvo do status
- **WHEN** a diretriz de contraste de texto é aplicada a status de cada estado, normais e invertidos, e as de alvo a um status ativo, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Direção
Em RTL, a ordem SHALL ser espelhada: o título e o ícone ficam à direita do texto.

#### Scenario: Status em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um status com ícone e texto é renderizado
- **THEN** o ícone fica à direita do texto

### Requirement: [Integração] Dependências
`GjaObjectStatus` SHALL depender somente de `gja/widgets/gja-icon`, `gja/widgets/gja-label`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Status sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** status normais, invertidos e ativos são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaObjectStatus` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` aplicável: contraste, semântica e, no ativo, alvo e teclado.

#### Scenario: Rastreabilidade do status
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do status
- **WHEN** os goldens dos status de cada estado, normais e invertidos, com título e ícone, e de um ativo são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaObjectStatus` SHALL ter dartdoc em toda API pública e uma página "GjaObjectStatus" na galeria com status por estado, invertidos, com título e um ativo que mostra uma mensagem.

#### Scenario: Página GjaObjectStatus na galeria
- **GIVEN** a página "GjaObjectStatus" aberta na galeria
- **WHEN** o status ativo "3 pendências" é tocado
- **THEN** a página mostra "Abrindo pendências"

### Requirement: [Restrições] Fora do escopo
`GjaObjectStatus` SHALL NOT aceitar cores, tamanhos ou estilos literais, nem cores de indicação fora dos estados de valor.

#### Scenario: Status sem valor literal
- **WHEN** a API pública de `GjaObjectStatus` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `TextStyle`
