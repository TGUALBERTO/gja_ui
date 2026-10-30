# rebic/widgets/rebic-page Specification

## Purpose

`RebicPage` é a página de conteúdo, como o `sap.m.Page` e o `sap.f.DynamicPage` do SAPUI5: uma área de título com botão de voltar, título, subtítulo e ações; o conteúdo, que rola entre o título e o rodapé ou recebe a altura disponível; e um rodapé fixo com as ações finais. É usada como corpo do `RebicScaffold` ou como página de uma rota.

## Requirements


### Requirement: [API] Propriedades
`RebicPage` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `title` | `String` | obrigatória |
| `subtitle` | `String?` | `null` |
| `onBack` | `VoidCallback?` | `null` |
| `actions` | `List<Widget>` | vazia |
| `body` | `Widget` | obrigatória |
| `padded` | `bool` | `true` |
| `scrollable` | `bool` | `true` |
| `footerActions` | `List<Widget>` | vazia |

#### Scenario: Página mínima
- **WHEN** `RebicPage` recebe só `title` e `body`
- **THEN** o título aparece no topo, o conteúdo começa abaixo da área de título, e não há botão de voltar nem rodapé

#### Scenario: Página completa
- **GIVEN** `onBack`, `title`, `subtitle`, duas ações e duas ações de rodapé, em LTR
- **WHEN** a página é renderizada
- **THEN** a área de título mostra, do início ao fim, o botão de voltar, o título com o subtítulo abaixo e as duas ações, e o rodapé mostra as duas ações terminando na borda final

### Requirement: [API] Rodapé condicional
O rodapé MUST aparecer somente quando `footerActions` não é vazia.

#### Scenario: Página sem rodapé
- **WHEN** a página é renderizada com `footerActions` vazia
- **THEN** não há rodapé, e o conteúdo vai até a borda inferior da página

### Requirement: [API] Callbacks e controlador
O botão de voltar SHALL aparecer somente quando `onBack` é informado e MUST chamá-lo uma vez por ativação. `RebicPage` SHALL NOT ter controlador.

#### Scenario: Voltar
- **GIVEN** uma página com `onBack` que conta as chamadas
- **WHEN** o botão de voltar é tocado
- **THEN** `onBack` é chamado uma vez

### Requirement: [Comportamento] Rolagem do conteúdo
Com `scrollable` `true`, o conteúdo SHALL rolar verticalmente entre a área de título e o rodapé, que MUST permanecer fixos. Com `scrollable` `false`, o conteúdo SHALL receber exatamente a altura entre a área de título e o rodapé, para widgets com rolagem própria.

#### Scenario: Conteúdo longo rola
- **GIVEN** uma página com rodapé e um conteúdo de 3000 de altura numa tela de 800
- **WHEN** o conteúdo é arrastado 500 para cima
- **THEN** o conteúdo sobe 500, e a área de título e o rodapé ficam na mesma posição

#### Scenario: Conteúdo com rolagem própria
- **GIVEN** uma página com rodapé e `scrollable` `false`
- **WHEN** a página é renderizada
- **THEN** o conteúdo recebe uma altura limitada, igual à distância entre a área de título e o rodapé

### Requirement: [Comportamento] Margem do conteúdo
Com `padded` `true`, o conteúdo SHALL ter nos quatro lados a margem de página da classe de tamanho da largura da própria página (`spacing.pageMarginFor`), como o padding responsivo da `sap.f.DynamicPage`. Com `padded` `false`, MUST NOT haver margem.

#### Scenario: Conteúdo sem margem
- **GIVEN** uma página com `padded` `false`
- **WHEN** a página é renderizada
- **THEN** o conteúdo começa na borda inicial da página, logo abaixo da área de título

#### Scenario: Margem pela largura da página
- **WHEN** páginas com `padded` `true` são renderizadas com larguras de 400, 800, 1200 e 1600
- **THEN** o conteúdo começa a 16, 32, 32 e 48 da borda inicial, respectivamente

### Requirement: [Aparência] Tokens de componente
A área de título e o rodapé SHALL usar o fundo `colors.base` e ser separados do conteúdo por divisores sutis de `rebic/widgets/rebic-divider`. O conteúdo SHALL NOT pintar fundo próprio. O título SHALL usar `typography.header2` com `colors.text`, e o subtítulo `typography.base` com `colors.label`. Os espaços SHALL vir de `spacing`, sem valores literais.

#### Scenario: Cores da página
- **WHEN** a página com rodapé é renderizada nos temas claro e escuro
- **THEN** a área de título e o rodapé têm o fundo `colors.base` de cada tema, e o conteúdo não pinta fundo

#### Scenario: Margem da densidade compacta
- **GIVEN** uma página numa subárvore compacta
- **WHEN** a página é renderizada
- **THEN** o conteúdo começa à margem de página do espaçamento compacto para a classe de tamanho da página, igual à da densidade cozy

### Requirement: [Estados] Botão de voltar
O botão de voltar SHALL apresentar os estados normal, hover, pressionado e foco do teclado de `rebic/core/interaction`, com as cores da família `transparent`. A página SHALL NOT apresentar outros estados de interação.

#### Scenario: Botão de voltar em hover
- **WHEN** o ponteiro fica sobre o botão de voltar
- **THEN** o fundo do botão é o de hover da família `transparent`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL ser: botão de voltar, ações, conteúdo e ações do rodapé. Um elemento do conteúdo que recebe o foco fora da área visível MUST ser rolado até ficar visível.

#### Scenario: Ordem de foco na página
- **GIVEN** uma página com o botão de voltar, uma ação, um item focável no conteúdo e uma ação de rodapé
- **WHEN** Tab é pressionado quatro vezes a partir do início
- **THEN** o foco passa pelo botão de voltar, pela ação, pelo item do conteúdo e pela ação de rodapé, nessa ordem

#### Scenario: Foco revela o conteúdo
- **GIVEN** um conteúdo longo com um item focável abaixo da área visível
- **WHEN** o item recebe o foco pelo teclado
- **THEN** o conteúdo rola até o item ficar inteiro na área visível

### Requirement: [Acessibilidade] Semântica e contraste
O título MUST ser exposto como cabeçalho. O botão de voltar SHALL ser exposto como botão com o rótulo `back` de `rebic/core/localization`. O texto da área de título MUST manter o contraste, e o botão MUST atender ao alvo mínimo da densidade, conforme `rebic/foundation/accessibility`.

#### Scenario: Semântica da página
- **GIVEN** uma página com `onBack`, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o título é um cabeçalho, e o botão de voltar é um botão com o rótulo "Voltar"

#### Scenario: Contraste e alvo na página
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas à página, nos temas claro e escuro e nas duas densidades
- **THEN** as duas diretrizes são atendidas

### Requirement: [Responsividade] Largura e direção
A página SHALL ocupar a largura disponível, sem limiares próprios. Em RTL, o botão de voltar MUST ficar na borda direita, com a seta espelhada, e as ações da área de título e do rodapé MUST terminar na borda esquerda.

#### Scenario: Página em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a página com `onBack`, uma ação e uma ação de rodapé é renderizada
- **THEN** o botão de voltar fica à direita, a ação termina na borda esquerda da área de título, e a ação de rodapé termina na borda esquerda do rodapé

### Requirement: [Integração] Dependências de widgets
Dos widgets, `RebicPage` SHALL depender somente de `rebic/widgets/rebic-text`, `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-icon-button`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-divider`, `rebic/widgets/rebic-row`, `rebic/widgets/rebic-column` e `rebic/widgets/rebic-spacing`, e SHALL funcionar como corpo de `rebic/widgets/rebic-scaffold`.

#### Scenario: Página no corpo do scaffold
- **GIVEN** uma árvore criada apenas com `RebicApp`, com um `RebicScaffold` cuja barra tem título
- **WHEN** uma `RebicPage` com rodapé é o corpo do scaffold
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino, a área de título da página começa abaixo da barra, e o rodapé termina na borda inferior da tela

### Requirement: [Integração] Dependências de núcleo e fundamentos
Do núcleo e dos fundamentos, `RebicPage` SHALL depender somente de `rebic/core/interaction`, `rebic/core/localization`, `rebic/foundation/color`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/breakpoints`, `rebic/foundation/iconography`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Página pelo tema da subárvore
- **GIVEN** uma página numa subárvore com o tema escuro, dentro de uma aplicação clara
- **WHEN** a página é renderizada
- **THEN** a área de título tem o fundo `colors.base` do tema escuro

### Requirement: [Testes] Cobertura exigida
`RebicPage` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` aplicável: contraste, alvo mínimo, semântica e teclado.

#### Scenario: Rastreabilidade da página
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da página
- **WHEN** os goldens da página com voltar, subtítulo, ações, conteúdo e rodapé são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicPage` SHALL ter dartdoc em toda API pública, com um exemplo de página com voltar, ações e rodapé, e uma página "RebicPage" na galeria construída com ela.

#### Scenario: Página RebicPage na galeria
- **GIVEN** a galeria com a página "RebicPage" aberta
- **WHEN** o botão de voltar da página é tocado
- **THEN** a galeria volta ao índice

### Requirement: [Restrições] Fora do escopo
`RebicPage` SHALL NOT aceitar larguras, alturas, cores ou espaços literais, nem oferecer cabeçalho expansível, margem por classe de tela ou botões prontos.

#### Scenario: Página sem valor literal
- **WHEN** a API pública de `RebicPage` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`
