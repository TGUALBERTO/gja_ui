# Spec Delta

## Purpose

`GjaRadioButton` é a opção de escolha única do GJA, como o `sap.m.RadioButton` do SAPUI5: um círculo com texto opcional, marcado quando é a opção escolhida, no padrão controlado (`selected` + `onSelect`); em geral é usado dentro de `GjaRadioButtonGroup`.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaRadioButton` SHALL expor, como o `sap.m.RadioButton`:

| Prop | Tipo | Padrão |
|---|---|---|
| `selected` | `bool` | `false` |
| `onSelect` | `ValueChanged<bool>?` | `null` |
| `text` | `String?` | `null` |
| `semanticLabel` | `String?` | `null` |
| `enabled` | `bool` | `true` |
| `editable` | `bool` | `true` |
| `valueState` | `GjaValueState` | `none` |
| `wrapping` | `bool` | `false` |
| `focusNode` | `FocusNode?` | `null` |

#### Scenario: Opção mínima
- **WHEN** `GjaRadioButton(text: 'Boleto', onSelect: …)` é renderizada
- **THEN** o círculo vazio fica antes do texto, separado por `spacing.xs`, e o conjunto tem ao menos o alvo mínimo da densidade

### Requirement: [API] Rótulo válido
A opção MUST ter `text` ou `semanticLabel` não vazio. Sem os dois, a criação MUST falhar em modo debug.

#### Scenario: Opção sem rótulo
- **WHEN** uma `GjaRadioButton` é criada sem `text` nem `semanticLabel`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Ao ser acionada (toque na opção ou no texto, Enter ou Espaço) sem estar marcada, a opção SHALL chamar `onSelect(true)`, como o evento `select`; marcada, MUST NOT chamar de novo. Ela MUST NOT mudar sozinha. Com `enabled` `false`, MUST ficar desabilitada; com `editable` `false`, MUST receber o foco sem chamar `onSelect`. `focusNode` SHALL ser o nó de foco da opção. `GjaRadioButton` SHALL NOT ter controlador.

#### Scenario: Escolher a opção
- **GIVEN** uma opção desmarcada que registra as chamadas
- **WHEN** ela é tocada, e depois uma opção marcada é tocada
- **THEN** a primeira chama `onSelect(true)` uma vez, e a segunda não chama

#### Scenario: Opção somente leitura
- **GIVEN** uma opção com `editable` `false`
- **WHEN** ela recebe o foco por Tab e é tocada
- **THEN** ela tem o foco, e `onSelect` não é chamado

### Requirement: [Comportamento] Texto
O texto SHALL ficar numa linha, com reticências quando não cabe, ou quebrar em várias linhas com `wrapping`. Tocar o texto MUST acionar a opção, como o rótulo do UI5.

#### Scenario: Toque no texto da opção
- **WHEN** o texto de uma opção desmarcada é tocado
- **THEN** `onSelect(true)` é chamado uma vez

### Requirement: [Aparência] Tokens de componente
O círculo SHALL ter o lado `icons.control + spacing.xxs`, o fundo `colors.base` e a borda fina `colors.fieldBorder`; marcada, SHALL ter um ponto `colors.brand` de lado `spacing.s`, centrado. Com `valueState`, borda e fundo SHALL vir de `colors.stateColors`; somente leitura, fundo `colors.background`, borda `colors.separator` e ponto `colors.label`. O texto SHALL usar `typography.base` e `colors.text`.

#### Scenario: Opção marcada
- **WHEN** uma opção marcada e uma com `valueState` `error` são renderizadas no tema claro
- **THEN** a primeira tem a borda `fieldBorder` e o ponto `brand` de lado `spacing.s`; a segunda tem a borda e o fundo de `stateColors(error)`

### Requirement: [Estados] Interação
A opção SHALL apresentar os estados normal, hover (borda `colors.brand`), pressionado, foco pelo teclado e desabilitado (opacidade `interaction.disabledOpacity`) de `gja/core/interaction`.

#### Scenario: Hover na opção
- **WHEN** o ponteiro fica sobre a opção
- **THEN** a borda passa a `colors.brand`

#### Scenario: Opção desabilitada
- **GIVEN** uma opção com `enabled` `false` e um `onSelect`
- **WHEN** ela é tocada
- **THEN** `onSelect` não é chamado, e o conteúdo tem a opacidade `interaction.disabledOpacity`

### Requirement: [Acessibilidade] Semântica
A opção SHALL ser exposta com o estado de marcação, num grupo exclusivo (`inMutuallyExclusiveGroup`), com o rótulo, o estado habilitado e a ação de toque, e MUST NOT ser exposta como botão. Com `editable` `false`, MUST ser exposta como somente leitura.

#### Scenario: Semântica da opção
- **WHEN** a árvore de semântica de uma opção marcada e de uma desabilitada é lida
- **THEN** as duas têm o estado de marcação num grupo exclusivo e não são botões; a primeira está marcada, e a segunda não habilitada

### Requirement: [Acessibilidade] Contraste, alvo e escala
A borda e o ponto MUST ter contraste de ao menos 3:1, o texto o contraste de texto, e a opção o alvo mínimo da densidade, conforme `gja/foundation/accessibility`. Com escala de texto 2,0, MUST NOT haver estouro.

#### Scenario: Contraste e alvo da opção
- **WHEN** as diretrizes de contraste de texto, alvo rotulado e alvo mínimo são aplicadas a opções marcadas e desmarcadas, nos temas claro e escuro e nas duas densidades
- **THEN** todas são atendidas

### Requirement: [Responsividade] Direção
Em RTL, o círculo MUST ficar à direita do texto. O lado do círculo MUST ser o mesmo nas duas densidades.

#### Scenario: Opção em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** uma opção com texto é renderizada
- **THEN** o círculo fica à direita do texto

### Requirement: [Integração] Dependências
`GjaRadioButton` SHALL depender somente de `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/density`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Opção sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** opções marcada, desmarcada, somente leitura e desabilitada são renderizadas e tocadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaRadioButton` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da opção
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da opção
- **WHEN** os goldens de opções desmarcada, marcada, com cada estado de valor, somente leitura e desabilitada são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaRadioButton` SHALL ter dartdoc em toda API pública e aparecer na página "GjaRadioButton" da galeria, ao lado do grupo.

#### Scenario: Página GjaRadioButton na galeria
- **GIVEN** a página "GjaRadioButton" aberta na galeria
- **WHEN** a opção avulsa "Receber por e-mail" é tocada
- **THEN** ela passa a marcada

### Requirement: [Restrições] Fora do escopo
`GjaRadioButton` SHALL NOT aceitar cores ou tamanhos literais, nem ter `groupName`, `width`, `useEntireWidth` ou texto de estado de valor; o agrupamento é do `GjaRadioButtonGroup`.

#### Scenario: Opção sem valor literal
- **WHEN** a API pública de `GjaRadioButton` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
