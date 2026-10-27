# rebic/widgets/rebic-divider Specification

## Purpose

`RebicDivider` separa grupos de conteúdo com uma linha fina, como os separadores de lista e de barra do SAPUI5: desenha uma linha horizontal ou vertical com a cor de um papel do tema, com espaço em volta e recuo nas pontas por passos de espaçamento, sem valores literais.

## Requirements

### Requirement: [API] Propriedades
`RebicDivider` SHALL expor dois construtores com as mesmas propriedades:

| Prop | Tipo | Padrão |
|---|---|---|
| `tone` | `RebicDividerTone` | `subtle` |
| `spacing` | `RebicSpace` | `none` |
| `indent` | `RebicSpace?` | sem recuo |
| `endIndent` | `RebicSpace?` | sem recuo |

`RebicDivider()` SHALL ser horizontal, e `RebicDivider.vertical()` SHALL ser vertical. `RebicDividerTone` SHALL ter `subtle` e `strong`.

#### Scenario: Divisor mínimo
- **GIVEN** uma árvore com `RebicApp` e uma coluna de 300 de largura
- **WHEN** `RebicDivider()` é colocado nela
- **THEN** ele ocupa os 300 de largura e tem a altura da linha fina, na cor `separator`

### Requirement: [API] Callbacks e controlador
`RebicDivider` SHALL NOT ter callbacks nem controlador: é um elemento decorativo.

#### Scenario: Divisor sem ação
- **GIVEN** `RebicDivider` com `spacing` `l`
- **WHEN** a área do divisor é tocada
- **THEN** nada é executado pelo `RebicDivider`

### Requirement: [Comportamento] Orientação
`RebicDivider()` SHALL ocupar toda a largura disponível, e `RebicDivider.vertical()` toda a altura disponível. A extensão no outro eixo MUST ser a linha fina mais duas vezes `spacing`.

#### Scenario: Divisor vertical numa linha
- **GIVEN** um `RebicRow` de 40 de altura com `crossAlignment` `stretch` e dois textos separados por `RebicDivider.vertical(spacing: s)`
- **WHEN** a linha é renderizada
- **THEN** o divisor tem 40 de altura e a largura da linha fina mais 2 × `spacing.s`

### Requirement: [Comportamento] Recuo direcional
`indent` SHALL recuar o início da linha e `endIndent` o fim, no eixo da linha. Na horizontal, início e fim MUST seguir a direção do texto. Na vertical, `indent` é o topo e `endIndent` é a base.

#### Scenario: Recuo em LTR e RTL
- **GIVEN** um `RebicDivider(indent: l)` numa coluna de 300 de largura
- **WHEN** ele é renderizado em LTR e depois em RTL
- **THEN** a linha começa a `spacing.l` da esquerda em LTR e termina a `spacing.l` da direita em RTL, com 300 − `spacing.l` de comprimento

### Requirement: [Aparência] Tokens de componente
`RebicDivider` SHALL obter a cor de `colors.separator` (`subtle`) ou `colors.fieldBorder` (`strong`), o espaço e o recuo de `spacing.<valor>`, todos do tema ativo, e a espessura da linha fina padrão, sem valores literais.

#### Scenario: Troca de tema do divisor
- **GIVEN** `RebicDivider(tone: strong)` no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** a linha usa o `fieldBorder` do escuro, sem recriar o widget com outros parâmetros

#### Scenario: Tons do divisor
- **WHEN** os dois tons são renderizados no tema claro
- **THEN** `subtle` usa `separator`, e `strong` usa `fieldBorder`

### Requirement: [Estados] Sem estados de interação
`RebicDivider` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado.

#### Scenario: Divisor não recebe foco
- **GIVEN** um `RebicDivider` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai direto ao segundo

### Requirement: [Acessibilidade] Teclado e foco
`RebicDivider` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas pelo divisor
- **GIVEN** uma página com `RebicDivider` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Acessibilidade] Semântica e contraste
`RebicDivider` SHALL ficar fora da árvore de semântica, por ser decorativo. O tom `subtle` (`separator`) é decorativo e isento de contraste mínimo. O tom `strong` (`fieldBorder`) MUST ter contraste ≥ 3:1 sobre `base` e `background`, para separar estruturas, conforme `rebic/foundation/accessibility`.

#### Scenario: Divisor fora da semântica
- **WHEN** um leitor de tela percorre uma página com dois textos separados por `RebicDivider`
- **THEN** são anunciados só os dois textos

#### Scenario: Contraste do tom forte
- **WHEN** a razão de contraste de `fieldBorder` é calculada sobre `base` e `background`, nos temas claro e escuro
- **THEN** todas são ≥ 3:1

### Requirement: [Responsividade] Densidade
O `spacing` e o recuo SHALL usar o espaçamento da densidade ativa. A espessura MUST ser a mesma nas duas densidades e em qualquer escala de texto.

#### Scenario: Densidade compacta do divisor
- **GIVEN** um `RebicDivider(spacing: l)`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** a altura é a linha fina mais 2 × `l` compacto dentro, e mais 2 × `l` confortável fora

### Requirement: [Integração] Dependências
`RebicDivider` SHALL depender somente de `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/theming`, `rebic/foundation/accessibility` e `rebic/widgets/rebic-spacing`.

#### Scenario: Divisor sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** as duas orientações e os dois tons de `RebicDivider` são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicDivider` MUST ter um teste de widget por cenário, goldens das orientações e dos tons nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: contraste do tom forte e semântica. As diretrizes de texto, de alvo de toque e o teclado não se aplicam.

#### Scenario: Rastreabilidade do divisor
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do divisor
- **WHEN** os goldens de `RebicDivider` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`RebicDivider` SHALL ter dartdoc em toda API pública e uma página "RebicDivider" na galeria com as duas orientações, os dois tons, `spacing` e recuo.

#### Scenario: Página RebicDivider na galeria
- **WHEN** a página "RebicDivider" é aberta
- **THEN** ela exibe divisores horizontais e verticais nos dois tons, com e sem `spacing` e recuo

### Requirement: [Restrições] Fora do escopo
`RebicDivider` SHALL NOT aceitar cor, espessura ou espaço literais, desenhar linha tracejada nem exibir texto.

#### Scenario: Divisor sem valor literal
- **WHEN** a API pública de `RebicDivider` é inspecionada
- **THEN** não há parâmetro dos tipos `Color`, `double` ou `EdgeInsets`
