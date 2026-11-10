## Purpose

`GjaApp` é a raiz de uma aplicação GJA, como o `sap.m.App` do SAPUI5: monta a aplicação sobre `WidgetsApp` sem Material e aplica, numa única declaração, o tema claro ou escuro (com o modo do sistema), a densidade, a localização, o escopo de tela, o fundo e a transição de página.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaApp` SHALL repassar ao `WidgetsApp`, com os mesmos tipos e padrões: `home`, `routes`, `initialRoute`, `onGenerateRoute`, `onUnknownRoute`, `navigatorKey`, `navigatorObservers`, `title`, `builder`, `locale`, `localizationsDelegates` e `debugShowCheckedModeBanner`. `GjaApp.router` SHALL aceitar `routerConfig` no lugar das propriedades de rota.

#### Scenario: Uso mínimo
- **GIVEN** `GjaApp` só com `home`
- **WHEN** `home` lê o tema e os textos ativos
- **THEN** recebe o tema claro de referência com a densidade recomendada pela plataforma, e os textos do idioma resolvido

#### Scenario: Aplicação com Router
- **GIVEN** `GjaApp.router` com um `routerConfig` que exibe uma página inicial
- **WHEN** a aplicação é renderizada
- **THEN** a página inicial aparece com o tema e os textos ativos

### Requirement: [API] Tema, densidade e idioma
`GjaApp` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `theme` | `GjaThemeData?` | claro de referência |
| `darkTheme` | `GjaThemeData?` | escuro de referência |
| `themeMode` | `GjaThemeMode` | `system` |
| `density` | `GjaDensity?` | recomendada pela plataforma |
| `supportedLocales` | `Iterable<Locale>?` | idiomas do GJA |

#### Scenario: Valores padrão
- **GIVEN** o sistema em modo claro e `GjaApp` sem tema, densidade nem idiomas
- **WHEN** a página lê o tema e os idiomas suportados
- **THEN** recebe o claro de referência e os idiomas pt-BR e en

### Requirement: [API] Callbacks e controlador
`GjaApp` SHALL NOT ter callbacks próprios nem controlador. A navegação usa o `Navigator` ou o `Router` nativos, e as trocas de tema, de densidade e de idioma acontecem reconstruindo `GjaApp` com outros valores.

#### Scenario: Navegação nativa
- **GIVEN** `GjaApp` com as rotas `/` e `/detalhe`
- **WHEN** `Navigator.pushNamed(context, '/detalhe')` é chamado e a transição termina
- **THEN** a página de detalhe é exibida e `Navigator.pop` volta à inicial

### Requirement: [Comportamento] Tema e modo do sistema
`GjaApp` SHALL publicar `theme` quando `themeMode` é `light`, `darkTheme` quando é `dark` e, quando é `system`, o tema que corresponde ao brilho do sistema operacional. A troca de brilho do sistema no modo `system` MUST trocar o tema publicado sem reconstruir a navegação.

#### Scenario: Modo do sistema
- **GIVEN** `GjaApp` com `themeMode` `system` e o sistema em modo claro
- **WHEN** o sistema passa para o modo escuro e a transição de tema termina
- **THEN** o tema publicado é `darkTheme`, e a rota atual continua a mesma

#### Scenario: Modo fixo
- **GIVEN** o sistema em modo escuro
- **WHEN** `GjaApp` é criado com `themeMode` `light`
- **THEN** o tema publicado é `theme`

### Requirement: [Comportamento] Densidade da aplicação
`GjaApp` SHALL aplicar `density` ao tema publicado ou, sem ela, a densidade recomendada pela plataforma de `gja/core/responsive`. A densidade MUST valer igualmente para `theme` e `darkTheme`.

#### Scenario: Densidade recomendada
- **GIVEN** a plataforma Windows e `GjaApp` sem `density`
- **WHEN** uma página lê o tema
- **THEN** a densidade é compacta; com a plataforma Android, é confortável

#### Scenario: Densidade informada
- **GIVEN** a plataforma Windows
- **WHEN** `GjaApp` é criado com `density` `comfortable`
- **THEN** a densidade publicada é confortável

### Requirement: [Comportamento] Localização da aplicação
`GjaApp` SHALL registrar os delegates da aplicação seguidos do delegate de `gja/core/localization`, e usar como idiomas suportados os informados ou, sem eles, os do GJA. `locale` informado MUST fixar o idioma.

#### Scenario: Idioma fixado
- **GIVEN** o dispositivo em pt-BR
- **WHEN** `GjaApp` é criado com `locale` en
- **THEN** os textos do framework são os de en

### Requirement: [Comportamento] Transição de página
`GjaApp` SHALL navegar entre páginas com uma rota sem Material: a página nova desliza do lado final (direita em LTR, esquerda em RTL) durante a duração `medium` do movimento do tema, com a curva `standard`, e volta pelo mesmo caminho ao sair. Com o movimento reduzido, a transição MUST ser imediata.

#### Scenario: Meio da transição
- **GIVEN** `GjaApp` em LTR com uma rota `/detalhe`
- **WHEN** a rota é aberta e passa metade da duração `medium`
- **THEN** a página de detalhe está deslocada para a direita, entre a borda e a posição final

#### Scenario: Movimento reduzido
- **GIVEN** o sistema com animações desligadas
- **WHEN** a rota `/detalhe` é aberta
- **THEN** no quadro seguinte ela já está na posição final

### Requirement: [Aparência] Fundo da aplicação
`GjaApp` SHALL pintar, atrás de todas as rotas, a cor `background` do tema ativo, e SHALL usar a cor `brand` como cor da aplicação para o sistema operacional. Nenhuma cor MUST vir de literal.

#### Scenario: Troca de tema
- **GIVEN** `GjaApp` com `themeMode` `light`
- **WHEN** ele é reconstruído com `themeMode` `dark` e a transição de tema termina
- **THEN** o fundo pintado é o `background` do tema escuro

### Requirement: [Estados] Sem estados visuais
`GjaApp` SHALL NOT apresentar estados de interação (hover, foco, pressionado, selecionado ou desabilitado), porque não é interativo.

#### Scenario: Não recebe foco
- **GIVEN** `GjaApp` com uma página de dois elementos focáveis
- **WHEN** Tab é pressionado três vezes a partir do primeiro elemento
- **THEN** o foco alterna entre os dois elementos, sem parada no próprio `GjaApp`

### Requirement: [Acessibilidade] Teclado e foco
`GjaApp` SHALL manter os atalhos de teclado nativos do `WidgetsApp` (Tab, Shift+Tab, Enter, Espaço, Esc e setas) para toda a aplicação.

#### Scenario: Esc dispensa um modal
- **GIVEN** um modal dispensável aberto numa página de `GjaApp`
- **WHEN** Esc é pressionado
- **THEN** o modal fecha

### Requirement: [Acessibilidade] Semântica, escala e movimento
`GjaApp` SHALL expor `title` como título da aplicação, preservar a escala de texto do sistema e respeitar o movimento reduzido na troca de tema e na transição de página, conforme `gja/foundation/accessibility`.

#### Scenario: Escala de texto preservada
- **GIVEN** o sistema com escala de texto 2,0
- **WHEN** uma página de `GjaApp` lê a escala de texto
- **THEN** ela é 2,0

### Requirement: [Responsividade] Escopo de tela e plataformas
`GjaApp` SHALL envolver as rotas no escopo de tela de `gja/core/responsive`, com os limiares do tema ativo, para que a classe de tamanho da tela seja publicada a toda a aplicação. A mesma configuração MUST funcionar em web, desktop e mobile.

#### Scenario: Densidade compacta
- **GIVEN** `GjaApp` com `density` `compact`
- **WHEN** um elemento interativo do núcleo é renderizado numa página sem alvo mínimo informado
- **THEN** ele usa o alvo mínimo compacto, e a classe da tela está publicada para a página

### Requirement: [Integração] Dependências
`GjaApp` SHALL depender somente de `gja/widgets/gja-theme`, `gja/core/localization`, `gja/core/interaction`, `gja/core/overlay` e `gja/core/responsive`, e dos mecanismos nativos do Flutter (`WidgetsApp`, `Navigator`, `Router`).

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** uma página com texto, um elemento interativo do núcleo e um modal é renderizada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaApp` MUST ter um teste de widget por cenário. Por não ter aparência própria além do fundo, os goldens e a bateria de acessibilidade de `gja/foundation/accessibility` não se aplicam ao próprio widget, e SHALL NOT ser exigidos dele.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaApp` SHALL ter dartdoc em toda API pública, com um exemplo de aplicação mínima. A galeria SHALL usar `GjaApp` como raiz e permitir escolher o modo de tema (sistema, claro, escuro) e a densidade no índice.

#### Scenario: Página na galeria
- **WHEN** a galeria é aberta e o modo de tema escuro é escolhido no índice
- **THEN** o fundo da galeria passa a ser o `background` do tema escuro

### Requirement: [Restrições] Fora do escopo
`GjaApp` SHALL NOT criar barra de navegação, menu lateral ou cabeçalho, e SHALL NOT usar `MaterialApp`, `CupertinoApp` ou rotas do Material. Ele SHALL NOT persistir as escolhas de tema, densidade ou idioma.

#### Scenario: Sem estrutura de página
- **WHEN** `GjaApp` é criado com uma página vazia em `home`
- **THEN** a árvore não contém nenhum widget de navegação ou cabeçalho do framework, só a página
