# rebic/widgets/rebic-avatar Specification

## Purpose

`RebicAvatar` representa uma pessoa ou um objeto, como o `sap.m.Avatar` do SAPUI5: uma imagem, as iniciais ou um ícone, em forma circular ou quadrada, em cinco tamanhos fixos, com fallback quando a imagem falha, opcionalmente clicável e anunciado ao leitor de tela pelo nome.

## Requirements

### Requirement: [API] Propriedades
`RebicAvatar` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `image` | `ImageProvider?` | `null` |
| `initials` | `String?` | `null` |
| `icon` | `IconData?` | `null` (ícone `user`) |
| `size` | `RebicAvatarSize` | `s` |
| `shape` | `RebicAvatarShape` | `circle` |
| `semanticLabel` | `String?` | `null` (as iniciais) |
| `onPressed` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Avatar com iniciais
- **WHEN** `RebicAvatar(initials: 'mb')` é renderizado
- **THEN** ele é um círculo de lado 1,5 × `icons.xLarge`, com o fundo `colors.selectionBackground` e "MB" em `colors.brand`

#### Scenario: Avatar com imagem
- **GIVEN** uma imagem que carrega com sucesso
- **WHEN** `RebicAvatar(image: imagem, initials: 'MB')` é renderizado
- **THEN** a imagem preenche o círculo, recortada, e as iniciais não aparecem

### Requirement: [API] Iniciais válidas
`initials`, quando informadas, MUST ter de 1 a 3 caracteres. Fora disso, MUST falhar em modo debug com mensagem que cita as iniciais.

#### Scenario: Iniciais longas
- **WHEN** um `RebicAvatar` é criado com `initials` "ABCD"
- **THEN** a criação falha em modo debug com mensagem que cita "ABCD"

### Requirement: [API] Callbacks e controlador
Com `onPressed`, o avatar SHALL ser ativo e chamar `onPressed` uma vez por ativação por toque, Enter ou Espaço. Sem `onPressed`, MUST NOT receber o foco nem reagir ao ponteiro. `RebicAvatar` SHALL NOT ter controlador.

#### Scenario: Avatar ativo
- **WHEN** um avatar com `onPressed` é tocado e, com o foco nele, Enter é pressionado
- **THEN** `onPressed` é chamado duas vezes

#### Scenario: Avatar inativo
- **GIVEN** um avatar sem `onPressed` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no avatar

### Requirement: [Comportamento] Ordem e fallback
O avatar SHALL mostrar, nesta ordem de preferência: a imagem, as iniciais, o `icon` e, sem nenhum deles, o ícone `user` do catálogo. Quando a imagem falha ao carregar, MUST mostrar as iniciais ou o ícone, como se não houvesse imagem.

#### Scenario: Imagem com erro mostra as iniciais
- **GIVEN** uma imagem que falha ao carregar e as iniciais "MB"
- **WHEN** o avatar é renderizado e a falha é notificada
- **THEN** "MB" aparece, e não há exceção

#### Scenario: Avatar sem conteúdo mostra o ícone padrão
- **WHEN** `RebicAvatar()` é renderizado
- **THEN** ele mostra o ícone `user` em `colors.brand`

### Requirement: [Aparência] Tamanhos
Os lados SHALL ser 1×, 1,5×, 2×, 2,5× e 3,5× `icons.xLarge` para `xs`, `s`, `m`, `l` e `xl`. As iniciais SHALL usar `typography.label`, `subtitle`, `title`, `headline` e `display`, respectivamente, e o ícone metade do lado.

#### Scenario: Lados por tamanho
- **WHEN** um avatar de cada tamanho é renderizado
- **THEN** os lados são 1×, 1,5×, 2×, 2,5× e 3,5× `icons.xLarge`, nessa ordem

### Requirement: [Aparência] Forma e cores
O avatar `circle` SHALL ser um círculo, e o `square` SHALL ter raio `radius.s`. O fundo SHALL ser `colors.selectionBackground`, e as iniciais e o ícone `colors.brand`. A imagem MUST ser recortada pela forma.

#### Scenario: Avatar quadrado
- **WHEN** um avatar `square` com iniciais é renderizado nos temas claro e escuro
- **THEN** o raio é `radius.s`, o fundo é o `colors.selectionBackground` e as iniciais o `colors.brand` de cada tema

### Requirement: [Estados] Interação do avatar ativo
O avatar ativo SHALL usar `colors.selectionHoverBackground` no hover e mostrar o anel de foco só com o foco do teclado. O avatar inativo SHALL NOT apresentar estados de interação.

#### Scenario: Avatar ativo em hover
- **WHEN** o ponteiro fica sobre um avatar ativo e depois sai
- **THEN** o fundo passa a `colors.selectionHoverBackground` e volta a `colors.selectionBackground`

### Requirement: [Acessibilidade] Semântica
O avatar SHALL ser exposto como imagem, com o rótulo `semanticLabel` ou, sem ele, as iniciais. O ativo MUST ser exposto como botão com a ação de toque. O conteúdo visual MUST NOT acrescentar outros nós.

#### Scenario: Semântica do avatar
- **WHEN** a árvore de semântica de `RebicAvatar(initials: 'MB', semanticLabel: 'Maria Barros')` e de um avatar ativo com iniciais "JS" é lida
- **THEN** o primeiro é imagem com o rótulo "Maria Barros", e o segundo é botão com o rótulo "JS" e ação de toque

### Requirement: [Acessibilidade] Contraste e alvo
As iniciais MUST manter o contraste sobre o fundo, e o avatar ativo MUST atender ao alvo mínimo e ao alvo rotulado, conforme `rebic/foundation/accessibility`.

#### Scenario: Contraste e alvo do avatar
- **WHEN** as diretrizes de contraste de texto e de alvo são aplicadas a avatares com iniciais em cada tamanho, um deles ativo, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

### Requirement: [Responsividade] Tamanho fixo
O lado do avatar MUST NOT mudar com a escala de texto, e as iniciais MUST caber no avatar, sem estouro, como no UI5.

#### Scenario: Avatar com escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** um avatar `xs` com iniciais "ABC" é renderizado
- **THEN** o lado continua 1 × `icons.xLarge`, e não há estouro

### Requirement: [Integração] Dependências
`RebicAvatar` SHALL depender somente de `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-text`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/radius`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Avatar sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** avatares com iniciais, ícone e ativo são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicAvatar` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` aplicável: contraste, semântica e, no ativo, alvo e teclado.

#### Scenario: Rastreabilidade do avatar
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do avatar
- **WHEN** os goldens dos avatares em cada tamanho, circulares e quadrados, com iniciais e com ícone, são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicAvatar` SHALL ter dartdoc em toda API pública e uma página "RebicAvatar" na galeria com os tamanhos, as formas, iniciais, ícone e um avatar ativo que mostra uma mensagem.

#### Scenario: Página RebicAvatar na galeria
- **GIVEN** a página "RebicAvatar" aberta na galeria
- **WHEN** o avatar ativo "Maria Barros" é tocado
- **THEN** a página mostra "Perfil de Maria Barros"

### Requirement: [Restrições] Fora do escopo
`RebicAvatar` SHALL NOT aceitar cores ou tamanhos literais, nem cores de acento, badge sobre o avatar ou grupos.

#### Scenario: Avatar sem valor literal
- **WHEN** a API pública de `RebicAvatar` é inspecionada
- **THEN** não há parâmetro do tipo `double` ou `Color`
