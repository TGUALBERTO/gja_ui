## MODIFIED Requirements

### Requirement: Tokens de movimento
O fundamento SHALL fornecer primitivos de duração e de curva de animação e um conjunto semântico de movimento com, no mínimo, os papéis de duração `instant`, `short`, `medium` e `long` e os papéis de curva `standard`, `enter` e `exit`. As durações semânticas MUST ser não decrescentes nessa ordem, e `instant` MUST valer zero. As curvas MUST ser as curvas CSS usadas pelo SAPUI5, e não as do Material.

#### Scenario: Ordem das durações
- **WHEN** o conjunto semântico de movimento padrão é inspecionado
- **THEN** `instant` ≤ `short` ≤ `medium` ≤ `long`, e `instant` vale zero

#### Scenario: Curvas CSS
- **WHEN** as curvas do conjunto semântico de movimento padrão são inspecionadas
- **THEN** `standard` é `ease-in-out` (0.42, 0, 0.58, 1), `enter` é `ease-out` (0, 0, 0.58, 1) e `exit` é `ease-in` (0.42, 0, 1, 1)

#### Scenario: Sem curvas do Material
- **WHEN** as curvas primitivas são listadas
- **THEN** nenhuma é (0.4, 0, 0.2, 1), (0, 0, 0.2, 1) ou (0.4, 0, 1, 1), e os nomes seguem as curvas CSS (`curveEaseInOut`, `curveEaseOut`, `curveEaseIn`)

#### Scenario: Widget anima sem literal
- **GIVEN** um widget que anima uma transição
- **WHEN** a verificação de tokens é executada no código do widget
- **THEN** a duração e a curva vêm do conjunto semântico de movimento, e nenhum literal de `Duration` é reportado
