## MODIFIED Requirements

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
- **THEN** ele é o nome do ícone em kebab-case (ex.: `slimArrowDown` → `slim-arrow-down`, `sysEnter2` → `sys-enter-2`), e nenhum nome do catálogo é `close`, `check`, `chevronDown`, `user` ou outro nome anterior sem equivalente no IconPool

### Requirement: Espelhamento de ícones direcionais
Os ícones que indicam direção horizontal (`slimArrowLeft`, `slimArrowRight`, `navBack`, `navigationRightArrow`, `log` e `popupWindow`) MUST ser espelhados quando o texto é da direita para a esquerda. Os demais ícones MUST NOT ser espelhados.

#### Scenario: Ícone direcional em RTL
- **GIVEN** `slimArrowRight` renderizado com direção de texto da direita para a esquerda
- **WHEN** o ícone é desenhado
- **THEN** ele aparece espelhado horizontalmente, e `accept` no mesmo contexto não é espelhado

### Requirement: Passos e papéis de tamanho de ícone
O conjunto semântico SHALL ter os passos `small`, `medium`, `large` e `xLarge` e os papéis `inline` (junto ao texto corrido) e `control` (dentro de botões e campos, como `sapContent_IconHeight`). Na referência, os passos MUST ser estritamente crescentes, cada papel MUST ter o valor de um passo, `control` MUST valer 16 (1rem) e todos os valores MUST vir da escala primitiva, finitos e positivos.

#### Scenario: Mapeamento de referência
- **WHEN** o mapeamento de referência é inspecionado
- **THEN** `small < medium < large < xLarge`, `inline` e `control` são iguais a algum passo, `control` vale 16, e cada valor existe na escala primitiva

#### Scenario: Tamanho inválido rejeitado
- **WHEN** um conjunto é derivado com `copyWith` usando um tamanho zero ou negativo
- **THEN** a criação falha em modo debug com mensagem que identifica o campo
