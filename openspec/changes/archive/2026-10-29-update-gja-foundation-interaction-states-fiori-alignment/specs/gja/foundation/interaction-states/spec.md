## MODIFIED Requirements

### Requirement: Estados de interação
O fundamento SHALL definir exatamente os estados `hovered`, `focused`, `pressed`, `selected` e `disabled`, como os estados de controle do Fiori. Ele MUST NOT definir estados de cor sem equivalente no Fiori, como `dragged`. Um componente pode estar em vários estados ao mesmo tempo, e as regras deste fundamento SHALL receber o conjunto de estados ativos.

#### Scenario: Conjunto de estados
- **WHEN** os estados definidos são listados
- **THEN** são exatamente os cinco estados, e o conjunto vazio representa o estado normal

#### Scenario: Sem estado de arraste
- **WHEN** os nomes dos estados definidos são inspecionados
- **THEN** nenhum deles é `dragged`

### Requirement: Testes e documentação dos estados
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Estados" com uma amostra de cada família em cada estado, nos modos claro e escuro.

#### Scenario: Página na galeria
- **WHEN** a página "Estados" é aberta
- **THEN** ela exibe, nos dois modos, as famílias `standard`, `emphasized`, `transparent`, `accept`, `reject`, `attention` e `list` nos estados normal, hover, ativo, selecionado, selecionado com hover, foco e desabilitado, cada amostra com o rótulo do estado

### Requirement: Famílias de controle
O fundamento SHALL definir as famílias de controle `standard`, `emphasized`, `transparent`, `accept`, `reject`, `attention` e `list`, no modelo dos tipos de botão e dos itens de lista do Fiori. Cada família MUST ter fundo, borda e texto explícitos para os estados normal, hover, ativo, selecionado e selecionado com hover. Essas cores MUST ser derivadas dos papéis de `gja/foundation/color`, para que uma troca de marca alcance todas as famílias.

#### Scenario: Família standard
- **WHEN** as cores da família `standard` são derivadas de um mapeamento de cor
- **THEN** normal = (`base`, `fieldBorder`, `brand`), hover = (`hoverBackground`, `fieldBorder`, `brand`), ativo = (`highlight`, `highlight`, `contrastText`), selecionado = (`selectionBackground`, `brand`, `brand`) e selecionado com hover = (`selectionHoverBackground`, `brand`, `brand`), na ordem fundo, borda e texto

#### Scenario: Família emphasized
- **WHEN** as cores da família `emphasized` são derivadas
- **THEN** normal = (`brand`, `brand`, `contrastText`), hover = (`brandHover`, `brandHover`, `contrastText`), e ativo, selecionado e selecionado com hover = (`highlight`, `highlight`, `contrastText`)

#### Scenario: Famílias transparent e list
- **WHEN** as cores das famílias `transparent` e `list` são derivadas
- **THEN** ambas têm borda transparente; `transparent` tem fundo transparente no normal e texto `brand`; `list` tem fundo `base` no normal e texto `text`; nas duas, hover usa `hoverBackground`, ativo usa `highlight` com `contrastText`, selecionado usa `selectionBackground` e selecionado com hover usa `selectionHoverBackground`

#### Scenario: Marca alcança as famílias
- **GIVEN** um mapeamento de cor com `brand` trocado
- **WHEN** as cores da família `standard` são derivadas dele
- **THEN** o texto normal e a borda do selecionado são o novo `brand`

#### Scenario: Famílias accept, reject e attention
- **WHEN** as cores das famílias `accept`, `reject` e `attention` são derivadas
- **THEN** cada uma usa só as cores do estado de valor `success`, `error` e `warning`, respectivamente: normal = (`background`, `border`, `foreground`), hover = (`hoverBackground`, `border`, `foreground`), e ativo, selecionado e selecionado com hover = (`foreground`, `foreground`, `background`)

#### Scenario: Ações semânticas sem cores da marca
- **WHEN** as cores das famílias `accept`, `reject` e `attention` são derivadas de um mapeamento com `brand`, `highlight` e `hoverBackground` trocados
- **THEN** nenhum estado dessas famílias muda

### Requirement: Resolução de cores por estado
As cores de uma família para um conjunto de estados MUST ser resolvidas nesta ordem de precedência: `disabled` usa as cores do normal (com a opacidade de desabilitado); `pressed` usa o ativo; `selected` com `hovered` usa o selecionado com hover; `selected` usa o selecionado; `hovered` usa o hover; os demais usam o normal. `focused` MUST NOT alterar as cores.

#### Scenario: Estados isolados
- **WHEN** as cores da família `standard` são resolvidas para `{}`, `{hovered}`, `{pressed}`, `{hovered, pressed}` e `{focused}`
- **THEN** os resultados são normal, hover, ativo, ativo e normal

#### Scenario: Seleção combinada
- **WHEN** as cores são resolvidas para `{selected}`, `{selected, hovered}` e `{selected, pressed}`
- **THEN** os resultados são selecionado, selecionado com hover e ativo

#### Scenario: Desabilitado usa o normal
- **WHEN** as cores são resolvidas para `{disabled, hovered, pressed}`
- **THEN** o resultado é o normal, e a opacidade do controle é a de desabilitado
