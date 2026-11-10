# gja/core/localization Specification

## Purpose

Define a localização do núcleo do GJA: os textos que os widgets do framework exibem e anunciam, os idiomas fornecidos e a resolução de idioma, o ponto de extensão para outros idiomas e a formatação de números e datas por idioma, com os mecanismos nativos de `Localizations` do Flutter.

## Requirements


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

### Requirement: Idiomas e resolução
O núcleo SHALL fornecer pt-BR e en, com pt-BR como padrão, e expor o delegate e a lista de idiomas para o `WidgetsApp`. A resolução MUST usar o mecanismo nativo do Flutter: o idioma exato, senão o mesmo código de língua, senão o padrão. O delegate MUST aceitar qualquer região de `pt` e de `en`.

#### Scenario: Região sem tradução própria
- **GIVEN** um `WidgetsApp` com o delegate e a lista de idiomas do núcleo
- **WHEN** o idioma do dispositivo é pt-PT, en-GB ou fr-FR
- **THEN** os textos são os de pt-BR, en e pt-BR, respectivamente

### Requirement: Acesso sem delegate
Os textos SHALL ser obtidos por `of(context)`. Quando o delegate não está registrado na árvore, `of(context)` MUST retornar os textos e formatos de pt-BR, para que os widgets funcionem em qualquer `WidgetsApp`.

#### Scenario: Árvore sem o delegate
- **GIVEN** um `WidgetsApp` sem o delegate do núcleo
- **WHEN** um widget lê `of(context).cancel`
- **THEN** o texto é "Cancelar"

### Requirement: Extensão por idioma da aplicação
A aplicação SHALL poder fornecer outro idioma, ou trocar textos de um idioma fornecido, com uma subclasse dos textos e um delegate próprio registrado antes do delegate do núcleo. A formatação de números e datas da subclasse MUST seguir o idioma dela sem código adicional.

#### Scenario: Idioma da aplicação
- **GIVEN** uma subclasse para `es` com `cancel` igual a "Cancelar" e o delegate dela registrado
- **WHEN** o idioma do dispositivo é es-ES e um decimal 1234,5 é formatado com uma casa
- **THEN** `of(context)` retorna a subclasse, e o número sai no formato do espanhol, com vírgula decimal

### Requirement: Formatação de números e datas
Os textos SHALL formatar, no idioma deles, decimal (com o número de casas pedido, 2 por padrão), inteiro (com agrupamento), data curta, hora e data com hora. Os formatos MUST vir dos dados de idioma do CLDR, e não de padrões fixos no código.

#### Scenario: Números
- **WHEN** 1234567.891 é formatado como decimal com 2 casas e 1234567 como inteiro
- **THEN** pt-BR retorna "1.234.567,89" e "1.234.567", e en retorna "1,234,567.89" e "1,234,567"

#### Scenario: Datas e horas
- **GIVEN** a data e hora 5 de março de 2026, 14:30
- **WHEN** ela é formatada como data e como hora
- **THEN** pt-BR retorna "05/03/2026" e "14:30", e en retorna "3/5/2026" e "2:30 PM", com o espaço antes de "PM" definido pelo CLDR

### Requirement: Testes e documentação da localização
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública MUST ter dartdoc. A galeria SHALL registrar o delegate e ter uma página "Localização" que alterna entre pt-BR e en, com os textos do framework, os textos de estado de valor, as contagens e os formatos.

#### Scenario: Página na galeria
- **WHEN** a página "Localização" é aberta e o idioma é trocado de pt-BR para en
- **THEN** os textos e os formatos exibidos passam de "Cancelar" e "1.234.567,89" para "Cancel" e "1,234,567.89"
### Requirement: Datas do calendário
Os textos SHALL ler uma data curta no formato do idioma (`parseDate`, nula se inválida) e fornecer o padrão desse formato (`datePattern`), o mês com o ano (`formatMonthYear`), a data por extenso com o dia da semana (`formatLongDate`), o primeiro dia da semana (`firstDayOfWeek`, como `DateTime.weekday`), os nomes curtos dos dias a partir dele (`shortWeekdays`) e os textos `previous` e `next`, tudo do CLDR.

#### Scenario: Ler e escrever datas
- **WHEN** "05/03/2026" e "31/02/2026" são lidos em pt-BR, e 5 de março de 2026 é formatada como mês e como data por extenso
- **THEN** a primeira é 5 de março de 2026 e a segunda é nula, e os textos são "março de 2026" e "quinta-feira, 5 de março de 2026"

#### Scenario: Semana do calendário
- **WHEN** `firstDayOfWeek`, `shortWeekdays` e `datePattern` são lidos em pt-BR e em en
- **THEN** a semana começa no domingo nos dois, o primeiro nome é "dom." em pt-BR e "Sun" em en, e o padrão é "dd/MM/y" em pt-BR e "M/d/y" em en

#### Scenario: Textos do calendário
- **WHEN** `previous` e `next` são lidos em pt-BR e em en
- **THEN** eles são "Anterior" e "Próximo" em pt-BR, e "Previous" e "Next" em en
### Requirement: Meses e anos do calendário
Os textos SHALL fornecer os nomes completos dos doze meses na forma independente (`monthNames`), o ano de uma data sem separador de milhar (`formatYear`) e o texto `today`, tudo do CLDR.

#### Scenario: Meses, ano e hoje
- **WHEN** `monthNames`, `formatYear` de 5 de março de 2026 e `today` são lidos em pt-BR e em en
- **THEN** o primeiro mês é "janeiro" em pt-BR e "January" em en, o ano é "2026" nos dois, e `today` é "Hoje" e "Today"
