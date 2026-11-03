# rebic/widgets/rebic-illustrated-message Specification

## Purpose

`RebicIllustratedMessage` explica uma tela ou área sem conteúdo, como o `sap.m.IllustratedMessage` do SAPUI5: uma ilustração do tipo da situação (sem dados, sem resultados, erro…), um título, uma descrição e ações, centralizados, em três tamanhos.

## Requirements

### Requirement: [API] Propriedades
`RebicIllustratedMessage` SHALL expor, como o `sap.m.IllustratedMessage`:

| Prop | Tipo | Padrão |
|---|---|---|
| `title` | `String` | obrigatória |
| `description` | `String?` | `null` |
| `illustrationType` | `RebicIllustrationType` | `noData` |
| `illustrationSize` | `RebicIllustrationSize` | `dialog` |
| `illustration` | `Widget?` | `null` |
| `additionalContent` | `List<Widget>` | `[]` |

#### Scenario: Mensagem mínima
- **WHEN** `RebicIllustratedMessage(title: 'Nenhum pedido')` é renderizada numa área de 400
- **THEN** a ilustração de `noData` fica no topo, e o título abaixo, os dois centralizados

### Requirement: [API] Callbacks e controlador
`RebicIllustratedMessage` SHALL NOT ter callbacks nem controlador; as ações são os widgets de `additionalContent`. `title` MUST NOT ser vazio, ou a criação MUST falhar em modo debug.

#### Scenario: Mensagem sem título
- **WHEN** uma `RebicIllustratedMessage` é criada com `title` vazio
- **THEN** a criação falha em modo debug

### Requirement: [Comportamento] Ilustração por tipo
`RebicIllustrationType` SHALL ter `noData`, `noEntries`, `noSearchResults`, `noFilterResults`, `error` e `success`. Sem `illustration`, a mensagem SHALL desenhar o ícone do tipo: `noData` com `RebicIcons.document`, `noEntries` com `folderBlank`, `noSearchResults` com `search`, `noFilterResults` com `filter`, `error` com `error` e `success` com `sysEnter2`. Com `illustration`, SHALL mostrar o widget dado no lugar do ícone.

#### Scenario: Ilustração de busca
- **WHEN** uma mensagem `noSearchResults` e uma com `illustration` própria são renderizadas
- **THEN** a primeira desenha o ícone `search`, e a segunda o widget dado, sem ícone

### Requirement: [Aparência] Tamanhos e tokens
`RebicIllustrationSize` SHALL ter `spot`, `dialog` e `scene`. O ícone SHALL ter `icons.xLarge` em `spot`, `2 × icons.xLarge` em `dialog` e `4 × icons.xLarge` em `scene`, na cor `colors.brand`; o título SHALL ter o estilo `h4`, `h3` e `h2`, respectivamente, de `rebic/widgets/rebic-title`; a descrição um `RebicText` (`typography.base`, `colors.text`); com `spacing.m` entre a ilustração, o título, a descrição e as ações. Nenhum valor MUST ser literal.

#### Scenario: Tamanhos da mensagem
- **WHEN** a mesma mensagem é renderizada em `spot`, `dialog` e `scene`
- **THEN** os ícones medem `icons.xLarge`, o dobro e o quádruplo, e os títulos usam os estilos `h4`, `h3` e `h2`

### Requirement: [Estados] Sem estados próprios
A mensagem SHALL NOT ter estados de interação próprios nem receber o foco; as ações têm os seus.

#### Scenario: Mensagem sem foco
- **GIVEN** uma mensagem sem ações entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai direto ao segundo

### Requirement: [Acessibilidade] Semântica e contraste
O título SHALL ser exposto como cabeçalho, no nível `titleLevel` (`RebicTitleLevel`, padrão `auto`); a ilustração MUST ficar fora da semântica. O título e a descrição MUST ter o contraste de texto.

#### Scenario: Semântica da mensagem
- **WHEN** a árvore de semântica de uma mensagem com título "Nenhum pedido" e descrição é lida
- **THEN** o título é cabeçalho, a descrição é lida depois dele, e não há nó da ilustração

#### Scenario: Contraste da mensagem
- **WHEN** a diretriz de contraste de texto é aplicada a mensagens nos temas claro e escuro
- **THEN** é atendida

### Requirement: [Responsividade] Largura
O título e a descrição SHALL quebrar em várias linhas, centralizados, sem estouro; as ações SHALL ficar lado a lado e quebrar para a linha seguinte quando não couberem.

#### Scenario: Mensagem estreita
- **WHEN** uma mensagem com descrição longa e duas ações é renderizada numa largura de 200
- **THEN** não há estouro, e a descrição ocupa mais de uma linha

### Requirement: [Integração] Dependências
`RebicIllustratedMessage` SHALL depender somente de `rebic/widgets/rebic-title`, `rebic/widgets/rebic-text`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Mensagem sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** uma mensagem de cada tipo, com ação, é renderizada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicIllustratedMessage` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: semântica e contraste de texto.

#### Scenario: Rastreabilidade da mensagem
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da mensagem
- **WHEN** os goldens dos três tamanhos e de uma mensagem com ação são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicIllustratedMessage` SHALL ter dartdoc em toda API pública e uma página "RebicIllustratedMessage" na galeria com os tipos, os tamanhos e uma mensagem com ação.

#### Scenario: Página RebicIllustratedMessage na galeria
- **GIVEN** a página "RebicIllustratedMessage" aberta na galeria
- **WHEN** a ação "Limpar filtros" é tocada
- **THEN** a mensagem de sem resultados dá lugar à lista

### Requirement: [Restrições] Fora do escopo
`RebicIllustratedMessage` SHALL NOT reproduzir as ilustrações da SAP, nem ter títulos e descrições padrão (`enableDefaultTitleAndDescription`), texto formatado ou responsividade vertical.

#### Scenario: Mensagem sem valor literal
- **WHEN** a API pública de `RebicIllustratedMessage` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
