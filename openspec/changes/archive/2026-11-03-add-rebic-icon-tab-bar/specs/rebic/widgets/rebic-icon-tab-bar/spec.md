# Spec Delta

## Purpose

`RebicIconTabBar` organiza conteúdo em abas, como o `sap.m.IconTabBar` do SAPUI5: um cabeçalho com as abas (texto, ícone e contagem opcionais), a aba escolhida destacada e, abaixo, o conteúdo dela, no padrão controlado (`selectedKey` + `onSelect`).

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicIconTabBar<T>` SHALL expor, como o `sap.m.IconTabBar`:

| Prop | Tipo | Padrão |
|---|---|---|
| `items` | `List<RebicIconTabFilter<T>>` | obrigatória |
| `selectedKey` | `T?` | `null` (a primeira aba habilitada) |
| `onSelect` | `ValueChanged<T>?` | `null` |
| `applyContentPadding` | `bool` | `true` |

`RebicIconTabFilter<T>`, como o `sap.m.IconTabFilter`, SHALL ter `key` (`T`), `text` (`String`), `icon` (`IconData?`), `count` (`String?`), `enabled` (padrão `true`) e `content` (`Widget?`).

#### Scenario: Abas mínimas
- **WHEN** uma barra com as abas "Itens", "Notas" e "Anexos" e `selectedKey` da segunda é renderizada
- **THEN** as três abas ficam lado a lado no cabeçalho, "Notas" está destacada, e o conteúdo de "Notas" aparece abaixo

### Requirement: [API] Abas válidas
`items` MUST NOT ser vazia, as chaves MUST ser distintas, e os textos MUST NOT ser vazios, ou a renderização MUST falhar em modo debug.

#### Scenario: Abas com chave repetida
- **WHEN** uma barra com duas abas de mesma chave é renderizada
- **THEN** a renderização falha em modo debug

### Requirement: [API] Callbacks e controlador
Escolher uma aba habilitada diferente da atual (toque, Enter ou Espaço) SHALL chamar `onSelect` com a chave dela, como o evento `select`. A barra MUST NOT mudar sozinha. Abas com `enabled` `false` MUST NOT ser escolhidas. `RebicIconTabBar` SHALL NOT ter controlador.

#### Scenario: Trocar de aba
- **GIVEN** uma barra cujo `onSelect` atualiza `selectedKey`
- **WHEN** a aba "Anexos" é tocada
- **THEN** `onSelect` recebe a chave de "Anexos", e o conteúdo de "Anexos" passa a aparecer

### Requirement: [Comportamento] Teclado
Tab SHALL entrar no cabeçalho pela aba escolhida e sair dele no Tab seguinte. As setas para a direita e para a esquerda SHALL mover o foco à aba habilitada seguinte ou anterior, voltando nas pontas, sem escolher; Enter e Espaço SHALL escolher a aba com o foco, como no UI5.

#### Scenario: Setas no cabeçalho
- **GIVEN** o foco na primeira aba, com a segunda desabilitada
- **WHEN** a seta para a direita é pressionada e depois Enter
- **THEN** o foco vai à terceira aba, e `onSelect` recebe a chave dela

### Requirement: [Aparência] Tokens de componente
Cada aba SHALL ter a altura `density.barHeight`, o espaço horizontal `spacing.l` e o texto `typography.base`, com o ícone antes do texto (`icons.control`) e a contagem depois, entre parênteses, na cor `colors.label`. A aba escolhida SHALL ter o texto e o ícone em `colors.brand` e um traço `colors.brand` de altura `spacing.xxs` na base; as demais, `colors.text`. O cabeçalho SHALL ter a borda inferior fina `colors.separator`, e o conteúdo `spacing.l` em volta com `applyContentPadding`.

#### Scenario: Aba escolhida
- **WHEN** uma barra com a aba "Notas" escolhida é renderizada no tema claro
- **THEN** o texto de "Notas" é `brand` com o traço `brand` na base, e o texto das outras é `text`

### Requirement: [Estados] Interação
As abas SHALL apresentar hover (fundo `colors.hoverBackground`), pressionado, foco pelo teclado (anel de foco) e desabilitado (opacidade `interaction.disabledOpacity`), de `rebic/core/interaction`.

#### Scenario: Aba desabilitada
- **GIVEN** uma aba com `enabled` `false`
- **WHEN** ela é tocada
- **THEN** `onSelect` não é chamado, e ela tem a opacidade `interaction.disabledOpacity`

### Requirement: [Acessibilidade] Semântica e contraste
Cada aba SHALL ser exposta como botão com o rótulo do texto (e da contagem), o estado selecionado e o habilitado. Os textos MUST ter o contraste de texto, e as abas o alvo mínimo da densidade.

#### Scenario: Semântica das abas
- **WHEN** a árvore de semântica de uma barra com "Notas" escolhida é lida
- **THEN** "Notas" é botão selecionado, e "Itens" é botão não selecionado

#### Scenario: Contraste e alvo das abas
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a uma barra, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Rolagem e direção
Quando as abas não cabem, o cabeçalho SHALL rolar na horizontal, sem estouro. Em RTL, a primeira aba MUST ficar à direita.

#### Scenario: Muitas abas
- **WHEN** uma barra com dez abas é renderizada numa largura de 300
- **THEN** não há estouro, e o cabeçalho rola na horizontal

#### Scenario: Abas em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** a barra "Itens", "Notas", "Anexos" é renderizada
- **THEN** "Itens" fica à direita de "Anexos"

### Requirement: [Integração] Dependências
`RebicIconTabBar` SHALL depender somente de `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Abas sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** uma barra com ícones e contagens é renderizada e as abas são tocadas
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicIconTabBar` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade das abas
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens das abas
- **WHEN** os goldens de uma barra de texto e de uma com ícones, contagens e uma aba desabilitada são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicIconTabBar` SHALL ter dartdoc em toda API pública e uma página "RebicIconTabBar" na galeria com abas de texto e abas com ícone e contagem.

#### Scenario: Página RebicIconTabBar na galeria
- **GIVEN** a página "RebicIconTabBar" aberta na galeria
- **WHEN** a aba "Anexos" é tocada
- **THEN** o conteúdo de "Anexos" aparece

### Requirement: [Restrições] Fora do escopo
`RebicIconTabBar` SHALL NOT aceitar cores ou tamanhos literais, nem ter abas aninhadas, menu de abas que não cabem (overflow), reordenação, `expandable`, `headerMode` `Inline` ou `iconColor`.

#### Scenario: Abas sem valor literal
- **WHEN** a API pública de `RebicIconTabBar` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
