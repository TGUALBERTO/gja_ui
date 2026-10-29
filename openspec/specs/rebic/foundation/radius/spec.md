# rebic/foundation/radius Specification

## Purpose

Define os raios de borda do Rebic: escala primitiva em pixels lógicos, passos e papéis semânticos, o formato de pílula e o mapeamento de referência, consumidos pelos widgets sem valores literais. Segue o modelo de tokens de `rebic/foundation/design-tokens`.

## Requirements

### Requirement: Escala primitiva de raios
O fundamento SHALL fornecer, na biblioteca de primitivos, uma escala de raios em pixels lógicos nomeada pelo valor (ex.: `radius4`), com no mínimo 0, 2, 4, 6, 8, 12 e 16, em ordem crescente, e um primitivo `radiusFull` para o formato de pílula.

#### Scenario: Escala em ordem
- **WHEN** a escala primitiva de raios é percorrida
- **THEN** cada valor é maior que o anterior, e o número do nome é igual ao valor

### Requirement: Formato de pílula
O primitivo `radiusFull` e o passo `full` MUST produzir cantos completamente arredondados em qualquer componente do framework. Para isso, o valor MUST ser finito e maior ou igual a metade da maior dimensão prevista para um componente (4096 px lógicos).

#### Scenario: Pílula em um controle
- **GIVEN** uma caixa de 120 × 32 px com raio `full`
- **WHEN** ela é desenhada
- **THEN** as extremidades são semicírculos de raio 16, a metade da altura

#### Scenario: Valor finito
- **WHEN** o valor de `full` é inspecionado
- **THEN** ele é finito e ≥ 2048

### Requirement: Passos e papéis semânticos de raio
O conjunto semântico de raio SHALL ter os passos `none`, `xs`, `s`, `m`, `l`, `xl` e `full` e os papéis por tipo de controle do Fiori: `button`, `field`, `popover`, `element` (diálogos e painéis) e `tile` (cartões e blocos). Na referência, `none` MUST valer zero, os passos MUST ser não decrescentes e cada papel MUST ter o valor de um passo. Todos os valores MUST ser finitos e não negativos.

#### Scenario: Ordem dos passos
- **WHEN** o mapeamento de referência é inspecionado
- **THEN** `none` vale 0 e `none ≤ xs ≤ s ≤ m ≤ l ≤ xl ≤ full`

#### Scenario: Papéis apontam para passos
- **WHEN** os papéis do mapeamento de referência são comparados com os passos
- **THEN** `button`, `field`, `popover`, `element` e `tile` são iguais a algum passo

#### Scenario: Valor negativo rejeitado
- **WHEN** um conjunto é derivado com `copyWith` usando um raio negativo
- **THEN** a criação falha em modo debug com mensagem que identifica o campo

#### Scenario: Papéis do Fiori
- **WHEN** os papéis do mapeamento de referência são inspecionados
- **THEN** `button` vale 8 (`sapButton_BorderCornerRadius`), `field` 4 (`sapField_BorderCornerRadius`), `popover` 8 (`sapPopover_BorderCornerRadius`), `element` 12 (`sapElement_BorderCornerRadius`) e `tile` 16 (`sapTile_BorderCornerRadius`), e não há papéis `control` nem `container`

### Requirement: Contrato do conjunto de raios
O conjunto semântico de raio MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp` com interpolação contínua de cada valor, igualdade por valor e diagnóstico com o nome de cada passo e papel. O mapeamento de referência MUST derivar todos os valores da escala primitiva.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com os passos finitos dobrados
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação de um papel
- **GIVEN** `button` igual a 4 no conjunto A e 8 no conjunto B
- **WHEN** `A.lerp(B, 0.5)` é calculado
- **THEN** `button` vale 6

#### Scenario: Valores vêm dos primitivos
- **WHEN** cada valor do mapeamento de referência é comparado com a escala primitiva
- **THEN** todo valor é igual a algum primitivo, incluindo `radiusFull`

### Requirement: Uso de raios sem literais nos widgets
Os widgets MUST expressar raios de borda somente com valores do conjunto semântico de raio ou de tokens de componente derivados dele. A verificação de tokens MUST rejeitar números literais em `BorderRadius` e `Radius` e aceitar referências aos tokens.

#### Scenario: Widget usa raio sem literal
- **GIVEN** um arquivo de widget que usa `BorderRadius.circular(radius.button)`
- **WHEN** a verificação de tokens é executada
- **THEN** nenhuma violação é reportada

#### Scenario: Widget com raio literal
- **GIVEN** um arquivo de widget que usa `BorderRadius.circular(6)`
- **WHEN** a verificação de tokens é executada
- **THEN** a verificação falha e indica o arquivo e a linha

### Requirement: Testes e documentação dos raios
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token e, nos papéis, o parâmetro Fiori correspondente. A galeria SHALL ter uma página "Raios" com uma amostra de cada passo e papel, com nome e valor.

#### Scenario: Página na galeria
- **WHEN** a página "Raios" é aberta
- **THEN** ela exibe uma amostra para `none`, `xs`, `s`, `m`, `l`, `xl`, `full`, `button`, `field`, `popover`, `element` e `tile`, cada uma com seu valor
