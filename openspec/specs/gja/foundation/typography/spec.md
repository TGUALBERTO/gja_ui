# gja/foundation/typography Specification

## Purpose

Define a tipografia do GJA: a fonte empacotada e sua licença, as escalas primitivas de tamanho, altura de linha e peso, os estilos semânticos de texto e o mapeamento de referência. Segue o modelo de tokens de `gja/foundation/design-tokens`.

## Requirements

### Requirement: Fonte empacotada e licenciada
O fundamento SHALL empacotar uma família tipográfica de licença aberta, sem fonte da SAP, com no mínimo os pesos 400, 500, 600 e 700, junto com o texto integral da licença. Aplicações que dependem do framework MUST conseguir usar a família sem declarar a fonte no próprio `pubspec.yaml`.

#### Scenario: Fonte disponível na aplicação consumidora
- **GIVEN** uma aplicação que depende de `gja_ui` e não declara fontes
- **WHEN** os arquivos da família são carregados pelo bundle de assets da aplicação
- **THEN** os quatro pesos são encontrados e carregados sem erro

#### Scenario: Licença distribuída
- **WHEN** o pacote do fundamento é inspecionado
- **THEN** o texto da licença da fonte está ao lado dos arquivos da fonte, e cada peso declarado no pacote tem um arquivo correspondente

### Requirement: Fontes de fallback do sistema
Os estilos semânticos MUST declarar uma lista de famílias de fallback do sistema, usada para glifos que a fonte empacotada não cobre. Essas famílias SHALL ser resolvidas como fontes do sistema, e não como assets do pacote.

#### Scenario: Fallback sem prefixo de pacote
- **WHEN** a família e os fallbacks de um estilo semântico são inspecionados
- **THEN** a família aponta para a fonte do pacote, e nenhum fallback contém o prefixo `packages/`

### Requirement: Escalas tipográficas primitivas
O fundamento SHALL fornecer, na biblioteca de primitivos, uma escala de tamanhos de fonte nomeada pelo valor (ex.: `size14`), uma escala de alturas de linha em pixels lógicos nomeada pelo valor (ex.: `lineHeight20`) e os pesos `regular`, `medium`, `semibold` e `bold`. As escalas MUST estar em ordem crescente, e toda altura de linha MUST ser múltiplo de 4.

#### Scenario: Escalas em ordem
- **WHEN** as escalas de tamanho e de altura de linha são percorridas
- **THEN** cada valor é maior que o anterior, o número do nome é igual ao valor e cada altura de linha é múltiplo de 4

### Requirement: Estilos semânticos de texto
O conjunto semântico de tipografia SHALL ter os estilos dos parâmetros Fiori: `header1`…`header6` (`sapFontHeader1Size`…`6Size`), `large` (`sapFontLargeSize`), `base` (`sapFontSize`), `baseSemibold`, `baseBold` e `small` (`sapFontSmallSize`). Os títulos MUST ser negrito, e `large`, `base` e `small`, regulares. Cada estilo MUST definir família, fallbacks, tamanho, altura de linha e peso, e MUST NOT definir cor nem fundo.

#### Scenario: Estilo completo e sem cor
- **WHEN** cada estilo do mapeamento de referência é inspecionado
- **THEN** família, fallbacks, tamanho, altura e peso estão definidos, e cor e fundo são nulos

#### Scenario: Hierarquia de tamanhos
- **WHEN** os tamanhos do mapeamento de referência são comparados
- **THEN** `header1 > header2 > header3 > header4 > header5 > header6 ≥ small` e `large > base > small`

#### Scenario: Pesos do texto base
- **WHEN** `base`, `baseSemibold` e `baseBold` são comparados
- **THEN** os três têm o mesmo tamanho e a mesma altura de linha, com pesos regular, semibold e bold

#### Scenario: Sem nomes do Material
- **WHEN** os nomes dos estilos do conjunto são listados
- **THEN** nenhum deles é `display`, `headline`, `title`, `subtitle`, `body`, `label` ou `caption`

### Requirement: Ritmo vertical e legibilidade
No mapeamento de referência, a altura de linha de cada estilo, em pixels lógicos e antes da escala de texto do sistema, MUST ser múltiplo de 4 e MUST valer pelo menos 1,2 vez o tamanho da fonte. Nenhum estilo MUST ter tamanho menor que 12. A distribuição do espaço da linha MUST ser igual acima e abaixo do texto.

#### Scenario: Altura de linha na grade
- **WHEN** a altura de linha de cada estilo é calculada como tamanho × altura relativa
- **THEN** o resultado é múltiplo de 4 e ≥ 1,2 × tamanho

#### Scenario: Tamanho mínimo
- **WHEN** os tamanhos do mapeamento de referência são inspecionados
- **THEN** nenhum é menor que 12

### Requirement: Contrato do conjunto tipográfico
O conjunto semântico de tipografia MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp`, igualdade por valor e diagnóstico com o nome de cada estilo. Na interpolação, tamanho e altura SHALL ser interpolados de forma contínua, e família e peso trocam conforme a interpolação de estilos de texto do SDK. O mapeamento de referência MUST derivar seus valores dos primitivos.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com todos os tamanhos aumentados
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação de tamanho
- **GIVEN** `base` com tamanho 14 no conjunto A e 18 no conjunto B
- **WHEN** `A.lerp(B, 0.5)` é calculado
- **THEN** o tamanho de `base` é 16

#### Scenario: Valores vêm dos primitivos
- **WHEN** tamanho, altura de linha e peso de cada estilo do mapeamento de referência são comparados com os primitivos
- **THEN** cada valor existe na escala primitiva correspondente

### Requirement: Testes e documentação da tipografia
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token e o parâmetro Fiori correspondente. A galeria SHALL ter uma página "Tipografia" com uma amostra de cada estilo, com nome, tamanho, altura e peso, renderizada com a fonte empacotada.

#### Scenario: Página na galeria
- **WHEN** a página "Tipografia" é aberta
- **THEN** ela exibe uma amostra de cada um dos onze estilos, identificada pelo nome e pelas medidas
