# Spec Delta

## Purpose

`RebicSelect` é o campo de seleção do Rebic, como o `sap.m.Select` do SAPUI5: mostra o item escolhido num campo com seta e abre a lista de `rebic/widgets/rebic-dropdown` para trocar, no padrão controlado (`selectedKey` + `onChange`).

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicSelect<T>` SHALL expor, como o `sap.m.Select`:

| Prop | Tipo | Padrão |
|---|---|---|
| `items` | `List<RebicDropdownItem<T>>` | obrigatória |
| `selectedKey` | `T?` | `null` |
| `onChange` | `ValueChanged<T>?` | `null` |
| `semanticLabel` | `String` | obrigatória |
| `placeholder` | `String?` | `null` |
| `enabled` | `bool` | `true` |
| `editable` | `bool` | `true` |
| `valueState` | `RebicValueState` | `none` |
| `valueStateText` | `String?` | `null` |

#### Scenario: Seleção mínima
- **WHEN** `RebicSelect` com três itens e `selectedKey` do segundo é renderizado numa largura de 300
- **THEN** o campo ocupa os 300, tem a altura `density.controlHeight` e mostra o texto do segundo item e a seta para baixo no fim

### Requirement: [API] Rótulo válido
`semanticLabel` MUST NOT ser vazio, e `items` MUST NOT ser vazia, ou a criação MUST falhar em modo debug.

#### Scenario: Seleção sem rótulo
- **WHEN** um `RebicSelect` é criado com `semanticLabel` vazio
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Escolher um item SHALL fechar a lista e chamar `onChange` com o valor dele, como o evento `change`, só quando ele difere de `selectedKey`. O campo MUST NOT mudar sozinho. `RebicSelect` SHALL NOT ter controlador público: a lista é aberta e fechada pelo próprio campo.

#### Scenario: Trocar o item
- **GIVEN** um campo com o primeiro item escolhido, cujo `onChange` atualiza `selectedKey`
- **WHEN** o campo é tocado, e o terceiro item é tocado na lista
- **THEN** a lista fecha, `onChange` recebe o valor do terceiro item, e o campo mostra o texto dele

### Requirement: [Comportamento] Abrir pelo teclado
Com o foco no campo, Enter, Espaço, F4 e Alt+seta para baixo SHALL abrir a lista, com o foco no item escolhido, como no UI5. Esc SHALL fechar a lista e devolver o foco ao campo, sem chamar `onChange`.

#### Scenario: Abrir com Espaço
- **GIVEN** o campo com o foco e o segundo item escolhido
- **WHEN** Espaço é pressionado, e depois Esc
- **THEN** a lista abre com o foco no segundo item e fecha, com o foco de volta no campo, sem chamar `onChange`

### Requirement: [Comportamento] Espaço reservado
Sem item escolhido, o campo SHALL mostrar `placeholder`, na cor `colors.label`, ou nada.

#### Scenario: Campo sem escolha
- **WHEN** um campo sem `selectedKey` e com `placeholder` "Escolha" é renderizado
- **THEN** ele mostra "Escolha" em `colors.label`

### Requirement: [Aparência] Tokens de componente
O campo SHALL ter a altura `density.controlHeight`, o espaço horizontal `spacing.s`, o raio `radius.field`, o fundo `colors.base`, a borda fina `colors.fieldBorder`, o texto `typography.base` com `colors.text` e a seta `RebicIcons.slimArrowDown` em `colors.brand`, no tamanho `icons.control`. Com `valueState`, borda e fundo SHALL vir de `colors.stateColors`; somente leitura, o fundo SHALL ser `colors.headerBackground` e a seta MUST NOT aparecer.

#### Scenario: Aparência da seleção
- **WHEN** um campo normal, um com `valueState` `error` e um somente leitura são renderizados no tema claro
- **THEN** o primeiro tem o fundo `base`, a borda `fieldBorder` e a seta; o segundo a borda e o fundo de `stateColors(error)`; e o terceiro o fundo `headerBackground`, sem seta

### Requirement: [Estados] Interação
O campo SHALL apresentar hover e pressionado (borda `colors.brand`), foco pelo teclado (anel de foco) e desabilitado (opacidade `interaction.disabledOpacity`) de `rebic/core/interaction`. Somente leitura, MUST receber o foco sem abrir a lista. Com `valueStateText`, a mensagem SHALL aparecer abaixo do campo enquanto ele tem o foco, como em `rebic/widgets/rebic-input`.

#### Scenario: Seleção somente leitura
- **GIVEN** um campo com `editable` `false`
- **WHEN** ele recebe o foco por Tab e é tocado
- **THEN** ele tem o foco, e a lista não abre

#### Scenario: Seleção desabilitada
- **GIVEN** um campo com `enabled` `false`
- **WHEN** ele é tocado
- **THEN** a lista não abre, e o conteúdo tem a opacidade `interaction.disabledOpacity`

#### Scenario: Mensagem da seleção
- **GIVEN** um campo com `valueState` `error` e `valueStateText` "Escolha um status"
- **WHEN** ele recebe o foco por Tab
- **THEN** "Escolha um status" aparece abaixo dele

### Requirement: [Acessibilidade] Semântica
O campo SHALL ser exposto como botão com o rótulo `semanticLabel`, o valor do texto do item escolhido, o estado habilitado e a ação de toque; a mensagem de estado SHALL ser a dica. A lista SHALL seguir a semântica de `rebic/widgets/rebic-dropdown`.

#### Scenario: Semântica da seleção
- **WHEN** a árvore de semântica de um campo "Status" com o item "Aprovado" escolhido é lida
- **THEN** ele é botão, com o rótulo "Status", o valor "Aprovado", habilitado e com ação de toque

### Requirement: [Acessibilidade] Contraste e alvo
O texto MUST ter o contraste de texto, a borda e a seta de ao menos 3:1, e o campo o alvo mínimo da densidade, conforme `rebic/foundation/accessibility`. Com escala de texto 2,0, o campo MUST crescer em altura sem estouro.

#### Scenario: Contraste e alvo da seleção
- **WHEN** as diretrizes de contraste de texto, alvo rotulado e alvo mínimo são aplicadas a campos com item e com espaço reservado, nos temas claro e escuro e nas duas densidades, e com escala de texto 2,0
- **THEN** todas são atendidas, e não há estouro

### Requirement: [Responsividade] Largura e direção
O campo SHALL ocupar a largura disponível, com o texto encurtado por reticências; a lista SHALL ter ao menos a largura do campo (`RebicPopoverWidth.anchor`). Em RTL, a seta MUST ficar no lado esquerdo.

#### Scenario: Seleção em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um campo com item escolhido é renderizado
- **THEN** a seta fica no lado esquerdo do campo

### Requirement: [Integração] Dependências
`RebicSelect` SHALL depender somente de `rebic/widgets/rebic-dropdown`, `rebic/widgets/rebic-popover`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/density`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Seleção sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um campo é aberto, um item é escolhido, e campos somente leitura e desabilitado são tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicSelect` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da seleção
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da seleção
- **WHEN** os goldens de campos com item, com espaço reservado, com cada estado de valor, somente leitura e desabilitado são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicSelect` SHALL ter dartdoc em toda API pública e uma página "RebicSelect" na galeria com campos interativos, um com ícones nos itens, um com espaço reservado e campos com estado de valor, somente leitura e desabilitado.

#### Scenario: Página RebicSelect na galeria
- **GIVEN** a página "RebicSelect" aberta na galeria
- **WHEN** o campo "Status" é tocado, e o item "Aprovado" é escolhido
- **THEN** o campo passa a mostrar "Aprovado"

### Requirement: [Restrições] Fora do escopo
`RebicSelect` SHALL NOT aceitar cores ou tamanhos literais, nem ter o tipo `IconOnly`, valores secundários (`showSecondaryValues`), `forceSelection`, `autoAdjustWidth` ou busca.

#### Scenario: Seleção sem valor literal
- **WHEN** a API pública de `RebicSelect` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
