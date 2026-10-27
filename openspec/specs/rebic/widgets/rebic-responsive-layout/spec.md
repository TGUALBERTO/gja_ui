# rebic/widgets/rebic-responsive-layout Specification

## Purpose

`RebicResponsiveLayout` mostra um conteúdo diferente por classe de tamanho, como os controles responsivos do SAPUI5: escolhe o construtor da classe atual, herdando o da classe menor quando falta, e mede a classe pela largura do próprio espaço ou da tela, com os limiares do tema. É a versão básica; as colunas flexíveis ficam para a Fase 4.

## Requirements

### Requirement: [API] Propriedades
`RebicResponsiveLayout` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `small` | `WidgetBuilder` | obrigatória |
| `medium` | `WidgetBuilder?` | herda de `small` |
| `large` | `WidgetBuilder?` | herda da menor com valor |
| `extraLarge` | `WidgetBuilder?` | herda da menor com valor |
| `basis` | `RebicLayoutBasis` | `container` |

`RebicLayoutBasis` SHALL ter `container` e `screen`.

#### Scenario: Layout responsivo mínimo
- **GIVEN** uma árvore com `RebicApp` e uma área de 300 de largura
- **WHEN** `RebicResponsiveLayout(small: …)` é colocado nela
- **THEN** o conteúdo de `small` é exibido

### Requirement: [API] Callbacks e controlador
`RebicResponsiveLayout` SHALL NOT ter callbacks nem controlador: a troca de conteúdo depende só da largura.

#### Scenario: Layout sem ação
- **GIVEN** `RebicResponsiveLayout` com conteúdo
- **WHEN** a área do layout é tocada fora do conteúdo
- **THEN** nada é executado pelo `RebicResponsiveLayout`

### Requirement: [Comportamento] Construtor por classe com herança
`RebicResponsiveLayout` SHALL exibir o construtor da classe de tamanho atual ou, sem ele, o da maior classe menor que tenha construtor. `small` MUST ser sempre o último recurso.

#### Scenario: Herança da classe menor no layout
- **GIVEN** um layout com `small` e `large`
- **WHEN** ele é renderizado em larguras das classes `small`, `medium`, `large` e `extraLarge`
- **THEN** os conteúdos são os de `small`, `small`, `large` e `large`

### Requirement: [Comportamento] Base da medida
Com `basis` `container`, a classe SHALL vir da largura máxima disponível para o próprio layout. Com `basis` `screen`, SHALL vir da classe da tela, publicada pelo escopo de `rebic/core/responsive`.

#### Scenario: Contêiner estreito numa tela larga
- **GIVEN** uma janela de 1500 de largura e um painel de 500
- **WHEN** um layout com `small` e `extraLarge` é colocado no painel com `basis` `container` e outro com `basis` `screen`
- **THEN** o primeiro mostra `small`, e o segundo mostra `extraLarge`

### Requirement: [Comportamento] Troca de classe
Quando a largura cruza um limiar, `RebicResponsiveLayout` SHALL exibir o construtor da nova classe. Mudanças de largura dentro da mesma classe MUST manter o construtor atual.

#### Scenario: Janela redimensionada
- **GIVEN** um layout de base `screen` com `small` e `large`, numa janela de 800
- **WHEN** a janela passa a 1200 e depois a 1300
- **THEN** o conteúdo passa de `small` a `large` e continua `large`

### Requirement: [Aparência] Tokens de componente
`RebicResponsiveLayout` SHALL classificar a largura com os limiares do tema ativo (`breakpoints`) e SHALL NOT pintar nada nem acrescentar espaço.

#### Scenario: Limiares do tema no layout
- **GIVEN** um tema com o limiar `medium` em 480 e uma área de 500
- **WHEN** um layout com `small` e `medium` é renderizado
- **THEN** o conteúdo é o de `medium`

### Requirement: [Estados] Sem estados de interação
`RebicResponsiveLayout` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Layout não recebe foco
- **GIVEN** um layout cujo conteúdo tem dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio layout

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL ser a do conteúdo exibido. O conteúdo de classes não exibidas MUST NOT estar na árvore.

#### Scenario: Só o conteúdo atual na árvore
- **GIVEN** um layout com `small` e `large`, renderizado na classe `small`
- **WHEN** a árvore de widgets é inspecionada
- **THEN** só o conteúdo de `small` está presente

### Requirement: [Acessibilidade] Semântica e escala
`RebicResponsiveLayout` SHALL NOT acrescentar nós à árvore de semântica. A escala de texto MUST NOT alterar a classe escolhida, que depende só da largura.

#### Scenario: Escala de texto sem efeito na classe
- **GIVEN** a escala de texto 2,0 e uma área de 500
- **WHEN** um layout com `small` e `medium` é renderizado
- **THEN** o conteúdo é o de `small`

### Requirement: [Responsividade] Classes e densidade
`RebicResponsiveLayout` SHALL usar as quatro classes de `rebic/foundation/breakpoints`. A densidade MUST NOT alterar a classe escolhida.

#### Scenario: Densidade sem efeito na classe
- **GIVEN** uma área de 700, dentro e fora de uma subárvore compacta
- **WHEN** um layout com `small` e `medium` é renderizado nas duas
- **THEN** as duas mostram `medium`

### Requirement: [Integração] Dependências
`RebicResponsiveLayout` SHALL depender somente de `rebic/core/responsive`, `rebic/foundation/breakpoints` e `rebic/foundation/theming`.

#### Scenario: Layout sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicResponsiveLayout` é renderizado com as duas bases
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicResponsiveLayout` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `rebic/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos.

#### Scenario: Rastreabilidade do layout responsivo
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicResponsiveLayout` SHALL ter dartdoc em toda API pública e uma página "RebicResponsiveLayout" na galeria com um formulário de uma coluna em `small` e duas a partir de `medium`, nas bases contêiner e tela.

#### Scenario: Página RebicResponsiveLayout na galeria
- **GIVEN** a galeria numa janela de 1200
- **WHEN** a página "RebicResponsiveLayout" é aberta e a janela passa a 500
- **THEN** o exemplo de base `screen` passa de duas colunas para uma

### Requirement: [Restrições] Fora do escopo
`RebicResponsiveLayout` SHALL NOT aceitar larguras literais de troca, animar a transição nem preservar o estado de widgets que mudam de lugar entre os layouts.

#### Scenario: Layout sem largura literal
- **WHEN** a API pública de `RebicResponsiveLayout` é inspecionada
- **THEN** não há parâmetro do tipo `double`
