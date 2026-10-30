# rebic/widgets/rebic-badge Specification

## Purpose

`RebicBadge` mostra um contador, como o badge dos controles (`BadgeEnabler`) e o `count` do `IconTabFilter` do SAPUI5: um número numa pílula com as cores de um estado de valor, sozinho ou sobre o canto superior final de outro elemento, com limite (`999+`), ocultação abaixo de 1 e semântica do número.

## Requirements

### Requirement: [API] Propriedades
`RebicBadge` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `count` | `int` | obrigatória |
| `max` | `int` | `999` |
| `state` | `RebicValueState` | `error` |
| `child` | `Widget?` | `null` |
| `semanticLabel` | `String?` | `null` (o número) |

#### Scenario: Contador avulso
- **WHEN** `RebicBadge(count: 5)` é renderizado
- **THEN** ele mostra "5" no estilo `typography.small`, com o fundo e a borda do estado `error`

#### Scenario: Contador sobre um elemento
- **GIVEN** um elemento de 40 × 40
- **WHEN** `RebicBadge(count: 3, child: elemento)` é renderizado, em LTR
- **THEN** o widget mede 40 × 40, como o elemento, e o centro do contador fica no canto superior direito do elemento

### Requirement: [API] Limite válido
`max` MUST ser ao menos 1. Um limite menor MUST falhar em modo debug com mensagem que cita o valor.

#### Scenario: Limite inválido
- **WHEN** um `RebicBadge` é criado com `max` 0
- **THEN** a criação falha em modo debug com mensagem que cita 0

### Requirement: [API] Callbacks e controlador
`RebicBadge` SHALL NOT ter callbacks nem controlador e MUST NOT impedir os gestos do `child`.

#### Scenario: Toque no elemento com contador
- **GIVEN** um elemento tocável com um contador sobre ele
- **WHEN** o contador é tocado
- **THEN** a ação do elemento é executada uma vez

### Requirement: [Comportamento] Limite e zero
Acima de `max`, o contador SHALL mostrar `max` seguido de "+". Abaixo de 1, o contador MUST NOT aparecer: sem `child`, o widget não ocupa espaço; com `child`, só o `child` aparece. O número SHALL ser formatado no idioma, por `rebic/core/localization`.

#### Scenario: Valor acima do limite
- **WHEN** `RebicBadge(count: 1500)` é renderizado
- **THEN** ele mostra "999+"

#### Scenario: Contador zero oculto
- **WHEN** `RebicBadge(count: 0)` é renderizado sozinho e sobre um elemento
- **THEN** nenhum número aparece, o avulso mede zero, e o outro mostra só o elemento

### Requirement: [Aparência] Estados de valor
O contador SHALL usar o fundo, a borda e a cor de frente do `state` em `colors.stateColors`. No estado `none`, o texto SHALL usar a cor de texto padrão.

#### Scenario: Cores do contador por estado
- **WHEN** um contador de cada estado de valor é renderizado
- **THEN** o fundo e a borda de cada um são os do estado, e o texto tem a cor de frente do estado, exceto `none`, que usa `colors.text`

### Requirement: [Aparência] Tokens de componente
O contador SHALL ser uma pílula com raio `radius.full`, texto `typography.small`, espaço horizontal `spacing.xs`, borda fina e lado mínimo `icons.small`, sem valores literais. Um único dígito MUST formar um círculo.

#### Scenario: Forma do contador
- **WHEN** contadores com "7" e "128" são renderizados
- **THEN** o de "7" é um círculo de lado ao menos `icons.small`, e o de "128" é mais largo que alto

### Requirement: [Estados] Sem estados de interação
`RebicBadge` SHALL NOT apresentar estados de interação nem receber o foco.

#### Scenario: Contador não recebe foco
- **GIVEN** um contador entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no contador

### Requirement: [Acessibilidade] Semântica
O contador avulso SHALL ser exposto com o rótulo `semanticLabel` ou, sem ele, o número exibido. Sobre um elemento, o rótulo do contador MUST ser anunciado no mesmo nó do elemento, depois do rótulo dele. Um contador oculto MUST NOT aparecer na semântica.

#### Scenario: Semântica do contador avulso
- **WHEN** a árvore de semântica de `RebicBadge(count: 1500)` e de `RebicBadge(count: 3, semanticLabel: '3 notificações')` é lida
- **THEN** os rótulos são "999+" e "3 notificações"

#### Scenario: Contador sobre um botão
- **GIVEN** um botão de ícone "Notificações" com `RebicBadge(count: 3, semanticLabel: '3 novas')`
- **WHEN** a árvore de semântica é lida
- **THEN** um único nó de botão tem o rótulo com "Notificações" e "3 novas", nessa ordem

### Requirement: [Acessibilidade] Contraste
O texto do contador MUST manter o contraste sobre o fundo de cada estado, nos temas claro e escuro, conforme `rebic/foundation/accessibility`.

#### Scenario: Contraste do contador
- **WHEN** a diretriz de contraste de texto é aplicada a um contador de cada estado, nos temas claro e escuro
- **THEN** a diretriz é atendida

### Requirement: [Responsividade] Direção e escala
Sobre um elemento, o contador SHALL ficar no canto superior final: à direita em LTR e à esquerda em RTL. Com escala de texto 2,0, o contador MUST crescer sem estouro, mantendo o tamanho do `child`.

#### Scenario: Contador em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um contador sobre um elemento é renderizado
- **THEN** o centro do contador fica no canto superior esquerdo do elemento

#### Scenario: Contador com escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** um contador sobre um elemento de 40 × 40 é renderizado
- **THEN** não há estouro, o contador é maior que na escala 1,0, e o widget continua medindo 40 × 40

### Requirement: [Integração] Dependências
`RebicBadge` SHALL depender somente de `rebic/core/localization`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/iconography`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Contador sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** contadores avulsos e sobre botões de ícone são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicBadge` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: contraste e semântica. Alvo de toque e teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade do contador
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do contador
- **WHEN** os goldens dos contadores por estado, com um e três dígitos, acima do limite e sobre botões de ícone são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicBadge` SHALL ter dartdoc em toda API pública e uma página "RebicBadge" na galeria com contadores por estado, sobre botões de ícone e um contador que aumenta ao tocar um botão.

#### Scenario: Página RebicBadge na galeria
- **GIVEN** a página "RebicBadge" aberta na galeria, com o contador de notificações em 0
- **WHEN** o botão "Nova notificação" é tocado duas vezes
- **THEN** o contador sobre o sino mostra "2"

### Requirement: [Restrições] Fora do escopo
`RebicBadge` SHALL NOT aceitar cores, tamanhos ou posições literais, nem mostrar um ponto sem número ou animar o contador.

#### Scenario: Contador sem valor literal
- **WHEN** a API pública de `RebicBadge` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color`, `Offset` ou `Alignment`
