## Purpose

`GjaText` exibe texto do GJA, como o `sap.m.Text` e o `sap.m.Title` do SAPUI5: aplica um estilo da escala tipográfica e uma cor de papel do tema ativo, limita as linhas com reticências, alinha e marca os títulos para leitores de tela, sem valores literais.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaText` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `data` (posicional) | `String` | obrigatória |
| `variant` | `GjaTextVariant` | `body` |
| `tone` | `GjaTextTone` | `standard` |
| `maxLines` | `int?` | sem limite |
| `textAlign` | `TextAlign` | `start` |
| `heading` | `bool?` | conforme a variante |

`maxLines` MUST ser maior que zero quando informado.

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `GjaApp` e o tema claro
- **WHEN** `GjaText('Pedido 4711')` é criado
- **THEN** o texto usa o estilo `body` e a cor `text` do tema, quebra linhas livremente e não é cabeçalho

#### Scenario: Linhas inválidas
- **WHEN** `GjaText` é criado com `maxLines` 0
- **THEN** a criação falha em modo debug com mensagem que cita `maxLines`

### Requirement: [API] Callbacks e controlador
`GjaText` SHALL NOT ter callbacks nem controlador: é um widget de exibição.

#### Scenario: Sem ação
- **GIVEN** `GjaText` numa página
- **WHEN** o texto é tocado
- **THEN** nada é executado, e a semântica não informa ação de toque

### Requirement: [Comportamento] Limite de linhas
Com `maxLines`, `GjaText` SHALL exibir no máximo esse número de linhas e terminar com reticências quando o texto não couber. Sem `maxLines`, o texto MUST quebrar em quantas linhas precisar.

#### Scenario: Texto truncado
- **GIVEN** um texto que ocupa quatro linhas na largura disponível
- **WHEN** `GjaText` é criado com `maxLines` 2
- **THEN** ele ocupa a altura de duas linhas e termina com reticências

#### Scenario: Texto livre
- **GIVEN** o mesmo texto, sem `maxLines`
- **WHEN** ele é renderizado na mesma largura
- **THEN** ele ocupa as quatro linhas, sem reticências

### Requirement: [Aparência] Tokens de componente
`GjaText` SHALL obter o estilo de `typography.<variant>` e a cor de `colors.text` (`standard`), `colors.label` (`muted`) ou do `foreground` do estado de valor correspondente (`success`, `warning`, `error`, `information`), todos do tema ativo, sem valores literais.

#### Scenario: Troca de tema
- **GIVEN** `GjaText` com `tone` `error` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o texto usa o `foreground` do estado `error` do tema escuro, sem ser recriado com outros parâmetros

#### Scenario: Variantes e tons
- **WHEN** cada combinação de `variant` e `tone` é renderizada no tema claro
- **THEN** o estilo tem o tamanho, a altura de linha e o peso de `typography.<variant>`, e a cor do papel do `tone`

### Requirement: [Estados] Sem estados de interação
`GjaText` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo. A cor do texto vem só de `tone`.

#### Scenario: Não recebe foco
- **GIVEN** uma página com `GjaText` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`GjaText` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas
- **GIVEN** uma página com `GjaText` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Acessibilidade] Semântica e contraste
`GjaText` SHALL expor ao leitor de tela o texto completo, mesmo truncado. As variantes `display`, `headline` e `title` MUST ser anunciadas como cabeçalho, e `heading` MUST poder ligar ou desligar isso. As cores de `tone` MUST ter contraste ≥ 4,5:1 sobre `base` e `background`, conforme `gja/foundation/accessibility`, e o texto MUST respeitar a escala de texto do sistema sem limite.

#### Scenario: Leitor de tela
- **WHEN** um leitor de tela percorre `GjaText('Pedidos em aberto', variant: title, maxLines: 1)` numa largura que o trunca
- **THEN** anuncia "Pedidos em aberto" como cabeçalho

#### Scenario: Contraste dos tons
- **WHEN** a diretriz de contraste de texto é aplicada a uma página com todos os tons, nos temas claro e escuro
- **THEN** a diretriz passa

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e uma largura de 320
- **WHEN** um parágrafo `body` é renderizado
- **THEN** não há estouro de layout, e o tamanho da fonte é o dobro do de `body`

### Requirement: [Responsividade] Tamanhos de tela e densidade
`GjaText` SHALL quebrar linhas conforme a largura disponível, em qualquer classe de tamanho. A tipografia MUST ser a mesma nas densidades confortável e compacta, conforme `gja/foundation/density`.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `GjaText` é renderizado nela
- **THEN** o estilo é igual ao da densidade confortável

### Requirement: [Integração] Dependências
`GjaText` SHALL depender somente de `gja/foundation/typography`, `gja/foundation/color`, `gja/foundation/theming`, `gja/foundation/density` e `gja/foundation/accessibility`, e do `Text` nativo do Flutter.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaText` é renderizado em todas as variantes
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaText` MUST ter um teste de widget por cenário, goldens das variantes e dos tons nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`: `textContrastGuideline`, escala de texto 2,0 sem estouro e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens das variantes
- **WHEN** os goldens de `GjaText` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`GjaText` SHALL ter dartdoc em toda API pública e uma página "GjaText" na galeria com as variantes, os tons e um exemplo de limite de linhas.

#### Scenario: Página GjaText na galeria
- **WHEN** a página "GjaText" é aberta
- **THEN** ela exibe as oito variantes, os seis tons e um texto truncado em duas linhas

### Requirement: [Restrições] Fora do escopo
`GjaText` SHALL NOT oferecer seleção de texto, texto rico, links nem cores arbitrárias. Uma cor fora dos papéis de `tone` MUST NOT ser aceita.

#### Scenario: Sem cor arbitrária
- **WHEN** a API pública de `GjaText` é inspecionada
- **THEN** não há parâmetro de cor, de `TextStyle` nem de `TextSpan`
