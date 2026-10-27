# rebic/widgets/rebic-spacing Specification

## Purpose

`RebicSpacing` aplica espaço nomeado do Rebic, como as classes de margem e padding do SAPUI5 (`sapUiSmallMargin` e afins): separa itens com um passo ou papel de espaçamento e envolve um filho com padding direcional, sempre com os valores do tema e da densidade ativos, sem números literais.

## Requirements

### Requirement: [API] Propriedades
`RebicSpacing` SHALL expor três construtores:

| Construtor | Propriedades | Padrão |
|---|---|---|
| `RebicSpacing.horizontal` | `space` (posicional, `RebicSpace`) | obrigatória |
| `RebicSpacing.vertical` | `space` (posicional, `RebicSpace`) | obrigatória |
| `RebicSpacing.padding` | `child`; `all`, `horizontal`, `vertical`, `start`, `end`, `top`, `bottom` (`RebicSpace?`) | `child` obrigatório; lados sem valor ficam sem espaço |


#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp` na densidade confortável
- **WHEN** `RebicSpacing.vertical(RebicSpace.m)` é colocado entre dois textos de uma coluna
- **THEN** os textos ficam separados pela altura `spacing.m` do tema, e o espaço não tem largura

### Requirement: [API] Valores de espaço
`RebicSpace` SHALL ter os passos `none`, `xxs`, `xs`, `s`, `m`, `l`, `xl`, `xxl` e `xxxl` e os papéis `inlineGap`, `stackGap`, `sectionGap` e `pageMargin`, com os mesmos nomes do conjunto semântico de espaçamento.

#### Scenario: Valores do fundamento
- **WHEN** os nomes de `RebicSpace` são comparados com os valores do espaçamento do tema
- **THEN** são os mesmos treze nomes, na mesma ordem

### Requirement: [API] Callbacks e controlador
`RebicSpacing` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Sem ação
- **GIVEN** `RebicSpacing.padding` em volta de um texto
- **WHEN** a área de padding é tocada
- **THEN** nada é executado pelo `RebicSpacing`

### Requirement: [Comportamento] Separadores
`RebicSpacing.horizontal` SHALL ocupar a largura do passo e altura zero, e `RebicSpacing.vertical` SHALL ocupar a altura do passo e largura zero, para separar itens sem alterar o tamanho no eixo cruzado.

#### Scenario: Separador numa linha
- **GIVEN** uma linha com dois quadrados de 20 e `RebicSpacing.horizontal(RebicSpace.inlineGap)` entre eles
- **WHEN** a linha é renderizada
- **THEN** a distância entre os quadrados é `spacing.inlineGap`, e a altura da linha continua 20

### Requirement: [Comportamento] Padding direcional
`RebicSpacing.padding` SHALL aplicar a cada lado o valor mais específico informado: `start`, `end`, `top` ou `bottom`, depois `horizontal` (início e fim) ou `vertical` (topo e base) e por fim `all`. `start` e `end` MUST seguir a direção do texto.

#### Scenario: Precedência dos lados
- **WHEN** `RebicSpacing.padding` recebe `all: s`, `horizontal: l` e `start: xl` em LTR
- **THEN** o padding é `xl` à esquerda, `l` à direita e `s` no topo e na base

#### Scenario: Início em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** `RebicSpacing.padding` recebe só `start: l`
- **THEN** o padding é `l` à direita e zero nos demais lados

### Requirement: [Aparência] Tokens de componente
`RebicSpacing` SHALL obter cada valor de `spacing.<passo ou papel>` do tema ativo, sem valores literais, e SHALL NOT pintar nada: o espaço é vazio e transparente.

#### Scenario: Troca de densidade
- **GIVEN** `RebicSpacing.vertical(RebicSpace.sectionGap)` renderizado na densidade confortável
- **WHEN** o tema ativo passa para a densidade compacta
- **THEN** a altura passa a ser o `sectionGap` compacto, sem recriar o widget com outros parâmetros

#### Scenario: Todos os passos e papéis
- **WHEN** cada valor de `RebicSpace` é usado em `RebicSpacing.vertical` no tema claro
- **THEN** a altura é o valor de mesmo nome em `spacing`

### Requirement: [Estados] Sem estados visuais
`RebicSpacing` SHALL NOT apresentar estados de interação, porque não é interativo nem visível.

#### Scenario: Não recebe foco
- **GIVEN** `RebicSpacing.horizontal` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`RebicSpacing` SHALL NOT entrar na ordem de foco nem alterar a ordem dos filhos que envolve.

#### Scenario: Ordem preservada no padding
- **GIVEN** dois elementos focáveis, o segundo envolvido por `RebicSpacing.padding`
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai ao segundo elemento

### Requirement: [Acessibilidade] Semântica e escala
`RebicSpacing` SHALL NOT acrescentar nós à árvore de semântica. O espaço MUST NOT depender da escala de texto: ele vem só da densidade.

#### Scenario: Semântica inalterada
- **WHEN** a árvore de semântica de um texto é comparada com e sem `RebicSpacing.padding` em volta dele
- **THEN** as duas árvores têm os mesmos rótulos e papéis

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** `RebicSpacing.vertical(RebicSpace.m)` é renderizado
- **THEN** a altura continua `spacing.m`

### Requirement: [Responsividade] Densidade
`RebicSpacing` SHALL usar o espaçamento da densidade ativa: confortável para entrada por toque, compacto para entrada por ponteiro, conforme `rebic/foundation/density`. A classe de tamanho da tela MUST NOT alterar os valores; margens responsivas são de `RebicResponsiveLayout`.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `RebicSpacing.horizontal(RebicSpace.l)` é renderizado dentro e fora dela
- **THEN** dentro a largura é o `l` compacto, e fora é o `l` confortável

### Requirement: [Integração] Dependências
`RebicSpacing` SHALL depender somente de `rebic/foundation/spacing`, `rebic/foundation/density` e `rebic/foundation/theming`, e dos widgets nativos de layout do Flutter.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** os três construtores de `RebicSpacing` são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicSpacing` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `rebic/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicSpacing` SHALL ter dartdoc em toda API pública e uma página "RebicSpacing" na galeria com cada passo e papel em escala, e o mesmo exemplo nas densidades confortável e compacta.

#### Scenario: Página RebicSpacing na galeria
- **WHEN** a página "RebicSpacing" é aberta
- **THEN** ela exibe os treze valores de `RebicSpace` com o tamanho de cada um e um exemplo de padding em cada densidade

### Requirement: [Restrições] Fora do escopo
`RebicSpacing` SHALL NOT aceitar números literais nem espaço negativo, nem distribuir espaço automaticamente entre filhos.

#### Scenario: Sem valor literal
- **WHEN** a API pública de `RebicSpacing` é inspecionada
- **THEN** nenhum construtor tem parâmetro do tipo `double`, `int` ou `EdgeInsets`
