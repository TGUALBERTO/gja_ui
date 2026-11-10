# Spec Delta

## Purpose

`GjaBreadcrumbs` mostra o caminho até a página atual, como o `sap.m.Breadcrumbs` do SAPUI5: os níveis anteriores como links, separados por um caractere, seguidos do nome da página atual como texto, que quebram em várias linhas quando não cabem.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaBreadcrumbs` SHALL expor, como o `sap.m.Breadcrumbs`:

| Prop | Tipo | Padrão |
|---|---|---|
| `links` | `List<GjaLink>` | obrigatória |
| `currentLocationText` | `String?` | `null` |
| `separatorStyle` | `GjaBreadcrumbsSeparator` | `slash` |
| `semanticLabel` | `String?` | `null` |

`GjaBreadcrumbsSeparator` SHALL ter `slash` (`/`), `backSlash` (`\`), `doubleSlash` (`//`), `doubleBackSlash` (`\\`), `greaterThan` (`>`) e `doubleGreaterThan` (`>>`).

#### Scenario: Trilha mínima
- **WHEN** uma trilha com os links "Início" e "Pedidos" e `currentLocationText` "4711" é renderizada
- **THEN** aparecem "Início / Pedidos / 4711", nessa ordem, numa linha

### Requirement: [API] Callbacks e controlador
`GjaBreadcrumbs` SHALL NOT ter callbacks nem controlador: cada link avisa a própria ação, de `gja/widgets/gja-link`. `links` e `currentLocationText` MUST NOT estar ambos vazios, ou a renderização MUST falhar em modo debug.

#### Scenario: Trilha vazia
- **WHEN** uma `GjaBreadcrumbs` sem links e sem `currentLocationText` é renderizada
- **THEN** a renderização falha em modo debug

### Requirement: [Comportamento] Navegação pelos links
Tocar um link SHALL chamar a ação dele uma vez. A página atual SHALL NOT ser acionável.

#### Scenario: Voltar pelo link
- **GIVEN** uma trilha cujo link "Pedidos" registra as chamadas
- **WHEN** "Pedidos" e depois o texto da página atual são tocados
- **THEN** a ação de "Pedidos" é chamada uma vez, e nada mais é chamado

### Requirement: [Aparência] Tokens de componente
Os links SHALL seguir `gja/widgets/gja-link`; a página atual SHALL usar `typography.base` com `colors.text`; o separador SHALL usar `typography.base` com `colors.label`, com `spacing.xs` antes e depois. Nenhum valor MUST ser literal.

#### Scenario: Separador da trilha
- **WHEN** uma trilha com `separatorStyle` `greaterThan` é renderizada no tema claro
- **THEN** os separadores são ">" na cor `label`, e a página atual tem a cor `text`

### Requirement: [Estados] Sem estados próprios
A trilha SHALL NOT ter estados próprios; os links têm os de `gja/widgets/gja-link`, e a página atual MUST NOT receber o foco.

#### Scenario: Foco só nos links
- **GIVEN** uma trilha com dois links e a página atual
- **WHEN** Tab é pressionado três vezes a partir do elemento anterior
- **THEN** o foco passa pelos dois links e sai da trilha

### Requirement: [Acessibilidade] Semântica e contraste
A trilha SHALL agrupar os itens num nó com o nome `semanticLabel`, quando dado; os separadores MUST ficar fora da semântica, e a página atual SHALL ser lida como texto, depois dos links. O texto MUST ter o contraste de texto.

#### Scenario: Semântica da trilha
- **WHEN** a árvore de semântica de uma trilha "Início / Pedidos / 4711" é lida
- **THEN** "Início" e "Pedidos" são links, "4711" é texto, e "/" não aparece

#### Scenario: Contraste da trilha
- **WHEN** a diretriz de contraste de texto é aplicada a uma trilha nos temas claro e escuro
- **THEN** é atendida

### Requirement: [Responsividade] Quebra e direção
Quando não cabem numa linha, os itens SHALL continuar na linha seguinte, sem estouro, cada link com o separador depois dele. Em RTL, a trilha MUST começar à direita.

#### Scenario: Trilha estreita
- **WHEN** uma trilha com cinco links é renderizada numa largura de 200
- **THEN** não há estouro, e os itens ocupam mais de uma linha

#### Scenario: Trilha em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a trilha "Início / Pedidos / 4711" é renderizada
- **THEN** "Início" fica à direita de "4711"

### Requirement: [Integração] Dependências
`GjaBreadcrumbs` SHALL depender somente de `gja/widgets/gja-link`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/spacing`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Trilha sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** uma trilha de cada separador é renderizada, e um link é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaBreadcrumbs` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`.

#### Scenario: Rastreabilidade da trilha
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da trilha
- **WHEN** os goldens de trilhas com cada separador são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaBreadcrumbs` SHALL ter dartdoc em toda API pública e uma página "GjaBreadcrumbs" na galeria com uma trilha navegável e os separadores.

#### Scenario: Página GjaBreadcrumbs na galeria
- **GIVEN** a página "GjaBreadcrumbs" aberta na galeria
- **WHEN** o link "Pedidos" é tocado
- **THEN** a trilha passa a terminar em "Pedidos"

### Requirement: [Restrições] Fora do escopo
`GjaBreadcrumbs` SHALL NOT aceitar cores ou espaços literais, nem recolher os primeiros níveis num seletor quando falta largura (o comportamento do UI5), nem ter a página atual como link (`currentLocation`).

#### Scenario: Trilha sem valor literal
- **WHEN** a API pública de `GjaBreadcrumbs` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
