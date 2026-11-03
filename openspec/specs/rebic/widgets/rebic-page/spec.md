# rebic/widgets/rebic-page Specification

## Purpose

`RebicPage` é a página de conteúdo, como o `sap.m.Page` do SAPUI5: um cabeçalho com o botão de voltar, o título e o conteúdo do cabeçalho; um subcabeçalho opcional; o conteúdo, que rola ou recebe a altura disponível; e um rodapé fixo ou flutuante. O cabeçalho, o subcabeçalho e o rodapé são barras de `RebicBar`. É usada como conteúdo principal do `RebicToolPage` ou como página de uma rota.

## Requirements


### Requirement: [API] Propriedades
`RebicPage` SHALL expor, além das propriedades do cabeçalho:

| Prop | Tipo | Padrão |
|---|---|---|
| `content` | `List<Widget>` | vazia |
| `enableScrolling` | `bool` | `true` |
| `backgroundDesign` | `RebicPageBackgroundDesign` | `standard` |
| `contentPadding` | `RebicContentPadding` | `none` |
| `footer` | `Widget?` | `null` |
| `showFooter` | `bool` | `true` |
| `floatingFooter` | `bool` | `false` |

#### Scenario: Página mínima
- **WHEN** `RebicPage` recebe só `title` e um item em `content`
- **THEN** o cabeçalho mostra o título, o conteúdo começa logo abaixo do cabeçalho, e não há botão de voltar nem rodapé

#### Scenario: Página completa
- **GIVEN** `showNavButton`, `title`, dois itens em `headerContent`, um `subHeader` e um `footer`, em LTR
- **WHEN** a página é renderizada
- **THEN** o cabeçalho mostra, do início ao fim, o botão de voltar, o título e os dois itens; o subcabeçalho vem logo abaixo; e o rodapé fica na borda inferior

### Requirement: [API] Callbacks e controlador
O botão de voltar SHALL aparecer somente com `showNavButton` e MUST chamar `onNavButtonPress` uma vez por ativação, como o evento `navButtonPress`; sem `onNavButtonPress`, MUST aparecer desabilitado. `RebicPage` SHALL NOT ter controlador.

#### Scenario: Voltar
- **GIVEN** uma página com `showNavButton` e um `onNavButtonPress` que conta as chamadas
- **WHEN** o botão de voltar é tocado
- **THEN** `onNavButtonPress` é chamado uma vez

### Requirement: [Comportamento] Rolagem do conteúdo
Com `enableScrolling` `true`, os itens de `content` SHALL ser empilhados e rolar verticalmente entre o cabeçalho e o rodapé, que MUST permanecer fixos. Com `enableScrolling` `false`, os itens SHALL dividir em partes iguais a altura entre o cabeçalho e o rodapé, para widgets com rolagem própria.

#### Scenario: Conteúdo longo rola
- **GIVEN** uma página com rodapé e um conteúdo de 3000 de altura numa tela de 800
- **WHEN** o conteúdo é arrastado 500 para cima
- **THEN** o conteúdo sobe 500, e o cabeçalho e o rodapé ficam na mesma posição

#### Scenario: Conteúdo com rolagem própria
- **GIVEN** uma página com rodapé e `enableScrolling` `false`
- **WHEN** a página é renderizada
- **THEN** o conteúdo recebe uma altura limitada, igual à distância entre o cabeçalho e o rodapé

### Requirement: [Estados] Botão de voltar
O botão de voltar SHALL ser um `RebicButton` só com ícone, do tipo `transparent`, com os estados normal, hover, pressionado, foco do teclado e desabilitado de `rebic/core/interaction`. A página SHALL NOT apresentar outros estados de interação.

#### Scenario: Botão de voltar em hover
- **WHEN** o ponteiro fica sobre o botão de voltar
- **THEN** o fundo do botão é o de hover da família `transparent`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL ser: botão de voltar, conteúdo do cabeçalho, subcabeçalho, conteúdo e rodapé. Um elemento do conteúdo que recebe o foco fora da área visível MUST ser rolado até ficar visível.

#### Scenario: Ordem de foco na página
- **GIVEN** uma página com o botão de voltar, um item no `headerContent`, um item focável no conteúdo e um item focável no rodapé
- **WHEN** Tab é pressionado quatro vezes a partir do início
- **THEN** o foco passa pelo botão de voltar, pelo item do cabeçalho, pelo item do conteúdo e pelo item do rodapé, nessa ordem

#### Scenario: Foco revela o conteúdo
- **GIVEN** um conteúdo longo com um item focável abaixo da área visível
- **WHEN** o item recebe o foco pelo teclado
- **THEN** o conteúdo rola até o item ficar inteiro na área visível

### Requirement: [Acessibilidade] Semântica e contraste
O título MUST ser um cabeçalho com o nível de `titleLevel`, como em `rebic/widgets/rebic-title`. O botão de voltar SHALL ser um botão com o rótulo `navButtonTooltip` ou, sem ele, o texto `back` de `rebic/core/localization`. O texto do cabeçalho MUST manter o contraste, e o botão MUST atender ao alvo mínimo da densidade, conforme `rebic/foundation/accessibility`.

#### Scenario: Semântica da página
- **GIVEN** uma página com `showNavButton` e `titleLevel` `h2`, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o título é um cabeçalho de nível 2, e o botão de voltar é um botão com o rótulo "Voltar"

#### Scenario: Contraste e alvo na página
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas à página, nos temas claro e escuro e nas duas densidades
- **THEN** as duas diretrizes são atendidas

### Requirement: [Responsividade] Largura e direção
A página SHALL ocupar a largura disponível. O espaçamento `responsive` SHALL seguir a classe da tela, como as media queries do UI5. Em RTL, o botão de voltar MUST ficar na borda direita, com a seta espelhada, e o conteúdo do cabeçalho MUST terminar na borda esquerda.

#### Scenario: Página em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a página com `showNavButton` e um item no `headerContent` é renderizada
- **THEN** o botão de voltar fica à direita, e o item do cabeçalho termina na borda esquerda

### Requirement: [Integração] Dependências de núcleo e fundamentos
Do núcleo e dos fundamentos, `RebicPage` SHALL depender somente de `rebic/core/interaction`, `rebic/core/localization`, `rebic/core/responsive`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/breakpoints`, `rebic/foundation/iconography`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Página pelo tema da subárvore
- **GIVEN** uma página numa subárvore com o tema escuro, dentro de uma aplicação clara
- **WHEN** a página é renderizada
- **THEN** o cabeçalho tem o fundo `colors.base` do tema escuro

### Requirement: [Testes] Cobertura exigida
`RebicPage` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` aplicável: contraste, alvo mínimo, semântica e teclado.

#### Scenario: Rastreabilidade da página
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da página
- **WHEN** os goldens da página com voltar, conteúdo do cabeçalho, subcabeçalho, conteúdo com espaçamento e rodapé, e os da página com rodapé flutuante, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicPage` SHALL ter dartdoc em toda API pública, com um exemplo de página com voltar, conteúdo do cabeçalho e rodapé, e uma página "RebicPage" na galeria construída com ela, com o rodapé flutuante e a escolha de `backgroundDesign`.

#### Scenario: Página RebicPage na galeria
- **GIVEN** a galeria com a página "RebicPage" aberta
- **WHEN** o botão de voltar da página é tocado
- **THEN** a galeria volta ao índice

### Requirement: [Restrições] Fora do escopo
`RebicPage` SHALL NOT aceitar larguras, alturas, cores ou espaços literais, nem oferecer subtítulo, cabeçalho expansível (`sap.f.DynamicPage`), `contentOnlyBusy` ou `landmarkInfo`.

#### Scenario: Página sem valor literal
- **WHEN** a API pública de `RebicPage` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`, nem `subtitle`, `onBack` ou `footerActions`

### Requirement: [Integração] Dependências de widgets e hospedeiro
Dos widgets, `RebicPage` SHALL depender somente de `rebic/widgets/rebic-bar`, `rebic/widgets/rebic-title`, `rebic/widgets/rebic-button` e `rebic/widgets/rebic-container`, e SHALL funcionar como conteúdo principal de `rebic/widgets/rebic-tool-page`.

#### Scenario: Página na página de ferramentas
- **GIVEN** uma árvore criada apenas com `RebicApp`, com um `RebicToolPage` cujo cabeçalho é um `RebicShellBar` com título
- **WHEN** uma `RebicPage` com rodapé é o conteúdo principal
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, o cabeçalho da página começa abaixo do da página de ferramentas, e o rodapé termina na borda inferior da tela

### Requirement: [API] Propriedades do cabeçalho
`RebicPage` SHALL expor `title` (`String?`), `titleLevel` (`RebicTitleLevel`, padrão `auto`), `titleAlignment` (`RebicTitleAlignment`, padrão `auto`), `showNavButton` (padrão `false`), `navButtonTooltip` (`String?`), `onNavButtonPress` (`VoidCallback?`), `headerContent` (`List<Widget>`), `customHeader` (`Widget?`), `showHeader` (padrão `true`), `subHeader` (`Widget?`) e `showSubHeader` (padrão `true`), como o `sap.m.Page`.

#### Scenario: Cabeçalho próprio
- **GIVEN** uma página com `title` e um `customHeader`
- **WHEN** a página é renderizada
- **THEN** o cabeçalho é o `customHeader`, e o título não aparece

### Requirement: [API] Áreas condicionais
Com `showHeader`, o cabeçalho SHALL aparecer sempre, mesmo vazio, como no `sap.m.Page`. O subcabeçalho MUST aparecer somente com `subHeader` e `showSubHeader`, e o rodapé somente com `footer` e `showFooter`.

#### Scenario: Página sem cabeçalho
- **WHEN** a página é renderizada com `showHeader` `false`
- **THEN** não há cabeçalho, e o conteúdo começa no topo da página

#### Scenario: Página sem rodapé
- **WHEN** a página é renderizada com um `footer` e `showFooter` `false`
- **THEN** não há rodapé, e o conteúdo vai até a borda inferior da página

### Requirement: [Comportamento] Espaçamento do conteúdo
O conteúdo SHALL ter o espaçamento de `contentPadding`, como as classes de padding do UI5: `none` nenhum; `standard` `spacing.l` nos quatro lados; `responsive` nenhum na classe de tela `small`, `spacing.l` em `medium`, e `spacing.l` em cima e embaixo com `spacing.xxl` nos lados em `large` e `extraLarge`.

#### Scenario: Conteúdo sem espaçamento
- **GIVEN** uma página com `contentPadding` `none`
- **WHEN** a página é renderizada
- **THEN** o conteúdo começa na borda inicial, logo abaixo do cabeçalho

#### Scenario: Espaçamento responsivo pela tela
- **WHEN** páginas com `contentPadding` `responsive` são renderizadas em telas de 400, 800 e 1200 de largura
- **THEN** o conteúdo começa a 0, 16 e 32 da borda inicial, e a 0, 16 e 16 do cabeçalho, respectivamente

### Requirement: [Comportamento] Rodapé flutuante
Com `floatingFooter`, o rodapé SHALL ficar sobre o conteúdo, afastado `spacing.s` das bordas inferior e laterais, com o desenho `floatingFooter` de `rebic/widgets/rebic-bar`. O conteúdo MUST ganhar embaixo um espaço igual à altura do rodapé mais o afastamento, para que o fim fique visível.

#### Scenario: Conteúdo sob o rodapé flutuante
- **GIVEN** uma página com `floatingFooter` e um conteúdo longo
- **WHEN** o conteúdo é rolado até o fim
- **THEN** o fim do conteúdo fica acima do rodapé, e o rodapé fica a `spacing.s` da borda inferior

### Requirement: [Aparência] Fundo e cabeçalho
O fundo da página SHALL seguir `backgroundDesign` (`RebicPageBackgroundDesign`): `standard` e `solid` usam `colors.background`, `list` usa `colors.base` e `transparent` não pinta fundo. O cabeçalho SHALL ser uma `RebicBar` de desenho `header`, com o título em `RebicTitle` (estilo `auto`, que é o H5) no conteúdo central, alinhado por `titleAlignment`.

#### Scenario: Fundo por backgroundDesign
- **WHEN** páginas com cada `backgroundDesign` são renderizadas nos temas claro e escuro
- **THEN** o fundo é `colors.background` em `standard` e `solid`, `colors.base` em `list`, e não há fundo em `transparent`

#### Scenario: Título do cabeçalho
- **WHEN** a página com `title` é renderizada
- **THEN** o título é um `RebicTitle` com o estilo `header5`, no conteúdo central de uma `RebicBar` de desenho `header`, logo depois do botão de voltar
