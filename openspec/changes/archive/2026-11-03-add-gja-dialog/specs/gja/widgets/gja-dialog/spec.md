# Spec Delta

## Purpose

`GjaDialog` é o diálogo modal do GJA, como o `sap.m.Dialog` do SAPUI5: um painel sobre a tela com título (e o ícone do estado nas mensagens), conteúdo rolável e botões no rodapé, aberto pelo modal de `gja/core/overlay`, que bloqueia a tela, prende o foco e fecha com Esc.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaDialog` SHALL expor, como o `sap.m.Dialog`:

| Prop | Tipo | Padrão |
|---|---|---|
| `content` | `Widget` | obrigatória |
| `title` | `String?` | `null` |
| `semanticLabel` | `String?` | `null` |
| `state` | `GjaValueState` | `none` |
| `beginButton` | `GjaButton?` | `null` |
| `endButton` | `GjaButton?` | `null` |
| `buttons` | `List<GjaButton>` | `[]` |
| `width` | `GjaDialogWidth` | `standard` |

`GjaDialogWidth` SHALL ter `standard` e `wide`.

#### Scenario: Diálogo mínimo
- **WHEN** `GjaDialog.open` abre um `GjaDialog(title: 'Excluir pedido', content: …, endButton: …)`
- **THEN** o painel aparece centralizado sobre a camada de bloqueio, com o título no topo, o conteúdo e o botão no rodapé

### Requirement: [API] Nome válido
O diálogo MUST ter `title` ou `semanticLabel` não vazio, ou a criação MUST falhar em modo debug.

#### Scenario: Diálogo sem nome
- **WHEN** um `GjaDialog` é criado sem `title` nem `semanticLabel`
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
`GjaDialog.open<T>(context, builder:, dismissible:)` SHALL abrir o diálogo com `GjaModal.show` de `gja/core/overlay` e devolver o resultado passado a `Navigator.pop`. O diálogo SHALL NOT ter callbacks próprios: os botões fecham com `Navigator.of(context).pop(resultado)`.

#### Scenario: Resultado do diálogo
- **GIVEN** um diálogo aberto cujo botão "Excluir" fecha com `true`
- **WHEN** "Excluir" é tocado
- **THEN** o diálogo fecha, e `open` devolve `true`

### Requirement: [Comportamento] Fechar com Esc
Com `dismissible` (padrão `true`), Esc SHALL fechar o diálogo com resultado nulo; sem ele, Esc MUST ser ignorado, como o `escapeHandler` do UI5. Tocar a camada de bloqueio MUST NOT fechar o diálogo.

#### Scenario: Esc no diálogo
- **GIVEN** um diálogo aberto com `dismissible` e outro sem
- **WHEN** Esc é pressionado em cada um
- **THEN** o primeiro fecha com resultado nulo, e o segundo continua aberto

### Requirement: [Comportamento] Rodapé e rolagem
O rodapé SHALL mostrar `buttons`, `beginButton` e `endButton`, nessa ordem, junto da borda final, quebrando para a linha seguinte quando não couberem. O conteúdo SHALL rolar quando passar da altura disponível, mantendo o título e o rodapé visíveis.

#### Scenario: Conteúdo longo
- **GIVEN** uma tela de 400 de altura e um diálogo com conteúdo de 1000
- **WHEN** ele é aberto
- **THEN** o painel cabe na tela, o título e o rodapé ficam visíveis, e o conteúdo rola

### Requirement: [Aparência] Tokens de componente
O painel SHALL usar a superfície `colors.base`, o raio `radius.element`, a sombra `shadows.dialog`, a largura de 8 (`standard`) ou 12 (`wide`) passos `spacing.xxxl`, limitada à largura da tela menos `spacing.l` de cada lado. O título SHALL usar o estilo `h4` com `spacing.l` em volta, separado do conteúdo por `GjaSeparator`; o conteúdo, `spacing.l`; e o rodapé, `spacing.s`, com `spacing.xs` entre os botões. Com `state`, um ícone do estado na cor `foreground` dele SHALL vir antes do título.

#### Scenario: Diálogo de erro
- **WHEN** um diálogo com `state` `error` é aberto no tema claro
- **THEN** o ícone `error` na cor `foreground` de `stateColors(error)` vem antes do título, e o painel tem o fundo `base`, a sombra `dialog` e a largura de 8 passos `spacing.xxxl`

### Requirement: [Estados] Foco preso
Enquanto aberto, o foco SHALL ficar preso no diálogo e voltar a quem o abriu ao fechar, e o conteúdo abaixo MUST NOT receber toques nem semântica, conforme `gja/core/overlay`.

#### Scenario: Foco no diálogo
- **GIVEN** um botão que abre um diálogo com dois botões
- **WHEN** o diálogo abre, Tab é pressionado três vezes, e ele é fechado
- **THEN** o foco circula só pelos botões do diálogo e volta ao botão que o abriu

### Requirement: [Acessibilidade] Semântica e contraste
O painel SHALL ser exposto como rota com o nome `title` (ou `semanticLabel`); o título SHALL ser cabeçalho. Os textos MUST ter o contraste de texto, e os botões o alvo mínimo, conforme `gja/foundation/accessibility`.

#### Scenario: Semântica do diálogo
- **WHEN** a árvore de semântica de um diálogo aberto "Excluir pedido" é lida
- **THEN** há uma rota com o nome "Excluir pedido", o título é cabeçalho, e a página abaixo não aparece

#### Scenario: Contraste do diálogo
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a um diálogo aberto, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Largura e direção
Numa tela mais estreita que a largura do painel, ele SHALL ocupar a largura da tela menos `spacing.l` de cada lado. Em RTL, o ícone do estado MUST ficar à direita do título, e os botões junto da borda esquerda.

#### Scenario: Diálogo em tela estreita
- **GIVEN** uma tela de 320 de largura
- **WHEN** um diálogo `standard` é aberto
- **THEN** o painel mede 320 − 2 × `spacing.l` de largura

### Requirement: [Integração] Dependências
`GjaDialog` SHALL depender somente de `gja/core/overlay`, `gja/widgets/gja-button`, `gja/widgets/gja-container`, `gja/widgets/gja-title`, `gja/widgets/gja-separator`, `gja/widgets/gja-spacing`, `gja/foundation/color`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/shadows`, `gja/foundation/iconography`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Diálogo sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** um diálogo com estado e botões é aberto e fechado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaDialog` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `gja/foundation/accessibility` aplicável.

#### Scenario: Rastreabilidade do diálogo
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do diálogo
- **WHEN** os goldens de um diálogo padrão e de um de erro abertos são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`GjaDialog` SHALL ter dartdoc em toda API pública e uma página "GjaDialog" na galeria com um diálogo de confirmação que mostra o resultado e um diálogo de erro.

#### Scenario: Página GjaDialog na galeria
- **GIVEN** a página "GjaDialog" aberta na galeria
- **WHEN** "Excluir pedido" é tocado, e o diálogo é confirmado
- **THEN** a página mostra "Pedido excluído"

### Requirement: [Restrições] Fora do escopo
`GjaDialog` SHALL NOT aceitar larguras ou alturas literais, nem ser arrastável, redimensionável, em tela cheia (`stretch`) ou ter `subHeader` e `customHeader`.

#### Scenario: Diálogo sem valor literal
- **WHEN** a API pública de `GjaDialog` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
