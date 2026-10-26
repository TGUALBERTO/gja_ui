# Spec Delta

## Purpose

Define os estados visuais de interação do Rebic: camada de estado, anel de foco, aparência desabilitada e elevação em interação, com regras de combinação que preservam o contraste dos papéis de `rebic/foundation/color` e usam os níveis de `rebic/foundation/elevation`.

## ADDED Requirements

### Requirement: Estados de interação
O fundamento SHALL definir exatamente os estados `hovered`, `focused`, `pressed`, `selected`, `dragged` e `disabled`. Um componente pode estar em vários estados ao mesmo tempo, e as regras deste fundamento SHALL receber o conjunto de estados ativos.

#### Scenario: Conjunto de estados
- **WHEN** os estados definidos são listados
- **THEN** são exatamente os seis estados, e o conjunto vazio representa o estado normal

### Requirement: Camada de estado
O conjunto semântico SHALL ter as opacidades de camada de estado `hover` 0,08, `pressed` 0,12, `selected` 0,12 e `dragged` 0,16 no mapeamento de referência, vindas da escala primitiva. A camada de estado MUST ser a cor de conteúdo da superfície (ex.: `onSurface` sobre `surface`) com a opacidade resultante, pintada sobre a superfície.

#### Scenario: Cor da camada
- **GIVEN** a cor de conteúdo `onSurface` do mapeamento claro
- **WHEN** a camada do estado `pressed` é calculada
- **THEN** a cor é `onSurface` com opacidade 0,12

### Requirement: Combinação de estados
A opacidade resultante MUST ser zero quando `disabled` estiver ativo. Nos demais casos, ela MUST ser a soma da opacidade de `selected` (se ativo) com a maior opacidade entre `hovered`, `pressed` e `dragged` ativos, limitada ao teto `maxOverlayOpacity` (0,16 na referência). `focused` MUST NOT acrescentar camada.

#### Scenario: Estados isolados
- **WHEN** a opacidade é calculada para `{}`, `{hovered}`, `{pressed}`, `{hovered, pressed}` e `{focused}`
- **THEN** os resultados são 0, 0,08, 0,12, 0,12 e 0

#### Scenario: Seleção combinada
- **WHEN** a opacidade é calculada para `{selected}`, `{selected, hovered}` e `{selected, dragged}`
- **THEN** os resultados são 0,12, 0,16 e 0,16, sem ultrapassar o teto

#### Scenario: Desabilitado anula a camada
- **WHEN** a opacidade é calculada para `{disabled, hovered, pressed}`
- **THEN** o resultado é 0

### Requirement: Anel de foco
O anel de foco MUST aparecer se, e somente se, `focused` estiver ativo e `disabled` não. O conjunto semântico SHALL definir a espessura do anel (≥ 2 px lógicos) e o afastamento em relação à borda do componente. A cor do anel MUST ser o papel `focus` do tema, que já tem contraste ≥ 3:1 sobre as superfícies.

#### Scenario: Visibilidade do anel
- **WHEN** a visibilidade é avaliada para `{focused}`, `{focused, pressed}`, `{hovered}` e `{focused, disabled}`
- **THEN** os resultados são verdadeiro, verdadeiro, falso e falso

#### Scenario: Espessura mínima
- **WHEN** a espessura do anel do mapeamento de referência é inspecionada
- **THEN** ela é ≥ 2, e o afastamento é ≥ 0

### Requirement: Aparência desabilitada
Componentes desabilitados MUST usar os papéis de cor desabilitados (`onSurfaceDisabled` e `surfaceDisabled`) quando existirem. Para conteúdo sem papel desabilitado, como ícones coloridos e imagens, o conjunto semântico SHALL definir a opacidade de conteúdo desabilitado, 0,38 na referência.

#### Scenario: Opacidade de desabilitado
- **WHEN** a opacidade de conteúdo desabilitado do mapeamento de referência é inspecionada
- **THEN** ela é 0,38 e vem da escala primitiva

### Requirement: Elevação em interação
Para um componente com elevação base entre os níveis 0 e 4, o nível resultante MUST ser a base + 1 com `hovered`, a base + 2 com `dragged`, limitado ao nível 4. Com `pressed` ou `disabled`, o nível MUST ser a base. Uma base fora de 0 a 4 MUST lançar `ArgumentError`.

#### Scenario: Níveis resultantes
- **GIVEN** um componente com elevação base 1
- **WHEN** o nível é calculado para `{}`, `{hovered}`, `{dragged}`, `{hovered, pressed}` e `{hovered, disabled}`
- **THEN** os resultados são 1, 2, 3, 1 e 1

#### Scenario: Limite superior e base inválida
- **WHEN** o nível é calculado com base 4 e `{dragged}`, e depois com base 5
- **THEN** o primeiro resultado é 4, e o segundo lança `ArgumentError`

### Requirement: Contraste preservado nos estados
Com a camada de estado na opacidade máxima (`maxOverlayOpacity`), o texto MUST manter contraste ≥ 4,5:1 nos dois mapeamentos de cor de referência, para `onSurface` sobre `background`, `surface` e `surfaceVariant`, `onPrimary` sobre `primary` e `onPrimaryContainer` sobre `primaryContainer`, com a camada feita da própria cor do texto.

#### Scenario: Pares de texto com a camada máxima
- **WHEN** cada par é avaliado com a superfície coberta pela camada máxima, nos modos claro e escuro
- **THEN** todas as razões de contraste são ≥ 4,5

### Requirement: Contrato do conjunto de estados
O conjunto semântico MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp` contínuo, igualdade por valor e diagnóstico. Em qualquer mapeamento, as opacidades MUST estar entre 0 e 1, cada opacidade de camada MUST ser ≤ `maxOverlayOpacity`, a espessura do anel MUST ser ≥ 2 e os aumentos de elevação MUST ser inteiros entre 0 e 4.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com hover 0,04
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Mapeamento inválido rejeitado
- **WHEN** um mapeamento é derivado com `copyWith` usando hover 0,2 (acima do teto) ou anel de 1 px
- **THEN** a criação falha em modo debug com mensagem que identifica o campo

### Requirement: Testes e documentação dos estados
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Estados" com uma superfície simulada em cada estado e combinação relevante, nos modos claro e escuro.

#### Scenario: Página na galeria
- **WHEN** a página "Estados" é aberta
- **THEN** ela exibe, nos dois modos, as superfícies normal, hover, pressionado, selecionado, selecionado + hover, arrastado, foco e desabilitado, cada uma com o rótulo do estado
