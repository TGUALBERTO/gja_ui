# Spec Delta

## Purpose

Define os breakpoints do Rebic: escala primitiva de larguras, as classes de tamanho, os limiares semânticos e a regra que classifica uma largura disponível, para que todos os layouts mudem de forma coerente. Segue o modelo de tokens de `rebic/foundation/design-tokens`.

## ADDED Requirements

### Requirement: Escala primitiva de larguras
O fundamento SHALL fornecer, na biblioteca de primitivos, uma escala de larguras em pixels lógicos nomeada pelo valor (ex.: `width1024`), com no mínimo 360, 600, 840, 1024, 1280, 1440 e 1920, em ordem crescente.

#### Scenario: Escala em ordem
- **WHEN** a escala primitiva de larguras é percorrida
- **THEN** cada valor é maior que o anterior, e o número do nome é igual ao valor

### Requirement: Classes de tamanho
O fundamento SHALL definir as classes de tamanho `small`, `medium`, `large` e `extraLarge`, nessa ordem, com comparação de ordem entre classes (`isAtLeast` e `isAtMost`).

#### Scenario: Comparação de classes
- **WHEN** `large.isAtLeast(medium)` e `small.isAtLeast(medium)` são avaliados
- **THEN** o primeiro é verdadeiro e o segundo é falso, e toda classe é `isAtLeast` e `isAtMost` dela mesma

### Requirement: Limiares semânticos
O conjunto semântico de breakpoints SHALL ter as larguras mínimas `medium`, `large` e `extraLarge`. Os limiares MUST ser finitos, positivos e estritamente crescentes em qualquer mapeamento. O mapeamento de referência MUST usar 600, 1024 e 1440, todos vindos da escala primitiva.

#### Scenario: Mapeamento de referência
- **WHEN** o mapeamento de referência é inspecionado
- **THEN** `medium` = 600, `large` = 1024 e `extraLarge` = 1440, e cada valor existe na escala primitiva

#### Scenario: Limiares fora de ordem rejeitados
- **WHEN** um conjunto é derivado com `copyWith` usando `large` menor ou igual a `medium`
- **THEN** a criação falha em modo debug com mensagem que cita os limiares

### Requirement: Classificação de uma largura
O conjunto semântico SHALL classificar uma largura disponível, em pixels lógicos, na maior classe cujo limiar mínimo seja menor ou igual à largura. Larguras abaixo de `medium` são `small`. O limiar é inclusivo. Largura zero é `small`, e largura infinita (sem limite) é `extraLarge`. Largura negativa ou `NaN` MUST lançar `ArgumentError`.

#### Scenario: Larguras nas bordas
- **GIVEN** o mapeamento de referência
- **WHEN** as larguras 0, 599.9, 600, 1023.9, 1024, 1439.9, 1440 e 4000 são classificadas
- **THEN** os resultados são `small`, `small`, `medium`, `medium`, `large`, `large`, `extraLarge` e `extraLarge`

#### Scenario: Largura sem limite
- **WHEN** `double.infinity` é classificado
- **THEN** o resultado é `extraLarge`

#### Scenario: Largura inválida
- **WHEN** −1 ou `double.nan` é classificado
- **THEN** a chamada lança `ArgumentError` com o valor recebido

#### Scenario: Limiares personalizados
- **GIVEN** um mapeamento com `medium` = 480, `large` = 960 e `extraLarge` = 1280
- **WHEN** a largura 500 é classificada
- **THEN** o resultado é `medium`

### Requirement: Contrato do conjunto de breakpoints
O conjunto semântico de breakpoints MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp` com interpolação contínua de cada limiar, igualdade por valor e diagnóstico com o nome de cada limiar.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com limiares 480, 960 e 1280
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação de limiar
- **GIVEN** `large` igual a 1024 no conjunto A e 960 no conjunto B
- **WHEN** `A.lerp(B, 0.5)` é calculado
- **THEN** `large` vale 992

### Requirement: Testes e documentação dos breakpoints
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Breakpoints" que mostra os limiares e a classe de tamanho da largura atual da janela.

#### Scenario: Página na galeria
- **GIVEN** a galeria aberta em janelas de 500, 800, 1200 e 1600 px de largura
- **WHEN** a página "Breakpoints" é exibida
- **THEN** ela informa as classes `small`, `medium`, `large` e `extraLarge`, respectivamente, e lista os três limiares
