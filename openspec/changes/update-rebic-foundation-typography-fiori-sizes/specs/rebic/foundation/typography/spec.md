## MODIFIED Requirements

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
