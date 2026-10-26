# Spec Delta

## Purpose

Define a elevação do Rebic: a geometria das sombras por nível, os papéis de elevação e a composição das sombras com a cor `shadow` de `rebic/foundation/color`, consumidas pelos widgets sem valores literais. Segue o modelo de tokens de `rebic/foundation/design-tokens`.

## ADDED Requirements

### Requirement: Escala primitiva de sombras
O fundamento SHALL fornecer, na biblioteca de primitivos, os níveis de sombra 0 a 4, cada um como lista de camadas sem cor (deslocamento vertical, desfoque, expansão e fator de opacidade entre 0 e 1). O nível 0 MUST não ter camadas. Do nível 1 ao 4, o maior desfoque e o maior deslocamento MUST ser estritamente crescentes.

#### Scenario: Profundidade crescente
- **WHEN** os níveis primitivos 0 a 4 são percorridos
- **THEN** o nível 0 não tem camadas, e o maior desfoque e o maior deslocamento crescem a cada nível seguinte

#### Scenario: Fatores de opacidade válidos
- **WHEN** as camadas de todos os níveis são inspecionadas
- **THEN** todo fator de opacidade está entre 0 e 1, e desfoque e expansão são não negativos

### Requirement: Níveis e papéis de elevação
O conjunto semântico de elevação SHALL ter os níveis `level0` a `level4` e os papéis `card` (cartões e contêineres elevados), `popover` (menus, listas suspensas e popovers) e `dialog` (diálogos e painéis modais). No mapeamento de referência, cada nível MUST ser igual ao primitivo correspondente, cada papel MUST ser igual a um nível e `card` < `popover` < `dialog` em profundidade.

#### Scenario: Papéis do mapeamento de referência
- **WHEN** os papéis do mapeamento de referência são inspecionados
- **THEN** `card` é `level1`, `popover` é `level2` e `dialog` é `level3`

### Requirement: Sombras com a cor do tema
O conjunto semântico SHALL converter um nível ou papel em sombras de caixa usando uma cor de sombra recebida, normalmente o papel `shadow` do tema ativo. Cada sombra MUST ter a geometria da camada e a cor recebida com a opacidade multiplicada pelo fator da camada. Nenhuma cor MUST vir do próprio fundamento de elevação.

#### Scenario: Sombra com a cor do modo
- **GIVEN** a cor `shadow` do mapeamento claro e a do escuro
- **WHEN** as sombras do papel `card` são geradas com cada uma
- **THEN** a geometria é a mesma nos dois casos, e só a opacidade das cores muda, na proporção dos fatores das camadas

#### Scenario: Nível sem sombra
- **WHEN** as sombras de `level0` são geradas com qualquer cor
- **THEN** a lista resultante é vazia

### Requirement: Uso de elevação sem literais nos widgets
Os widgets MUST obter sombras somente do conjunto semântico de elevação combinado com a cor `shadow` do tema. A verificação de tokens MUST rejeitar números literais de desfoque, expansão e elevação, e aceitar sombras geradas pelos tokens.

#### Scenario: Widget usa sombra dos tokens
- **GIVEN** um arquivo de widget com `boxShadow: elevation.shadowsFor(elevation.card, colors.shadow)`
- **WHEN** a verificação de tokens é executada
- **THEN** nenhuma violação é reportada

#### Scenario: Widget com sombra literal
- **GIVEN** um arquivo de widget com `BoxShadow(blurRadius: 8)`
- **WHEN** a verificação de tokens é executada
- **THEN** a verificação falha e indica o arquivo e a linha

### Requirement: Contrato do conjunto de elevação
O conjunto semântico de elevação MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp`, igualdade por valor e diagnóstico com o nome de cada nível e papel. Na interpolação, as camadas SHALL ser interpoladas uma a uma, e uma camada que falta em um dos lados é tratada como camada sem deslocamento, desfoque, expansão nem opacidade.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com `card` igual a `level2`
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação a partir de nível sem sombra
- **WHEN** `level0` é interpolado até `level2` em `t = 0.5`
- **THEN** o resultado tem as camadas de `level2`, com deslocamento, desfoque, expansão e opacidade pela metade

### Requirement: Testes e documentação da elevação
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Elevação" com uma superfície por nível e por papel, nos modos claro e escuro.

#### Scenario: Página na galeria
- **WHEN** a página "Elevação" é aberta
- **THEN** ela exibe `level0` a `level4` e os papéis `card`, `popover` e `dialog` nos dois modos, cada superfície com as sombras do respectivo nível
