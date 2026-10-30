# rebic/widgets/rebic-shell-bar Specification

## Purpose

`RebicShellBar` é a barra superior da aplicação, como o `sap.f.ShellBar` do SAPUI5: no início, os botões de voltar e de menu, o ícone inicial, o título e o segundo título; no fim, a pesquisa, as notificações com contador, o conteúdo adicional, o perfil e o seletor de produtos. Cada elemento aparece por uma propriedade e avisa a aplicação pelo seu callback.

## Requirements

### Requirement: [API] Propriedades
`RebicShellBar` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `title` | `String?` | `null` |
| `secondTitle` | `String?` | `null` |
| `homeIcon` | `Widget?` | `null` |
| `homeIconTooltip` | `String?` | `null` (texto `logo`) |
| `profile` | `RebicAvatar?` | `null` |
| `additionalContent` | `List<Widget>` | vazia |

E os botões, como em "[API] Botões da barra".

#### Scenario: Barra completa
- **GIVEN** todos os elementos visíveis, com um item de conteúdo adicional, em LTR
- **WHEN** a barra é renderizada numa largura de 1200
- **THEN** aparecem, do início ao fim, voltar, menu, ícone inicial, título e segundo título; e, terminando na borda final, pesquisa, notificações, o conteúdo adicional, o perfil e o seletor de produtos

#### Scenario: Barra só com título
- **WHEN** `RebicShellBar(title: 'Compras')` é renderizado
- **THEN** só o título aparece, e não há botões

### Requirement: [API] Botões da barra
`RebicShellBar` SHALL expor `showNavButton`, `showMenuButton`, `showSearch`, `showNotifications` e `showProductSwitcher`, todos `bool` com padrão `false`, e `notificationsNumber` (`int`, padrão `0`), que MUST NOT ser negativo.

#### Scenario: Contador negativo
- **WHEN** `RebicShellBar` é criado com `notificationsNumber` -1
- **THEN** a criação falha em modo debug com mensagem que cita `notificationsNumber`

### Requirement: [API] Callbacks e controlador
`RebicShellBar` SHALL expor `onHomeIconPressed`, `onNavButtonPressed`, `onMenuButtonPressed`, `onSearchButtonPressed`, `onNotificationsPressed`, `onProductSwitcherPressed` e `onAvatarPressed`, todos `VoidCallback?`, como os eventos do `sap.f.ShellBar`. Um botão visível sem callback MUST aparecer desabilitado. O ícone inicial sem `onHomeIconPressed` e o perfil sem `onAvatarPressed` MUST NOT ser interativos. A barra SHALL NOT ter controlador.

#### Scenario: Botões avisam a aplicação
- **GIVEN** a barra completa com um callback que registra cada evento
- **WHEN** voltar, menu, ícone inicial, pesquisa, notificações, perfil e seletor de produtos são tocados, nessa ordem
- **THEN** os callbacks correspondentes são chamados uma vez cada, nessa ordem

#### Scenario: Botão sem callback
- **WHEN** a barra tem `showSearch` `true` e nenhum `onSearchButtonPressed`
- **THEN** o botão de pesquisa aparece desabilitado

### Requirement: [Comportamento] Contador de notificações
Com `notificationsNumber` maior que zero, o botão de notificações SHALL mostrar o contador de `rebic/widgets/rebic-badge`, no estado `error`. Com zero, o contador MUST NOT aparecer.

#### Scenario: Notificações com contador
- **WHEN** a barra tem `showNotifications` `true` e `notificationsNumber` 4
- **THEN** o botão de notificações mostra o contador "4"

### Requirement: [Comportamento] Espaço insuficiente
Quando os elementos não cabem na largura, o título e o segundo título SHALL encolher e terminar com reticências, nessa ordem inversa: o segundo título primeiro. Os botões, o conteúdo adicional e o perfil MUST manter o tamanho, e a barra MUST NOT gerar erro de layout.

#### Scenario: Títulos truncados
- **GIVEN** uma barra de 360 com voltar, menu, título e segundo título longos, notificações e perfil
- **WHEN** a barra é renderizada
- **THEN** não há erro de layout, o segundo título termina com reticências, e todos os botões aparecem inteiros

### Requirement: [Aparência] Superfície e margem
A barra SHALL usar o fundo `colors.shell`, a sombra `shadows.header` e a altura `spacing.xxxl`. A margem horizontal SHALL seguir a classe da largura da própria barra: `spacing.pageMargin` em `small`, `spacing.xxl` em `medium` e `spacing.xxxl` em `large` e `extraLarge`, como os paddings Phone, Tablet e Desktop do ShellBar. Os elementos SHALL ficar separados por `spacing.xs`, sem valores literais.

#### Scenario: Aparência da barra
- **WHEN** a barra completa é renderizada nos temas claro e escuro
- **THEN** o fundo é `colors.shell`, a barra tem a sombra `shadows.header` e a altura `spacing.xxxl`, e o título tem o estilo `header5` e a cor `colors.text` de cada tema

#### Scenario: Margem por largura
- **WHEN** a barra é renderizada com larguras de 500, 800 e 1200
- **THEN** o primeiro elemento começa a `spacing.pageMargin`, `spacing.xxl` e `spacing.xxxl` da borda inicial, respectivamente

### Requirement: [Aparência] Títulos e botões
O título SHALL usar o estilo `header5` e o segundo título o estilo `small`, ambos com `colors.text`. Os botões SHALL ser `RebicIconButton` do tipo `transparent`, com os ícones `navBack`, `menu2`, `search`, `bell` e `grid` de `rebic/foundation/iconography`. O perfil SHALL ser exibido no tamanho `xs` de `RebicAvatar`, como o `Avatar` do ShellBar.

#### Scenario: Ícones dos botões
- **WHEN** a barra completa é renderizada
- **THEN** voltar, menu, pesquisa, notificações e seletor de produtos são `RebicIconButton` do tipo `transparent` com os ícones `navBack`, `menu2`, `search`, `bell` e `grid`, e o segundo título tem o estilo `small`, e o perfil tem o tamanho `xs`

### Requirement: [Estados] Estados dos botões
Os botões, o ícone inicial interativo e o perfil interativo SHALL apresentar os estados normal, hover, pressionado, foco do teclado e desabilitado de `rebic/core/interaction`, com as cores da família `transparent` de `rebic/foundation/interaction-states`. A barra SHALL NOT apresentar estados próprios.

#### Scenario: Botão da barra em hover
- **WHEN** o ponteiro fica sobre o botão de menu
- **THEN** o fundo do botão é o de hover da família `transparent`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL seguir a ordem visual dos elementos interativos. Os botões MUST ser ativados por Enter e Espaço, como define `rebic/core/interaction`.

#### Scenario: Ordem de foco na barra
- **GIVEN** a barra com voltar, menu, pesquisa e perfil interativo, em LTR
- **WHEN** Tab é pressionado três vezes a partir do botão de voltar
- **THEN** o foco passa pelo menu, pela pesquisa e pelo perfil, nessa ordem

#### Scenario: Menu pelo teclado
- **GIVEN** o botão de menu com o foco
- **WHEN** Enter é pressionado
- **THEN** `onMenuButtonPressed` é chamado

### Requirement: [Acessibilidade] Semântica
A barra SHALL ser um contêiner com o rótulo `shellBar` de `rebic/core/localization`, e o título MUST ser um cabeçalho de nível 1, como no `sap.f.ShellBar`. Os botões MUST ter as dicas `back`, `menu`, `search`, `notifications` e `products`, e o ícone inicial a dica `homeIconTooltip` ou o texto `logo`. O contador de notificações MUST fazer parte do rótulo do botão.

#### Scenario: Semântica da barra
- **GIVEN** a barra completa em pt-BR, com `notificationsNumber` 4
- **WHEN** a árvore de semântica é lida
- **THEN** o contêiner tem o rótulo "Barra de shell", o título é um cabeçalho de nível 1, e os botões têm os rótulos "Voltar", "Menu", "Pesquisar", "Notificações" com o contador 4 e "Meus produtos"

### Requirement: [Acessibilidade] Contraste e alvo
O texto da barra MUST manter o contraste sobre `colors.shell`, e os elementos interativos MUST atender ao alvo mínimo da densidade, conforme `rebic/foundation/accessibility`.

#### Scenario: Contraste e alvo na barra
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas à barra completa, nos temas claro e escuro
- **THEN** as duas diretrizes são atendidas

### Requirement: [Responsividade] Largura, densidade e direção
A classe usada pela barra SHALL ser a da largura da própria barra, com os limiares do tema ativo. A altura da barra MUST ser a mesma nas densidades cozy e compacta, e os botões MUST seguir a altura de controle da densidade. Em RTL, a ordem dos elementos MUST ser espelhada, e o ícone de voltar MUST ser espelhado.

#### Scenario: Barra em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a barra com voltar, título e perfil é renderizada
- **THEN** o botão de voltar fica na borda direita, o perfil termina na borda esquerda, e o ícone de voltar aponta para a direita

#### Scenario: Barra na densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** a barra com o botão de menu é renderizada
- **THEN** a barra mede `spacing.xxxl` de altura, e o botão mede a altura de controle compacta

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `RebicShellBar` SHALL depender somente de `rebic/widgets/rebic-icon-button`, `rebic/widgets/rebic-avatar`, `rebic/widgets/rebic-badge`, `rebic/widgets/rebic-tooltip`, `rebic/widgets/rebic-title`, `rebic/widgets/rebic-container`, `rebic/core/interaction`, `rebic/core/localization` e `rebic/core/responsive`.

#### Scenario: Barra sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** a barra completa é renderizada e seus botões são tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Integração] Dependências de fundamentos
Dos fundamentos, `RebicShellBar` SHALL depender somente de `rebic/foundation/color`, `rebic/foundation/shadows`, `rebic/foundation/spacing`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/breakpoints`, `rebic/foundation/density`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Barra pelo tema da subárvore
- **GIVEN** uma barra numa subárvore com o tema escuro, dentro de uma aplicação clara
- **WHEN** a barra é renderizada
- **THEN** o fundo da barra é o `colors.shell` escuro

### Requirement: [Testes] Cobertura exigida
`RebicShellBar` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos: contraste, alvo mínimo, semântica e teclado.

#### Scenario: Rastreabilidade da barra
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da barra
- **WHEN** os goldens da barra completa e da barra só com título são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicShellBar` SHALL ter dartdoc em toda API pública e uma página "RebicShellBar" na galeria com a barra completa, a barra só com título e uma barra estreita com títulos truncados.

#### Scenario: Página RebicShellBar na galeria
- **WHEN** a página "RebicShellBar" é aberta
- **THEN** ela exibe a barra completa, a barra só com título e a barra estreita, e tocar o botão de menu da barra completa mostra uma mensagem

### Requirement: [Restrições] Fora do escopo
`RebicShellBar` SHALL NOT oferecer menu "mais" para elementos que não cabem (`sap.m.OverflowToolbar`), menu no título (`menu`), campo de pesquisa (`searchManager`), Joule (`showCopilot`), larguras, alturas nem cores literais.

#### Scenario: Barra sem valor literal
- **WHEN** a API pública de `RebicShellBar` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`, nem de menu, pesquisa gerenciada ou Joule
