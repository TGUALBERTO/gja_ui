# Spec Delta

## Purpose

`GjaToolPage` é a estrutura da aplicação, como o `sap.tnt.ToolPage` do SAPUI5: um cabeçalho e um subcabeçalho no topo, em geral um `GjaShellBar`; um conteúdo lateral, em geral a navegação, que fica ao lado do conteúdo principal ou o cobre na tela pequena; e o conteúdo principal. O estado expandido do conteúdo lateral é automático pela faixa da tela na primeira exibição ou controlado pela aplicação.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaToolPage` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `header` | `Widget?` | `null` |
| `subHeader` | `Widget?` | `null` |
| `sideContent` | `Widget?` | `null` |
| `mainContents` | `List<Widget>` | vazia |
| `sideExpanded` | `bool?` | `null` (automático) |
| `onSideExpandedChanged` | `ValueChanged<bool>?` | `null` |

#### Scenario: Estrutura completa
- **GIVEN** `header`, `subHeader`, `sideContent` e um conteúdo principal, numa tela `large` em LTR
- **WHEN** a página é renderizada
- **THEN** o cabeçalho fica no topo, o subcabeçalho logo abaixo, e abaixo deles o conteúdo lateral na borda inicial, seguido do conteúdo principal até a borda final

#### Scenario: Página só com conteúdo principal
- **WHEN** `GjaToolPage` recebe só um conteúdo principal, numa tela de 1200 × 800
- **THEN** o conteúdo principal ocupa a tela inteira

### Requirement: [API] Callbacks e controlador
Com `sideExpanded` informado, o estado SHALL ser controlado: `GjaToolPage.toggleSideContentMode(context)` MUST chamar `onSideExpandedChanged` com o valor oposto e MUST NOT mudar o estado sozinho. Sem `sideExpanded`, a alternância SHALL mudar o estado automático e chamar `onSideExpandedChanged`, se houver. `GjaToolPage.sideExpandedOf(context)` SHALL retornar o estado em vigor para os descendentes, e `null` fora de um `GjaToolPage`; `toggleSideContentMode` fora dele MUST não fazer nada.

#### Scenario: Estado controlado
- **GIVEN** `sideExpanded` `false` e um `onSideExpandedChanged` que registra os valores
- **WHEN** `toggleSideContentMode` é chamado a partir do cabeçalho
- **THEN** o callback recebe `true`, e `sideExpandedOf` continua `false` até a aplicação reconstruir com `true`

#### Scenario: Estado automático alternado
- **GIVEN** uma página sem `sideExpanded`, numa tela `large`
- **WHEN** `toggleSideContentMode` é chamado
- **THEN** `sideExpandedOf` passa de `true` a `false`, e o callback recebe `false`

### Requirement: [Comportamento] Estado automático
Sem `sideExpanded`, o conteúdo lateral SHALL começar expandido, exceto na classe `small`, como o `sideExpanded` inicial do `sap.tnt.ToolPage`. Depois da primeira exibição, o estado automático MUST ser mantido quando a classe da tela muda.

#### Scenario: Estado inicial por classe
- **WHEN** a página sem `sideExpanded` é exibida pela primeira vez em telas das classes `small`, `medium`, `large` e `extraLarge`
- **THEN** `sideExpandedOf` é `false`, `true`, `true` e `true`, respectivamente

#### Scenario: Estado mantido na troca de classe
- **GIVEN** uma página sem `sideExpanded` numa tela `large`, com o conteúdo lateral recolhido por `toggleSideContentMode`
- **WHEN** a tela passa à classe `extraLarge` e depois à `medium`
- **THEN** o conteúdo lateral continua recolhido

### Requirement: [Comportamento] Conteúdo lateral ao lado
Nas classes `medium`, `large` e `extraLarge`, o conteúdo lateral SHALL ficar na borda inicial, abaixo do cabeçalho, com a largura que ele mesmo define para o estado em vigor, lido por `sideExpandedOf`. O conteúdo principal MUST ocupar o restante da largura. O `GjaToolPage` MUST NOT desenhar separador nem fundo para o conteúdo lateral.

#### Scenario: Largura definida pelo conteúdo lateral
- **GIVEN** uma tela `medium` e um conteúdo lateral que mede 240 expandido e 48 recolhido
- **WHEN** a página é renderizada e depois `toggleSideContentMode` é chamado
- **THEN** o conteúdo lateral mede 240 e depois 48, e o conteúdo principal começa logo após ele e termina na borda final

### Requirement: [Comportamento] Conteúdo lateral na tela pequena
Na classe `small`, o conteúdo lateral expandido SHALL cobrir toda a área abaixo do cabeçalho, e o recolhido MUST sair da tela pela borda inicial. Com o conteúdo lateral expandido, o conteúdo principal MUST sair da ordem de foco e da árvore de semântica, preservando o estado.

#### Scenario: Conteúdo lateral cobre o principal
- **GIVEN** uma tela `small` com `sideExpanded` `true`
- **WHEN** a página é renderizada
- **THEN** o conteúdo lateral ocupa toda a largura abaixo do cabeçalho, e o conteúdo principal não está na árvore de semântica

#### Scenario: Conteúdo lateral recolhido fora da tela
- **GIVEN** uma tela `small` com `sideExpanded` `false`
- **WHEN** a página é renderizada
- **THEN** o conteúdo lateral não está visível, e o conteúdo principal ocupa toda a largura

#### Scenario: Estado do conteúdo principal preservado
- **GIVEN** uma tela `small` e um conteúdo principal com um contador em 3
- **WHEN** o conteúdo lateral é expandido e depois recolhido
- **THEN** o conteúdo principal volta a aparecer com o contador em 3

### Requirement: [Comportamento] Vários conteúdos principais
Os itens de `mainContents` SHALL ser empilhados na ordem da lista, dividindo a altura disponível em partes iguais. Com um só item, ele MUST ocupar toda a área principal.

#### Scenario: Dois conteúdos principais
- **GIVEN** dois conteúdos principais numa área principal de 600 de altura
- **WHEN** a página é renderizada
- **THEN** o primeiro ocupa os 300 de cima e o segundo os 300 de baixo

### Requirement: [Aparência] Tokens de componente
A página SHALL usar o fundo `colors.background`, como o `sapBackgroundColor` do ToolPage. O cabeçalho e o subcabeçalho MUST ser pintados sobre o conteúdo, para que a sombra do cabeçalho apareça sobre ele, sem valores literais.

#### Scenario: Fundo da página
- **WHEN** a página com conteúdo lateral é renderizada nos temas claro e escuro
- **THEN** a área atrás do conteúdo principal tem o fundo `colors.background` de cada tema

### Requirement: [Aparência] Movimento do conteúdo lateral
Na classe `small`, a entrada e a saída do conteúdo lateral SHALL ser animadas com `motion.long` e a curva `motion.standard`, como a transição de 0,3 s do ToolPage. Com movimento reduzido, a mudança MUST ser imediata. Nas demais classes, a mudança de largura é do próprio conteúdo lateral.

#### Scenario: Saída sem animação no movimento reduzido
- **GIVEN** o movimento reduzido ativo, numa tela `small` com o conteúdo lateral expandido
- **WHEN** `toggleSideContentMode` é chamado e um único quadro é desenhado
- **THEN** o conteúdo lateral já não está visível

### Requirement: [Estados] Sem estados próprios
`GjaToolPage` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado: os estados são dos controles que ele hospeda.

#### Scenario: Página não recebe foco
- **GIVEN** uma página com um item focável no cabeçalho e outro no conteúdo principal
- **WHEN** Tab é pressionado a partir do item do cabeçalho
- **THEN** o foco vai direto ao item do conteúdo principal

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL ser: cabeçalho, subcabeçalho, conteúdo lateral e conteúdo principal.

#### Scenario: Ordem de foco na página
- **GIVEN** uma página numa tela `large` com um item focável em cada área
- **WHEN** Tab é pressionado três vezes a partir do item do cabeçalho
- **THEN** o foco passa pelo subcabeçalho, pelo conteúdo lateral e pelo conteúdo principal, nessa ordem

### Requirement: [Acessibilidade] Semântica
A árvore de semântica SHALL seguir a mesma ordem das áreas. Com o conteúdo lateral recolhido na classe `small`, ele MUST NOT estar na árvore de semântica nem na ordem de foco.

#### Scenario: Conteúdo lateral recolhido fora da semântica
- **GIVEN** uma tela `small` com o conteúdo lateral recolhido e um item com rótulo nele
- **WHEN** a árvore de semântica é lida
- **THEN** o rótulo do item não aparece

### Requirement: [Responsividade] Tela e direção
A classe usada pela página SHALL ser a da tela, com os limiares do tema ativo, porque ela estrutura a aplicação inteira. Em RTL, o conteúdo lateral MUST ficar na borda direita e, na classe `small`, sair pela direita.

#### Scenario: Página em RTL
- **GIVEN** a direção do texto da direita para a esquerda, numa tela `large`
- **WHEN** a página com conteúdo lateral é renderizada
- **THEN** o conteúdo lateral fica na borda direita, e o conteúdo principal termina na borda esquerda

### Requirement: [Integração] Dependências
`GjaToolPage` SHALL depender somente de `gja/widgets/gja-app`, `gja/widgets/gja-container`, `gja/core/responsive`, `gja/foundation/color`, `gja/foundation/design-tokens`, `gja/foundation/breakpoints`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Página sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** uma página com cabeçalho, conteúdo lateral e conteúdo principal é a página inicial
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaToolPage` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, com o conteúdo lateral expandido, e a bateria de `gja/foundation/accessibility` aplicável: semântica e teclado. O contraste e o alvo mínimo são dos controles hospedados.

#### Scenario: Rastreabilidade da página de ferramentas
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da página de ferramentas
- **WHEN** os goldens da página com `GjaShellBar`, conteúdo lateral expandido e conteúdo principal são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaToolPage` SHALL ter dartdoc em toda API pública, com um exemplo de `GjaShellBar` cujo botão de menu chama `toggleSideContentMode`, e uma página "GjaToolPage" na galeria com uma página de demonstração com cabeçalho, conteúdo lateral e conteúdo principal.

#### Scenario: Página GjaToolPage na galeria
- **GIVEN** a galeria numa janela de 500 com a página "GjaToolPage" aberta
- **WHEN** o botão de menu da barra de demonstração é tocado
- **THEN** o conteúdo lateral de demonstração passa a cobrir o conteúdo principal

### Requirement: [Restrições] Fora do escopo
`GjaToolPage` SHALL NOT aceitar larguras, alturas ou cores literais, nem desenhar barra, navegação, separador ou fundo do conteúdo lateral. O `contentBackgroundDesign` e o recolhimento automático ao escolher um item da navegação entram com `GjaPage` e `GjaSideNavigation`.

#### Scenario: Página sem valor literal
- **WHEN** a API pública de `GjaToolPage` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem `Color`
