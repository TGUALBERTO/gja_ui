## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
`RebicText` SHALL obter o estilo da tipografia do tema: `display` → `header1`, `headline` → `header2`, `title` → `header3`, `subtitle` → `header4`, `body` → `base`, `bodyStrong` → `baseSemibold`, `label` → `base` e `caption` → `small`. A cor SHALL ser `colors.text` (`standard`), `colors.label` (`muted`) ou o `foreground` do estado de valor do `tone`, todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `RebicText` com `tone` `error` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o texto usa o `foreground` do estado `error` do tema escuro, sem ser recriado com outros parâmetros

#### Scenario: Variantes e tons
- **WHEN** cada combinação de `variant` e `tone` é renderizada no tema claro
- **THEN** o estilo tem o tamanho, a altura de linha e o peso do estilo Fiori mapeado para a `variant`, e a cor do papel do `tone`
