# rebic/widgets/rebic-scaffold Specification

## Purpose

`RebicScaffold` é a estrutura da aplicação, como o `sap.tnt.ToolPage` do SAPUI5: uma barra superior com logo, título, ações e o botão de navegação; uma área de navegação lateral que se adapta à classe da tela (expandida ao lado, recolhida ao lado ou sobre o corpo); e o corpo da página. O estado da navegação é controlado pela aplicação ou automático pela classe da tela.

## Requirements

### Requirement: [API] Propriedades
`RebicScaffold` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `body` | `Widget` | obrigatória |
| `title` | `String?` | `null` |
| `logo` | `Widget?` | `null` |
| `actions` | `List<Widget>` | vazia |
| `navigation` | `Widget?` | `null` |
| `navigationExpanded` | `bool?` | `null` (automático) |
| `onNavigationExpandedChanged` | `ValueChanged<bool>?` | `null` |

#### Scenario: Barra completa
- **GIVEN** `logo`, `title`, duas ações e `navigation` informados, em LTR
- **WHEN** o scaffold é renderizado
- **THEN** a barra mostra, do início ao fim, o botão de navegação, o logo e o título, e as duas ações terminam na borda final da barra

### Requirement: [API] Barra condicional
A barra superior MUST aparecer somente quando `title`, `logo`, `navigation` ou ao menos uma ação é informado. O botão de navegação MUST aparecer somente quando há `navigation`.

#### Scenario: Scaffold mínimo
- **WHEN** `RebicScaffold` recebe só `body`, numa tela de 1200 × 800
- **THEN** não há barra superior, e o corpo ocupa a tela inteira

### Requirement: [API] Callbacks e controlador
Com `navigationExpanded` informado, o estado SHALL ser controlado: o botão de navegação MUST chamar `onNavigationExpandedChanged` com o valor oposto e MUST NOT mudar o estado sozinho. Sem `navigationExpanded`, o botão SHALL alternar o estado automático e chamar `onNavigationExpandedChanged`, se houver. `RebicScaffold.navigationExpandedOf(context)` SHALL retornar o estado em vigor para os descendentes do scaffold, e `null` fora dele.

#### Scenario: Navegação controlada
- **GIVEN** `navigationExpanded` `false` e um `onNavigationExpandedChanged` que registra os valores
- **WHEN** o botão de navegação é tocado
- **THEN** o callback recebe `true`, e `navigationExpandedOf` continua `false` até a aplicação reconstruir com `true`

#### Scenario: Navegação automática alternada
- **GIVEN** um scaffold sem `navigationExpanded`, numa tela `large`
- **WHEN** o botão de navegação é tocado
- **THEN** `navigationExpandedOf` passa de `true` a `false`, e o callback recebe `false`

### Requirement: [Comportamento] Estado automático por classe
Sem `navigationExpanded`, a navegação SHALL começar expandida nas classes `large` e `extraLarge` e recolhida em `small` e `medium`, pela classe da tela. Quando a classe da tela muda, o estado automático MUST voltar ao padrão da nova classe, descartando a alternância feita pelo botão.

#### Scenario: Estado inicial em cada classe
- **WHEN** o scaffold sem `navigationExpanded` é renderizado em telas das classes `small`, `medium`, `large` e `extraLarge`
- **THEN** `navigationExpandedOf` é `false`, `false`, `true` e `true`, respectivamente

#### Scenario: Troca de classe restaura o padrão
- **GIVEN** um scaffold sem `navigationExpanded` numa tela `large`, com a navegação recolhida pelo botão
- **WHEN** a tela passa à classe `extraLarge`
- **THEN** a navegação volta a ficar expandida

### Requirement: [Comportamento] Navegação ao lado do corpo
Nas classes `medium`, `large` e `extraLarge`, a navegação SHALL ficar na borda inicial, abaixo da barra, com a largura que o próprio conteúdo define, expandida ou recolhida, seguida de um separador. O corpo MUST ocupar o restante da largura.

#### Scenario: Navegação recolhida ao lado
- **GIVEN** uma tela `medium` e uma navegação que mede 64 de largura quando recolhida
- **WHEN** o scaffold é renderizado
- **THEN** a navegação fica na borda inicial com 64 de largura, e o corpo começa após o separador e termina na borda final da tela

### Requirement: [Comportamento] Navegação na tela small
Na classe `small`, a navegação recolhida SHALL ficar oculta, e o corpo MUST ocupar toda a largura. A navegação expandida SHALL ocupar toda a área abaixo da barra, e o corpo MUST sair da tela, da ordem de foco e da árvore de semântica, preservando o estado.

#### Scenario: Navegação expandida cobre o corpo
- **GIVEN** uma tela `small` com `navigationExpanded` `true`
- **WHEN** o scaffold é renderizado
- **THEN** a navegação ocupa toda a largura abaixo da barra, e o corpo não está visível nem na árvore de semântica

#### Scenario: Estado do corpo preservado
- **GIVEN** uma tela `small` e um corpo com um contador em 3
- **WHEN** a navegação é expandida e depois recolhida
- **THEN** o corpo volta a aparecer com o contador em 3

### Requirement: [Aparência] Tokens de componente
A barra SHALL usar o fundo `colors.shell` e a sombra `shadows.header`. A área de navegação SHALL usar o fundo `colors.base`, e o separador SHALL ser o de `rebic/widgets/rebic-divider` com tom sutil. Os espaços internos da barra SHALL vir de `spacing`, o botão MUST ter a família `transparent` de `rebic/foundation/interaction-states` e o ícone `menu2` de `rebic/foundation/iconography`, sem valores literais.

#### Scenario: Cores da barra e da navegação
- **WHEN** o scaffold com barra e navegação é renderizado nos temas claro e escuro
- **THEN** o fundo da barra é `colors.shell`, o da navegação é `colors.base`, e a barra tem a sombra `shadows.header` de cada tema

### Requirement: [Aparência] Movimento da navegação
A mudança de largura da navegação ao lado do corpo SHALL ser animada com `motion.medium` e a curva `motion.standard`. Com movimento reduzido, a mudança MUST ser imediata.

#### Scenario: Largura sem animação no movimento reduzido
- **GIVEN** o movimento reduzido ativo, numa tela `large`, e uma navegação que mede 240 expandida e 64 recolhida
- **WHEN** o botão de navegação é tocado e um único quadro é desenhado
- **THEN** a navegação já mede 64

### Requirement: [Estados] Botão de navegação
O botão de navegação SHALL apresentar os estados normal, hover, pressionado e foco do teclado de `rebic/core/interaction`, com as cores da família `transparent`. O scaffold SHALL NOT apresentar outros estados de interação.

#### Scenario: Botão em hover
- **WHEN** o ponteiro fica sobre o botão de navegação
- **THEN** o fundo do botão é o de hover da família `transparent`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL ser: botão de navegação, logo, ações, navegação e corpo. O botão MUST ser ativado por Enter e Espaço, como define `rebic/core/interaction`.

#### Scenario: Ordem de foco no scaffold
- **GIVEN** um scaffold numa tela `large` com o botão de navegação, uma ação, um item focável na navegação e um no corpo
- **WHEN** Tab é pressionado quatro vezes a partir do início
- **THEN** o foco passa pelo botão, pela ação, pelo item da navegação e pelo item do corpo, nessa ordem

#### Scenario: Botão pelo teclado
- **GIVEN** o botão de navegação com o foco, e a navegação expandida
- **WHEN** Enter é pressionado
- **THEN** a navegação fica recolhida

### Requirement: [Acessibilidade] Semântica e contraste
O botão de navegação SHALL ser exposto como botão, com o rótulo `navigation` de `rebic/core/localization` e o estado expandido ou recolhido da navegação. O título MUST ser exposto como cabeçalho. O texto da barra MUST manter o contraste sobre `colors.shell`, e o botão MUST atender ao alvo mínimo da densidade, conforme `rebic/foundation/accessibility`.

#### Scenario: Semântica do botão de navegação
- **GIVEN** a navegação recolhida, em pt-BR
- **WHEN** a árvore de semântica é lida
- **THEN** o botão tem o papel de botão, o rótulo "Navegação" e o estado recolhido, e o título é um cabeçalho

#### Scenario: Contraste e alvo na barra
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas à barra, nos temas claro e escuro
- **THEN** as duas diretrizes são atendidas

### Requirement: [Responsividade] Tela e direção
A classe usada pelo scaffold SHALL ser a da tela, com os limiares do tema ativo, porque ele estrutura a página inteira. Em RTL, a navegação, o botão e o logo MUST ficar na borda direita, e as ações na esquerda.

#### Scenario: Scaffold em RTL
- **GIVEN** a direção do texto da direita para a esquerda, numa tela `large`
- **WHEN** o scaffold com navegação e uma ação é renderizado
- **THEN** a navegação e o botão ficam na borda direita, e a ação termina na borda esquerda da barra

### Requirement: [Integração] Dependências de widgets e núcleo
Dos widgets e do núcleo, `RebicScaffold` SHALL depender somente de `rebic/widgets/rebic-app`, `rebic/widgets/rebic-container`, `rebic/widgets/rebic-divider`, `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-icon-button`, `rebic/widgets/rebic-text`, `rebic/core/responsive`, `rebic/core/interaction` e `rebic/core/localization`.

#### Scenario: Scaffold sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um scaffold com barra, navegação e corpo é a página inicial
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Integração] Dependências de fundamentos
Dos fundamentos, `RebicScaffold` SHALL depender somente de `rebic/foundation/color`, `rebic/foundation/shadows`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/iconography`, `rebic/foundation/interaction-states`, `rebic/foundation/design-tokens`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Barra pelo tema da subárvore
- **GIVEN** um scaffold numa subárvore com o tema escuro e densidade compacta, dentro de uma aplicação clara e confortável
- **WHEN** a barra é renderizada
- **THEN** o fundo da barra é o `colors.shell` escuro, e o botão de navegação mede a altura de controle compacta

### Requirement: [Testes] Cobertura exigida
`RebicScaffold` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` aplicável à barra: contraste, alvo mínimo, semântica e teclado.

#### Scenario: Rastreabilidade do scaffold
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do scaffold
- **WHEN** os goldens do scaffold com barra, navegação expandida e corpo são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicScaffold` SHALL ter dartdoc em toda API pública, com um exemplo de aplicação com barra e navegação, e uma página "RebicScaffold" na galeria com um scaffold de demonstração com navegação e corpo.

#### Scenario: Página RebicScaffold na galeria
- **GIVEN** a galeria numa janela de 500 com a página "RebicScaffold" aberta
- **WHEN** o botão de navegação do scaffold de demonstração é tocado
- **THEN** a navegação de demonstração passa a ocupar a área do corpo

### Requirement: [Restrições] Fora do escopo
`RebicScaffold` SHALL NOT aceitar larguras, alturas ou cores literais, nem embutir o conteúdo da navegação, pesquisa, perfil ou notificações. O cabeçalho, a rolagem e o rodapé de ações da página são de `RebicPage`.

#### Scenario: Scaffold sem valor literal
- **WHEN** a API pública de `RebicScaffold` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`
