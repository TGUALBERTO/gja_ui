# Spec Delta

## Purpose

`RebicTable` é a tabela responsiva do Rebic, como o `sap.m.Table` do SAPUI5: colunas com título e alinhamento, linhas de células que podem ser acionadas ou escolhidas (seleção única ou múltipla, no padrão controlado `selectedKeys` + `onSelectionChange`) e colunas que, em larguras pequenas, somem ou descem para baixo da linha (popin).

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicTable<T>` SHALL expor, como o `sap.m.Table`:

| Prop | Tipo | Padrão |
|---|---|---|
| `columns` | `List<RebicColumn>` | obrigatória |
| `items` | `List<RebicColumnListItem<T>>` | obrigatória |
| `headerText` | `String?` | `null` |
| `noDataText` | `String?` | `null` |
| `mode` | `RebicListMode` | `none` |
| `selectedKeys` | `Set<T>` | `{}` |
| `onSelectionChange` | `ValueChanged<Set<T>>?` | `null` |
| `onItemPress` | `ValueChanged<T>?` | `null` |

#### Scenario: Tabela mínima
- **WHEN** uma tabela com as colunas "Produto" e "Quantidade" e duas linhas é renderizada
- **THEN** os títulos ficam numa linha acima das linhas, e cada célula fica abaixo do título da sua coluna

### Requirement: [API] Colunas e linhas válidas
`RebicColumn` SHALL ter `header`, `hAlign` (`begin`, `center`, `end`; padrão `begin`), `flex` (`int`, padrão 1, no lugar do `width`), `minScreenWidth` (`RebicSizeClass?`) e `demandPopin` (padrão `false`). `RebicColumnListItem<T>` SHALL ter `key`, `cells` e `type` (`inactive`, `active`, `navigation`; padrão `inactive`). `columns` MUST NOT ser vazia, cada linha MUST ter uma célula por coluna e as chaves MUST ser distintas, ou a renderização MUST falhar em modo debug.

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
`RebicListMode` SHALL ter `none`, `singleSelectMaster` e `multiSelect`. No modo `multiSelect`, cada linha e o cabeçalho SHALL ter uma caixa de seleção no início: a da linha inclui ou tira a chave dela; a do cabeçalho escolhe todas, ou nenhuma quando todas já estão escolhidas, e fica parcial quando só algumas estão. Sem itens, a tabela SHALL mostrar `noDataText` (ou o `noData` da localização) no lugar das linhas.

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
As linhas acionáveis SHALL apresentar hover (fundo `colors.hoverBackground`), pressionado e foco pelo teclado, de `rebic/core/interaction`; as `inactive` fora do modo `singleSelectMaster` SHALL NOT reagir ao ponteiro.

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
`RebicTable` SHALL depender somente de `rebic/core/interaction`, `rebic/core/localization`, `rebic/widgets/rebic-check-box`, `rebic/widgets/rebic-title`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/breakpoints`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Tabela sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** uma tabela `multiSelect` com linhas `navigation` é renderizada, tocada e escolhida
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicTable` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade da tabela
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da tabela
- **WHEN** os goldens de uma tabela `multiSelect` com linhas `navigation` e uma escolhida, larga e estreita (com popin), e de uma vazia são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicTable` SHALL ter dartdoc em toda API pública e uma página "RebicTable" na galeria com uma tabela de produtos com seleção múltipla, linhas `navigation` e colunas em popin.

#### Scenario: Página RebicTable na galeria
- **GIVEN** a página "RebicTable" aberta na galeria
- **WHEN** a linha "Teclado" é tocada
- **THEN** a página mostra "Aberto: Teclado"

### Requirement: [Restrições] Fora do escopo
`RebicTable` SHALL NOT aceitar larguras ou cores literais, nem ter `growing`, cabeçalho fixo, barras de ferramentas, rodapés, agrupamento, ordenação, `alternateRowColors`, `highlight` ou os modos `Delete` e `SingleSelectLeft`.

#### Scenario: Tabela sem valor literal
- **WHEN** a API pública de `RebicTable` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
