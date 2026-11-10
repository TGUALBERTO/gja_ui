# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaButton` SHALL expor, como o `sap.m.Button`:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String?` | `null` |
| `icon` | `IconData?` | `null` |
| `tooltip` | `String?` | `null` |
| `type` | `GjaButtonType` | `standard` |
| `enabled` | `bool` | `true` |
| `onPress` | `VoidCallback?` | `null` |
| `busy` | `bool` | `false` |

#### Scenario: Botão mínimo
- **WHEN** `GjaButton(text: 'Salvar', onPress: …)` é renderizado
- **THEN** ele tem a altura `density.controlHeight`, as cores do normal da família `standard`, e o texto "Salvar" centralizado

#### Scenario: Botão com ícone
- **GIVEN** um botão com `icon` e `text`, em LTR
- **WHEN** ele é renderizado
- **THEN** o ícone fica antes do texto, separado por `spacing.xs`

#### Scenario: Botão só com ícone
- **WHEN** `GjaButton(icon: GjaIcons.edit, tooltip: 'Editar', onPress: …)` é renderizado
- **THEN** ele é um quadrado de lado `density.controlHeight`, com as cores do normal da família `standard` e o ícone de tamanho `icons.control` centralizado

### Requirement: [API] Callbacks e controlador
O botão SHALL chamar `onPress` uma vez por ativação por toque, Enter ou Espaço. Com `enabled` `false`, o botão MUST ficar desabilitado: sem ativação, fora da ordem de foco e com a opacidade de desabilitado. Com `onPress` nulo e `enabled` `true`, o botão SHALL continuar habilitado e focável, sem ação. `GjaButton` SHALL NOT ter controlador.

#### Scenario: Pressionar
- **WHEN** o botão é tocado
- **THEN** `onPress` é chamado uma vez

#### Scenario: Botão desabilitado
- **GIVEN** um botão com `enabled` `false` e um `onPress`
- **WHEN** ele é tocado
- **THEN** `onPress` não é chamado, e o conteúdo tem a opacidade `interaction.disabledOpacity`

#### Scenario: Botão sem ação
- **GIVEN** um botão com `onPress` nulo entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro e o botão é tocado
- **THEN** o botão recebe o foco, não tem a opacidade de desabilitado, e o toque não gera erro

### Requirement: [Comportamento] Estado ocupado
Com `busy`, o botão SHALL mostrar um indicador circular indeterminado, na cor do texto do estado, no lugar do ícone ou, sem ícone, antes do texto. Ele MUST ignorar os acionamentos e manter as cores, o tamanho e o foco.

#### Scenario: Botão ocupado
- **GIVEN** um botão com ícone, texto e `busy`
- **WHEN** ele é tocado
- **THEN** `onPress` não é chamado, o indicador ocupa o lugar do ícone, e a largura do botão é a mesma de antes

#### Scenario: Botão só com ícone ocupado
- **GIVEN** um botão só com ícone e `busy`
- **WHEN** ele é renderizado
- **THEN** o indicador fica no lugar do ícone, e o botão continua um quadrado de lado `density.controlHeight`

### Requirement: [Comportamento] Ativação pelo teclado
Com o foco no botão, Enter e Espaço SHALL ativá-lo, como define `gja/core/interaction`.

#### Scenario: Enter e Espaço
- **GIVEN** o botão com o foco
- **WHEN** Enter e depois Espaço são pressionados
- **THEN** `onPress` é chamado duas vezes

### Requirement: [Aparência] Tokens de componente
A altura SHALL ser `density.controlHeight`, o espaço horizontal interno `spacing.m`, o espaço entre ícone e texto `spacing.xs`, o raio `radius.button`, o ícone `icons.control` e o texto `typography.baseSemibold`. Sem `text`, o botão SHALL ser um quadrado de lado `density.controlHeight`, sem espaço interno. A borda SHALL ter a espessura fina do framework. Nenhum valor MUST ser literal.

#### Scenario: Medidas da densidade compacta
- **GIVEN** um botão com texto e um só com ícone, numa subárvore compacta
- **WHEN** eles são renderizados
- **THEN** a altura dos dois é o `controlHeight` compacto, o texto começa a `spacing.m` da borda inicial, e o botão só com ícone é um quadrado com esse lado

### Requirement: [Acessibilidade] Semântica
O botão SHALL ser exposto como botão, com o estado habilitado e a ação de toque. O rótulo SHALL ser `text` ou, sem ele, `tooltip`; com os dois, `tooltip` SHALL ser exposta como dica. A mensagem do botão só com ícone MUST aparecer uma única vez, como rótulo. Desabilitado, MUST ser exposto como não habilitado. Ocupado, MUST expor o valor `loading` de `gja/core/localization`.

#### Scenario: Semântica do botão
- **WHEN** a árvore de semântica de um botão habilitado e de um com `enabled` `false` é lida
- **THEN** os dois são botões com o rótulo do `text`, o primeiro habilitado e com ação de toque, e o segundo não habilitado

#### Scenario: Semântica do botão só com ícone
- **GIVEN** um botão só com ícone e `tooltip` "Editar", e um botão com `text` "Salvar" e `tooltip` "Salvar o pedido"
- **WHEN** a árvore de semântica é lida
- **THEN** o primeiro é um botão de rótulo "Editar", sem dica; o segundo tem o rótulo "Salvar" e a dica "Salvar o pedido"

#### Scenario: Semântica do ocupado
- **GIVEN** um botão ocupado, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o nó do botão tem o valor "Carregando"

### Requirement: [Acessibilidade] Contraste, alvo e escala
O texto de cada tipo MUST manter o contraste de texto, e o ícone do botão só com ícone, o de ao menos 3:1 sobre o fundo do estado. O botão MUST atender ao alvo mínimo da densidade e à diretriz de alvo rotulado, conforme `gja/foundation/accessibility`. Com escala de texto 2,0, o botão com texto MUST crescer em altura sem estouro, e o botão só com ícone MUST manter o tamanho.

#### Scenario: Contraste e alvo
- **WHEN** as diretrizes de contraste de texto, de alvo rotulado e de alvo mínimo são aplicadas a um botão com texto e a um só com ícone de cada tipo, nos temas claro e escuro e nas duas densidades, e o contraste do ícone é medido
- **THEN** todas as diretrizes são atendidas, e o contraste do ícone é de ao menos 3:1

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** um botão com ícone e texto e um só com ícone são renderizados
- **THEN** não há estouro, o primeiro tem ao menos `controlHeight` de altura, e o segundo continua um quadrado de lado `controlHeight`

### Requirement: [Responsividade] Largura e direção
O botão com texto SHALL ter a largura do conteúdo e, em espaço menor, MUST encurtar o texto com reticências, numa linha. Em RTL, o ícone MUST ficar à direita do texto, e ícones direcionais (com espelhamento no catálogo) MUST ser espelhados.

#### Scenario: Botão em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um botão com ícone e texto é renderizado
- **THEN** o ícone fica à direita do texto

#### Scenario: Rótulo longo
- **GIVEN** um botão com um texto longo num espaço de 120 de largura
- **WHEN** ele é renderizado
- **THEN** o botão mede no máximo 120, o texto fica numa linha com reticências, e não há estouro

#### Scenario: Ícone direcional em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um botão só com o ícone `GjaIcons.navBack` é renderizado
- **THEN** o ícone é desenhado espelhado, apontando para a direita

### Requirement: [Integração] Dependências do núcleo e de widgets
Do núcleo e dos widgets, `GjaButton` SHALL depender somente de `gja/core/interaction`, `gja/core/localization`, `gja/widgets/gja-progress-indicator` e `gja/widgets/gja-tooltip`.

#### Scenario: Botão sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um botão com texto e um só com ícone de cada tipo, um desabilitado e um ocupado são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

#### Scenario: Barra e página usam o botão
- **WHEN** um `GjaShellBar` com o botão de menu e uma `GjaPage` com `showNavButton` são renderizados, em pt-BR
- **THEN** o botão de menu e o de voltar são `GjaButton` só com ícone, do tipo `transparent`, com as dicas "Menu" e "Voltar"

### Requirement: [Testes] Cobertura exigida
`GjaButton` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria completa de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do botão
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do botão
- **WHEN** os goldens dos seis tipos com texto, com ícone e texto e só com ícone, de um desabilitado e de um ocupado são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaButton` SHALL ter dartdoc em toda API pública e uma página "GjaButton" na galeria com um botão de cada tipo, botões com ícone, uma barra de ações só com ícone, um desabilitado e um que fica ocupado ao ser tocado.

#### Scenario: Página GjaButton na galeria
- **GIVEN** a página "GjaButton" aberta na galeria
- **WHEN** o botão de exemplo "Enviar" é tocado, e o primeiro botão da barra de ações recebe o foco por Tab
- **THEN** "Enviar" fica ocupado, e a dica do botão da barra aparece

### Requirement: [Restrições] Fora do escopo
`GjaButton` SHALL NOT aceitar cores, larguras ou alturas literais, nem funcionar como alternância ou menu; `width`, `iconFirst`, `activeIcon` e os tipos `Ghost`, `Back`, `Up`, `Critical`, `Negative`, `Success` e `Neutral` ficam fora.

#### Scenario: Botão sem valor literal
- **WHEN** a API pública de `GjaButton` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color`, `Duration` ou `Widget`

## ADDED Requirements

### Requirement: [API] Conteúdo válido
O botão MUST ter `text` não vazio ou `icon`. Sem `text`, `tooltip` MUST ser não vazia, porque é o único texto da ação. Uma combinação inválida MUST falhar em modo debug.

#### Scenario: Botão sem conteúdo
- **WHEN** um `GjaButton` é criado sem `text` nem `icon`, e outro só com `icon` e sem `tooltip`
- **THEN** as duas criações falham em modo debug

### Requirement: [Comportamento] Dica
Com `tooltip`, a dica SHALL ser mostrada pelo `gja/widgets/gja-tooltip`: com o ponteiro sobre o botão após o atraso, com o foco do teclado e com um toque longo.

#### Scenario: Dica no hover
- **WHEN** o ponteiro fica sobre um botão só com ícone além de `motion.long`
- **THEN** a dica com o texto de `tooltip` aparece

#### Scenario: Dica no foco do teclado
- **WHEN** um botão com `tooltip` recebe o foco por Tab
- **THEN** o anel de foco aparece, e a dica abre

## REMOVED Requirements

### Requirement: [API] Rótulo válido
**Reason**: o botão passa a aceitar só ícone, como o `sap.m.Button`; a validação passa a "[API] Conteúdo válido".
**Migration**: Use `text` no lugar de `label`; para uma ação só com ícone, use `GjaButton(icon: …, tooltip: …)`.
