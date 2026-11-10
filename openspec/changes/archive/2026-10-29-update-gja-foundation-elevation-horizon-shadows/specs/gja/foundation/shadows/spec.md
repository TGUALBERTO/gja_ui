## Purpose

Define as sombras do GJA no modelo dos parâmetros `sapContent_Shadow0`…`3` e `sapContent_HeaderShadow` do Fiori: a geometria de cada sombra, os papéis de sombra por tipo de superfície e a composição com a cor `shadow` de `gja/foundation/color`, consumidas pelos widgets sem valores literais. Segue o modelo de tokens de `gja/foundation/design-tokens`.

## ADDED Requirements

### Requirement: Escala primitiva de sombras
O fundamento SHALL fornecer, na biblioteca de primitivos, as sombras `none`, `shadow0` a `shadow3` e `header`, cada uma como lista de camadas sem cor (deslocamento vertical, desfoque, expansão e fator de opacidade entre 0 e 1). `none` MUST não ter camadas. De `shadow0` a `shadow3`, o maior desfoque MUST ser estritamente crescente e o maior deslocamento MUST ser não decrescente. `header` MUST ter ao menos uma camada com deslocamento para baixo.

#### Scenario: Profundidade crescente
- **WHEN** as sombras primitivas `none` e `shadow0` a `shadow3` são percorridas
- **THEN** `none` não tem camadas, o maior desfoque cresce estritamente de `shadow0` a `shadow3`, e o maior deslocamento nunca diminui

#### Scenario: Fatores de opacidade válidos
- **WHEN** as camadas de todas as sombras primitivas, incluindo `header`, são inspecionadas
- **THEN** todo fator de opacidade está entre 0 e 1, desfoque e expansão são não negativos, e `header` tem deslocamento positivo

### Requirement: Geometria no modelo Horizon
As sombras `shadow1` a `shadow3` MUST ter um contorno (camada sem deslocamento nem desfoque, com expansão de 1 px) e uma camada difusa, como os parâmetros `sapContent_Shadow1`…`3` do Horizon. `shadow0` MUST NOT ter contorno. Nenhuma sombra MUST ter o par de camadas "contato" e "ambiente" do modelo de elevação do Material.

#### Scenario: Contorno nas sombras de sobreposição
- **WHEN** as camadas de `shadow1`, `shadow2` e `shadow3` são inspecionadas
- **THEN** cada uma tem exatamente uma camada com deslocamento 0, desfoque 0 e expansão 1, e uma camada com desfoque maior que 0

#### Scenario: Cartão sem contorno
- **WHEN** as camadas de `shadow0` são inspecionadas
- **THEN** nenhuma tem expansão maior que 0

### Requirement: Sombras e papéis
O conjunto semântico de sombras SHALL ter as sombras `none` e `shadow0` a `shadow3` e os papéis `card` (cartões e blocos), `popover` (popovers, menus, listas suspensas e dicas), `dialog` (diálogos e painéis modais), `dragged` (item arrastado) e `header` (cabeçalhos e barras fixas). Na referência, cada sombra MUST ser igual ao primitivo de mesmo nome, e `card` < `popover` < `dialog` ≤ `dragged` em profundidade.

#### Scenario: Papéis do mapeamento de referência
- **WHEN** os papéis do mapeamento de referência são inspecionados
- **THEN** `card` é `shadow0`, `popover` é `shadow2`, `dialog` é `shadow3`, `dragged` é `shadow3` e `header` é o primitivo `header`

#### Scenario: Sem vocabulário do Material
- **WHEN** os nomes públicos do fundamento são listados
- **THEN** nenhum deles contém `elevation`

### Requirement: Sombras com a cor do tema
O conjunto semântico SHALL converter uma sombra ou papel em sombras de caixa usando uma cor de sombra recebida, normalmente o papel `shadow` do tema ativo. Cada sombra de caixa MUST ter a geometria da camada e a cor recebida com a opacidade multiplicada pelo fator da camada. Nenhuma cor MUST vir do próprio fundamento de sombras.

#### Scenario: Sombra com a cor do modo
- **GIVEN** a cor `shadow` do mapeamento claro e a do escuro
- **WHEN** as sombras de caixa do papel `card` são geradas com cada uma
- **THEN** a geometria é a mesma nos dois casos, e só a opacidade das cores muda, na proporção dos fatores das camadas

#### Scenario: Sombra vazia
- **WHEN** as sombras de caixa de `none` são geradas com qualquer cor
- **THEN** a lista resultante é vazia

### Requirement: Uso de sombras sem literais nos widgets
Os widgets MUST obter sombras somente do conjunto semântico de sombras combinado com a cor `shadow` do tema. A verificação de tokens MUST rejeitar números literais de desfoque, expansão e elevação, e aceitar sombras geradas pelos tokens.

#### Scenario: Widget usa sombra dos tokens
- **GIVEN** um arquivo de widget com `boxShadow: shadows.boxShadows(shadows.card, colors.shadow)`
- **WHEN** a verificação de tokens é executada
- **THEN** nenhuma violação é reportada

#### Scenario: Widget com sombra literal
- **GIVEN** um arquivo de widget com `BoxShadow(blurRadius: 8)`
- **WHEN** a verificação de tokens é executada
- **THEN** a verificação falha e indica o arquivo e a linha

### Requirement: Contrato do conjunto de sombras
O conjunto semântico de sombras MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp`, igualdade por valor e diagnóstico com o nome de cada sombra e papel. Na interpolação, as camadas SHALL ser interpoladas uma a uma, e uma camada que falta em um dos lados é tratada como camada sem deslocamento, desfoque, expansão nem opacidade.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com `card` igual a `shadow1`
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação a partir de sombra vazia
- **WHEN** `none` é interpolado até `shadow1` em `t = 0.5`
- **THEN** o resultado tem as camadas de `shadow1`, com deslocamento, desfoque, expansão e opacidade pela metade

### Requirement: Testes e documentação das sombras
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token e o parâmetro Fiori correspondente. A galeria SHALL ter uma página "Sombras" com uma superfície por sombra e por papel, nos modos claro e escuro.

#### Scenario: Página na galeria
- **WHEN** a página "Sombras" é aberta
- **THEN** ela exibe `none`, `shadow0` a `shadow3` e os papéis `card`, `popover`, `dialog`, `dragged` e `header` nos dois modos, cada superfície com as sombras correspondentes
