# rebic/widgets/rebic-busy-indicator Specification

## Purpose

`RebicBusyIndicator` indica uma operação em andamento sem progresso medível, como o `sap.m.BusyIndicator` e o estado `busy` dos controles do SAPUI5: três pontos animados, com texto opcional, sozinhos ou sobre um conteúdo, que fica bloqueado enquanto está ocupado.

## Requirements

### Requirement: [API] Propriedades
`RebicBusyIndicator` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String?` | `null` |
| `busy` | `bool` | `true` |
| `child` | `Widget?` | `null` |

Sem `child`, mostra o indicador; com `child`, mostra o conteúdo e, enquanto `busy`, o indicador sobre ele.

#### Scenario: Indicador mínimo
- **WHEN** `RebicBusyIndicator()` é renderizado
- **THEN** aparecem três pontos lado a lado, na cor `colors.brand`

### Requirement: [API] Callbacks e controlador
`RebicBusyIndicator` SHALL NOT ter callbacks nem controlador: o pai controla `busy`.

#### Scenario: Indicador sem ação
- **WHEN** o indicador é tocado
- **THEN** nada é executado pelo indicador

### Requirement: [Comportamento] Animação
Os pontos SHALL pulsar em sequência, num ciclo de quatro vezes `motion.long`. Com movimento reduzido, os pontos MUST ficar parados e visíveis, conforme `rebic/foundation/design-tokens`.

#### Scenario: Pontos parados sem animação
- **GIVEN** o modo de animação `none`
- **WHEN** o indicador é renderizado e o tempo avança
- **THEN** não há quadros pendentes, e os três pontos continuam visíveis

### Requirement: [Comportamento] Conteúdo ocupado
Com `child` e `busy`, o conteúdo SHALL ficar com a opacidade `interaction.disabledOpacity`, fora dos toques, do foco e da semântica, com o indicador centrado sobre ele. Com `busy` `false`, o conteúdo MUST ficar normal e o indicador MUST NOT aparecer.

#### Scenario: Conteúdo bloqueado
- **GIVEN** um `RebicBusyIndicator` com `busy` e um botão como `child`
- **WHEN** o botão é tocado
- **THEN** a ação do botão não é chamada, e os pontos aparecem sobre ele

#### Scenario: Conteúdo liberado
- **GIVEN** o mesmo indicador com `busy` `false`
- **WHEN** o botão é tocado
- **THEN** a ação do botão é chamada uma vez, e não há pontos

### Requirement: [Aparência] Tokens de componente
Cada ponto SHALL ser um círculo `colors.brand` de lado `spacing.s`, com `spacing.xs` entre eles; o texto, abaixo dos pontos a `spacing.s`, SHALL usar `typography.base` com `colors.text`. Nenhum valor MUST ser literal.

#### Scenario: Indicador com texto
- **WHEN** `RebicBusyIndicator(text: 'Carregando pedidos')` é renderizado
- **THEN** os pontos têm o lado `spacing.s`, e o texto fica abaixo deles, centralizado

### Requirement: [Estados] Sem estados de interação
O indicador SHALL NOT apresentar estados de interação nem receber o foco.

#### Scenario: Indicador sem foco
- **GIVEN** um indicador entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai direto ao segundo

### Requirement: [Acessibilidade] Semântica
O indicador SHALL ser exposto como região viva, com o rótulo `text` ou, sem ele, `loading` de `rebic/core/localization`. Com `child` e `busy`, MUST ser o único nó exposto do conjunto.

#### Scenario: Semântica do indicador
- **GIVEN** um indicador sem texto, em pt-BR, e um com `busy` sobre um texto "Pedidos"
- **WHEN** a árvore de semântica é lida
- **THEN** os dois têm o rótulo "Carregando" como região viva, e "Pedidos" não é anunciado

### Requirement: [Responsividade] Tamanho
O indicador SHALL ter o tamanho dos pontos e do texto, sem depender da largura; sobre um `child`, SHALL ocupar o tamanho do conteúdo. O tamanho dos pontos MUST ser o mesmo nas duas densidades.

#### Scenario: Indicador sobre conteúdo grande
- **WHEN** um indicador `busy` é renderizado sobre um conteúdo de 300 por 200
- **THEN** o conjunto mede 300 por 200, e os pontos ficam no centro

### Requirement: [Integração] Dependências
`RebicBusyIndicator` SHALL depender somente de `rebic/core/localization`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/spacing`, `rebic/foundation/design-tokens`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Indicador sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um indicador sozinho e um sobre conteúdo são renderizados e animados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicBusyIndicator` MUST ter um teste de widget por cenário, goldens (sem animação) nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: semântica e contraste do texto.

#### Scenario: Rastreabilidade do indicador
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do indicador
- **WHEN** os goldens de um indicador sozinho, com texto e sobre um conteúdo são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicBusyIndicator` SHALL ter dartdoc em toda API pública e uma página "RebicBusyIndicator" na galeria com um indicador sozinho, um com texto e um cartão que fica ocupado ao tocar um botão.

#### Scenario: Página RebicBusyIndicator na galeria
- **GIVEN** a página "RebicBusyIndicator" aberta na galeria
- **WHEN** o botão "Atualizar" é tocado
- **THEN** o cartão fica ocupado

### Requirement: [Restrições] Fora do escopo
`RebicBusyIndicator` SHALL NOT aceitar cores, tamanhos ou durações literais, nem ícone personalizado (`customIcon`) ou atraso de exibição (`busyIndicatorDelay`).

#### Scenario: Indicador sem valor literal
- **WHEN** a API pública de `RebicBusyIndicator` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color` ou `Duration`
