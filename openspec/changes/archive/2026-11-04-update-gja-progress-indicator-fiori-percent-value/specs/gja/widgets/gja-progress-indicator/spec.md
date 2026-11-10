# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Valor válido
`percentValue` MUST estar entre 0 e 100. Um valor fora do intervalo MUST falhar em modo debug com mensagem que cita o valor.

#### Scenario: Valor fora do intervalo
- **WHEN** `GjaProgressIndicator(percentValue: 120)` é criado
- **THEN** a criação falha em modo debug com mensagem que cita 120

### Requirement: [Aparência] Tokens de componente
O preenchimento SHALL usar `colors.brand` no estado `none` e `stateColors(state).foreground` nos demais. A trilha SHALL usar `colors.separator`. A espessura da barra SHALL ser `spacing.xs`, sem valores literais.

#### Scenario: Cores por estado
- **WHEN** barras são renderizadas em cada estado de valor
- **THEN** o preenchimento de `none` é `colors.brand`, o de cada outro estado é a cor de frente do estado, e a trilha é `colors.separator`

#### Scenario: Espessura da densidade compacta
- **GIVEN** uma barra numa subárvore compacta
- **WHEN** ela é renderizada
- **THEN** a altura dela é o `spacing.xs` compacto

### Requirement: [Responsividade] Largura e direção
A barra SHALL ocupar a largura disponível. Em RTL, o preenchimento MUST começar na borda direita.

#### Scenario: Barra em RTL
- **GIVEN** a direção do texto da direita para a esquerda e uma barra de 400 com `percentValue` 25
- **WHEN** a barra é renderizada
- **THEN** o preenchimento mede 100 e termina na borda direita

### Requirement: [Integração] Dependências
`GjaProgressIndicator` SHALL depender somente de `gja/core/localization`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/design-tokens`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Indicador sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** barras com valores diferentes são renderizadas e atualizadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaProgressIndicator` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`: semântica e contraste não textual. Alvo de toque e teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade do indicador
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do indicador
- **WHEN** os goldens das barras em cada estado e com valores 0, 45 e 100 são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaProgressIndicator` SHALL ter dartdoc em toda API pública e uma página "GjaProgressIndicator" na galeria com barras em cada estado e uma barra que avança.

#### Scenario: Página GjaProgressIndicator na galeria
- **WHEN** a página "GjaProgressIndicator" é aberta na galeria
- **THEN** ela mostra uma barra por estado de valor e uma barra que avança

### Requirement: [Restrições] Fora do escopo
`GjaProgressIndicator` SHALL NOT aceitar cores, espessuras ou durações literais, nem ter forma circular, modo indeterminado (o "ocupado" é o `GjaBusyIndicator`), texto do valor (`displayValue`, `showValue`), buffer ou segmentos.

#### Scenario: Indicador sem valor literal
- **WHEN** a API pública de `GjaProgressIndicator` é inspecionada
- **THEN** o único `double` é `percentValue`, e não há parâmetro de cor nem de duração

## REMOVED Requirements

### Requirement: [API] Propriedades
**Reason**: Os construtores `linear` e `circular` e `value` de 0 a 1 dão lugar ao construtor único com `percentValue`, como o `sap.m.ProgressIndicator`; sai o cenário do círculo.
**Migration**: Troque `GjaProgressIndicator.linear(value: v)` por `GjaProgressIndicator(percentValue: v * 100)`. O requisito passa a "[API] Propriedades da barra".

### Requirement: [Acessibilidade] Semântica
**Reason**: Sem o indeterminado, sai o cenário de semântica sem valor.
**Migration**: O requisito passa a "[Acessibilidade] Semântica da barra".

### Requirement: [Comportamento] Determinado e indeterminado
**Reason**: O indeterminado é o `sap.m.BusyIndicator`, que o GJA tem como `GjaBusyIndicator`; o `sap.m.ProgressIndicator` é só a barra determinada.
**Migration**: Para "ocupado", use `GjaBusyIndicator`; para progresso, `GjaProgressIndicator(percentValue:)`. A animação até o novo valor passa ao requisito "[Comportamento] Valor animado".

### Requirement: [Comportamento] Movimento reduzido
**Reason**: Sem o indeterminado, não há desenho estático a especificar.
**Migration**: O comportamento com movimento reduzido passa ao requisito "[Comportamento] Valor animado".

## ADDED Requirements

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
`GjaProgressIndicator` SHALL expor, como o `sap.m.ProgressIndicator`, o construtor padrão com:

| Prop | Tipo | Padrão |
|---|---|---|
| `percentValue` | `double` | obrigatório |
| `state` | `GjaValueState` | `none` |
| `semanticLabel` | `String?` | texto `loading` |

#### Scenario: Barra determinada
- **GIVEN** uma área de 400 de largura, em LTR
- **WHEN** `GjaProgressIndicator(percentValue: 45)` é renderizado
- **THEN** a barra ocupa os 400, e o preenchimento mede 180 a partir da borda inicial

### Requirement: [Acessibilidade] Semântica da barra
O indicador SHALL ser exposto com o rótulo `semanticLabel` ou, sem ele, o texto `loading` de `gja/core/localization`, e MUST expor o valor em porcentagem inteira.

#### Scenario: Semântica do valor
- **GIVEN** uma barra com `percentValue` 45.6, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o nó tem o rótulo "Carregando" e o valor "46%"
