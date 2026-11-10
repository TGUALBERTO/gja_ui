# gja/foundation/spacing Specification

## Purpose

Define os espaçamentos do GJA: escala primitiva em pixels lógicos, passos semânticos relativos, papéis de layout e o mapeamento de referência, consumidos pelos widgets sem valores literais. Segue o modelo de tokens de `gja/foundation/design-tokens`.

## Requirements

### Requirement: Escala primitiva de espaçamento
O fundamento SHALL fornecer uma escala primitiva de espaçamento em pixels lógicos, nomeada pelo valor (ex.: `space16`), com no mínimo os valores 0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48 e 64. Todo valor diferente de 2 MUST ser múltiplo de 4. A escala MUST ficar na biblioteca de primitivos, em ordem crescente.

#### Scenario: Grade de 4 pixels
- **WHEN** os valores da escala primitiva são percorridos
- **THEN** cada valor é 2 ou múltiplo de 4, e cada um é maior que o anterior

#### Scenario: Nome corresponde ao valor
- **WHEN** um primitivo da escala é lido pelo nome
- **THEN** o número do nome é igual ao valor em pixels lógicos

### Requirement: Passos semânticos de espaçamento
O conjunto semântico de espaçamento SHALL ter os passos `none`, `xxs`, `xs`, `s`, `m`, `l`, `xl`, `xxl` e `xxxl`. No mapeamento de referência, `none` MUST valer zero e os passos MUST ser não decrescentes nessa ordem. Todos os valores MUST ser finitos e não negativos, em qualquer mapeamento.

#### Scenario: Ordem dos passos
- **WHEN** o mapeamento de referência é inspecionado
- **THEN** `none` vale 0 e `none ≤ xxs ≤ xs ≤ s ≤ m ≤ l ≤ xl ≤ xxl ≤ xxxl`

#### Scenario: Valor negativo rejeitado
- **WHEN** um conjunto é derivado com `copyWith` usando um passo negativo
- **THEN** a criação falha em modo debug com mensagem que identifica o passo

### Requirement: Papéis de layout
O conjunto semântico de espaçamento SHALL ter os papéis `inlineGap` (entre elementos lado a lado), `stackGap` (entre itens empilhados de um grupo), `sectionGap` (entre seções) e `pageMargin` (borda do conteúdo da página na classe S), e as margens de página das classes M, L e XL. Na referência, cada papel e margem MUST ter o valor de um passo, com `inlineGap ≤ stackGap ≤ sectionGap` e margens não decrescentes de S a XL.

#### Scenario: Papéis apontam para passos
- **WHEN** os papéis de layout do mapeamento de referência são comparados com os passos
- **THEN** cada papel é igual a algum passo do mesmo conjunto

#### Scenario: Hierarquia dos papéis
- **WHEN** os papéis de layout do mapeamento de referência são comparados entre si
- **THEN** `inlineGap ≤ stackGap ≤ sectionGap`

#### Scenario: Margem de página por classe de tamanho
- **WHEN** a margem de página do mapeamento de referência é pedida para cada classe de tamanho
- **THEN** ela vale 16 em S, 32 em M, 32 em L e 48 em XL, como `sapUiResponsivePadding`, e a de S é `pageMargin`

### Requirement: Contrato do conjunto de espaçamento
O conjunto semântico de espaçamento MUST seguir o contrato dos conjuntos de tokens: imutável, construtor `const`, `copyWith`, `lerp` com interpolação contínua de cada valor, igualdade por valor e diagnóstico com o nome de cada passo e papel. O mapeamento de referência MUST derivar todos os valores da escala primitiva.

#### Scenario: Contrato verificado
- **GIVEN** o mapeamento de referência e um mapeamento com todos os valores dobrados
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação de um passo
- **GIVEN** `m` igual a 12 no conjunto A e 20 no conjunto B
- **WHEN** `A.lerp(B, 0.5)` é calculado
- **THEN** `m` vale 16

#### Scenario: Valores vêm dos primitivos
- **WHEN** cada valor do mapeamento de referência é comparado com a escala primitiva
- **THEN** todo valor é igual a algum primitivo

### Requirement: Uso sem literais nos widgets
Os widgets MUST expressar padding, margem e distância entre filhos somente com valores do conjunto semântico de espaçamento ou de tokens de componente derivados dele. A verificação de tokens MUST rejeitar números literais nessas posições e aceitar referências aos tokens.

#### Scenario: Widget usa espaçamento sem literal
- **GIVEN** um arquivo de widget que usa `EdgeInsets.all(spacing.m)` e `SizedBox(width: spacing.inlineGap)`
- **WHEN** a verificação de tokens é executada
- **THEN** nenhuma violação é reportada

#### Scenario: Widget com espaçamento literal
- **GIVEN** um arquivo de widget que usa `SizedBox(width: 8)`
- **WHEN** a verificação de tokens é executada
- **THEN** a verificação falha e indica o arquivo e a linha

### Requirement: Testes e documentação dos espaçamentos
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Espaçamentos" que mostra cada passo, cada papel de layout e a margem de página de cada classe de tamanho, com seu valor.

#### Scenario: Página na galeria
- **WHEN** a página "Espaçamentos" é aberta
- **THEN** ela exibe os nomes dos passos `xxs` a `xxxl`, dos papéis de layout e das margens de página de S a XL, cada um com seu valor em pixels lógicos

### Requirement: Classes de margem do Fiori
No mapeamento de referência, os passos `s`, `l`, `xxl` e `xxxl` MUST valer o mesmo que as classes de margem `sapUiTinyMargin` (0.5rem), `sapUiSmallMargin` (1rem), `sapUiMediumMargin` (2rem) e `sapUiLargeMargin` (3rem) do Fiori, e o dartdoc de cada um SHALL citar a classe correspondente.

#### Scenario: Passos e classes de margem
- **WHEN** os passos `s`, `l`, `xxl` e `xxxl` do mapeamento de referência são inspecionados
- **THEN** eles valem 8, 16, 32 e 48
