# rebic/widgets/rebic-button Specification

## Purpose

`RebicButton` é o botão de ação do Rebic, como o `sap.m.Button` do SAPUI5: rótulo, ícone opcional antes dele e um dos seis tipos Fiori (`standard`, `emphasized`, `transparent`, `accept`, `reject`, `attention`), com os estados de interação do núcleo, desabilitado quando não há ação e ocupado com um indicador de progresso.

## Requirements

### Requirement: [API] Propriedades
`RebicButton` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `label` | `String` | obrigatória |
| `onPressed` | `VoidCallback?` | obrigatória (`null` desabilita) |
| `type` | `RebicButtonType` | `standard` |
| `icon` | `IconData?` | `null` |
| `busy` | `bool` | `false` |

#### Scenario: Botão mínimo
- **WHEN** `RebicButton(label: 'Salvar', onPressed: …)` é renderizado
- **THEN** ele tem a altura `density.controlHeight`, as cores do normal da família `standard`, e o rótulo "Salvar" centralizado

#### Scenario: Botão com ícone
- **GIVEN** um botão com `icon` e rótulo, em LTR
- **WHEN** ele é renderizado
- **THEN** o ícone fica antes do rótulo, separado por `spacing.xs`

### Requirement: [API] Rótulo válido
`label` MUST NOT ser vazio. Um rótulo vazio MUST falhar em modo debug; ações só com ícone usam `RebicIconButton`.

#### Scenario: Rótulo vazio
- **WHEN** um `RebicButton` é criado com `label` vazio
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
O botão SHALL chamar `onPressed` uma vez por ativação por toque, Enter ou Espaço. Com `onPressed` nulo, o botão MUST ficar desabilitado: sem ativação, fora da ordem de foco e com a opacidade de desabilitado. `RebicButton` SHALL NOT ter controlador.

#### Scenario: Pressionar
- **WHEN** o botão é tocado
- **THEN** `onPressed` é chamado uma vez

#### Scenario: Botão desabilitado
- **GIVEN** um botão com `onPressed` nulo
- **WHEN** ele é tocado
- **THEN** nada é executado, e o conteúdo tem a opacidade `interaction.disabledOpacity`

### Requirement: [Comportamento] Estado ocupado
Com `busy`, o botão SHALL mostrar um indicador circular indeterminado, na cor do texto do estado, no lugar do ícone ou, sem ícone, antes do rótulo. Ele MUST ignorar os acionamentos e manter as cores e o foco.

#### Scenario: Botão ocupado
- **GIVEN** um botão com ícone e `busy`
- **WHEN** ele é tocado
- **THEN** `onPressed` não é chamado, o indicador ocupa o lugar do ícone, e a largura do botão é a mesma de antes

### Requirement: [Comportamento] Ativação pelo teclado
Com o foco no botão, Enter e Espaço SHALL ativá-lo, como define `rebic/core/interaction`.

#### Scenario: Enter e Espaço
- **GIVEN** o botão com o foco
- **WHEN** Enter e depois Espaço são pressionados
- **THEN** `onPressed` é chamado duas vezes

### Requirement: [Aparência] Cores por tipo
Cada tipo SHALL usar a família de controle de mesmo nome de `rebic/foundation/interaction-states`, com a resolução de cores por estado dessa spec: fundo, borda e texto do estado atual. O rótulo e o ícone MUST usar a cor de texto do estado.

#### Scenario: Cores por tipo
- **WHEN** um botão de cada tipo é renderizado no estado normal
- **THEN** o fundo, a borda e o texto de cada um são os do normal da família correspondente

### Requirement: [Aparência] Tokens de componente
A altura SHALL ser `density.controlHeight`, o espaço horizontal interno `spacing.m`, o espaço entre ícone e rótulo `spacing.xs`, o raio `radius.control`, o ícone `icons.control` e o rótulo `typography.bodyStrong`. A borda SHALL ter a espessura fina do framework. Nenhum valor MUST ser literal.

#### Scenario: Medidas da densidade compacta
- **GIVEN** um botão numa subárvore compacta
- **WHEN** ele é renderizado
- **THEN** a altura é o `controlHeight` compacto, e o rótulo começa a `spacing.m` compacto da borda inicial

### Requirement: [Estados] Interação
O botão SHALL apresentar os estados normal, hover, pressionado (ativo), foco pelo teclado e desabilitado de `rebic/core/interaction`. O anel de foco MUST aparecer só com o foco vindo do teclado.

#### Scenario: Hover e pressionado
- **WHEN** o ponteiro fica sobre o botão e depois o pressiona sem soltar
- **THEN** o fundo passa ao do hover e depois ao do ativo da família do tipo

#### Scenario: Foco pelo teclado
- **GIVEN** um botão focável
- **WHEN** ele recebe o foco por Tab e, em outra montagem, por toque
- **THEN** o anel de foco aparece no primeiro caso e não aparece no segundo

### Requirement: [Acessibilidade] Semântica
O botão SHALL ser exposto como botão, com o rótulo `label`, o estado habilitado e a ação de toque. Desabilitado, MUST ser exposto como não habilitado. Ocupado, MUST expor o valor `loading` de `rebic/core/localization`.

#### Scenario: Semântica do botão
- **WHEN** a árvore de semântica de um botão habilitado e de um desabilitado é lida
- **THEN** os dois são botões com o rótulo do `label`, o primeiro habilitado e com ação de toque, e o segundo não habilitado

#### Scenario: Semântica do ocupado
- **GIVEN** um botão ocupado, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o nó do botão tem o valor "Carregando"

### Requirement: [Acessibilidade] Contraste, alvo e escala
O texto de cada tipo MUST manter o contraste, e o botão MUST atender ao alvo mínimo da densidade, conforme `rebic/foundation/accessibility`. Com escala de texto 2,0, o botão MUST crescer em altura sem estouro.

#### Scenario: Contraste e alvo
- **WHEN** as diretrizes de contraste de texto, de rótulo do alvo e de alvo mínimo são aplicadas a um botão de cada tipo, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** um botão com ícone é renderizado
- **THEN** não há estouro, e a altura é de ao menos `controlHeight`

### Requirement: [Responsividade] Largura e direção
O botão SHALL ter a largura do conteúdo e, em espaço menor, MUST encurtar o rótulo com reticências, numa linha. Em RTL, o ícone MUST ficar à direita do rótulo.

#### Scenario: Botão em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um botão com ícone é renderizado
- **THEN** o ícone fica à direita do rótulo

#### Scenario: Rótulo longo
- **GIVEN** um botão com um rótulo longo num espaço de 120 de largura
- **WHEN** ele é renderizado
- **THEN** o botão mede no máximo 120, o rótulo fica numa linha com reticências, e não há estouro

### Requirement: [Integração] Dependências do núcleo e de widgets
Do núcleo e dos widgets, `RebicButton` SHALL depender somente de `rebic/core/interaction`, `rebic/core/localization` e `rebic/widgets/rebic-progress-indicator`.

#### Scenario: Botão sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um botão de cada tipo, um desabilitado e um ocupado são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Integração] Dependências de fundamentos
Dos fundamentos, `RebicButton` SHALL depender somente de `rebic/foundation/interaction-states`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/density`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Botão pelo tema da subárvore
- **GIVEN** um botão `emphasized` numa subárvore com o tema escuro, dentro de uma aplicação clara
- **WHEN** ele é renderizado
- **THEN** o fundo é o `brand` do tema escuro

### Requirement: [Testes] Cobertura exigida
`RebicButton` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria completa de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do botão
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do botão
- **WHEN** os goldens dos seis tipos, com e sem ícone, desabilitado e ocupado, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicButton` SHALL ter dartdoc em toda API pública e uma página "RebicButton" na galeria com um botão de cada tipo, botões com ícone, um desabilitado e um que fica ocupado ao ser tocado.

#### Scenario: Página RebicButton na galeria
- **GIVEN** a página "RebicButton" aberta na galeria
- **WHEN** o botão de exemplo "Enviar" é tocado
- **THEN** ele fica ocupado

### Requirement: [Restrições] Fora do escopo
`RebicButton` SHALL NOT aceitar cores, larguras ou alturas literais, nem funcionar como alternância, menu ou botão só de ícone.

#### Scenario: Botão sem valor literal
- **WHEN** a API pública de `RebicButton` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `Duration`
