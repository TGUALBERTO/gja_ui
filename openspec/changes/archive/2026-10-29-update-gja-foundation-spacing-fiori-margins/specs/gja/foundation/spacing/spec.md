## MODIFIED Requirements

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

### Requirement: Testes e documentação dos espaçamentos
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Espaçamentos" que mostra cada passo, cada papel de layout e a margem de página de cada classe de tamanho, com seu valor.

#### Scenario: Página na galeria
- **WHEN** a página "Espaçamentos" é aberta
- **THEN** ela exibe os nomes dos passos `xxs` a `xxxl`, dos papéis de layout e das margens de página de S a XL, cada um com seu valor em pixels lógicos

## ADDED Requirements

### Requirement: Classes de margem do Fiori
No mapeamento de referência, os passos `s`, `l`, `xxl` e `xxxl` MUST valer o mesmo que as classes de margem `sapUiTinyMargin` (0.5rem), `sapUiSmallMargin` (1rem), `sapUiMediumMargin` (2rem) e `sapUiLargeMargin` (3rem) do Fiori, e o dartdoc de cada um SHALL citar a classe correspondente.

#### Scenario: Passos e classes de margem
- **WHEN** os passos `s`, `l`, `xxl` e `xxxl` do mapeamento de referência são inspecionados
- **THEN** eles valem 8, 16, 32 e 48
