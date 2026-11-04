# rebic/widgets/rebic-progress-indicator Specification

## Purpose

`RebicProgressIndicator` mostra o andamento de uma operação, como o `sap.m.ProgressIndicator` e o `sap.m.BusyIndicator` do SAPUI5: uma barra na largura disponível ou um círculo no tamanho de um ícone, determinado (com valor de 0 a 1) ou indeterminado (animado), com a cor do estado de valor, semântica de progresso e respeito ao movimento reduzido.

## Requirements

### Requirement: [API] Valor válido
`percentValue` MUST estar entre 0 e 100. Um valor fora do intervalo MUST falhar em modo debug com mensagem que cita o valor.

#### Scenario: Valor fora do intervalo
- **WHEN** `RebicProgressIndicator(percentValue: 120)` é criado
- **THEN** a criação falha em modo debug com mensagem que cita 120

### Requirement: [API] Callbacks e controlador
`RebicProgressIndicator` SHALL NOT ter callbacks nem controlador: o valor vem da aplicação a cada construção.

#### Scenario: Indicador sem ação
- **GIVEN** uma barra determinada
- **WHEN** ela é tocada
- **THEN** nada é executado, e não há detector de gestos no indicador

### Requirement: [Aparência] Tokens de componente
O preenchimento SHALL usar `colors.brand` no estado `none` e `stateColors(state).foreground` nos demais. A trilha SHALL usar `colors.separator`. A espessura da barra SHALL ser `spacing.xs`, sem valores literais.

#### Scenario: Cores por estado
- **WHEN** barras são renderizadas em cada estado de valor
- **THEN** o preenchimento de `none` é `colors.brand`, o de cada outro estado é a cor de frente do estado, e a trilha é `colors.separator`

#### Scenario: Espessura da densidade compacta
- **GIVEN** uma barra numa subárvore compacta
- **WHEN** ela é renderizada
- **THEN** a altura dela é o `spacing.xs` compacto

### Requirement: [Estados] Sem estados de interação
`RebicProgressIndicator` SHALL NOT apresentar estados de interação, porque não é interativo. Os estados de valor só mudam a cor do preenchimento.

#### Scenario: Indicador não recebe foco
- **GIVEN** um indicador entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no indicador

### Requirement: [Acessibilidade] Contraste
O preenchimento MUST ter contraste de ao menos 3:1 sobre `colors.base` e `colors.background`, em todos os estados e temas, conforme `rebic/foundation/accessibility`. A trilha é decorativa, como os separadores, e fica isenta.

#### Scenario: Contraste do preenchimento
- **WHEN** o contraste da cor de preenchimento de cada estado é medido sobre `colors.base` e `colors.background`, nos temas claro e escuro
- **THEN** todas as medidas são de ao menos 3:1

### Requirement: [Responsividade] Largura e direção
A barra SHALL ocupar a largura disponível. Em RTL, o preenchimento MUST começar na borda direita.

#### Scenario: Barra em RTL
- **GIVEN** a direção do texto da direita para a esquerda e uma barra de 400 com `percentValue` 25
- **WHEN** a barra é renderizada
- **THEN** o preenchimento mede 100 e termina na borda direita

### Requirement: [Integração] Dependências
`RebicProgressIndicator` SHALL depender somente de `rebic/core/localization`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/design-tokens`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Indicador sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** barras com valores diferentes são renderizadas e atualizadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicProgressIndicator` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: semântica e contraste não textual. Alvo de toque e teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade do indicador
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do indicador
- **WHEN** os goldens das barras em cada estado e com valores 0, 45 e 100 são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicProgressIndicator` SHALL ter dartdoc em toda API pública e uma página "RebicProgressIndicator" na galeria com barras em cada estado e uma barra que avança.

#### Scenario: Página RebicProgressIndicator na galeria
- **WHEN** a página "RebicProgressIndicator" é aberta na galeria
- **THEN** ela mostra uma barra por estado de valor e uma barra que avança

### Requirement: [Restrições] Fora do escopo
`RebicProgressIndicator` SHALL NOT aceitar cores, espessuras ou durações literais, nem ter forma circular, modo indeterminado (o "ocupado" é o `RebicBusyIndicator`), texto do valor (`displayValue`, `showValue`), buffer ou segmentos.

#### Scenario: Indicador sem valor literal
- **WHEN** a API pública de `RebicProgressIndicator` é inspecionada
- **THEN** o único `double` é `percentValue`, e não há parâmetro de cor nem de duração

### Requirement: [Comportamento] Valor animado
O preenchimento SHALL corresponder a `percentValue` e, quando ele muda, MUST chegar ao novo valor com a duração `motion.short`; com movimento reduzido, MUST mudar sem animação.

#### Scenario: Valor atualizado
- **GIVEN** uma barra de 400 com `percentValue` 45
- **WHEN** ela é reconstruída com `percentValue` 80 e as animações terminam
- **THEN** o preenchimento mede 320

#### Scenario: Valor sem animação
- **GIVEN** o movimento reduzido ativo e uma barra de 400 com `percentValue` 45
- **WHEN** ela é reconstruída com `percentValue` 80
- **THEN** o preenchimento mede 320 no quadro seguinte, sem quadros agendados

### Requirement: [API] Propriedades da barra
`RebicProgressIndicator` SHALL expor, como o `sap.m.ProgressIndicator`, o construtor padrão com:

| Prop | Tipo | Padrão |
|---|---|---|
| `percentValue` | `double` | obrigatório |
| `state` | `RebicValueState` | `none` |
| `semanticLabel` | `String?` | texto `loading` |

#### Scenario: Barra determinada
- **GIVEN** uma área de 400 de largura, em LTR
- **WHEN** `RebicProgressIndicator(percentValue: 45)` é renderizado
- **THEN** a barra ocupa os 400, e o preenchimento mede 180 a partir da borda inicial

### Requirement: [Acessibilidade] Semântica da barra
O indicador SHALL ser exposto com o rótulo `semanticLabel` ou, sem ele, o texto `loading` de `rebic/core/localization`, e MUST expor o valor em porcentagem inteira.

#### Scenario: Semântica do valor
- **GIVEN** uma barra com `percentValue` 45.6, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o nó tem o rótulo "Carregando" e o valor "46%"
