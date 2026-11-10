## Purpose

`GjaProgressIndicator` mostra o andamento de uma operação, como o `sap.m.ProgressIndicator` e o `sap.m.BusyIndicator` do SAPUI5: uma barra na largura disponível ou um círculo no tamanho de um ícone, determinado (com valor de 0 a 1) ou indeterminado (animado), com a cor do estado de valor, semântica de progresso e respeito ao movimento reduzido.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaProgressIndicator` SHALL expor os construtores `linear` e `circular`, com:

| Prop | Tipo | Padrão |
|---|---|---|
| `value` | `double?` | `null` (indeterminado) |
| `state` | `GjaValueState` | `none` |
| `semanticLabel` | `String?` | texto `loading` |
| `size` (só `circular`) | `GjaIconSize` | `control` |

#### Scenario: Barra determinada
- **GIVEN** uma área de 400 de largura, em LTR
- **WHEN** `GjaProgressIndicator.linear(value: 0.45)` é renderizado
- **THEN** a barra ocupa os 400, e o preenchimento mede 180 a partir da borda inicial

#### Scenario: Círculo no tamanho de ícone
- **WHEN** `GjaProgressIndicator.circular(size: GjaIconSize.xLarge)` é renderizado
- **THEN** ele é um quadrado com o lado `icons.xLarge` do tema

### Requirement: [API] Valor válido
`value`, quando informado, MUST estar entre 0 e 1. Um valor fora do intervalo MUST falhar em modo debug com mensagem que cita o valor.

#### Scenario: Valor fora do intervalo
- **WHEN** `GjaProgressIndicator.linear(value: 1.2)` é criado
- **THEN** a criação falha em modo debug com mensagem que cita 1.2

### Requirement: [API] Callbacks e controlador
`GjaProgressIndicator` SHALL NOT ter callbacks nem controlador: o valor vem da aplicação a cada construção.

#### Scenario: Indicador sem ação
- **GIVEN** uma barra determinada
- **WHEN** ela é tocada
- **THEN** nada é executado, e não há detector de gestos no indicador

### Requirement: [Comportamento] Determinado e indeterminado
Com `value`, o preenchimento SHALL corresponder ao valor e, quando o valor muda, MUST chegar ao novo valor com a duração `motion.short`. Sem `value`, o indicador SHALL ser animado continuamente, com um ciclo de quatro vezes `motion.long`.

#### Scenario: Valor atualizado
- **GIVEN** uma barra de 400 com `value` 0.45
- **WHEN** ela é reconstruída com `value` 0.8 e as animações terminam
- **THEN** o preenchimento mede 320

#### Scenario: Indeterminado em movimento
- **GIVEN** um indicador circular sem `value`
- **WHEN** meio ciclo passa
- **THEN** o desenho mudou, e há quadros agendados enquanto ele está na tela

### Requirement: [Comportamento] Movimento reduzido
Com movimento reduzido, o indeterminado MUST ficar parado, sem agendar quadros. A barra SHALL mostrar um segmento fixo de um terço no centro da trilha, e o círculo SHALL mostrar um arco fixo de um quarto.

#### Scenario: Indeterminado estático
- **GIVEN** o movimento reduzido ativo
- **WHEN** uma barra sem `value` é renderizada
- **THEN** não há quadros agendados, e o segmento mede um terço da trilha, centrado

### Requirement: [Aparência] Tokens de componente
O preenchimento SHALL usar `colors.brand` no estado `none` e `stateColors(state).foreground` nos demais. A trilha SHALL usar `colors.separator`. A espessura da barra SHALL ser `spacing.xs`, o traço do círculo `spacing.xxs` e o lado do círculo `icons.<size>`, sem valores literais.

#### Scenario: Cores por estado
- **WHEN** barras determinadas são renderizadas em cada estado de valor
- **THEN** o preenchimento de `none` é `colors.brand`, o de cada outro estado é a cor de frente do estado, e a trilha é `colors.separator`

#### Scenario: Espessura da densidade compacta
- **GIVEN** uma barra numa subárvore compacta
- **WHEN** ela é renderizada
- **THEN** a altura dela é o `spacing.xs` compacto

### Requirement: [Estados] Sem estados de interação
`GjaProgressIndicator` SHALL NOT apresentar estados de interação, porque não é interativo. Os estados de valor só mudam a cor do preenchimento.

#### Scenario: Indicador não recebe foco
- **GIVEN** um indicador entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no indicador

### Requirement: [Acessibilidade] Semântica
O indicador SHALL ser exposto com o rótulo `semanticLabel` ou, sem ele, o texto `loading` de `gja/core/localization`. O determinado MUST expor o valor em porcentagem inteira, e o indeterminado MUST NOT expor valor.

#### Scenario: Semântica do valor
- **GIVEN** uma barra com `value` 0.456, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o nó tem o rótulo "Carregando" e o valor "46%"

#### Scenario: Semântica do indeterminado
- **GIVEN** um círculo sem `value` e com `semanticLabel` "Salvando pedido"
- **WHEN** a árvore de semântica é lida
- **THEN** o nó tem o rótulo "Salvando pedido" e nenhum valor

### Requirement: [Acessibilidade] Contraste
O preenchimento MUST ter contraste de ao menos 3:1 sobre `colors.base` e `colors.background`, em todos os estados e temas, conforme `gja/foundation/accessibility`. A trilha é decorativa, como os separadores, e fica isenta.

#### Scenario: Contraste do preenchimento
- **WHEN** o contraste da cor de preenchimento de cada estado é medido sobre `colors.base` e `colors.background`, nos temas claro e escuro
- **THEN** todas as medidas são de ao menos 3:1

### Requirement: [Responsividade] Largura e direção
A barra SHALL ocupar a largura disponível. O círculo SHALL ter o tamanho do ícone, independente da escala de texto. Em RTL, o preenchimento da barra MUST começar na borda direita.

#### Scenario: Barra em RTL
- **GIVEN** a direção do texto da direita para a esquerda e uma barra de 400 com `value` 0.25
- **WHEN** a barra é renderizada
- **THEN** o preenchimento mede 100 e termina na borda direita

### Requirement: [Integração] Dependências
`GjaProgressIndicator` SHALL depender somente de `gja/widgets/gja-icon`, `gja/core/localization`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/iconography`, `gja/foundation/design-tokens`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Indicador sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** as duas formas são renderizadas, determinadas e indeterminadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaProgressIndicator` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`: semântica e contraste não textual. Alvo de toque e teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade do indicador
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do indicador
- **WHEN** os goldens das barras determinadas em cada estado e dos círculos em cada tamanho são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaProgressIndicator` SHALL ter dartdoc em toda API pública e uma página "GjaProgressIndicator" na galeria com barras em cada estado, uma barra indeterminada e círculos nos tamanhos de ícone.

#### Scenario: Página GjaProgressIndicator na galeria
- **WHEN** a página "GjaProgressIndicator" é aberta na galeria
- **THEN** ela mostra uma barra por estado de valor, uma barra indeterminada e um círculo por tamanho de ícone

### Requirement: [Restrições] Fora do escopo
`GjaProgressIndicator` SHALL NOT aceitar cores, espessuras ou durações literais, nem mostrar texto do valor, buffer ou segmentos.

#### Scenario: Indicador sem valor literal
- **WHEN** a API pública de `GjaProgressIndicator` é inspecionada
- **THEN** o único `double` é `value`, e não há parâmetro de cor nem de duração
