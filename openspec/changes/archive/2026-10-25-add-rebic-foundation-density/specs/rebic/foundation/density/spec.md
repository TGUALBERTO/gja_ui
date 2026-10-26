# Spec Delta

## Purpose

Define a densidade do Rebic: os modos `comfortable` e `compact`, as dimensões de controle, item e alvo de interação de cada modo e o espaçamento compacto, preservando a tipografia. Usa a escala e o contrato de `rebic/foundation/spacing` e os estilos de `rebic/foundation/typography`.

## ADDED Requirements

### Requirement: Modos de densidade
O fundamento SHALL definir exatamente os modos `comfortable` (entrada por toque) e `compact` (entrada por ponteiro) e fornecer um mapeamento de referência para cada um, obtido a partir do modo.

#### Scenario: Mapeamento por modo
- **WHEN** o mapeamento de referência é pedido para cada modo
- **THEN** cada resultado informa o próprio modo, e os dois mapeamentos são diferentes

### Requirement: Dimensões de controle por densidade
O conjunto semântico de densidade SHALL ter a altura de controle (botões, campos e seleções), a altura de item de lista e o tamanho mínimo de alvo de interação. Nos mapeamentos de referência, cada dimensão compacta MUST ser menor ou igual à confortável, e todas MUST ser valores da escala primitiva de espaçamento.

#### Scenario: Valores de referência
- **WHEN** os mapeamentos de referência são inspecionados
- **THEN** o confortável tem controle 40, item 48 e alvo 48; o compacto tem controle 32, item 32 e alvo 24

#### Scenario: Compacto não maior que confortável
- **WHEN** cada dimensão do compacto é comparada com a do confortável
- **THEN** nenhuma dimensão compacta é maior

### Requirement: Alvo mínimo de interação
O tamanho mínimo de alvo MUST ser de pelo menos 48 px lógicos no modo `comfortable` (diretrizes de toque) e de pelo menos 24 px lógicos no modo `compact` (WCAG 2.2, critério 2.5.8). Em qualquer mapeamento, ele MUST ser maior ou igual a 24.

#### Scenario: Alvos dos mapeamentos de referência
- **WHEN** o alvo mínimo de cada mapeamento de referência é inspecionado
- **THEN** o confortável é ≥ 48 e o compacto é ≥ 24

#### Scenario: Alvo abaixo do mínimo rejeitado
- **WHEN** um mapeamento é derivado com `copyWith` usando alvo mínimo 20
- **THEN** a criação falha em modo debug com mensagem que cita o mínimo de 24

### Requirement: Espaçamento por densidade
Cada mapeamento de densidade SHALL conter um conjunto de espaçamento completo. O confortável MUST usar o mapeamento de referência de espaçamento. O compacto MUST ter cada passo e papel menor ou igual ao do confortável, com passos não decrescentes, `none` igual a zero, cada papel de layout igual a algum passo e todos os valores vindos da escala primitiva de espaçamento.

#### Scenario: Espaçamento confortável
- **WHEN** o espaçamento do mapeamento confortável é comparado com o mapeamento de referência de espaçamento
- **THEN** eles são iguais

#### Scenario: Espaçamento compacto
- **WHEN** o espaçamento compacto é inspecionado
- **THEN** cada valor é ≤ ao confortável correspondente, os passos são não decrescentes, `none` vale 0, os papéis apontam para passos e os valores existem na escala primitiva

### Requirement: Tipografia preservada
A densidade MUST NOT alterar tamanhos de fonte nem alturas de linha. Em cada mapeamento de referência, a altura de controle MUST comportar a linha do estilo de rótulo da tipografia de referência mais o passo `xs` do próprio espaçamento acima e abaixo.

#### Scenario: Rótulo cabe no controle
- **WHEN** a altura de controle de cada mapeamento de referência é comparada com a altura de linha do rótulo mais duas vezes o passo `xs` da mesma densidade
- **THEN** a altura de controle é maior ou igual

#### Scenario: Densidade sem estilos de texto
- **WHEN** o conjunto de densidade é inspecionado
- **THEN** ele não contém tamanhos de fonte nem estilos de texto, e os widgets usam a mesma tipografia nas duas densidades

### Requirement: Contrato do conjunto de densidade
O conjunto semântico de densidade MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp`, igualdade por valor e diagnóstico. Na interpolação, as dimensões e o espaçamento SHALL ser interpolados de forma contínua, e o modo troca em `t = 0.5`. Todas as dimensões MUST ser finitas e positivas.

#### Scenario: Contrato verificado
- **GIVEN** os mapeamentos de referência confortável e compacto
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação entre densidades
- **WHEN** o confortável é interpolado até o compacto em `t = 0.5`
- **THEN** a altura de controle é 36, e o modo é `compact`

### Requirement: Testes e documentação da densidade
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Densidade" com controles simulados nas duas densidades lado a lado, mostrando as alturas e o alvo mínimo.

#### Scenario: Página na galeria
- **WHEN** a página "Densidade" é aberta
- **THEN** ela exibe as duas densidades, cada uma com um controle simulado da altura de controle e as medidas de controle, item e alvo
