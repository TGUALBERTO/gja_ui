# Spec Delta

## Purpose

`RebicMessageStrip` mostra uma mensagem curta dentro da página, como o `sap.m.MessageStrip` do SAPUI5: uma faixa com o texto, as cores do tipo da mensagem, ícone opcional, link opcional e botão de fechar opcional.

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicMessageStrip` SHALL expor, como o `sap.m.MessageStrip`:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String` | obrigatória |
| `type` | `RebicValueState` | `information` |
| `showIcon` | `bool` | `false` |
| `showCloseButton` | `bool` | `false` |
| `onClose` | `VoidCallback?` | `null` |
| `link` | `RebicLink?` | `null` |

#### Scenario: Faixa mínima
- **WHEN** `RebicMessageStrip(text: 'Pedido salvo')` é renderizada numa largura de 400
- **THEN** ela ocupa os 400, com o texto em `typography.base` e as cores do tipo `information`

### Requirement: [API] Texto válido
`text` MUST NOT ser vazio, ou a criação MUST falhar em modo debug.

#### Scenario: Faixa sem texto
- **WHEN** uma `RebicMessageStrip` é criada com `text` vazio
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
Com `showCloseButton`, o botão de fechar SHALL chamar `onClose` uma vez por ativação, como o evento `close`. A faixa MUST NOT se esconder sozinha: o pai a remove. `RebicMessageStrip` SHALL NOT ter controlador.

#### Scenario: Fechar a faixa
- **GIVEN** uma faixa com `showCloseButton` cujo `onClose` a remove
- **WHEN** o botão de fechar é tocado
- **THEN** `onClose` é chamado uma vez, e a faixa some

### Requirement: [Comportamento] Ícone e link
Com `showIcon`, a faixa SHALL mostrar antes do texto o ícone do tipo: `information` e `none` com `RebicIcons.information`, `success` com `sysEnter2`, `warning` com `warning` e `error` com `error`. O `link` SHALL vir depois do texto, na mesma linha quando couber.

#### Scenario: Faixa com ícone e link
- **WHEN** uma faixa `error` com `showIcon` e um `link` é renderizada
- **THEN** o ícone `error` vem antes do texto, e o link depois

### Requirement: [Aparência] Tokens de componente
A faixa SHALL usar o fundo `background`, a borda fina `border` e, no ícone, a cor `foreground` de `colors.stateColors(type)`; o texto `typography.base` com `colors.text`; o raio `radius.popover`; o espaço interno `spacing.l` nas laterais e `spacing.s` em cima e embaixo; e `spacing.xs` entre o ícone, o texto e o link. O botão de fechar SHALL ser um `RebicButton` só com o ícone `decline`, `transparent`, com a dica `close` de `rebic/core/localization`.

#### Scenario: Cores por tipo
- **WHEN** uma faixa de cada tipo é renderizada no tema claro
- **THEN** cada uma tem o fundo e a borda de `stateColors` do seu tipo

### Requirement: [Estados] Sem estados próprios
A faixa SHALL NOT ter estados de interação próprios; o link e o botão de fechar têm os seus, de `rebic/widgets/rebic-link` e `rebic/widgets/rebic-button`.

#### Scenario: Faixa sem foco próprio
- **GIVEN** uma faixa sem link nem botão de fechar entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai direto ao segundo

### Requirement: [Acessibilidade] Semântica e contraste
A faixa SHALL ser exposta como um nó com o texto e como região viva (`liveRegion`), para o leitor de tela anunciar a mensagem quando ela aparece; o ícone MUST ficar fora da semântica. O texto MUST ter o contraste de texto sobre o fundo de cada tipo, nos temas claro e escuro.

#### Scenario: Semântica da faixa
- **WHEN** a árvore de semântica de uma faixa "Pedido salvo" é lida
- **THEN** há um nó com o rótulo "Pedido salvo", marcado como região viva

#### Scenario: Contraste da faixa
- **WHEN** a diretriz de contraste de texto e a de alvo mínimo são aplicadas a faixas de cada tipo, com botão de fechar, nos temas claro e escuro e nas duas densidades
- **THEN** são atendidas

### Requirement: [Responsividade] Quebra e direção
O texto SHALL quebrar em várias linhas quando não cabe, e a faixa SHALL crescer em altura. Em RTL, o ícone MUST ficar à direita do texto, e o botão de fechar à esquerda.

#### Scenario: Faixa estreita
- **WHEN** uma faixa com um texto longo é renderizada numa largura de 200
- **THEN** o texto ocupa mais de uma linha, e não há estouro

#### Scenario: Faixa em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** uma faixa com `showIcon` e `showCloseButton` é renderizada
- **THEN** o ícone fica à direita do texto, e o botão de fechar no lado esquerdo

### Requirement: [Integração] Dependências
`RebicMessageStrip` SHALL depender somente de `rebic/widgets/rebic-button`, `rebic/widgets/rebic-link`, `rebic/core/localization`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Faixa sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** faixas de cada tipo, com ícone, link e botão de fechar, são renderizadas e o botão é tocado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicMessageStrip` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`.

#### Scenario: Rastreabilidade da faixa
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens da faixa
- **WHEN** os goldens de faixas de cada tipo, com ícone, com link e com botão de fechar são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicMessageStrip` SHALL ter dartdoc em toda API pública e uma página "RebicMessageStrip" na galeria com uma faixa de cada tipo, uma com link e uma que pode ser fechada.

#### Scenario: Página RebicMessageStrip na galeria
- **GIVEN** a página "RebicMessageStrip" aberta na galeria
- **WHEN** o botão de fechar da faixa que pode ser fechada é tocado
- **THEN** a faixa some

### Requirement: [Restrições] Fora do escopo
`RebicMessageStrip` SHALL NOT aceitar cores literais, nem ter `customIcon`, `colorSet`, `colorScheme` ou texto formatado (`enableFormattedText`).

#### Scenario: Faixa sem valor literal
- **WHEN** a API pública de `RebicMessageStrip` é inspecionada
- **THEN** não há parâmetro do tipo `Color` ou `double`
