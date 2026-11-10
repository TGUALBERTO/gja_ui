# rebic/foundation/iconography Specification

## Purpose

Define os ícones do Rebic: a fonte de ícones empacotada e licenciada, o catálogo semântico de ícones, o espelhamento de ícones direcionais e as escalas e papéis de tamanho, sem dependência de Material. Segue o modelo de tokens de `rebic/foundation/design-tokens`.

## Requirements

### Requirement: Fonte de ícones empacotada e licenciada
O fundamento SHALL empacotar uma fonte de ícones de licença aberta, sem ícones da SAP, junto com o texto integral da licença e o mapa oficial de nomes para códigos da versão empacotada. Aplicações que dependem do framework MUST conseguir usar os ícones sem declarar a fonte no próprio `pubspec.yaml`.

#### Scenario: Fonte disponível na aplicação consumidora
- **GIVEN** uma aplicação que depende de `gja_ui` e não declara fontes
- **WHEN** a fonte de ícones é carregada pelo bundle de assets da aplicação
- **THEN** o arquivo é encontrado e carregado sem erro

#### Scenario: Licença e mapa distribuídos
- **WHEN** o pacote do fundamento é inspecionado
- **THEN** a fonte, o texto da licença e o mapa de códigos estão na mesma pasta, e a fonte está declarada no pacote

### Requirement: Catálogo semântico de ícones
O fundamento SHALL fornecer um catálogo de ícones constantes com os nomes do IconPool do SAPUI5 (`sap-icon://<nome>`) em camelCase, com no mínimo os nomes do cenário "Catálogo completo e sem repetição". Cada ícone MUST apontar para a fonte empacotada e para um código existente no mapa oficial. Os desenhos são da fonte empacotada, sem assets da SAP.

#### Scenario: Códigos conferem com o mapa oficial
- **WHEN** cada ícone do catálogo é comparado com o mapa de códigos empacotado
- **THEN** a família e o pacote são os da fonte empacotada, e o código é igual ao do nome de origem correspondente no mapa

#### Scenario: Catálogo completo e sem repetição
- **WHEN** o catálogo é inspecionado
- **THEN** ele contém no mínimo `add`, `decline`, `search`, `accept`, `slimArrowUp`, `slimArrowDown`, `slimArrowLeft`, `slimArrowRight`, `navBack`, `navigationRightArrow`, `menu2`, `overflow`, `edit`, `delete`, `information`, `warning`, `error`, `sysEnter2`, `sysHelp`, `calendar`, `pending`, `personPlaceholder`, `filter`, `sort`, `upload`, `download`, `refresh`, `actionSettings`, `home`, `popupWindow`, `show`, `hide`, `copy`, `log`, `bell`, `document` e `folderBlank`, e dois nomes diferentes não apontam para o mesmo código

#### Scenario: Nomes do IconPool
- **WHEN** o nome do IconPool de cada ícone do catálogo é consultado
- **THEN** o nome do catálogo é o nome do IconPool sem hífens, com a letra seguinte maiúscula (ex.: `slim-arrow-down` → `slimArrowDown`, `sys-enter-2` → `sysEnter2`, `menu2` → `menu2`), e nenhum nome do catálogo é `close`, `check`, `chevronDown`, `user` ou outro nome anterior sem equivalente no IconPool

### Requirement: Espelhamento de ícones direcionais
Os ícones que indicam direção horizontal (`slimArrowLeft`, `slimArrowRight`, `navBack`, `navigationRightArrow`, `log` e `popupWindow`) MUST ser espelhados quando o texto é da direita para a esquerda. Os demais ícones MUST NOT ser espelhados.

#### Scenario: Ícone direcional em RTL
- **GIVEN** `slimArrowRight` renderizado com direção de texto da direita para a esquerda
- **WHEN** o ícone é desenhado
- **THEN** ele aparece espelhado horizontalmente, e `accept` no mesmo contexto não é espelhado

### Requirement: Uso de ícones fora do catálogo
O fundamento SHALL expor, na biblioteca de primitivos, a família e o pacote da fonte, para que uma aplicação possa declarar como constante qualquer outro ícone da fonte empacotada, pelo código do mapa oficial.

#### Scenario: Ícone extra da aplicação
- **GIVEN** uma aplicação que cria um ícone constante com o código de `anchor` do mapa oficial e a família e o pacote dos primitivos
- **WHEN** o ícone é comparado com um ícone do catálogo
- **THEN** ele usa a mesma família e o mesmo pacote

### Requirement: Escala primitiva de tamanhos de ícone
O fundamento SHALL fornecer, na biblioteca de primitivos, uma escala de tamanhos de ícone em pixels lógicos nomeada pelo valor (ex.: `size20`), com no mínimo 12, 16, 20, 24, 32, 40 e 48, em ordem crescente.

#### Scenario: Escala em ordem
- **WHEN** a escala primitiva de tamanhos de ícone é percorrida
- **THEN** cada valor é maior que o anterior, e o número do nome é igual ao valor

### Requirement: Passos e papéis de tamanho de ícone
O conjunto semântico SHALL ter os passos `small`, `medium`, `large` e `xLarge` e os papéis `inline` (junto ao texto corrido) e `control` (dentro de botões e campos, como `sapContent_IconHeight`). Na referência, os passos MUST ser estritamente crescentes, cada papel MUST ter o valor de um passo, `control` MUST valer 16 (1rem) e todos os valores MUST vir da escala primitiva, finitos e positivos.

#### Scenario: Mapeamento de referência
- **WHEN** o mapeamento de referência é inspecionado
- **THEN** `small < medium < large < xLarge`, `inline` e `control` são iguais a algum passo, `control` vale 16, e cada valor existe na escala primitiva

#### Scenario: Tamanho inválido rejeitado
- **WHEN** um conjunto é derivado com `copyWith` usando um tamanho zero ou negativo
- **THEN** a criação falha em modo debug com mensagem que identifica o campo

### Requirement: Contrato do conjunto de tamanhos de ícone
O conjunto semântico de tamanhos de ícone MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp` com interpolação contínua, igualdade por valor e diagnóstico com o nome de cada passo e papel.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com todos os tamanhos aumentados em 4
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

### Requirement: Testes e documentação dos ícones
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Ícones" com todos os ícones do catálogo, cada um com seu nome semântico, renderizados com a fonte empacotada.

#### Scenario: Página na galeria
- **WHEN** a página "Ícones" é aberta
- **THEN** ela exibe um ícone para cada nome do catálogo, identificado pelo nome semântico
