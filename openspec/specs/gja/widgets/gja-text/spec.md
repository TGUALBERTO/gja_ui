# gja/widgets/gja-text Specification

## Purpose

`GjaText` exibe texto corrido do GJA, como o `sap.m.Text` do SAPUI5: usa o estilo `base` e a cor de texto do tema, quebra linhas ou fica em uma, limita as linhas com reticências e alinha, sem variantes, tons nem valores literais. Títulos são de `GjaTitle`, e rótulos, de `GjaLabel`.

## Requirements


### Requirement: [API] Propriedades
`GjaText` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` (posicional) | `String` | obrigatória |
| `maxLines` | `int?` | sem limite |
| `wrapping` | `bool` | `true` |
| `textAlign` | `TextAlign` | `start` |

`maxLines` MUST ser maior que zero quando informado.

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `GjaApp` e o tema claro
- **WHEN** `GjaText('Pedido 4711')` é criado
- **THEN** o texto usa o estilo `base` e a cor `text` do tema, quebra linhas livremente e não é cabeçalho

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
Com `maxLines`, `GjaText` SHALL exibir no máximo esse número de linhas e terminar com reticências quando o texto não couber. Sem `maxLines`, o texto MUST quebrar em quantas linhas precisar. Sem `wrapping`, o texto MUST ocupar uma linha e terminar com reticências, e `maxLines` MUST ser ignorado, como no `sap.m.Text`.

#### Scenario: Texto truncado
- **GIVEN** um texto que ocupa quatro linhas na largura disponível
- **WHEN** `GjaText` é criado com `maxLines` 2
- **THEN** ele ocupa a altura de duas linhas e termina com reticências

#### Scenario: Texto livre
- **GIVEN** o mesmo texto, sem `maxLines`
- **WHEN** ele é renderizado na mesma largura
- **THEN** ele ocupa as quatro linhas, sem reticências

#### Scenario: Texto sem quebra
- **GIVEN** o mesmo texto, com `wrapping` `false` e `maxLines` 3
- **WHEN** ele é renderizado na mesma largura
- **THEN** ele ocupa a altura de uma linha e termina com reticências

### Requirement: [Estados] Sem estados de interação
`GjaText` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo. A cor do texto é sempre `colors.text`.

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

### Requirement: [Responsividade] Tamanhos de tela e densidade
`GjaText` SHALL quebrar linhas conforme a largura disponível, em qualquer classe de tamanho. A tipografia MUST ser a mesma nas densidades cozy e compacta, conforme `gja/foundation/density`.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `GjaText` é renderizado nela
- **THEN** o estilo é igual ao da densidade cozy

### Requirement: [Integração] Dependências
`GjaText` SHALL depender somente de `gja/foundation/typography`, `gja/foundation/color`, `gja/foundation/theming`, `gja/foundation/density` e `gja/foundation/accessibility`, e do `Text` nativo do Flutter.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaText` é renderizado livre, limitado a duas linhas e sem quebra
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Documentação] Exemplos mínimos
`GjaText` SHALL ter dartdoc em toda API pública e uma página "GjaText" na galeria com um texto livre, um texto limitado a duas linhas e um texto sem quebra.

#### Scenario: Página GjaText na galeria
- **WHEN** a página "GjaText" é aberta
- **THEN** ela exibe um parágrafo livre, o mesmo parágrafo truncado em duas linhas e em uma linha sem quebra

### Requirement: [Restrições] Fora do escopo
`GjaText` SHALL NOT oferecer seleção de texto, texto rico, links, variantes de tamanho, tons nem cores arbitrárias. Títulos MUST usar `gja/widgets/gja-title`, e rótulos, `gja/widgets/gja-label`.

#### Scenario: Sem cor arbitrária
- **WHEN** a API pública de `GjaText` é inspecionada
- **THEN** não há parâmetro de cor, de tom, de variante, de cabeçalho, de `TextStyle` nem de `TextSpan`

### Requirement: [Aparência] Estilo e cor do texto
`GjaText` SHALL usar o estilo `typography.base` e a cor `colors.text` (`sapTextColor`) do tema ativo, sem valores literais.

#### Scenario: Troca de tema do texto
- **GIVEN** `GjaText` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o texto usa a cor `text` do tema escuro, sem ser recriado com outros parâmetros

#### Scenario: Estilo do texto
- **WHEN** `GjaText` é renderizado no tema claro
- **THEN** o estilo tem o tamanho, a altura de linha e o peso de `base`, e a cor `text`

### Requirement: [Acessibilidade] Semântica, contraste e escala de texto
`GjaText` SHALL expor ao leitor de tela o texto completo, mesmo truncado, e MUST NOT ser anunciado como cabeçalho. A cor MUST ter contraste ≥ 4,5:1 sobre `base` e `background`, conforme `gja/foundation/accessibility`, e o texto MUST respeitar a escala de texto do sistema sem limite.

#### Scenario: Leitor de tela
- **WHEN** um leitor de tela percorre `GjaText('Pedidos em aberto no mês', maxLines: 1)` numa largura que o trunca
- **THEN** anuncia "Pedidos em aberto no mês", sem papel de cabeçalho

#### Scenario: Contraste do texto
- **WHEN** a diretriz de contraste de texto é aplicada a uma página com `GjaText`, nos temas claro e escuro
- **THEN** a diretriz passa

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e uma largura de 320
- **WHEN** um parágrafo é renderizado
- **THEN** não há estouro de layout, e o tamanho da fonte é o dobro do de `base`

### Requirement: [Testes] Cobertura do texto
`GjaText` MUST ter um teste de widget por cenário, goldens de um texto livre, truncado e sem quebra nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `gja/foundation/accessibility`: `textContrastGuideline`, escala de texto 2,0 sem estouro e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do texto
- **WHEN** os goldens de `GjaText` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem
