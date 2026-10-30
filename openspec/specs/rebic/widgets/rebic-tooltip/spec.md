# rebic/widgets/rebic-tooltip Specification

## Purpose

`RebicTooltip` mostra uma dica textual curta sobre um elemento, como o `tooltip` dos controles do SAPUI5: ela abre com o ponteiro sobre o elemento (após um atraso), com o foco do teclado ou com um toque longo, e fecha pela saída do ponteiro, perda de foco, Esc ou toque fora. Ela permanece enquanto o ponteiro está sobre ela, só uma fica aberta por vez, e a mensagem é anunciada pelo leitor de tela como a dica do próprio elemento.

## Requirements


### Requirement: [API] Propriedades
`RebicTooltip` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `message` | `String` | obrigatória |
| `child` | `Widget` | obrigatória |
| `placement` | `RebicPlacement` | `bottom` |
| `excludeFromSemantics` | `bool` | `false` |

#### Scenario: Tooltip mínimo
- **GIVEN** um `RebicTooltip` com `message` "Editar pedido" em volta de um ícone
- **WHEN** o ponteiro fica sobre o ícone além do atraso de abertura
- **THEN** a dica "Editar pedido" aparece abaixo do ícone, centralizada nele e afastada `spacing.xs`

### Requirement: [API] Mensagem válida
`message` MUST NOT ser vazia. Uma mensagem vazia MUST falhar em modo debug.

#### Scenario: Mensagem vazia
- **WHEN** um `RebicTooltip` é criado com `message` vazia
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
`RebicTooltip` SHALL NOT ter callbacks nem controlador e MUST NOT impedir os gestos do filho.

#### Scenario: Toque no filho preservado
- **GIVEN** um `RebicTooltip` em volta de um elemento tocável
- **WHEN** o elemento é tocado
- **THEN** a ação do elemento é executada uma vez

### Requirement: [Comportamento] Abertura e fechamento pelo ponteiro
Com o ponteiro sobre o filho, a dica SHALL abrir após `motion.long`. Quando o ponteiro sai do filho, a dica SHALL fechar após `motion.short`, a menos que o ponteiro chegue à dica nesse intervalo.

#### Scenario: Hover com atraso
- **GIVEN** o ponteiro movido para cima do filho
- **WHEN** passa metade de `motion.long` e depois o restante
- **THEN** a dica não está aberta na metade e está aberta ao fim

#### Scenario: Saída do ponteiro
- **GIVEN** a dica aberta pelo ponteiro
- **WHEN** o ponteiro sai do filho para uma área vazia e passa `motion.short`
- **THEN** a dica fecha

### Requirement: [Comportamento] Permanência sobre a dica
A dica MUST permanecer aberta enquanto o ponteiro está sobre ela, conforme o critério 1.4.13 da WCAG 2.2 (conteúdo apontável).

#### Scenario: Ponteiro sobre a dica
- **GIVEN** a dica aberta pelo ponteiro
- **WHEN** o ponteiro vai do filho para a dica e fica sobre ela por `motion.long`
- **THEN** a dica continua aberta

### Requirement: [Comportamento] Abertura por foco e por toque
A dica SHALL abrir sem atraso quando o filho recebe o foco pelo teclado e MUST fechar quando o filho perde o foco. Um toque longo no filho SHALL abrir a dica, e um toque fora dela MUST fechá-la.

#### Scenario: Foco pelo teclado
- **GIVEN** um filho focável com dica e outro elemento focável depois dele
- **WHEN** Tab leva o foco ao filho e depois ao outro elemento
- **THEN** a dica abre com o foco no filho e fecha quando o foco sai

#### Scenario: Toque longo
- **WHEN** o filho recebe um toque longo e depois uma área vazia é tocada
- **THEN** a dica abre no toque longo e fecha no toque fora

### Requirement: [Comportamento] Uma dica por vez
Abrir uma dica MUST fechar qualquer outra dica aberta.

#### Scenario: Segunda dica fecha a primeira
- **GIVEN** a dica de um elemento aberta pelo foco
- **WHEN** um segundo elemento com dica recebe um toque longo
- **THEN** só a dica do segundo elemento está aberta

### Requirement: [Aparência] Tokens de componente
A dica SHALL usar a superfície `colors.base` com a borda `colors.separator`, o raio `radius.s`, a sombra `shadows.popover`, os espaços internos `spacing.s` (horizontal) e `spacing.xs` (vertical) e o texto em `RebicText`, de `rebic/widgets/rebic-text`. A largura máxima SHALL ser derivada de `spacing.xxxl`, e mensagens mais longas MUST quebrar em linhas.

#### Scenario: Aparência da dica
- **WHEN** a dica aberta é renderizada nos temas claro e escuro
- **THEN** o fundo é `colors.base`, a borda é `colors.separator`, há a sombra `shadows.popover`, e o texto tem o estilo `base` e a cor `text`

### Requirement: [Aparência] Movimento da dica
Com movimento reduzido, os atrasos de abertura e fechamento SHALL ser zero, conforme `rebic/foundation/accessibility`.

#### Scenario: Abertura sem atraso no movimento reduzido
- **GIVEN** o movimento reduzido ativo
- **WHEN** o ponteiro é movido para cima do filho e um quadro é desenhado
- **THEN** a dica já está aberta

### Requirement: [Estados] Sem estados próprios
`RebicTooltip` SHALL NOT apresentar estados de interação nem receber o foco. Os estados do filho MUST NOT ser alterados pela dica.

#### Scenario: Dica não recebe foco
- **GIVEN** um filho focável com dica aberta e outro elemento focável depois dele
- **WHEN** Tab é pressionado com o foco no filho
- **THEN** o foco vai ao outro elemento, sem parada na dica

### Requirement: [Acessibilidade] Teclado
Esc MUST fechar a dica aberta sem mover o foco, conforme o critério 1.4.13 da WCAG 2.2 (conteúdo dispensável).

#### Scenario: Esc fecha a dica
- **GIVEN** a dica aberta pelo foco do teclado no filho
- **WHEN** Esc é pressionado
- **THEN** a dica fecha, e o foco continua no filho

### Requirement: [Acessibilidade] Semântica e contraste
A mensagem SHALL ser exposta como a dica (`tooltip`) do nó do filho, exceto com `excludeFromSemantics`, quando o filho já anuncia a mensagem como rótulo. A sobreposição MUST NOT acrescentar outro nó com a mensagem. O texto da dica MUST manter o contraste sobre `colors.base`, conforme `rebic/foundation/accessibility`.

#### Scenario: Mensagem na semântica do filho
- **GIVEN** a dica aberta em volta de um botão com rótulo "Editar"
- **WHEN** a árvore de semântica é lida
- **THEN** o nó do botão tem a dica "Editar pedido", e nenhum outro nó tem esse texto

#### Scenario: Contraste da dica
- **WHEN** a diretriz de contraste de texto é aplicada à dica aberta, nos temas claro e escuro
- **THEN** a diretriz é atendida

#### Scenario: Dica fora da semântica
- **GIVEN** a dica com `excludeFromSemantics` em volta de um botão cujo rótulo é a própria mensagem
- **WHEN** a árvore de semântica é lida
- **THEN** o nó do botão não tem dica, e a mensagem aparece uma única vez, como rótulo

### Requirement: [Responsividade] Bordas e direção
A dica MUST ficar dentro da tela, com a inversão de lado e o limite de bordas de `rebic/core/overlay`. Em RTL, `start` e `end` seguem a direção do texto, como no núcleo.

#### Scenario: Dica junto à borda
- **GIVEN** um filho junto à borda direita e à base da tela, com uma mensagem longa
- **WHEN** a dica é aberta
- **THEN** ela aparece acima do filho, dentro da tela, com a largura no máximo igual à largura máxima

### Requirement: [Integração] Dependências
`RebicTooltip` SHALL depender somente de `rebic/core/overlay`, `rebic/widgets/rebic-text`, `rebic/widgets/rebic-container`, `rebic/foundation/color`, `rebic/foundation/shadows`, `rebic/foundation/radius`, `rebic/foundation/spacing`, `rebic/foundation/design-tokens`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Tooltip sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** uma dica é aberta e fechada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicTooltip` MUST ter um teste de widget por cenário, goldens da dica aberta nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: contraste, semântica e teclado. O alvo de toque é o do filho e não se aplica à dica.

#### Scenario: Rastreabilidade da dica
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da dica
- **WHEN** os goldens da dica aberta, curta e longa, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicTooltip` SHALL ter dartdoc em toda API pública e uma página "RebicTooltip" na galeria com ícones com dica e uma dica longa.

#### Scenario: Página RebicTooltip na galeria
- **GIVEN** a página "RebicTooltip" aberta na galeria
- **WHEN** o ponteiro fica sobre o primeiro ícone de exemplo
- **THEN** a dica dele aparece

### Requirement: [Restrições] Fora do escopo
`RebicTooltip` SHALL NOT aceitar conteúdo que não seja texto, cores, larguras ou atrasos literais, nem desenhar seta.

#### Scenario: Tooltip sem valor literal
- **WHEN** a API pública de `RebicTooltip` é inspecionada
- **THEN** `message` é `String`, e não há parâmetro do tipo `double`, `Color`, `Duration` ou `Widget` além de `child`
