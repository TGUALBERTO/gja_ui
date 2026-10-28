# rebic/foundation/interaction-states Specification

## Purpose

Define os estados visuais de interação do Rebic no modelo Fiori: famílias de controle com cores explícitas por estado, derivadas dos papéis de `rebic/foundation/color`, contorno de foco e aparência desabilitada por opacidade, com contraste de texto preservado em todos os estados.

## Requirements

### Requirement: Estados de interação
O fundamento SHALL definir exatamente os estados `hovered`, `focused`, `pressed`, `selected`, `dragged` e `disabled`. Um componente pode estar em vários estados ao mesmo tempo, e as regras deste fundamento SHALL receber o conjunto de estados ativos.

#### Scenario: Conjunto de estados
- **WHEN** os estados definidos são listados
- **THEN** são exatamente os seis estados, e o conjunto vazio representa o estado normal

### Requirement: Anel de foco
O anel de foco MUST aparecer se, e somente se, `focused` estiver ativo e `disabled` não. O conjunto semântico SHALL definir a espessura do anel (≥ 2 px lógicos) e o afastamento em relação à borda do componente. A cor do anel MUST ser o papel `focus` do tema, que já tem contraste ≥ 3:1 sobre as superfícies.

#### Scenario: Visibilidade do anel
- **WHEN** a visibilidade é avaliada para `{focused}`, `{focused, pressed}`, `{hovered}` e `{focused, disabled}`
- **THEN** os resultados são verdadeiro, verdadeiro, falso e falso

#### Scenario: Espessura mínima
- **WHEN** a espessura do anel do mapeamento de referência é inspecionada
- **THEN** ela é ≥ 2, e o afastamento é ≥ 0

### Requirement: Aparência desabilitada
Um controle desabilitado MUST manter as cores do estado normal e ser exibido inteiro com a opacidade de desabilitado (0,4 na referência, como `sapContent_DisabledOpacity`). Fora do estado desabilitado, a opacidade do controle MUST ser 1.

#### Scenario: Opacidade de desabilitado
- **WHEN** a opacidade do controle é calculada para `{disabled}` e para `{hovered}`
- **THEN** os resultados são 0,4 (da escala primitiva) e 1

### Requirement: Contrato do conjunto de estados
O conjunto semântico de estados MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp` contínuo, igualdade por valor e diagnóstico. Em qualquer mapeamento, a opacidade de desabilitado MUST estar entre 0 (exclusive) e 1, a espessura do anel MUST ser ≥ 2 e o afastamento MUST ser finito e ≥ 0.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com opacidade de desabilitado 0,5
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Mapeamento inválido rejeitado
- **WHEN** um mapeamento é derivado com `copyWith` usando opacidade de desabilitado 0 ou anel de 1 px
- **THEN** a criação falha em modo debug com mensagem que identifica o campo

### Requirement: Testes e documentação dos estados
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Estados" com uma amostra de cada família em cada estado, nos modos claro e escuro.

#### Scenario: Página na galeria
- **WHEN** a página "Estados" é aberta
- **THEN** ela exibe, nos dois modos, as famílias `standard`, `emphasized`, `transparent` e `list` nos estados normal, hover, ativo, selecionado, selecionado com hover, foco e desabilitado, cada amostra com o rótulo do estado

### Requirement: Famílias de controle
O fundamento SHALL definir as famílias de controle `standard`, `emphasized`, `transparent`, `accept`, `reject`, `attention` e `list`, no modelo dos tipos de botão e dos itens de lista do Fiori. Cada família MUST ter fundo, borda e texto explícitos para os estados normal, hover, ativo, selecionado e selecionado com hover. Essas cores MUST ser derivadas dos papéis de `rebic/foundation/color`, para que uma troca de marca alcance todas as famílias.

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
- **THEN** cada uma usa as cores do estado de valor `success`, `error` e `warning`, respectivamente: normal = (fundo, borda e frente do estado), hover = (`hoverBackground`, borda do estado, frente do estado), e ativo, selecionado e selecionado com hover = (`highlight`, `highlight`, `contrastText`)

### Requirement: Resolução de cores por estado
As cores de uma família para um conjunto de estados MUST ser resolvidas nesta ordem de precedência: `disabled` usa as cores do normal (com a opacidade de desabilitado); `pressed` ou `dragged` usa o ativo; `selected` com `hovered` usa o selecionado com hover; `selected` usa o selecionado; `hovered` usa o hover; os demais usam o normal. `focused` MUST NOT alterar as cores.

#### Scenario: Estados isolados
- **WHEN** as cores da família `standard` são resolvidas para `{}`, `{hovered}`, `{pressed}`, `{hovered, pressed}` e `{focused}`
- **THEN** os resultados são normal, hover, ativo, ativo e normal

#### Scenario: Seleção combinada
- **WHEN** as cores são resolvidas para `{selected}`, `{selected, hovered}` e `{selected, pressed}`
- **THEN** os resultados são selecionado, selecionado com hover e ativo

#### Scenario: Desabilitado usa o normal
- **WHEN** as cores são resolvidas para `{disabled, hovered, pressed}`
- **THEN** o resultado é o normal, e a opacidade do controle é a de desabilitado

### Requirement: Contraste de texto nos estados
Nos dois mapeamentos de cor de referência, o texto de cada estado de cada família, exceto desabilitado, MUST ter contraste ≥ 4,5:1 sobre o fundo desse estado. Quando o fundo é transparente, a medida é feita sobre `base` e `background`. A borda do normal da família `standard` MUST ter contraste ≥ 3:1 sobre `base`.

#### Scenario: Texto de todos os estados
- **WHEN** cada família e cada estado não desabilitado são avaliados nos modos claro e escuro
- **THEN** todas as razões de texto sobre fundo são ≥ 4,5, e a borda normal de `standard` sobre `base` é ≥ 3
