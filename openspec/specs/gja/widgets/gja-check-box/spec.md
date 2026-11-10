# gja/widgets/gja-check-box Specification

## Purpose

`GjaCheckBox` é a caixa de seleção do GJA, como o `sap.m.CheckBox` do SAPUI5: marca ou desmarca uma opção, com texto opcional, estado parcial, somente leitura e estado de valor, no padrão controlado (`selected` + `onSelect`).

## Requirements

### Requirement: [API] Propriedades
`GjaCheckBox` SHALL expor, como o `sap.m.CheckBox`:

| Prop | Tipo | Padrão |
|---|---|---|
| `selected` | `bool` | `false` |
| `onSelect` | `ValueChanged<bool>?` | `null` |
| `text` | `String?` | `null` |
| `semanticLabel` | `String?` | `null` |
| `partiallySelected` | `bool` | `false` |
| `enabled` | `bool` | `true` |
| `editable` | `bool` | `true` |
| `valueState` | `GjaValueState` | `none` |
| `wrapping` | `bool` | `false` |

#### Scenario: Caixa mínima
- **WHEN** `GjaCheckBox(text: 'Aceito os termos', onSelect: …)` é renderizada
- **THEN** a caixa desmarcada fica antes do texto, separada por `spacing.xs`, e o conjunto tem ao menos o alvo mínimo da densidade

### Requirement: [API] Rótulo válido
A caixa MUST ter `text` ou `semanticLabel` não vazio, porque o leitor de tela precisa de um nome. Sem os dois, a criação MUST falhar em modo debug.

#### Scenario: Caixa sem rótulo
- **WHEN** uma `GjaCheckBox` é criada sem `text` nem `semanticLabel`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Ao ser acionada, a caixa SHALL chamar `onSelect` com o novo valor (`!selected`; `true` quando parcial), como o evento `select`. Ela MUST NOT mudar sozinha: o pai atualiza `selected`. Com `enabled` `false`, MUST ficar desabilitada; com `editable` `false`, MUST receber o foco sem chamar `onSelect`. `GjaCheckBox` SHALL NOT ter controlador.

#### Scenario: Marcar a caixa
- **GIVEN** uma caixa desmarcada cujo `onSelect` atualiza `selected`
- **WHEN** ela é tocada e depois Espaço é pressionado com o foco nela
- **THEN** `onSelect` recebe `true` e depois `false`, e a marca acompanha o valor

#### Scenario: Caixa somente leitura
- **GIVEN** uma caixa com `editable` `false`
- **WHEN** ela recebe o foco por Tab e é tocada
- **THEN** ela tem o foco, e `onSelect` não é chamado

### Requirement: [Comportamento] Estado parcial
Com `partiallySelected`, a caixa SHALL mostrar a marca parcial no lugar da marca de seleção, e acionar MUST chamar `onSelect(true)`.

#### Scenario: Caixa parcial
- **GIVEN** uma caixa com `partiallySelected` e `selected` `false`
- **WHEN** ela é tocada
- **THEN** antes do toque há a marca parcial, e `onSelect` recebe `true`

### Requirement: [Comportamento] Texto
O texto SHALL ficar numa linha, com reticências quando não cabe, ou quebrar em várias linhas com `wrapping`. Tocar o texto MUST acionar a caixa, como o rótulo do UI5.

#### Scenario: Toque no texto
- **WHEN** o texto de uma caixa com `onSelect` é tocado
- **THEN** `onSelect` é chamado uma vez

### Requirement: [Aparência] Tokens de componente
A caixa SHALL ter o lado `icons.control + spacing.xxs`, o raio `radius.field`, o fundo `colors.base`, a borda fina `colors.fieldBorder` e, marcada, a marca `GjaIcons.accept` em `colors.brand`, no tamanho `icons.control`. A marca parcial SHALL ser um quadrado `colors.brand` recuado `spacing.xs`. O texto SHALL usar `typography.base` e `colors.text`. Nenhum valor MUST ser literal.

#### Scenario: Caixa marcada
- **WHEN** uma caixa marcada é renderizada no tema claro
- **THEN** a caixa tem o lado `icons.control + spacing.xxs`, a borda `fieldBorder`, o fundo `base`, e a marca usa `brand`

### Requirement: [Aparência] Estado de valor e somente leitura
Com `valueState` diferente de `none`, a borda SHALL ser `border` e o fundo `background` de `colors.stateColors(valueState)`. Somente leitura, o fundo SHALL ser `colors.background` e a borda `colors.separator`, e a marca `colors.label`.

#### Scenario: Caixa com erro
- **WHEN** uma caixa com `valueState` `error` é renderizada
- **THEN** a borda e o fundo são os de `stateColors(error)`

### Requirement: [Estados] Interação
A caixa SHALL apresentar os estados normal, hover (borda `colors.brand`), pressionado, foco pelo teclado (anel de foco) e desabilitado (opacidade `interaction.disabledOpacity`) de `gja/core/interaction`.

#### Scenario: Hover na caixa
- **WHEN** o ponteiro fica sobre a caixa
- **THEN** a borda passa a `colors.brand`

#### Scenario: Caixa desabilitada
- **GIVEN** uma caixa com `enabled` `false` e um `onSelect`
- **WHEN** ela é tocada
- **THEN** `onSelect` não é chamado, e o conteúdo tem a opacidade `interaction.disabledOpacity`

### Requirement: [Acessibilidade] Semântica
A caixa SHALL ser exposta como caixa de seleção, com o rótulo `text` ou `semanticLabel`, o estado marcado (ou misto, quando parcial), o habilitado e a ação de toque quando habilitada. Com `editable` `false`, MUST ser exposta como somente leitura.

#### Scenario: Semântica da caixa
- **WHEN** a árvore de semântica de uma caixa marcada, de uma parcial, de uma desabilitada e de uma somente leitura é lida
- **THEN** todas têm o estado de marcação e nenhuma é botão; a primeira está marcada, a segunda mista, a terceira não habilitada, e a quarta somente leitura

### Requirement: [Acessibilidade] Contraste, alvo e escala
A borda e a marca MUST ter contraste de ao menos 3:1 sobre o fundo, o texto o contraste de texto, e o conjunto o alvo mínimo da densidade, conforme `gja/foundation/accessibility`. Com escala de texto 2,0, MUST NOT haver estouro.

#### Scenario: Contraste e alvo da caixa
- **WHEN** as diretrizes de contraste de texto, alvo rotulado e alvo mínimo são aplicadas a caixas marcadas, desmarcadas e com cada estado de valor, nos temas claro e escuro e nas duas densidades
- **THEN** todas são atendidas

#### Scenario: Escala de texto da caixa
- **GIVEN** a escala de texto 2,0
- **WHEN** uma caixa com texto é renderizada numa largura de 200
- **THEN** não há estouro

### Requirement: [Responsividade] Direção e densidade
Em RTL, a caixa MUST ficar à direita do texto. O alvo SHALL seguir `density.minTargetSize`; o lado da caixa MUST ser o mesmo nas duas densidades.

#### Scenario: Caixa em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** uma caixa com texto é renderizada
- **THEN** a caixa fica à direita do texto

### Requirement: [Integração] Dependências
`GjaCheckBox` SHALL depender somente de `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/density`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Caixa sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** caixas marcada, parcial, somente leitura e desabilitada são renderizadas e tocadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaCheckBox` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da caixa
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da caixa
- **WHEN** os goldens de caixas desmarcada, marcada, parcial, com cada estado de valor, somente leitura e desabilitada são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaCheckBox` SHALL ter dartdoc em toda API pública e uma página "GjaCheckBox" na galeria com caixas interativas, uma parcial que reflete um grupo, os estados de valor, somente leitura e desabilitada.

#### Scenario: Página GjaCheckBox na galeria
- **GIVEN** a página "GjaCheckBox" aberta na galeria
- **WHEN** a caixa "Aceito os termos" é tocada
- **THEN** ela passa a marcada

### Requirement: [Restrições] Fora do escopo
`GjaCheckBox` SHALL NOT aceitar cores ou tamanhos literais, nem ter `displayOnly`, `required`, `width`, `useEntireWidth` ou texto de estado de valor.

#### Scenario: Caixa sem valor literal
- **WHEN** a API pública de `GjaCheckBox` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
