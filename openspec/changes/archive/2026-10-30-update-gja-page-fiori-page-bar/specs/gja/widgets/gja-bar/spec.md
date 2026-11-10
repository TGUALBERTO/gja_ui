# Spec Delta

## Purpose

`GjaBar` é a barra horizontal de três áreas do GJA, como o `sap.m.Bar` do SAPUI5: conteúdo no início, no meio e no fim, com um desenho de cabeçalho, subcabeçalho, rodapé ou rodapé flutuante. É a barra do cabeçalho, do subcabeçalho e do rodapé de `GjaPage`, e serve também a outras áreas da aplicação.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaBar` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `contentLeft` | `List<Widget>` | vazia |
| `contentMiddle` | `List<Widget>` | vazia |
| `contentRight` | `List<Widget>` | vazia |
| `design` | `GjaBarDesign` | `auto` |
| `titleAlignment` | `GjaTitleAlignment` | `none` |

#### Scenario: Barra com as três áreas
- **GIVEN** um item em cada área, em LTR, numa largura de 800
- **WHEN** a barra é renderizada
- **THEN** o item de `contentLeft` começa no início, o de `contentRight` termina no fim, e o de `contentMiddle` fica entre eles

### Requirement: [API] Desenhos e alinhamentos
`GjaBarDesign` SHALL ter os valores `auto`, `header`, `subHeader`, `footer` e `floatingFooter`, e `GjaTitleAlignment` os valores `none`, `start`, `center` e `auto`, como o `sap.m.BarDesign` e o `sap.m.TitleAlignment`.

#### Scenario: Valores dos enums da barra
- **WHEN** os valores de `GjaBarDesign` e `GjaTitleAlignment` são listados
- **THEN** eles são `auto`, `header`, `subHeader`, `footer` e `floatingFooter`; e `none`, `start`, `center` e `auto`

### Requirement: [API] Callbacks e controlador
`GjaBar` SHALL NOT ter callbacks nem controlador: a interação é dos controles que ela contém.

#### Scenario: Barra sem ação própria
- **GIVEN** uma barra só com um texto em `contentMiddle`
- **WHEN** a barra é tocada
- **THEN** nada é executado, e a semântica não informa ação de toque

### Requirement: [Comportamento] Alinhamento do conteúdo central
Com `titleAlignment` `none` ou `center`, o conteúdo central SHALL ficar centrado na largura da barra quando couber entre as outras áreas; se não couber, MUST ficar no espaço entre elas. Com `start` ou `auto`, o conteúdo central SHALL começar logo depois de `contentLeft`, como o `Auto` do tema Horizon.

#### Scenario: Conteúdo central centrado
- **GIVEN** uma barra de 800 com um item de 40 em `contentLeft`, um de 200 em `contentMiddle` e `titleAlignment` `none`
- **WHEN** a barra é renderizada
- **THEN** o item central fica com o centro a 400 do início

#### Scenario: Conteúdo central no início
- **GIVEN** a mesma barra com `titleAlignment` `start`
- **WHEN** a barra é renderizada
- **THEN** o item central começa logo depois do item de `contentLeft`, a `spacing.xs` dele

### Requirement: [Comportamento] Desenho automático
Com `design` `auto`, a barra SHALL usar o desenho da área de `GjaPage` em que está: `header` no cabeçalho, `subHeader` no subcabeçalho, e `footer` ou `floatingFooter` no rodapé, conforme o `floatingFooter` da página. Fora de uma página, `auto` MUST ser `header`.

#### Scenario: Barra automática no rodapé
- **GIVEN** uma `GjaPage` com `footer` igual a uma barra com `design` `auto`
- **WHEN** a página é renderizada
- **THEN** a barra tem o desenho `footer`

#### Scenario: Barra automática fora da página
- **WHEN** uma barra com `design` `auto` é renderizada fora de uma página
- **THEN** ela tem o desenho `header`

### Requirement: [Comportamento] Espaço insuficiente
Os conteúdos do início e do fim SHALL manter o tamanho. O conteúdo central MUST receber só o espaço restante, e a barra MUST NOT gerar erro de layout.

#### Scenario: Título longo no meio
- **GIVEN** uma barra de 320 com um botão em cada ponta e um `GjaTitle` longo no meio
- **WHEN** a barra é renderizada
- **THEN** não há erro de layout, os botões aparecem inteiros, e o título termina com reticências

### Requirement: [Aparência] Tokens de componente
A barra SHALL ter a altura `density.barHeight`, o fundo `colors.base`, o espaço `spacing.s` nas pontas e `spacing.xs` entre os itens. Pelo desenho: `header` SHALL ter a sombra `shadows.header`; `subHeader` nenhuma borda nem sombra; `footer` uma borda `colors.separator` no topo; e `floatingFooter` a borda `colors.separator` em volta e o raio `radius.s`, sem valores literais.

#### Scenario: Desenhos da barra
- **WHEN** uma barra de cada desenho é renderizada nos temas claro e escuro
- **THEN** todas têm o fundo `colors.base`; a de cabeçalho tem a sombra `shadows.header`; a de rodapé, a borda superior `colors.separator`; e a flutuante, a borda `colors.separator` e o raio `radius.s`

#### Scenario: Altura por densidade
- **WHEN** a barra é renderizada nas densidades cozy e compacta
- **THEN** ela mede `density.barHeight` de cada densidade: 48 e 32

### Requirement: [Estados] Sem estados próprios
`GjaBar` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado: os estados são dos controles que ela contém.

#### Scenario: Barra não recebe foco
- **GIVEN** uma barra só com texto, entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL ser: conteúdo do início, conteúdo central e conteúdo do fim.

#### Scenario: Ordem de foco na barra
- **GIVEN** um item focável em cada área
- **WHEN** Tab é pressionado duas vezes a partir do item do início
- **THEN** o foco passa pelo item central e pelo item do fim, nessa ordem

### Requirement: [Acessibilidade] Semântica e contraste
A barra SHALL NOT criar nó de semântica próprio: os nós dos conteúdos seguem a ordem início, meio e fim. O fundo `colors.base` MUST manter o contraste dos textos e ícones do tema, conforme `gja/foundation/accessibility`.

#### Scenario: Contraste na barra
- **WHEN** a diretriz de contraste de texto é aplicada a barras com texto em cada desenho, nos temas claro e escuro
- **THEN** a diretriz é atendida

### Requirement: [Responsividade] Largura, densidade e direção
A barra SHALL ocupar a largura disponível. Em RTL, o conteúdo do início MUST ficar à direita, e o do fim à esquerda.

#### Scenario: Barra em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a barra com um item no início e outro no fim é renderizada
- **THEN** o item do início fica na borda direita, e o do fim na borda esquerda

### Requirement: [Integração] Dependências
`GjaBar` SHALL depender somente de `gja/foundation/color`, `gja/foundation/shadows`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/radius`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Barra sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** barras de cada desenho são renderizadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaBar` MUST ter um teste de widget por cenário, goldens dos quatro desenhos nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`: contraste e teclado.

#### Scenario: Rastreabilidade da barra de três áreas
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da barra de três áreas
- **WHEN** os goldens dos quatro desenhos são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaBar` SHALL ter dartdoc em toda API pública e uma página "GjaBar" na galeria com os quatro desenhos e os alinhamentos `none` e `start` do conteúdo central.

#### Scenario: Página GjaBar na galeria
- **WHEN** a página "GjaBar" é aberta
- **THEN** ela exibe uma barra de cada desenho e as duas barras de alinhamento

### Requirement: [Restrições] Fora do escopo
`GjaBar` SHALL NOT mover itens para um menu "mais" (`sap.m.OverflowToolbar`, previsto como `GjaToolbar` no catálogo), nem aceitar larguras, alturas ou cores literais.

#### Scenario: Barra sem valor literal
- **WHEN** a API pública de `GjaBar` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`
