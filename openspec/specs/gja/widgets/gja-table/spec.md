# gja/widgets/gja-table Specification

## Purpose

`GjaTable` é a tabela responsiva do GJA, como o `sap.m.Table` do SAPUI5: colunas com título e alinhamento, linhas de células que podem ser acionadas ou escolhidas (seleção única ou múltipla, no padrão controlado `selectedKeys` + `onSelectionChange`) e colunas que, em larguras pequenas, somem ou descem para baixo da linha (popin).

## Requirements

### Requirement: [API] Propriedades
`GjaTable<T>` SHALL expor, como o `sap.m.Table`:

| Prop | Tipo | Padrão |
|---|---|---|
| `columns` | `List<GjaColumn>` | obrigatória |
| `items` | `List<GjaListItemBase<T>>` | obrigatória |
| `headerText` | `String?` | `null` |
| `noDataText` | `String?` | `null` |
| `mode` | `GjaListMode` | `none` |
| `selectedKeys` | `Set<T>` | `{}` |
| `onSelectionChange` | `ValueChanged<Set<T>>?` | `null` |
| `onItemPress` | `ValueChanged<T>?` | `null` |

#### Scenario: Tabela mínima
- **WHEN** uma tabela com as colunas "Produto" e "Quantidade" e duas linhas é renderizada
- **THEN** os títulos ficam numa linha acima das linhas, e cada célula fica abaixo do título da sua coluna

### Requirement: [API] Colunas e linhas válidas
`GjaColumn` SHALL ter `header`, `hAlign` (`begin`, `center`, `end`; padrão `begin`), `flex` (`int`, padrão 1, no lugar do `width`), `minScreenWidth` (`GjaSizeClass?`) e `demandPopin` (padrão `false`). `GjaColumnListItem<T>` SHALL ter `key`, `cells` e `type` (`inactive`, `active`, `navigation`; padrão `inactive`). `columns` MUST NOT ser vazia, cada linha MUST ter uma célula por coluna e as chaves MUST ser distintas, ou a renderização MUST falhar em modo debug.

#### Scenario: Linha com células a menos
- **WHEN** uma tabela de duas colunas com uma linha de uma célula é renderizada
- **THEN** a renderização falha em modo debug

### Requirement: [API] Callbacks e controlador
Acionar uma linha `active` ou `navigation` (toque, Enter ou Espaço) SHALL chamar `onItemPress` com a chave dela, como o evento `itemPress`; as `navigation` mostram uma seta no fim. No modo `singleSelectMaster`, acionar uma linha SHALL chamar `onSelectionChange` com só a chave dela. A tabela MUST NOT mudar a seleção sozinha nem ter controlador.

#### Scenario: Acionar uma linha
- **GIVEN** uma tabela com a linha "Teclado" do tipo `navigation`
- **WHEN** a linha é tocada
- **THEN** `onItemPress` recebe a chave de "Teclado", e a linha mostra a seta

#### Scenario: Seleção única
- **GIVEN** uma tabela `singleSelectMaster` cujo `onSelectionChange` atualiza `selectedKeys`
- **WHEN** a segunda linha é tocada
- **THEN** `onSelectionChange` recebe só a chave dela, e ela fica destacada

### Requirement: [Comportamento] Seleção múltipla e tabela vazia
`GjaListMode` SHALL ter `none`, `singleSelectMaster` e `multiSelect`. No modo `multiSelect`, cada linha e o cabeçalho SHALL ter uma caixa de seleção no início: a da linha inclui ou tira a chave dela; a do cabeçalho escolhe todas, ou nenhuma quando todas já estão escolhidas, e fica parcial quando só algumas estão. Sem itens, a tabela SHALL mostrar `noDataText` (ou o `noData` da localização) no lugar das linhas.

#### Scenario: Seleção múltipla
- **GIVEN** uma tabela `multiSelect` de três linhas, sem nenhuma escolhida, cujo `onSelectionChange` atualiza `selectedKeys`
- **WHEN** a caixa da segunda linha é tocada, e depois a do cabeçalho
- **THEN** a do cabeçalho fica parcial depois do primeiro toque, e no fim as três estão escolhidas

#### Scenario: Tabela vazia
- **WHEN** uma tabela sem itens e sem `noDataText` é renderizada em pt-BR
- **THEN** ela mostra "Sem dados" abaixo dos títulos

### Requirement: [Comportamento] Teclado
Com o foco numa linha acionável, as setas para cima e para baixo SHALL mover o foco à linha acionável anterior ou seguinte.

#### Scenario: Setas na tabela
- **GIVEN** o foco na primeira de duas linhas `active`
- **WHEN** a seta para baixo e depois Enter são pressionados
- **THEN** `onItemPress` recebe a chave da segunda linha

### Requirement: [Aparência] Tokens de componente
O cabeçalho das colunas e as linhas SHALL ter a altura mínima `density.listItemHeight`, células com `spacing.s` nas laterais e `spacing.xs` em cima e embaixo, a borda inferior `colors.separator` e o fundo `colors.base`. O texto dos títulos das colunas SHALL ser `typography.base` em `colors.label`; `headerText`, um título H5. A linha escolhida SHALL ter o fundo `colors.selectionBackground`.

#### Scenario: Linha da tabela
- **WHEN** uma tabela é renderizada no tema claro
- **THEN** cada linha tem a altura `listItemHeight`, e o título "Produto" tem a cor `label`

### Requirement: [Estados] Interação
As linhas acionáveis SHALL apresentar hover (fundo `colors.hoverBackground`), pressionado e foco pelo teclado, de `gja/core/interaction`; as `inactive` fora do modo `singleSelectMaster` SHALL NOT reagir ao ponteiro.

#### Scenario: Linha em hover
- **WHEN** o ponteiro passa sobre uma linha `active` e depois sobre uma `inactive`
- **THEN** só a `active` tem o fundo `hoverBackground`

### Requirement: [Acessibilidade] Semântica e contraste
Cada linha acionável SHALL ser exposta como botão com os textos das células e, no modo `singleSelectMaster`, o estado selecionado. As caixas de seleção SHALL ter os nomes `selectAll` (cabeçalho) e `selectItem` (linha) da localização. A tabela SHALL ser um nó com o nome `headerText`, quando dado. Os textos MUST ter o contraste de texto, e os alvos o tamanho mínimo.

#### Scenario: Semântica da tabela
- **WHEN** a árvore de semântica de uma tabela `singleSelectMaster` com a linha "Teclado" escolhida é lida
- **THEN** a linha é botão selecionado com o rótulo que contém "Teclado"

#### Scenario: Contraste e alvo da tabela
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a tabelas `multiSelect` e `singleSelectMaster`, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Popin e direção
A tabela SHALL classificar a própria largura com `breakpoints.classify`. Uma coluna cujo `minScreenWidth` é maior que essa classe MUST sumir do cabeçalho e das linhas; com `demandPopin`, a célula dela SHALL aparecer abaixo das células visíveis, depois do título da coluna e de dois-pontos. Em RTL, a primeira coluna MUST ficar à direita.

#### Scenario: Colunas em popin
- **GIVEN** uma tabela com a coluna "Preço" com `minScreenWidth` `medium` e `demandPopin`, e a coluna "Estoque" com `minScreenWidth` `medium`
- **WHEN** ela é renderizada com a largura 400
- **THEN** "Preço" e "Estoque" não estão no cabeçalho, e cada linha mostra "Preço:" e o preço abaixo das outras células

#### Scenario: Tabela em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a tabela é renderizada
- **THEN** o título da primeira coluna fica à direita do da segunda

### Requirement: [Integração] Dependências
`GjaTable` SHALL depender somente de `gja/core/interaction`, `gja/core/localization`, `gja/widgets/gja-check-box`, `gja/widgets/gja-title`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/spacing`, `gja/foundation/density`, `gja/foundation/breakpoints`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Tabela sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** uma tabela `multiSelect` com linhas `navigation` é renderizada, tocada e escolhida
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaTable` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da tabela
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da tabela
- **WHEN** os goldens de uma tabela `multiSelect` com linhas `navigation` e uma escolhida, larga e estreita (com popin), de uma com títulos de grupo e o botão de mais linhas, e de uma vazia são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaTable` SHALL ter dartdoc em toda API pública e uma página "GjaTable" na galeria com uma tabela de produtos com seleção múltipla, linhas `navigation`, colunas em popin, títulos de grupo e o botão de mais linhas.

#### Scenario: Página GjaTable na galeria
- **GIVEN** a página "GjaTable" aberta na galeria
- **WHEN** a linha "Teclado" é tocada
- **THEN** a página mostra "Aberto: Teclado"

### Requirement: [Restrições] Fora do escopo
`GjaTable` SHALL NOT aceitar larguras ou cores literais, nem ter `growingScrollToLoad`, cabeçalho fixo, barras de ferramentas, rodapés, ordenação, `alternateRowColors`, `highlight` ou os modos `Delete` e `SingleSelectLeft`.

#### Scenario: Tabela sem valor literal
- **WHEN** a API pública de `GjaTable` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`

### Requirement: [Comportamento] Mais linhas
Com `growing` (padrão `false`), a tabela SHALL mostrar só as primeiras `growingThreshold` linhas (`int`, padrão 20) e, abaixo delas, um botão com `growingTriggerText` (`String?`; nulo usa `more` da localização) e a contagem "[mostradas / total]"; acioná-lo SHALL mostrar mais `growingThreshold` linhas, e ele some quando todas aparecem, como o `growing` do `sap.m.Table`. `growingThreshold` MUST ser positivo.

#### Scenario: Mais linhas
- **GIVEN** uma tabela com `growing`, `growingThreshold` 2 e cinco linhas, em pt-BR
- **WHEN** o botão "Mais" é tocado duas vezes
- **THEN** de início há duas linhas e "[2 / 5]", depois quatro e "[4 / 5]", e por fim as cinco, sem o botão

### Requirement: [Comportamento] Títulos de grupo
`items` SHALL aceitar `GjaGroupHeaderListItem<T>`, como o `sap.m.GroupHeaderListItem`, com `title` e `count` (`String?`, entre parênteses), mostrado na largura da tabela em `typography.baseBold` e exposto como cabeçalho. Títulos de grupo MUST NOT ser escolhidos, acionados ou contados pela seleção, pelas setas ou por `growing`.

#### Scenario: Títulos de grupo
- **GIVEN** uma tabela `multiSelect` com o título "Periféricos" e duas linhas, e o título "Vídeo" e uma linha
- **WHEN** a caixa do cabeçalho é tocada
- **THEN** os títulos aparecem acima das linhas deles, como cabeçalhos, e `onSelectionChange` recebe só as três chaves das linhas
