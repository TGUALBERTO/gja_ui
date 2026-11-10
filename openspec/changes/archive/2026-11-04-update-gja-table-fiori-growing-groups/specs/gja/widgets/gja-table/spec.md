# Spec Delta

## MODIFIED Requirements

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

### Requirement: [Restrições] Fora do escopo
`GjaTable` SHALL NOT aceitar larguras ou cores literais, nem ter `growingScrollToLoad`, cabeçalho fixo, barras de ferramentas, rodapés, ordenação, `alternateRowColors`, `highlight` ou os modos `Delete` e `SingleSelectLeft`.

#### Scenario: Tabela sem valor literal
- **WHEN** a API pública de `GjaTable` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`

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

## ADDED Requirements

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
