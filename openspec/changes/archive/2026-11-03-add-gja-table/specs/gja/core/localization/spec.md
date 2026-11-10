# Spec Delta

## MODIFIED Requirements

### Requirement: Textos do framework
O núcleo SHALL fornecer um conjunto tipado de textos do framework: `ok`, `cancel`, `close`, `search`, `clear`, `noData`, `loading`, `more`, `required`, `navigation`, `back`, `menu`, `logo`, `notifications`, `profile`, `products`, `shellBar`, `selectAll`, `selectItem`, o texto de cada estado de valor e a contagem de itens selecionados. O texto do estado `none` MUST ser vazio. A contagem MUST tratar zero, um e vários, com o número formatado no idioma. Os widgets MUST NOT fixar esses textos.

#### Scenario: Textos em pt-BR
- **GIVEN** os textos do idioma pt-BR
- **WHEN** `cancel`, `noData` e o texto do estado `error` são lidos
- **THEN** eles são "Cancelar", "Sem dados" e "Valor inválido"

#### Scenario: Textos em en
- **GIVEN** os textos do idioma en
- **WHEN** `cancel`, `noData` e o texto do estado `error` são lidos
- **THEN** eles são "Cancel", "No data" e "Invalid value"

#### Scenario: Contagem de selecionados
- **WHEN** a contagem é pedida para 0, 1 e 1000 em pt-BR e em en
- **THEN** pt-BR retorna "Nenhum item selecionado", "1 item selecionado" e "1.000 itens selecionados", e en retorna "No items selected", "1 item selected" e "1,000 items selected"

#### Scenario: Estado sem texto
- **WHEN** o texto do estado `none` é lido em qualquer idioma fornecido
- **THEN** ele é vazio, e os de `success`, `warning`, `error` e `information` não são vazios

#### Scenario: Texto da navegação
- **WHEN** `navigation` é lido em pt-BR e em en
- **THEN** ele é "Navegação" e "Navigation", respectivamente

#### Scenario: Texto de voltar
- **WHEN** `back` é lido em pt-BR e em en
- **THEN** ele é "Voltar" e "Back", respectivamente

#### Scenario: Textos da barra
- **WHEN** `menu`, `logo`, `notifications`, `profile`, `products` e `shellBar` são lidos em pt-BR e em en
- **THEN** em pt-BR eles são "Menu", "Logotipo", "Notificações", "Perfil", "Meus produtos" e "Barra de shell", e em en "Menu", "Logo", "Notifications", "Profile", "My products" e "Shell Bar", como os textos do `sap.f.ShellBar`

#### Scenario: Textos da tabela
- **WHEN** `selectAll` e `selectItem` são lidos em pt-BR e em en
- **THEN** em pt-BR eles são "Selecionar tudo" e "Selecionar item", e em en "Select All" e "Select Item"
