# rebic/widgets/rebic-link Specification

## Purpose

`RebicLink` é o link de ação do Rebic, como o `sap.m.Link` do SAPUI5: um texto na cor de link (ou na do texto, quando sutil, e em negrito, quando enfatizado), sublinhado no hover e no pressionado, numa linha ou com quebra, desabilitado quando não há ação e anunciado ao leitor de tela como link.

## Requirements

### Requirement: [API] Propriedades
`RebicLink` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String` | obrigatória |
| `onPressed` | `VoidCallback?` | obrigatória (`null` desabilita) |
| `emphasized` | `bool` | `false` |
| `subtle` | `bool` | `false` |
| `wrapping` | `bool` | `false` |

#### Scenario: Link mínimo
- **WHEN** `RebicLink(text: 'Ver pedido', onPressed: …)` é renderizado
- **THEN** o texto "Ver pedido" aparece numa linha, na cor `colors.link`, com o estilo `typography.base` e sem sublinhado

### Requirement: [API] Texto válido
`text` MUST NOT ser vazio. Um texto vazio MUST falhar em modo debug.

#### Scenario: Texto vazio
- **WHEN** um `RebicLink` é criado com `text` vazio
- **THEN** a criação falha em modo debug

### Requirement: [API] Callbacks e controlador
O link SHALL chamar `onPressed` uma vez por ativação por toque, Enter ou Espaço. Com `onPressed` nulo, MUST ficar desabilitado: sem ativação, fora da ordem de foco e com a opacidade de desabilitado. `RebicLink` SHALL NOT ter controlador.

#### Scenario: Acionar o link
- **WHEN** o link é tocado e, com o foco nele, Enter é pressionado
- **THEN** `onPressed` é chamado duas vezes

#### Scenario: Link desabilitado
- **GIVEN** um link com `onPressed` nulo
- **WHEN** ele é tocado
- **THEN** nada é executado, e o texto tem a opacidade `interaction.disabledOpacity`

### Requirement: [Comportamento] Quebra do texto
Sem `wrapping`, o texto SHALL ficar numa linha e MUST terminar com reticências quando não cabe. Com `wrapping`, o texto SHALL quebrar em quantas linhas precisar.

#### Scenario: Texto longo sem quebra
- **GIVEN** um link com texto longo num espaço de 120 de largura
- **WHEN** ele é renderizado
- **THEN** o texto fica numa linha, com reticências, e não há estouro

#### Scenario: Texto longo com quebra
- **GIVEN** o mesmo link com `wrapping`
- **WHEN** ele é renderizado
- **THEN** o texto ocupa mais de uma linha, sem reticências

### Requirement: [Aparência] Variantes
O link SHALL usar `colors.link` e o estilo `typography.base`. Com `subtle`, a cor SHALL ser `colors.text`. Com `emphasized`, o estilo SHALL ser `typography.baseBold`. As duas indicações podem ser combinadas.

#### Scenario: Link sutil e enfatizado
- **WHEN** um link `subtle` e um `emphasized` são renderizados
- **THEN** o primeiro tem a cor `colors.text`, e o segundo tem a cor `colors.link` e o estilo `typography.baseBold`

### Requirement: [Aparência] Tokens de componente
A cor, o estilo e o raio do anel de foco SHALL vir do tema ativo (`colors`, `typography`, `radius.control`), sem valores literais.

#### Scenario: Cor do link nos temas
- **WHEN** o link é renderizado nos temas claro e escuro
- **THEN** a cor do texto é o `colors.link` de cada tema

### Requirement: [Estados] Interação
O link SHALL mostrar o texto sublinhado no hover e no pressionado e sem sublinhado nos demais estados. O anel de foco MUST aparecer só com o foco vindo do teclado. Desabilitado, MUST NOT reagir ao ponteiro.

#### Scenario: Sublinhado no hover e no pressionado
- **WHEN** o ponteiro fica sobre o link, depois o pressiona sem soltar e depois sai
- **THEN** o texto fica sublinhado no hover e no pressionado e volta sem sublinhado ao sair

#### Scenario: Foco pelo teclado no link
- **WHEN** o link recebe o foco por Tab
- **THEN** o anel de foco aparece

### Requirement: [Acessibilidade] Semântica
O link SHALL ser exposto com o papel de link, e não de botão, com o rótulo `text`, o estado habilitado e a ação de toque, pelo papel de link de `rebic/core/interaction`. Desabilitado, MUST ser exposto como não habilitado.

#### Scenario: Semântica do link
- **WHEN** a árvore de semântica de um link habilitado e de um desabilitado é lida
- **THEN** os dois têm o papel de link e não o de botão, com o rótulo do `text`, o primeiro habilitado e com ação de toque, e o segundo não habilitado

### Requirement: [Acessibilidade] Contraste, alvo e escala
O texto do link, normal e sutil, MUST manter o contraste sobre `colors.base` e `colors.background`. O link MUST atender ao alvo mínimo da densidade e ao alvo rotulado, conforme `rebic/foundation/accessibility`. Com escala de texto 2,0, MUST crescer sem estouro.

#### Scenario: Contraste e alvo do link
- **WHEN** as diretrizes de contraste de texto, alvo rotulado e alvo mínimo são aplicadas a links normal, sutil e enfatizado, nos temas claro e escuro e nas duas densidades
- **THEN** todas as diretrizes são atendidas

#### Scenario: Link com escala de texto 2,0
- **GIVEN** a escala de texto 2,0
- **WHEN** um link é renderizado
- **THEN** não há estouro, e o texto é maior que na escala 1,0

### Requirement: [Responsividade] Largura e direção
O link SHALL ter a largura do texto, limitada pelo espaço disponível. Em RTL, o texto MUST seguir a direção da leitura, e as reticências MUST ficar no fim lógico.

#### Scenario: Link em RTL
- **GIVEN** a direção do texto da direita para a esquerda e um link com texto longo num espaço de 120
- **WHEN** ele é renderizado
- **THEN** o texto usa a direção RTL e termina com reticências

### Requirement: [Integração] Dependências
`RebicLink` SHALL depender somente de `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/interaction-states`, `rebic/foundation/radius`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Link sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** links normal, sutil, enfatizado e desabilitado são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicLink` MUST ter um teste de widget por cenário, goldens nos temas claro e escuro, em cada densidade, e a bateria de `rebic/foundation/accessibility` para widgets interativos.

#### Scenario: Rastreabilidade do link
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do link
- **WHEN** os goldens dos links normal, sutil, enfatizado, desabilitado e com quebra são comparados com a referência, nos temas claro e escuro e nas duas densidades
- **THEN** não há diferenças

### Requirement: [Documentação] Exemplos mínimos
`RebicLink` SHALL ter dartdoc em toda API pública e uma página "RebicLink" na galeria com as variantes, um link com quebra e um link que mostra uma mensagem ao ser acionado.

#### Scenario: Página RebicLink na galeria
- **GIVEN** a página "RebicLink" aberta na galeria
- **WHEN** o link "Ver pedido 4711" é tocado
- **THEN** a página mostra "Pedido 4711 aberto"

### Requirement: [Restrições] Fora do escopo
`RebicLink` SHALL NOT aceitar cores, estilos ou URLs, nem compor texto rico.

#### Scenario: Link sem valor literal
- **WHEN** a API pública de `RebicLink` é inspecionada
- **THEN** não há parâmetro do tipo `double`, `Color`, `TextStyle`, `Uri` ou `Widget`
