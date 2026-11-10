## MODIFIED Requirements

### Requirement: Escala primitiva de larguras
O fundamento SHALL fornecer, na biblioteca de primitivos, a escala de larguras dos limites de faixa do SAPUI5 (`sap.ui.Device.media`, conjunto `SAP_STANDARD_EXTENDED`), em pixels lógicos e nomeada pelo valor (ex.: `width1024`): exatamente 600, 1024 e 1440, em ordem crescente. Ela MUST NOT conter larguras de outros sistemas, como 360, 840, 1280 ou 1920.

#### Scenario: Escala em ordem
- **WHEN** a escala primitiva de larguras é percorrida
- **THEN** cada valor é maior que o anterior, e o número do nome é igual ao valor

#### Scenario: Faixas do SAPUI5
- **WHEN** os valores da escala primitiva são listados
- **THEN** eles são exatamente 600, 1024 e 1440

### Requirement: Classes de tamanho
O fundamento SHALL definir as classes de tamanho `small`, `medium`, `large` e `extraLarge`, nessa ordem, correspondentes às faixas S, M, L e XL do SAPUI5 (Phone, Tablet, Desktop e LargeDesktop), com comparação de ordem entre classes (`isAtLeast` e `isAtMost`).

#### Scenario: Comparação de classes
- **WHEN** `large.isAtLeast(medium)` e `small.isAtLeast(medium)` são avaliados
- **THEN** o primeiro é verdadeiro e o segundo é falso, e toda classe é `isAtLeast` e `isAtMost` dela mesma
