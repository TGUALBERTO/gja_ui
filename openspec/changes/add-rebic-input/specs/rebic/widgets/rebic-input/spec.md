# Spec Delta

## Purpose

`RebicInput` é o campo de texto de uma linha do Rebic, como o `sap.m.Input` do SAPUI5: edição de texto com espaço reservado, tipos de teclado e senha, limite de caracteres, botão de limpar, somente leitura e estado de valor com mensagem, no padrão controlado (`value` + `onLiveChange`).

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicInput` SHALL expor, como o `sap.m.Input`:

| Prop | Tipo | Padrão |
|---|---|---|
| `value` | `String` | `''` |
| `placeholder` | `String?` | `null` |
| `semanticLabel` | `String?` | `null` |
| `type` | `RebicInputType` | `text` |
| `enabled` | `bool` | `true` |
| `editable` | `bool` | `true` |
| `valueState` | `RebicValueState` | `none` |
| `valueStateText` | `String?` | `null` |

#### Scenario: Campo mínimo
- **WHEN** `RebicInput(placeholder: 'Nome', onLiveChange: …)` é renderizado numa largura de 300
- **THEN** ele ocupa os 300, tem a altura `density.controlHeight` e mostra "Nome" no lugar do texto

### Requirement: [API] Rótulo válido
O campo MUST ter `semanticLabel` ou `placeholder` não vazio, para o leitor de tela. Sem os dois, a criação MUST falhar em modo debug.

#### Scenario: Campo sem rótulo
- **WHEN** um `RebicInput` é criado sem `semanticLabel` nem `placeholder`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
A cada edição, o campo SHALL chamar `onLiveChange` com o texto, como o evento `liveChange`. Com Enter, SHALL chamar `onSubmit`; com Enter ou ao perder o foco com o texto diferente do último avisado, SHALL chamar `onChange`, como os eventos `submit` e `change`. O campo MUST mostrar `value` quando o pai muda o valor. `RebicInput` SHALL NOT ter controlador público; `focusNode` (`FocusNode?`) é o nó de foco.

#### Scenario: Digitar no campo
- **GIVEN** um campo cujo `onLiveChange` atualiza `value` e que registra `onChange` e `onSubmit`
- **WHEN** "abc" é digitado e Enter é pressionado
- **THEN** `onLiveChange` recebe o texto a cada letra, e `onChange` e `onSubmit` recebem "abc" uma vez

#### Scenario: Valor vindo do pai
- **GIVEN** um campo com `value` "a"
- **WHEN** o pai passa a `value` "xyz"
- **THEN** o campo mostra "xyz"

### Requirement: [Comportamento] Tipos e limite
`type` (`RebicInputType`: `text`, `email`, `number`, `password`, `tel`, `url`) SHALL definir o teclado: `password` SHALL esconder os caracteres; `email`, `number`, `tel` e `url` SHALL pedir o teclado correspondente. Com `maxLength` (`int`, padrão `0`, sem limite) maior que zero, o campo MUST NOT aceitar mais caracteres que o limite.

#### Scenario: Senha e limite
- **WHEN** "123456" é digitado num campo `password` com `maxLength` 4
- **THEN** o texto é "1234", e os caracteres aparecem escondidos

### Requirement: [Comportamento] Botão de limpar
Com `showClearIcon` (padrão `false`), editável e com texto, o campo SHALL mostrar no fim um botão só com o ícone `RebicIcons.decline` e a dica `clear` de `rebic/core/localization`, que esvazia o texto e chama `onLiveChange('')` e `onChange('')`.

#### Scenario: Limpar o campo
- **GIVEN** um campo com `showClearIcon` e o texto "abc"
- **WHEN** o botão de limpar é tocado
- **THEN** `onLiveChange` e `onChange` recebem "", e o botão some

### Requirement: [Comportamento] Mensagem de estado de valor
Com `valueState` diferente de `none` e `valueStateText`, o campo SHALL mostrar a mensagem logo abaixo, em `typography.small` com a cor `foreground` do estado, enquanto tiver o foco, como a mensagem do UI5.

#### Scenario: Mensagem de erro no foco
- **GIVEN** um campo com `valueState` `error` e `valueStateText` "Informe o nome"
- **WHEN** ele recebe o foco
- **THEN** "Informe o nome" aparece abaixo dele, e some quando o foco sai

### Requirement: [Aparência] Tokens de componente
O campo SHALL ter a altura mínima `density.controlHeight`, o espaço horizontal `spacing.s`, o raio `radius.field`, o fundo `colors.base`, a borda fina `colors.fieldBorder`, o texto `typography.base` com `colors.text` e o espaço reservado com `colors.label`. Com `valueState`, borda e fundo SHALL vir de `colors.stateColors`; somente leitura, o fundo SHALL ser `colors.headerBackground`. Nenhum valor MUST ser literal.

#### Scenario: Aparência do campo
- **WHEN** um campo normal, um com `valueState` `warning` e um somente leitura são renderizados no tema claro
- **THEN** o primeiro tem o fundo `base` e a borda `fieldBorder`, o segundo a borda e o fundo de `stateColors(warning)`, e o terceiro o fundo `headerBackground`

### Requirement: [Estados] Interação
O campo SHALL apresentar hover (borda `colors.brand`), foco (borda `colors.brand` e anel de foco de `rebic/core/interaction`) e desabilitado (opacidade `interaction.disabledOpacity`, sem foco nem edição). Somente leitura, MUST receber o foco e permitir selecionar, sem editar.

#### Scenario: Foco no campo
- **WHEN** o campo recebe o foco
- **THEN** a borda passa a `colors.brand`, e o anel de foco aparece

#### Scenario: Campo desabilitado
- **GIVEN** um campo com `enabled` `false`
- **WHEN** ele é tocado
- **THEN** ele não recebe o foco, e o conteúdo tem a opacidade `interaction.disabledOpacity`

#### Scenario: Campo somente leitura
- **GIVEN** um campo com `editable` `false` e o texto "abc"
- **WHEN** ele é tocado e "x" é digitado
- **THEN** ele recebe o foco, e o texto continua "abc"

### Requirement: [Acessibilidade] Semântica
O campo SHALL ser exposto como campo de texto, com o rótulo `semanticLabel` (ou `placeholder`), o valor, o estado habilitado e, somente leitura, o estado de somente leitura. A mensagem de estado de valor SHALL ser exposta como dica do campo; o espaço reservado MUST NOT ser lido como valor.

#### Scenario: Semântica do campo
- **WHEN** a árvore de semântica de um campo com `semanticLabel` "Nome", valor "Ana" e `valueStateText` "Confira" é lida
- **THEN** ele é campo de texto, com o rótulo "Nome", o valor "Ana" e a dica "Confira"

### Requirement: [Acessibilidade] Contraste, alvo e escala
A borda MUST ter contraste de ao menos 3:1, o texto e o espaço reservado o contraste de texto, e o campo o alvo mínimo da densidade, conforme `rebic/foundation/accessibility`. Com escala de texto 2,0, o campo MUST crescer em altura sem estouro.

#### Scenario: Contraste e alvo do campo
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a campos com texto e com espaço reservado, nos temas claro e escuro e nas duas densidades, e o contraste da borda é medido
- **THEN** todas são atendidas

#### Scenario: Escala de texto do campo
- **GIVEN** a escala de texto 2,0
- **WHEN** um campo com texto é renderizado numa largura de 200
- **THEN** não há estouro, e a altura é de ao menos `controlHeight`

### Requirement: [Responsividade] Largura e direção
O campo SHALL ocupar a largura disponível. Em RTL, o texto e o botão de limpar MUST seguir a direção: o texto começa à direita, e o botão fica à esquerda.

#### Scenario: Campo em RTL
- **GIVEN** a direção do texto da direita para a esquerda e um campo com `showClearIcon` e texto
- **WHEN** ele é renderizado
- **THEN** o botão de limpar fica no lado esquerdo do campo

### Requirement: [Integração] Dependências
`RebicInput` SHALL depender somente de `rebic/widgets/rebic-button`, `rebic/core/interaction`, `rebic/core/localization`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/density`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Campo sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** campos de cada tipo, somente leitura e desabilitado são renderizados, e texto é digitado num deles
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicInput` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do campo
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do campo
- **WHEN** os goldens de campos vazio, com texto, com botão de limpar, com cada estado de valor, somente leitura e desabilitado são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicInput` SHALL ter dartdoc em toda API pública e uma página "RebicInput" na galeria com campos de cada tipo, um com limite, um com botão de limpar, um com validação que mostra o estado de erro e campos somente leitura e desabilitado.

#### Scenario: Página RebicInput na galeria
- **GIVEN** a página "RebicInput" aberta na galeria
- **WHEN** "Ana" é digitado no campo "Nome"
- **THEN** o texto "Olá, Ana" aparece na página

### Requirement: [Restrições] Fora do escopo
`RebicInput` SHALL NOT aceitar cores ou tamanhos literais, nem ter sugestões, ajuda de valor (`showValueHelp`), `description`, `width`, máscara ou várias linhas (é o `RebicTextArea`).

#### Scenario: Campo sem valor literal
- **WHEN** a API pública de `RebicInput` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
