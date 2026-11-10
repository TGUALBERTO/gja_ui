## MODIFIED Requirements

### Requirement: Famílias de controle
O fundamento SHALL definir as famílias de controle `standard`, `emphasized`, `transparent`, `accept`, `reject`, `attention` e `list`, no modelo dos tipos de botão e dos itens de lista do Fiori. Cada família MUST ter fundo, borda e texto explícitos para os estados normal, hover, ativo, selecionado e selecionado com hover. Essas cores MUST ser derivadas dos papéis de `gja/foundation/color`, para que uma troca de marca alcance todas as famílias.

#### Scenario: Família standard
- **WHEN** as cores da família `standard` são derivadas de um mapeamento de cor
- **THEN** normal = (`base`, `fieldBorder`, `brand`), hover = (`hoverBackground`, `fieldBorder`, `brand`), ativo = (`highlight`, `highlight`, `contrastText`), selecionado = (`selectionBackground`, `brand`, `brand`) e selecionado com hover = (`selectionHoverBackground`, `brand`, `brand`), na ordem fundo, borda e texto

#### Scenario: Família emphasized
- **WHEN** as cores da família `emphasized` são derivadas
- **THEN** normal = (`brand`, `brand`, `contrastText`), hover = (`brandHover`, `brandHover`, `contrastText`), e ativo, selecionado e selecionado com hover = (`highlight`, `highlight`, `contrastText`)

#### Scenario: Famílias transparent e list
- **WHEN** as cores das famílias `transparent` e `list` são derivadas
- **THEN** ambas têm borda transparente; `transparent` tem fundo transparente no normal e texto `brand`; `list` tem fundo `base` no normal e texto `text`; nas duas, hover usa `hoverBackground`, ativo usa `highlight` com `contrastText`, selecionado usa `selectionBackground` e selecionado com hover usa `selectionHoverBackground`

#### Scenario: Marca alcança as famílias
- **GIVEN** um mapeamento de cor com `brand` trocado
- **WHEN** as cores da família `standard` são derivadas dele
- **THEN** o texto normal e a borda do selecionado são o novo `brand`

#### Scenario: Famílias accept, reject e attention
- **WHEN** as cores das famílias `accept`, `reject` e `attention` são derivadas
- **THEN** cada uma usa as cores do estado de valor `success`, `error` e `warning`, respectivamente: normal = (fundo, borda e frente do estado), hover = (`hoverBackground`, borda do estado, frente do estado), e ativo, selecionado e selecionado com hover = (`highlight`, `highlight`, `contrastText`)
