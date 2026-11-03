# Spec Delta

## Purpose

`RebicPanel` é o contêiner com cabeçalho do Rebic, como o `sap.m.Panel` do SAPUI5: um título e um conteúdo que, no painel expansível, abre e fecha pelo cabeçalho, no padrão controlado (`expanded` + `onExpand`). Painéis expansíveis empilhados formam o acordeão do Fiori.

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicPanel` SHALL expor, como o `sap.m.Panel`:

| Prop | Tipo | Padrão |
|---|---|---|
| `headerText` | `String?` | `null` |
| `content` | `List<Widget>` | `[]` |
| `expandable` | `bool` | `false` |
| `expanded` | `bool` | `false` |
| `onExpand` | `ValueChanged<bool>?` | `null` |
| `backgroundDesign` | `RebicPanelBackgroundDesign` | `solid` |

#### Scenario: Painel mínimo
- **WHEN** um painel com o título "Endereço" e o texto "Rua A, 10" é renderizado
- **THEN** o título fica acima do texto, sem seta, e o texto aparece

### Requirement: [API] Título obrigatório no expansível
Um painel com `expandable` `true` MUST ter `headerText` não vazio, ou a renderização MUST falhar em modo debug. Sem `headerText`, o painel fixo SHALL NOT ter cabeçalho.

#### Scenario: Painel expansível sem título
- **WHEN** um painel expansível sem `headerText` é renderizado
- **THEN** a renderização falha em modo debug

### Requirement: [API] Callbacks e controlador
Num painel expansível, acionar o cabeçalho (toque, Enter ou Espaço) SHALL chamar `onExpand` com o estado oposto a `expanded`, como o evento `expand`. O painel MUST NOT abrir ou fechar sozinho; sem `onExpand`, o cabeçalho fica desabilitado. `RebicPanel` SHALL NOT ter controlador.

#### Scenario: Expandir o painel
- **GIVEN** um painel expansível fechado cujo `onExpand` atualiza `expanded`
- **WHEN** o cabeçalho é tocado
- **THEN** `onExpand` recebe `true`, e o conteúdo aparece

### Requirement: [Comportamento] Conteúdo recolhido
Fechado, o painel expansível SHALL mostrar só o cabeçalho; o conteúdo MUST sair da semântica e do foco, mas manter o estado. O conteúdo SHALL abrir e fechar com `motion.medium` e a curva `motion.standard`, de forma imediata com movimento reduzido.

#### Scenario: Painel recolhido
- **GIVEN** um painel expansível fechado com o texto "Detalhes"
- **WHEN** ele é renderizado
- **THEN** só o cabeçalho tem altura, e "Detalhes" não está na árvore de semântica

#### Scenario: Teclado no painel
- **GIVEN** o foco no cabeçalho de um painel expansível fechado
- **WHEN** Enter é pressionado
- **THEN** `onExpand` recebe `true`

### Requirement: [Aparência] Tokens de componente
O cabeçalho SHALL ter a altura `density.listItemHeight`, `spacing.l` nas laterais (`spacing.s` no início do expansível, com a seta `icons.control` e `spacing.s` antes do título), o título `typography.header6` com `colors.text` e, com o conteúdo visível, a borda inferior `colors.separator`. O conteúdo SHALL ter `spacing.l` em volta. O fundo SHALL ser `colors.base` (`solid`) ou nenhum (`transparent`).

#### Scenario: Cabeçalho do painel
- **WHEN** um painel aberto é renderizado no tema claro
- **THEN** o cabeçalho tem a altura `listItemHeight` e o título o estilo `header6`, e o painel tem o fundo `base`

### Requirement: [Estados] Interação
O cabeçalho do painel expansível SHALL apresentar hover (fundo `colors.hoverBackground`), pressionado, foco pelo teclado e desabilitado, de `rebic/core/interaction`.

#### Scenario: Cabeçalho em hover
- **WHEN** o ponteiro passa sobre o cabeçalho de um painel expansível
- **THEN** o cabeçalho tem o fundo `hoverBackground`

### Requirement: [Acessibilidade] Semântica e contraste
O cabeçalho do painel expansível SHALL ser exposto como botão com o título e o estado aberto ou fechado; o do painel fixo, como cabeçalho com o título. Os textos MUST ter o contraste de texto, e o cabeçalho o alvo mínimo.

#### Scenario: Semântica do painel
- **WHEN** a árvore de semântica de um painel expansível fechado "Pagamento" é lida
- **THEN** "Pagamento" é botão com o estado de expansão fechado

#### Scenario: Contraste e alvo do painel
- **WHEN** as diretrizes de contraste de texto e de alvo mínimo são aplicadas a painéis aberto e fechado, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Largura e direção
O painel SHALL ocupar a largura disponível. Em RTL, a seta MUST ficar à direita do título e apontar para a esquerda quando fechado.

#### Scenario: Painel em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um painel expansível é renderizado
- **THEN** a seta fica à direita do título

### Requirement: [Integração] Dependências
`RebicPanel` SHALL depender somente de `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/density`, `rebic/foundation/design-tokens`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Painel sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** um painel expansível com um campo é aberto e fechado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicPanel` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do painel
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do painel
- **WHEN** os goldens de um painel fixo, de um expansível aberto e de um fechado são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicPanel` SHALL ter dartdoc em toda API pública e uma página "RebicPanel" na galeria com um painel fixo e um acordeão de painéis expansíveis.

#### Scenario: Página RebicPanel na galeria
- **GIVEN** a página "RebicPanel" aberta na galeria
- **WHEN** o cabeçalho "Pagamento" do acordeão é tocado
- **THEN** a página mostra "Boleto em 30 dias"

### Requirement: [Restrições] Fora do escopo
`RebicPanel` SHALL NOT aceitar larguras, alturas ou cores literais, nem ter `headerToolbar`, `infoToolbar`, `stickyHeader` ou o fundo `Translucent`.

#### Scenario: Painel sem valor literal
- **WHEN** a API pública de `RebicPanel` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
