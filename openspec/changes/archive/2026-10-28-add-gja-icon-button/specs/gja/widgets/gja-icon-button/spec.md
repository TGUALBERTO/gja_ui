## Purpose

`GjaIconButton` é o botão só com ícone do GJA, como o `sap.m.Button` com `icon` e `tooltip` do SAPUI5: quadrado, com um dos tipos Fiori (padrão `transparent`), os estados de interação do núcleo, desabilitado quando não há ação e uma dica obrigatória, mostrada pelo `GjaTooltip` e anunciada como rótulo do botão.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaIconButton` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `icon` | `IconData` | obrigatória |
| `tooltip` | `String` | obrigatória |
| `onPressed` | `VoidCallback?` | obrigatória (`null` desabilita) |
| `type` | `GjaButtonType` | `transparent` |

#### Scenario: Botão de ícone mínimo
- **WHEN** `GjaIconButton(icon: GjaIcons.edit, tooltip: 'Editar', onPressed: …)` é renderizado
- **THEN** ele é um quadrado de lado `density.controlHeight`, com as cores do normal da família `transparent` e o ícone de tamanho `icons.control` centralizado

### Requirement: [API] Dica obrigatória
`tooltip` MUST NOT ser vazia, porque é o único texto da ação. Uma dica vazia MUST falhar em modo debug.

#### Scenario: Dica vazia
- **WHEN** um `GjaIconButton` é criado com `tooltip` vazia
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
O botão SHALL chamar `onPressed` uma vez por ativação por toque, Enter ou Espaço. Com `onPressed` nulo, MUST ficar desabilitado: sem ativação, fora da ordem de foco e com a opacidade de desabilitado. `GjaIconButton` SHALL NOT ter controlador.

#### Scenario: Pressionar o botão de ícone
- **WHEN** o botão é tocado
- **THEN** `onPressed` é chamado uma vez

#### Scenario: Botão de ícone desabilitado
- **GIVEN** um botão com `onPressed` nulo
- **WHEN** ele é tocado
- **THEN** nada é executado, e o conteúdo tem a opacidade `interaction.disabledOpacity`

### Requirement: [Comportamento] Dica
A dica SHALL ser mostrada pelo `gja/widgets/gja-tooltip`, com a mensagem `tooltip`: com o ponteiro sobre o botão após o atraso, com o foco do teclado e com um toque longo.

#### Scenario: Dica no hover
- **WHEN** o ponteiro fica sobre o botão além de `motion.long`
- **THEN** a dica com o texto de `tooltip` aparece

### Requirement: [Comportamento] Ativação pelo teclado
Com o foco no botão, Enter e Espaço SHALL ativá-lo, como define `gja/core/interaction`.

#### Scenario: Enter e Espaço no botão de ícone
- **GIVEN** o botão com o foco
- **WHEN** Enter e depois Espaço são pressionados
- **THEN** `onPressed` é chamado duas vezes

### Requirement: [Aparência] Cores por tipo
Cada tipo SHALL usar a família de controle de mesmo nome de `gja/foundation/interaction-states`, com fundo, borda e texto do estado atual. O ícone MUST usar a cor de texto do estado.

#### Scenario: Cores do botão de ícone por tipo
- **WHEN** um botão de ícone de cada tipo é renderizado no estado normal
- **THEN** o fundo, a borda e a cor do ícone de cada um são os do normal da família correspondente

### Requirement: [Aparência] Tokens de componente
O lado SHALL ser `density.controlHeight`, o raio `radius.control` e o ícone `icons.control`, com a borda fina do framework, sem valores literais. A escala de texto MUST NOT alterar o tamanho.

#### Scenario: Botão de ícone na densidade compacta
- **GIVEN** um botão de ícone numa subárvore compacta, com escala de texto 2,0
- **WHEN** ele é renderizado
- **THEN** ele é um quadrado com o lado `controlHeight` compacto, e o ícone mede `icons.control`

### Requirement: [Estados] Interação
O botão SHALL apresentar os estados normal, hover, pressionado (ativo), foco pelo teclado e desabilitado de `gja/core/interaction`. O anel de foco MUST aparecer só com o foco vindo do teclado.

#### Scenario: Hover e pressionado no botão de ícone
- **WHEN** o ponteiro fica sobre o botão e depois o pressiona sem soltar
- **THEN** o fundo passa ao do hover e depois ao do ativo da família do tipo

#### Scenario: Foco pelo teclado no botão de ícone
- **WHEN** o botão recebe o foco por Tab
- **THEN** o anel de foco aparece, e a dica abre

### Requirement: [Acessibilidade] Semântica
O botão SHALL ser exposto como botão, com o rótulo `tooltip`, o estado habilitado e a ação de toque. A mensagem MUST aparecer uma única vez na árvore de semântica, como rótulo, sem repetir como dica. Desabilitado, MUST ser exposto como não habilitado.

#### Scenario: Semântica do botão de ícone
- **GIVEN** um botão de ícone habilitado com `tooltip` "Editar" e um desabilitado com "Excluir"
- **WHEN** a árvore de semântica é lida
- **THEN** os dois são botões com esses rótulos, sem dica, o primeiro habilitado e com ação de toque e o segundo não habilitado

### Requirement: [Acessibilidade] Contraste e alvo
O ícone de cada tipo MUST ter contraste de ao menos 3:1 sobre o fundo do estado, e o botão MUST atender ao alvo mínimo da densidade e à diretriz de alvo rotulado, conforme `gja/foundation/accessibility`.

#### Scenario: Contraste e alvo do botão de ícone
- **WHEN** as diretrizes de alvo rotulado e de alvo mínimo são aplicadas a um botão de cada tipo, nos temas claro e escuro e nas duas densidades, e o contraste do ícone é medido
- **THEN** as diretrizes são atendidas, e o contraste é de ao menos 3:1

### Requirement: [Responsividade] Direção
O botão SHALL ter tamanho fixo pela densidade. Em RTL, ícones direcionais (com espelhamento no catálogo) MUST ser espelhados.

#### Scenario: Ícone direcional em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um botão de ícone com `GjaIcons.arrowLeft` é renderizado
- **THEN** o ícone é desenhado espelhado, apontando para a direita

### Requirement: [Integração] Dependências
`GjaIconButton` SHALL depender somente de `gja/core/interaction`, `gja/widgets/gja-tooltip`, `gja/widgets/gja-button` (`GjaButtonType`), `gja/foundation/interaction-states`, `gja/foundation/iconography`, `gja/foundation/density`, `gja/foundation/radius`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Botão de ícone sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um botão de ícone de cada tipo e um desabilitado são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

#### Scenario: Scaffold e página usam o botão de ícone
- **WHEN** um `GjaScaffold` com navegação e uma `GjaPage` com `onBack` são renderizados
- **THEN** o botão de navegação e o de voltar são `GjaIconButton` com as dicas "Navegação" e "Voltar"

### Requirement: [Testes] Cobertura exigida
`GjaIconButton` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do botão de ícone
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do botão de ícone
- **WHEN** os goldens dos seis tipos e de um desabilitado são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaIconButton` SHALL ter dartdoc em toda API pública e uma página "GjaIconButton" na galeria com uma barra de ações de ícone, um botão de cada tipo e um desabilitado.

#### Scenario: Página GjaIconButton na galeria
- **GIVEN** a página "GjaIconButton" aberta na galeria
- **WHEN** o primeiro botão da barra de ações recebe o foco por Tab
- **THEN** a dica dele aparece

### Requirement: [Restrições] Fora do escopo
`GjaIconButton` SHALL NOT aceitar cores, tamanhos ou rótulos visíveis, nem ter estado ocupado ou de alternância.

#### Scenario: Botão de ícone sem valor literal
- **WHEN** a API pública de `GjaIconButton` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color`, `Duration` ou `Widget`
