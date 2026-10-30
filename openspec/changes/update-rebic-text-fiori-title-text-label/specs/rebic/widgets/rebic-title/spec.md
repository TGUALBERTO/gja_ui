# Spec Delta

## Purpose

`RebicTitle` exibe o título de uma página, seção, cartão ou diálogo, como o `sap.m.Title` do SAPUI5: separa o nível semântico (`level`) do estilo visual (`titleStyle`), usa a cor de título do tema, termina com reticências quando não quebra linhas e é anunciado como cabeçalho aos leitores de tela.

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicTitle` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` (posicional) | `String` | obrigatória |
| `level` | `RebicTitleLevel` | `auto` |
| `titleStyle` | `RebicTitleLevel` | `auto` |
| `wrapping` | `bool` | `false` |
| `textAlign` | `TextAlign` | `start` |

`RebicTitleLevel` SHALL ter exatamente os valores `auto`, `h1`, `h2`, `h3`, `h4`, `h5` e `h6`, como o `sap.ui.core.TitleLevel`.

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp` e o tema claro
- **WHEN** `RebicTitle('Pedidos em aberto')` é criado
- **THEN** o título usa o estilo `header5` e a cor `text` do tema, ocupa uma linha e é anunciado como cabeçalho sem nível

#### Scenario: Níveis do título
- **WHEN** os valores de `RebicTitleLevel` são listados
- **THEN** eles são `auto`, `h1`, `h2`, `h3`, `h4`, `h5` e `h6`

### Requirement: [API] Callbacks e controlador
`RebicTitle` SHALL NOT ter callbacks nem controlador: é um widget de exibição.

#### Scenario: Título sem ação
- **GIVEN** `RebicTitle` numa página
- **WHEN** o título é tocado
- **THEN** nada é executado, e a semântica não informa ação de toque

### Requirement: [Comportamento] Nível separado do estilo
`level` SHALL definir só a semântica, e `titleStyle` só o estilo, como no `sap.m.Title`. Com `titleStyle` `auto`, o estilo MUST ser o H5, qualquer que seja o `level`.

#### Scenario: Nível sem efeito no estilo
- **WHEN** `RebicTitle('Pedidos', level: RebicTitleLevel.h1)` é renderizado
- **THEN** o estilo é `header5`, e o leitor de tela o anuncia como cabeçalho de nível 1

#### Scenario: Estilo sem efeito na semântica
- **WHEN** `RebicTitle('Pedidos', titleStyle: RebicTitleLevel.h2)` é renderizado
- **THEN** o estilo é `header2`, e o leitor de tela o anuncia como cabeçalho sem nível

### Requirement: [Comportamento] Quebra de linhas
Sem `wrapping`, `RebicTitle` SHALL ocupar uma linha e terminar com reticências quando não couber. Com `wrapping`, o título MUST quebrar em quantas linhas precisar.

#### Scenario: Título truncado
- **GIVEN** um título que ocupa duas linhas na largura disponível
- **WHEN** `RebicTitle` é renderizado sem `wrapping`
- **THEN** ele ocupa a altura de uma linha e termina com reticências

#### Scenario: Título com quebra
- **GIVEN** o mesmo título, com `wrapping` `true`
- **WHEN** ele é renderizado na mesma largura
- **THEN** ele ocupa as duas linhas, sem reticências

### Requirement: [Aparência] Estilo e cor
`RebicTitle` SHALL obter o estilo da tipografia do tema pelo `titleStyle`: `h1` → `header1`, `h2` → `header2`, `h3` → `header3`, `h4` → `header4`, `h5` e `auto` → `header5`, `h6` → `header6`. A cor SHALL ser `colors.text` do tema ativo, que no Horizon é igual a `sapTitleColor`, sem valores literais.

#### Scenario: Estilos do título
- **WHEN** um título de cada `titleStyle` é renderizado no tema claro
- **THEN** cada um tem o tamanho, a altura de linha e o peso do estilo mapeado, e a cor `text`

#### Scenario: Troca de tema do título
- **GIVEN** `RebicTitle` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o título usa a cor `text` do tema escuro, sem ser recriado com outros parâmetros

### Requirement: [Estados] Sem estados de interação
`RebicTitle` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo.

#### Scenario: Título não recebe foco
- **GIVEN** uma página com `RebicTitle` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`RebicTitle` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas pelo título
- **GIVEN** uma página com `RebicTitle` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Acessibilidade] Semântica e contraste
`RebicTitle` SHALL ser anunciado como cabeçalho, com o texto completo mesmo truncado. Com `level` de `h1` a `h6`, o nível MUST ser informado ao leitor de tela; com `auto`, MUST NOT haver nível. A cor MUST ter contraste ≥ 4,5:1 sobre `base` e `background`, conforme `rebic/foundation/accessibility`, e o título MUST respeitar a escala de texto do sistema sem limite.

#### Scenario: Leitor de tela no título
- **WHEN** um leitor de tela percorre `RebicTitle('Pedidos em aberto', level: RebicTitleLevel.h2)` numa largura que o trunca
- **THEN** anuncia "Pedidos em aberto" como cabeçalho de nível 2

#### Scenario: Contraste do título
- **WHEN** a diretriz de contraste de texto é aplicada a uma página com um título de cada estilo, nos temas claro e escuro
- **THEN** a diretriz passa

#### Scenario: Título com escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e uma largura de 320
- **WHEN** um título com `wrapping` é renderizado
- **THEN** não há estouro de layout, e o tamanho da fonte é o dobro do de `header5`

### Requirement: [Responsividade] Tamanhos de tela e densidade
`RebicTitle` SHALL ocupar a largura disponível em qualquer classe de tamanho, truncando ou quebrando conforme `wrapping`. A tipografia MUST ser a mesma nas densidades cozy e compacta, conforme `rebic/foundation/density`.

#### Scenario: Título na densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `RebicTitle` é renderizado nela
- **THEN** o estilo é igual ao da densidade cozy

### Requirement: [Integração] Dependências
`RebicTitle` SHALL depender somente de `rebic/foundation/typography`, `rebic/foundation/color`, `rebic/foundation/theming`, `rebic/foundation/density` e `rebic/foundation/accessibility`, e do `Text` nativo do Flutter.

#### Scenario: Título sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicTitle` é renderizado em todos os estilos
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicTitle` MUST ter um teste de widget por cenário, goldens dos estilos nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: `textContrastGuideline`, escala de texto 2,0 sem estouro e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade do título
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens dos estilos
- **WHEN** os goldens de `RebicTitle` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, com os sete estilos e um título truncado, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`RebicTitle` SHALL ter dartdoc em toda API pública e uma página "RebicTitle" na galeria com os estilos, um exemplo de nível diferente do estilo e um título truncado e outro com quebra.

#### Scenario: Página RebicTitle na galeria
- **WHEN** a página "RebicTitle" é aberta
- **THEN** ela exibe os sete estilos, um título de nível H1 com estilo H5 e os títulos truncado e com quebra

### Requirement: [Restrições] Fora do escopo
`RebicTitle` SHALL NOT oferecer limite de linhas, conteúdo arbitrário, link, ícone, cores arbitrárias nem `wrappingType`. Uma cor fora de `colors.text` MUST NOT ser aceita.

#### Scenario: Título sem cor arbitrária
- **WHEN** a API pública de `RebicTitle` é inspecionada
- **THEN** não há parâmetro de cor, de `TextStyle`, de `maxLines` nem de widget filho
