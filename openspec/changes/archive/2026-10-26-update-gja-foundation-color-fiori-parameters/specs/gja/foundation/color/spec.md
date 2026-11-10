# Spec Delta

## MODIFIED Requirements

### Requirement: Papéis semânticos de cor
O conjunto semântico de cor SHALL ter os papéis no modelo de parâmetros de tema do Fiori, sem prefixo, listados no cenário "Papéis do modelo Fiori". Ele MUST NOT usar o vocabulário do Material Design (`surface`, `onSurface`, `primaryContainer`, `scrim`). Ele MUST seguir o contrato dos conjuntos de tokens: imutável, `copyWith`, `lerp`, igualdade por valor e diagnóstico.

#### Scenario: Papéis do modelo Fiori
- **WHEN** os papéis do conjunto semântico de cor são listados
- **THEN** eles são `background`, `base`, `headerBackground`, `shell`, `text`, `label`, `link`, `separator`, `fieldBorder`, `brand`, `brandHover`, `highlight`, `contrastText`, `hoverBackground`, `selectionBackground`, `selectionHoverBackground`, `focus`, `shadow` e `blockLayer`, além das cores dos estados de valor

#### Scenario: Contrato do conjunto
- **GIVEN** os mapeamentos claro e escuro de referência
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e conjuntos com os mesmos valores são iguais

#### Scenario: Interpolação de cor
- **GIVEN** `base` branca no conjunto A e preta no conjunto B
- **WHEN** `A.lerp(B, 0.5)` é calculado
- **THEN** `base` é o ponto médio de cada canal entre as duas cores

### Requirement: Mapeamentos claro e escuro de referência
O fundamento SHALL fornecer dois mapeamentos de referência, claro e escuro, que atribuem um primitivo a cada papel semântico, sem nenhum literal de cor fora da biblioteca de primitivos. No escuro, `background` e `base` MUST ter luminância menor que `text`. No claro, ocorre o inverso.

#### Scenario: Papéis vêm dos primitivos
- **WHEN** cada papel dos mapeamentos claro e escuro é comparado com as escalas primitivas
- **THEN** todo valor de papel é igual a algum primitivo, exceto `shadow` e `blockLayer`, que podem aplicar opacidade a um primitivo

#### Scenario: Polaridade do modo escuro
- **WHEN** o mapeamento escuro é inspecionado
- **THEN** `base` e `background` são mais escuros que `text`

### Requirement: Contraste mínimo dos papéis
Nos mapeamentos claro e escuro, a razão de contraste WCAG 2.1 MUST ser ≥ 4,5:1 para cada par de texto listado no cenário "Pares de texto" e ≥ 3:1 para cada par não textual listado no cenário "Pares não textuais". `separator`, `shadow` e `blockLayer` são decorativos e isentos.

#### Scenario: Pares de texto
- **WHEN** a razão de contraste é calculada nos dois mapeamentos para `text` sobre `background`, `base`, `headerBackground`, `hoverBackground`, `selectionBackground` e `selectionHoverBackground`; `label` e `link` sobre `background`, `base` e `headerBackground`; `brand` sobre `background`, `base`, `hoverBackground`, `selectionBackground` e `selectionHoverBackground`; `contrastText` sobre `brand`, `brandHover` e `highlight`; e o `foreground` de cada estado de valor sobre `base`, `background` e o `background` do estado
- **THEN** todas as razões são ≥ 4,5

#### Scenario: Pares não textuais
- **WHEN** a razão de contraste é calculada nos dois mapeamentos para `fieldBorder`, `focus` e `brand` sobre `background`, `base` e `headerBackground`, e para o `border` de cada estado de valor sobre `base` e `background`
- **THEN** todas as razões são ≥ 3

#### Scenario: Personalização que viola o contraste
- **GIVEN** um mapeamento personalizado em que `text` tem contraste 2:1 sobre `base`
- **WHEN** a verificação de contraste do fundamento é aplicada a ele
- **THEN** ela reporta o par `text`/`base` com a razão encontrada e o mínimo exigido

#### Scenario: Papéis isentos
- **WHEN** a verificação de contraste é aplicada a um mapeamento em que `separator` é igual a `base`
- **THEN** nenhum problema é reportado, porque `separator` é decorativo

### Requirement: Testes e documentação das cores
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível do token. A galeria SHALL ter uma página "Cores" com as amostras de cada papel e de cada estado de valor nos modos claro e escuro, mostrando a razão de contraste dos pares de texto.

#### Scenario: Página na galeria
- **WHEN** a página "Cores" é aberta
- **THEN** ela exibe os papéis `text`, `brand` e `error` nos dois modos, cada par de texto com sua razão de contraste

#### Scenario: Galeria sem cor fixa
- **WHEN** o código da galeria é inspecionado
- **THEN** a cor da aplicação vem do mapeamento de referência, e não de um literal
