# Spec Delta

## Purpose

`RebicDatePicker` é o seletor de data do Rebic, como o `sap.m.DatePicker` do SAPUI5: um campo que lê a data digitada no formato do idioma e um ícone que abre um calendário mensal num popover, com limites de data, no padrão controlado (`dateValue` + `onChange`).

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicDatePicker` SHALL expor, como o `sap.m.DatePicker`:

| Prop | Tipo | Padrão |
|---|---|---|
| `dateValue` | `DateTime?` | `null` |
| `onChange` | `ValueChanged<DateTime?>?` | `null` |
| `minDate` | `DateTime?` | `null` |
| `maxDate` | `DateTime?` | `null` |
| `placeholder` | `String?` | `datePattern` |
| `semanticLabel` | `String?` | `null` |

#### Scenario: Seletor mínimo
- **WHEN** um seletor com `dateValue` 5 de março de 2026 é renderizado em pt-BR
- **THEN** o campo mostra "05/03/2026" e o ícone de calendário

### Requirement: [API] Limites válidos
Com `minDate` e `maxDate`, `minDate` MUST NOT ser depois de `maxDate`, ou a renderização MUST falhar em modo debug. As horas de `dateValue`, `minDate` e `maxDate` SHALL ser ignoradas.

#### Scenario: Limites invertidos
- **WHEN** um seletor com `minDate` depois de `maxDate` é renderizado
- **THEN** a renderização falha em modo debug

### Requirement: [API] Callbacks e controlador
Escolher um dia no calendário, ou confirmar (Enter ou perda de foco) um texto que é uma data válida dentro dos limites, SHALL chamar `onChange` com a data, como o evento `change`; esvaziar o campo SHALL chamar `onChange(null)`. Escolher um dia SHALL fechar o calendário. O seletor MUST NOT mudar `dateValue` sozinho nem ter controlador.

#### Scenario: Escolher no calendário
- **GIVEN** um seletor em pt-BR com `dateValue` 5 de março de 2026, cujo `onChange` atualiza `dateValue`
- **WHEN** o ícone é tocado, e depois o dia 17
- **THEN** o calendário mostra "março de 2026", `onChange` recebe 17 de março de 2026, o calendário fecha e o campo mostra "17/03/2026"

#### Scenario: Digitar uma data
- **WHEN** "20/03/2026" é digitado num seletor em pt-BR e Enter é pressionado
- **THEN** `onChange` recebe 20 de março de 2026

### Requirement: [Comportamento] Data inválida e limites
Um texto confirmado que não é data, ou que está fora de `minDate`–`maxDate`, MUST NOT chamar `onChange`: o campo SHALL mostrar o estado `error` com o texto `valueState(error)` da localização até a próxima edição, a menos que o pai dê outro `valueState`. No calendário, os dias fora dos limites SHALL ficar desabilitados.

#### Scenario: Data inválida
- **WHEN** "31/02/2026" é digitado num seletor em pt-BR e Enter é pressionado
- **THEN** `onChange` não é chamado, e o campo tem o estado `error`

#### Scenario: Limites do calendário
- **GIVEN** um seletor com `minDate` 10 de março de 2026 e o calendário de março aberto
- **WHEN** o dia 5 é tocado
- **THEN** `onChange` não é chamado, e o dia 5 é anunciado como desabilitado

### Requirement: [Comportamento] Calendário
O calendário SHALL mostrar o mês de `dateValue` (ou o atual), com botões para o mês anterior e o seguinte, os dias da semana a partir de `firstDayOfWeek` e seis semanas de dias. O ícone, F4 e Alt+seta para baixo SHALL abrir o calendário; Esc ou um toque fora o fecham.

#### Scenario: Navegar entre meses
- **GIVEN** o calendário de março de 2026 aberto em pt-BR
- **WHEN** o botão "Próximo" é tocado
- **THEN** o calendário mostra "abril de 2026"

### Requirement: [Comportamento] Teclado do calendário
Ao abrir, o foco SHALL ir ao dia escolhido, ou a hoje. As setas SHALL mover o foco um dia (para os lados) ou uma semana (para cima e para baixo), e PageUp e PageDown um mês, trocando o mês mostrado quando preciso; Enter e Espaço escolhem o dia focado.

#### Scenario: Teclado no calendário
- **GIVEN** um seletor com `dateValue` 31 de março de 2026 e o foco no campo
- **WHEN** Alt+seta para baixo, a seta para a direita e Enter são pressionados
- **THEN** `onChange` recebe 1º de abril de 2026

### Requirement: [Aparência] Tokens de componente
O campo SHALL ser um `RebicInput` com `valueHelpIconSrc` `RebicIcons.calendar`. No calendário, cada dia SHALL ter a altura `density.minTargetSize`; o escolhido, o fundo `colors.brand` e o texto `colors.contrastText`; hoje, a borda `colors.brand`; os de outros meses, o texto `colors.label`. O mês SHALL usar `typography.baseBold`, e os dias da semana `typography.small` em `colors.label`.

#### Scenario: Dia escolhido
- **WHEN** o calendário de um seletor com `dateValue` 5 de março de 2026 é aberto no tema claro
- **THEN** o dia 5 tem o fundo `brand` e o texto `contrastText`, e o dia 1º de abril o texto `label`

### Requirement: [Estados] Interação
O seletor SHALL repassar ao campo `enabled` e `editable` (padrão `true`), `valueState` (padrão `none`) e `valueStateText` (`String?`); sem `enabled` ou `editable`, o ícone some e o calendário não abre. Os dias e os botões do calendário SHALL ter os estados de `rebic/core/interaction`.

#### Scenario: Seletor desabilitado
- **WHEN** um seletor com `enabled` `false` é renderizado, e F4 é pressionado
- **THEN** não há ícone de calendário, e o calendário não abre

### Requirement: [Acessibilidade] Semântica e contraste
O campo SHALL ter o nome `semanticLabel` ou `placeholder`. Cada dia SHALL ser exposto como botão com o nome `formatLongDate` e o estado selecionado; os botões do cabeçalho, com os nomes `previous` e `next`; o calendário, como diálogo. Os textos MUST ter o contraste de texto, e os alvos o tamanho mínimo.

#### Scenario: Semântica do calendário
- **WHEN** a árvore de semântica do calendário aberto de um seletor em pt-BR com `dateValue` 5 de março de 2026 é lida
- **THEN** "quinta-feira, 5 de março de 2026" é botão selecionado, e há botões "Anterior" e "Próximo"

#### Scenario: Contraste e alvo do seletor
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas ao seletor com o calendário aberto, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Largura e direção
O seletor SHALL ocupar a largura disponível, e o calendário a largura `standard` do popover. Em RTL, os dias da semana MUST começar pela direita, e as setas para os lados MUST trocar de sentido.

#### Scenario: Calendário em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** o calendário é aberto
- **THEN** o primeiro dia da semana fica à direita do segundo

### Requirement: [Integração] Dependências
`RebicDatePicker` SHALL depender somente de `rebic/core/interaction`, `rebic/core/localization`, `rebic/widgets/rebic-input`, `rebic/widgets/rebic-popover`, `rebic/widgets/rebic-button`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Seletor sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um seletor é aberto, navegado, escolhido e digitado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicDatePicker` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do seletor
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do seletor
- **WHEN** os goldens do seletor com o calendário aberto, com uma data escolhida e um limite, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicDatePicker` SHALL ter dartdoc em toda API pública e uma página "RebicDatePicker" na galeria com um seletor de data de entrega com limite mínimo.

#### Scenario: Página RebicDatePicker na galeria
- **GIVEN** a página "RebicDatePicker" aberta na galeria
- **WHEN** "20/03/2030" é digitado no seletor e Enter é pressionado
- **THEN** a página mostra "Entrega: 20/03/2030"

### Requirement: [Restrições] Fora do escopo
`RebicDatePicker` SHALL NOT aceitar larguras ou cores literais, nem ter `displayFormat`, `valueFormat`, a escolha de mês e ano pelo cabeçalho, o botão "Hoje", datas especiais, outros calendários ou intervalos.

#### Scenario: Seletor sem valor literal
- **WHEN** a API pública de `RebicDatePicker` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
