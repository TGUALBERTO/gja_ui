## MODIFIED Requirements

### Requirement: Estado semântico de valor
O fundamento SHALL definir o estado semântico de valor com exatamente os valores `none`, `success`, `warning`, `error` e `information`. O conjunto semântico de cor MUST associar a cada estado quatro papéis: `foreground` (texto e ícone), `background` (fundo suave), `hoverBackground` (fundo suave em hover, como `sapButton_Accept_Hover_Background`) e `border`. A consulta MUST ser exaustiva: todo estado retorna cores definidas.

#### Scenario: Cores de erro
- **GIVEN** o mapeamento claro de referência
- **WHEN** as cores do estado `error` são consultadas
- **THEN** são retornados `foreground`, `background`, `hoverBackground` e `border` definidos, diferentes das cores do estado `success`

#### Scenario: Estado sem destaque
- **WHEN** as cores do estado `none` são consultadas
- **THEN** elas vêm da escala neutra

#### Scenario: Hover distinto do fundo
- **WHEN** cada estado de valor é consultado nos mapeamentos claro e escuro
- **THEN** o `hoverBackground` é diferente do `background` do mesmo estado e vem da mesma escala primitiva

### Requirement: Contraste mínimo dos papéis
Nos mapeamentos claro e escuro, a razão de contraste WCAG 2.1 MUST ser ≥ 4,5:1 para cada par de texto listado no cenário "Pares de texto" e ≥ 3:1 para cada par não textual listado no cenário "Pares não textuais". `separator`, `shadow` e `blockLayer` são decorativos e isentos.

#### Scenario: Pares de texto
- **WHEN** a razão de contraste é calculada nos dois mapeamentos para `text` sobre `background`, `base`, `headerBackground`, `hoverBackground`, `selectionBackground` e `selectionHoverBackground`; `label` e `link` sobre `background`, `base` e `headerBackground`; `brand` sobre `background`, `base`, `hoverBackground`, `selectionBackground` e `selectionHoverBackground`; `contrastText` sobre `brand`, `brandHover` e `highlight`; e o `foreground` de cada estado de valor sobre `base`, `background`, o `background` do estado e o `hoverBackground` do estado
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
