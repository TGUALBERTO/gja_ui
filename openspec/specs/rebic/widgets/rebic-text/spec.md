# rebic/widgets/rebic-text Specification

## Purpose

`RebicText` exibe texto do Rebic, como o `sap.m.Text` e o `sap.m.Title` do SAPUI5: aplica um estilo da escala tipográfica e uma cor de papel do tema ativo, limita as linhas com reticências, alinha e marca os títulos para leitores de tela, sem valores literais.

## Requirements


### Requirement: [API] Propriedades
`RebicText` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` (posicional) | `String` | obrigatória |
| `maxLines` | `int?` | sem limite |
| `wrapping` | `bool` | `true` |
| `textAlign` | `TextAlign` | `start` |

`maxLines` MUST ser maior que zero quando informado.

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp` e o tema claro
- **WHEN** `RebicText('Pedido 4711')` é criado
- **THEN** o texto usa o estilo `base` e a cor `text` do tema, quebra linhas livremente e não é cabeçalho

#### Scenario: Linhas inválidas
- **WHEN** `RebicText` é criado com `maxLines` 0
- **THEN** a criação falha em modo debug com mensagem que cita `maxLines`

### Requirement: [API] Callbacks e controlador
`RebicText` SHALL NOT ter callbacks nem controlador: é um widget de exibição.

#### Scenario: Sem ação
- **GIVEN** `RebicText` numa página
- **WHEN** o texto é tocado
- **THEN** nada é executado, e a semântica não informa ação de toque

### Requirement: [Comportamento] Limite de linhas
Com `maxLines`, `RebicText` SHALL exibir no máximo esse número de linhas e terminar com reticências quando o texto não couber. Sem `maxLines`, o texto MUST quebrar em quantas linhas precisar. Sem `wrapping`, o texto MUST ocupar uma linha e terminar com reticências, e `maxLines` MUST ser ignorado, como no `sap.m.Text`.

#### Scenario: Texto truncado
- **GIVEN** um texto que ocupa quatro linhas na largura disponível
- **WHEN** `RebicText` é criado com `maxLines` 2
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
`RebicText` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo. A cor do texto é sempre `colors.text`.

#### Scenario: Não recebe foco
- **GIVEN** uma página com `RebicText` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`RebicText` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas
- **GIVEN** uma página com `RebicText` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Responsividade] Tamanhos de tela e densidade
`RebicText` SHALL quebrar linhas conforme a largura disponível, em qualquer classe de tamanho. A tipografia MUST ser a mesma nas densidades cozy e compacta, conforme `rebic/foundation/density`.

#### Scenario: Densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `RebicText` é renderizado nela
- **THEN** o estilo é igual ao da densidade cozy

### Requirement: [Integração] Dependências
`RebicText` SHALL depender somente de `rebic/foundation/typography`, `rebic/foundation/color`, `rebic/foundation/theming`, `rebic/foundation/density` e `rebic/foundation/accessibility`, e do `Text` nativo do Flutter.

#### Scenario: Funciona sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicText` é renderizado em todas as variantes
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Documentação] Exemplos mínimos
`RebicText` SHALL ter dartdoc em toda API pública e uma página "RebicText" na galeria com um texto livre, um texto limitado a duas linhas e um texto sem quebra.

#### Scenario: Página RebicText na galeria
- **WHEN** a página "RebicText" é aberta
- **THEN** ela exibe um parágrafo livre, o mesmo parágrafo truncado em duas linhas e em uma linha sem quebra

### Requirement: [Restrições] Fora do escopo
`RebicText` SHALL NOT oferecer seleção de texto, texto rico, links, variantes de tamanho, tons nem cores arbitrárias. Títulos MUST usar `rebic/widgets/rebic-title`, e rótulos, `rebic/widgets/rebic-label`.

#### Scenario: Sem cor arbitrária
- **WHEN** a API pública de `RebicText` é inspecionada
- **THEN** não há parâmetro de cor, de tom, de variante, de cabeçalho, de `TextStyle` nem de `TextSpan`

### Requirement: [Aparência] Estilo e cor do texto
`RebicText` SHALL usar o estilo `typography.base` e a cor `colors.text` (`sapTextColor`) do tema ativo, sem valores literais.

#### Scenario: Troca de tema do texto
- **GIVEN** `RebicText` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o texto usa a cor `text` do tema escuro, sem ser recriado com outros parâmetros

#### Scenario: Estilo do texto
- **WHEN** `RebicText` é renderizado no tema claro
- **THEN** o estilo tem o tamanho, a altura de linha e o peso de `base`, e a cor `text`

### Requirement: [Acessibilidade] Semântica, contraste e escala de texto
`RebicText` SHALL expor ao leitor de tela o texto completo, mesmo truncado, e MUST NOT ser anunciado como cabeçalho. A cor MUST ter contraste ≥ 4,5:1 sobre `base` e `background`, conforme `rebic/foundation/accessibility`, e o texto MUST respeitar a escala de texto do sistema sem limite.

#### Scenario: Leitor de tela
- **WHEN** um leitor de tela percorre `RebicText('Pedidos em aberto no mês', maxLines: 1)` numa largura que o trunca
- **THEN** anuncia "Pedidos em aberto no mês", sem papel de cabeçalho

#### Scenario: Contraste do texto
- **WHEN** a diretriz de contraste de texto é aplicada a uma página com `RebicText`, nos temas claro e escuro
- **THEN** a diretriz passa

#### Scenario: Escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e uma largura de 320
- **WHEN** um parágrafo é renderizado
- **THEN** não há estouro de layout, e o tamanho da fonte é o dobro do de `base`

### Requirement: [Testes] Cobertura do texto
`RebicText` MUST ter um teste de widget por cenário, goldens de um texto livre, truncado e sem quebra nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: `textContrastGuideline`, escala de texto 2,0 sem estouro e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do texto
- **WHEN** os goldens de `RebicText` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem
