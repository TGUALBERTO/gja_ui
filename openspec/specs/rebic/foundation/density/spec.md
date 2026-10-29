# rebic/foundation/density Specification

## Purpose

Define a densidade do Rebic: os modos `cozy` e `compact` das densidades de conteúdo do Fiori e as dimensões de controle, item e alvo de interação de cada modo, com o mesmo espaçamento nos dois, preservando a tipografia. Usa a escala e o contrato de `rebic/foundation/spacing` e os estilos de `rebic/foundation/typography`.

## Requirements

### Requirement: Modos de densidade
O fundamento SHALL definir exatamente os modos `cozy` (densidade confortável, entrada por toque, como `sapUiSizeCozy`) e `compact` (entrada por ponteiro, como `sapUiSizeCompact`) e fornecer um mapeamento de referência para cada um, obtido a partir do modo. Ele MUST NOT usar o nome `comfortable`.

#### Scenario: Mapeamento por modo
- **WHEN** o mapeamento de referência é pedido para cada modo
- **THEN** cada resultado informa o próprio modo, e os dois mapeamentos são diferentes

#### Scenario: Nomes do Fiori
- **WHEN** os modos de densidade são listados
- **THEN** eles são exatamente `cozy` e `compact`

### Requirement: Dimensões de controle por densidade
O conjunto semântico de densidade SHALL ter a altura de controle (`sapElement_Height`), a altura de item de lista e o alvo mínimo de interação (`sapElement_LineHeight`). Nos mapeamentos de referência, cada dimensão compacta MUST ser menor ou igual à cozy, e todas MUST ser valores da escala primitiva de densidade.

#### Scenario: Valores de referência
- **WHEN** os mapeamentos de referência são inspecionados
- **THEN** o cozy tem controle 36, item 44 e alvo 44; o compacto tem controle 26, item 32 e alvo 32

#### Scenario: Compacto não maior que confortável
- **WHEN** cada dimensão do compacto é comparada com a do cozy
- **THEN** nenhuma dimensão compacta é maior

#### Scenario: Escala primitiva de densidade
- **WHEN** a escala primitiva de densidade é inspecionada
- **THEN** ela tem 26, 32, 36 e 44 em ordem crescente, cada um nomeado pelo valor

### Requirement: Alvo mínimo de interação
O alvo mínimo MUST ser de pelo menos 44 px lógicos no modo `cozy` (altura de linha `sapElement_LineHeight`) e de pelo menos 24 px lógicos no modo `compact` (WCAG 2.2, critério 2.5.8). Em qualquer mapeamento, ele MUST ser maior ou igual a 24.

#### Scenario: Alvos dos mapeamentos de referência
- **WHEN** o alvo mínimo de cada mapeamento de referência é inspecionado
- **THEN** o cozy é ≥ 44 e o compacto é ≥ 24

#### Scenario: Alvo abaixo do mínimo rejeitado
- **WHEN** um mapeamento é derivado com `copyWith` usando alvo mínimo 20
- **THEN** a criação falha em modo debug com mensagem que cita o mínimo de 24

### Requirement: Espaçamento por densidade
Cada mapeamento de densidade SHALL conter um conjunto de espaçamento completo. Os mapeamentos de referência cozy e compacto MUST usar o mesmo mapeamento de referência de espaçamento: como no Fiori, a densidade muda as alturas de elemento, e as classes de margem valem o mesmo em Cozy e Compact.

#### Scenario: Espaçamento confortável
- **WHEN** o espaçamento do mapeamento cozy é comparado com o mapeamento de referência de espaçamento
- **THEN** eles são iguais

#### Scenario: Espaçamento compacto
- **WHEN** o espaçamento compacto é comparado com o mapeamento de referência de espaçamento
- **THEN** eles são iguais, e o compacto difere do cozy só nas dimensões de controle, item e alvo

### Requirement: Tipografia preservada
A densidade MUST NOT alterar tamanhos de fonte nem alturas de linha. Em cada mapeamento de referência, a altura de controle MUST comportar a linha do estilo `base` da tipografia de referência mais o passo `xxs` do próprio espaçamento acima e abaixo.

#### Scenario: Rótulo cabe no controle
- **WHEN** a altura de controle de cada mapeamento de referência é comparada com a altura de linha de `base` mais duas vezes o passo `xxs` da mesma densidade
- **THEN** a altura de controle é maior ou igual

#### Scenario: Densidade sem estilos de texto
- **WHEN** o conjunto de densidade é inspecionado
- **THEN** ele não contém tamanhos de fonte nem estilos de texto, e os widgets usam a mesma tipografia nas duas densidades

### Requirement: Contrato do conjunto de densidade
O conjunto semântico de densidade MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp`, igualdade por valor e diagnóstico. Na interpolação, as dimensões e o espaçamento SHALL ser interpolados de forma contínua, e o modo troca em `t = 0.5`. Todas as dimensões MUST ser finitas e positivas.

#### Scenario: Contrato verificado
- **GIVEN** os mapeamentos de referência cozy e compacto
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação entre densidades
- **WHEN** o cozy é interpolado até o compacto em `t = 0.5`
- **THEN** a altura de controle é 31, e o modo é `compact`

### Requirement: Testes e documentação da densidade
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token e o parâmetro Fiori correspondente. A galeria SHALL ter uma página "Densidade" com controles simulados nas duas densidades lado a lado, mostrando as alturas e o alvo mínimo.

#### Scenario: Página na galeria
- **WHEN** a página "Densidade" é aberta
- **THEN** ela exibe as densidades `cozy` e `compact`, cada uma com um controle simulado da altura de controle e as medidas de controle, item e alvo
