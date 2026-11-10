# gja/widgets/gja-switch Specification

## Purpose

`GjaSwitch` é a chave liga/desliga do GJA, como o `sap.m.Switch` do SAPUI5: alterna um estado com efeito imediato, no padrão controlado (`state` + `onChange`), com trilho e alça que mudam de lado e de cor.

## Requirements

### Requirement: [API] Propriedades
`GjaSwitch` SHALL expor, como o `sap.m.Switch`:

| Prop | Tipo | Padrão |
|---|---|---|
| `state` | `bool` | `false` |
| `onChange` | `ValueChanged<bool>?` | `null` |
| `semanticLabel` | `String` | obrigatória |
| `enabled` | `bool` | `true` |

#### Scenario: Chave mínima
- **WHEN** `GjaSwitch(semanticLabel: 'Notificações', onChange: …)` é renderizada
- **THEN** a chave aparece desligada, com a alça no início do trilho, e tem ao menos o alvo mínimo da densidade

### Requirement: [API] Rótulo válido
`semanticLabel` MUST NOT ser vazio, porque a chave não tem texto visível. Um rótulo vazio MUST falhar em modo debug.

#### Scenario: Chave sem rótulo
- **WHEN** uma `GjaSwitch` é criada com `semanticLabel` vazio
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Ao ser acionada (toque, Enter ou Espaço), a chave SHALL chamar `onChange` com `!state`, como o evento `change`. Ela MUST NOT mudar sozinha: o pai atualiza `state`. Com `enabled` `false`, MUST ficar desabilitada. `GjaSwitch` SHALL NOT ter controlador.

#### Scenario: Ligar a chave
- **GIVEN** uma chave desligada cujo `onChange` atualiza `state`
- **WHEN** ela é tocada e depois Espaço é pressionado com o foco nela
- **THEN** `onChange` recebe `true` e depois `false`

#### Scenario: Chave desabilitada
- **GIVEN** uma chave com `enabled` `false` e um `onChange`
- **WHEN** ela é tocada
- **THEN** `onChange` não é chamado, e o conteúdo tem a opacidade `interaction.disabledOpacity`

### Requirement: [Comportamento] Posição da alça
Desligada, a alça SHALL ficar no início do trilho; ligada, no fim. A mudança de lado SHALL ser animada com `motion.short` e a curva padrão, e MUST ser imediata sem animação, conforme `gja/foundation/design-tokens`.

#### Scenario: Alça ligada
- **GIVEN** uma chave ligada, em LTR
- **WHEN** ela é renderizada
- **THEN** a alça fica no fim (à direita) do trilho

### Requirement: [Aparência] Tokens de componente
O trilho SHALL ter a altura `icons.medium`, a largura `2 × icons.medium` e o raio `radius.full`; a alça SHALL ser um círculo `colors.base` com o lado `icons.control`, centrado no trilho. Desligado, o trilho SHALL ser `colors.fieldBorder`; ligado, `colors.brand`. Nenhum valor MUST ser literal.

#### Scenario: Cores do trilho
- **WHEN** uma chave desligada e uma ligada são renderizadas no tema claro
- **THEN** os trilhos são `fieldBorder` e `brand`, as alças são `base`, e os trilhos medem `2 × icons.medium` por `icons.medium`

### Requirement: [Estados] Interação
A chave SHALL apresentar os estados normal, hover (trilho `colors.label` desligado e `colors.brandHover` ligado), pressionado, foco pelo teclado (anel de foco) e desabilitado de `gja/core/interaction`.

#### Scenario: Hover na chave
- **WHEN** o ponteiro fica sobre uma chave ligada
- **THEN** o trilho passa a `colors.brandHover`

### Requirement: [Acessibilidade] Semântica
A chave SHALL ser exposta com o estado de alternância (`toggled`), o rótulo `semanticLabel`, o estado habilitado e a ação de toque, e MUST NOT ser exposta como botão.

#### Scenario: Semântica da chave
- **WHEN** a árvore de semântica de uma chave ligada e de uma desabilitada é lida
- **THEN** as duas têm o estado de alternância e não são botões; a primeira está alternada e habilitada, e a segunda não habilitada

### Requirement: [Acessibilidade] Contraste e alvo
O trilho desligado e o ligado MUST ter contraste de ao menos 3:1 sobre `base` e `background`, e a chave MUST atender ao alvo mínimo da densidade e ao alvo rotulado, conforme `gja/foundation/accessibility`. A escala de texto MUST NOT alterar o tamanho.

#### Scenario: Contraste e alvo da chave
- **WHEN** as diretrizes de alvo rotulado e de alvo mínimo são aplicadas a chaves ligadas e desligadas, nos temas claro e escuro e nas duas densidades, e o contraste dos trilhos é medido
- **THEN** as diretrizes são atendidas, e o contraste é de ao menos 3:1

### Requirement: [Responsividade] Direção e densidade
Em RTL, "ligado" MUST pôr a alça à esquerda. O tamanho do trilho MUST ser o mesmo nas duas densidades; o alvo segue `density.minTargetSize`.

#### Scenario: Chave em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** uma chave ligada é renderizada
- **THEN** a alça fica no lado esquerdo do trilho

### Requirement: [Integração] Dependências
`GjaSwitch` SHALL depender somente de `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/iconography`, `gja/foundation/radius`, `gja/foundation/density`, `gja/foundation/design-tokens`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Chave sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** chaves ligada, desligada e desabilitada são renderizadas e tocadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaSwitch` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da chave
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da chave
- **WHEN** os goldens de chaves desligada, ligada e desabilitada (ligada e desligada) são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaSwitch` SHALL ter dartdoc em toda API pública e uma página "GjaSwitch" na galeria com chaves interativas ao lado de rótulos e chaves desabilitadas.

#### Scenario: Página GjaSwitch na galeria
- **GIVEN** a página "GjaSwitch" aberta na galeria
- **WHEN** a chave "Notificações" é tocada
- **THEN** ela passa a ligada

### Requirement: [Restrições] Fora do escopo
`GjaSwitch` SHALL NOT aceitar cores ou tamanhos literais, nem ter `customTextOn`, `customTextOff`, o tipo `AcceptReject` ou `name`.

#### Scenario: Chave sem valor literal
- **WHEN** a API pública de `GjaSwitch` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
