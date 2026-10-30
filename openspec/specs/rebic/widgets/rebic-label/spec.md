# rebic/widgets/rebic-label Specification

## Purpose

`RebicLabel` exibe o rótulo de um campo ou de um valor, como o `sap.m.Label` do SAPUI5: usa a cor de rótulo do tema, pode ser negrito, mostrar os dois-pontos e o asterisco de obrigatório, e termina com reticências quando não quebra linhas.

## Requirements

### Requirement: [API] Propriedades
`RebicLabel` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` (posicional) | `String` | obrigatória |
| `design` | `RebicLabelDesign` | `standard` |
| `required` | `bool` | `false` |
| `showColon` | `bool` | `false` |
| `wrapping` | `bool` | `false` |
| `textAlign` | `TextAlign` | `start` |

`RebicLabelDesign` SHALL ter exatamente os valores `standard` e `bold`, como o `sap.m.LabelDesign`.

#### Scenario: Uso mínimo
- **GIVEN** uma árvore com `RebicApp` e o tema claro
- **WHEN** `RebicLabel('Fornecedor')` é criado
- **THEN** o rótulo usa o estilo `base` e a cor `label` do tema, ocupa uma linha e não tem dois-pontos nem asterisco

#### Scenario: Desenhos do rótulo
- **WHEN** os valores de `RebicLabelDesign` são listados
- **THEN** eles são `standard` e `bold`

### Requirement: [API] Callbacks e controlador
`RebicLabel` SHALL NOT ter callbacks nem controlador: é um widget de exibição.

#### Scenario: Rótulo sem ação
- **GIVEN** `RebicLabel` numa página
- **WHEN** o rótulo é tocado
- **THEN** nada é executado, e a semântica não informa ação de toque

### Requirement: [Comportamento] Dois-pontos e obrigatório
Com `showColon`, `RebicLabel` SHALL mostrar ":" logo depois do texto. Com `required`, SHALL mostrar "*" depois do texto e dos dois-pontos, como no `sap.m.Label`. Os sinais MUST continuar visíveis quando o texto é truncado.

#### Scenario: Rótulo com dois-pontos e obrigatório
- **WHEN** `RebicLabel('Fornecedor', showColon: true, required: true)` é renderizado em LTR
- **THEN** aparecem, do início ao fim, "Fornecedor", ":" e "*"

#### Scenario: Sinais com texto truncado
- **GIVEN** um rótulo com `showColon` e `required` cujo texto não cabe numa linha
- **WHEN** ele é renderizado sem `wrapping`
- **THEN** o texto termina com reticências, e ":" e "*" continuam visíveis no fim

### Requirement: [Comportamento] Quebra de linhas
Sem `wrapping`, `RebicLabel` SHALL ocupar uma linha e terminar com reticências quando não couber. Com `wrapping`, o rótulo MUST quebrar em quantas linhas precisar.

#### Scenario: Rótulo truncado
- **GIVEN** um rótulo que ocupa duas linhas na largura disponível
- **WHEN** `RebicLabel` é renderizado sem `wrapping`
- **THEN** ele ocupa a altura de uma linha e termina com reticências

#### Scenario: Rótulo com quebra
- **GIVEN** o mesmo rótulo, com `wrapping` `true`
- **WHEN** ele é renderizado na mesma largura
- **THEN** ele ocupa as duas linhas, sem reticências

### Requirement: [Aparência] Estilo e cor
`RebicLabel` SHALL usar `typography.base` no desenho `standard` e `typography.baseBold` no `bold`, com a cor `colors.label` (`sapContent_LabelColor`). Os dois-pontos SHALL ter o estilo e a cor do texto, e o asterisco SHALL usar a cor `colors.required` (`sapField_RequiredColor`), todos do tema ativo, sem valores literais.

#### Scenario: Desenhos e sinais
- **WHEN** rótulos `standard` e `bold`, com e sem `required`, são renderizados no tema claro
- **THEN** o texto tem o estilo do desenho e a cor `label`, e o asterisco tem a cor `required`

#### Scenario: Troca de tema do rótulo
- **GIVEN** `RebicLabel` com `required` renderizado no tema claro
- **WHEN** o tema ativo muda para escuro
- **THEN** o texto e o asterisco usam as cores `label` e `required` do tema escuro, sem ser recriados com outros parâmetros

### Requirement: [Estados] Sem estados de interação
`RebicLabel` SHALL NOT apresentar estados de hover, foco, pressionado, selecionado ou desabilitado, porque não é interativo.

#### Scenario: Rótulo não recebe foco
- **GIVEN** uma página com `RebicLabel` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro elemento
- **THEN** o foco vai direto ao segundo elemento

### Requirement: [Acessibilidade] Teclado e foco
`RebicLabel` SHALL NOT entrar na ordem de foco nem responder a teclas.

#### Scenario: Teclas ignoradas pelo rótulo
- **GIVEN** uma página com `RebicLabel` e nenhum elemento focável
- **WHEN** Tab, Enter e Espaço são pressionados
- **THEN** nada muda na página

### Requirement: [Acessibilidade] Semântica e contraste
`RebicLabel` SHALL expor ao leitor de tela o texto completo, mesmo truncado, e MUST NOT ser anunciado como cabeçalho. Com `required`, o asterisco MUST ser anunciado como o texto `required` de `rebic/core/localization`, e não como "asterisco". As cores `label` e `required` MUST ter contraste ≥ 4,5:1 sobre `base` e `background`, conforme `rebic/foundation/accessibility`.

#### Scenario: Leitor de tela no rótulo
- **WHEN** um leitor de tela percorre `RebicLabel('Fornecedor', showColon: true, required: true)` em pt-BR
- **THEN** anuncia "Fornecedor:, Obrigatório", sem papel de cabeçalho

#### Scenario: Contraste do rótulo
- **WHEN** a diretriz de contraste de texto é aplicada a uma página com rótulos `standard` e `bold` obrigatórios, nos temas claro e escuro
- **THEN** a diretriz passa

#### Scenario: Rótulo com escala de texto 2,0
- **GIVEN** a escala de texto 2,0 e uma largura de 320
- **WHEN** um rótulo com `wrapping` e `required` é renderizado
- **THEN** não há estouro de layout, e o tamanho da fonte é o dobro do de `base`

### Requirement: [Responsividade] Tamanhos de tela e densidade
`RebicLabel` SHALL ocupar a largura disponível em qualquer classe de tamanho, truncando ou quebrando conforme `wrapping`. A tipografia MUST ser a mesma nas densidades cozy e compacta, conforme `rebic/foundation/density`.

#### Scenario: Rótulo na densidade compacta
- **GIVEN** uma subárvore com densidade `compact`
- **WHEN** `RebicLabel` é renderizado nela
- **THEN** o estilo é igual ao da densidade cozy

### Requirement: [Integração] Dependências
`RebicLabel` SHALL depender somente de `rebic/core/localization`, `rebic/foundation/typography`, `rebic/foundation/color`, `rebic/foundation/theming`, `rebic/foundation/density` e `rebic/foundation/accessibility`, e do `Text` nativo do Flutter.

#### Scenario: Rótulo sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicLabel` é renderizado nos dois desenhos, com dois-pontos e obrigatório
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicLabel` MUST ter um teste de widget por cenário, goldens dos desenhos com e sem sinais nos temas claro e escuro, em cada densidade, e a parte aplicável da bateria de `rebic/foundation/accessibility`: `textContrastGuideline`, escala de texto 2,0 sem estouro e semântica. As diretrizes de alvo de toque e o teclado não se aplicam, por não ser interativo.

#### Scenario: Rastreabilidade do rótulo
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

#### Scenario: Goldens do rótulo
- **WHEN** os goldens de `RebicLabel` são comparados com a referência
- **THEN** existem as imagens de claro e escuro em cada densidade, e todas coincidem

### Requirement: [Documentação] Exemplos mínimos
`RebicLabel` SHALL ter dartdoc em toda API pública e uma página "RebicLabel" na galeria com os dois desenhos, os dois-pontos, o obrigatório e um rótulo truncado.

#### Scenario: Página RebicLabel na galeria
- **WHEN** a página "RebicLabel" é aberta
- **THEN** ela exibe os rótulos `standard` e `bold`, um com dois-pontos, um obrigatório e um truncado

### Requirement: [Restrições] Fora do escopo
`RebicLabel` SHALL NOT oferecer cores arbitrárias, limite de linhas, `wrappingType` nem associação a um campo (`labelFor`), que entra com os campos de entrada.

#### Scenario: Rótulo sem cor arbitrária
- **WHEN** a API pública de `RebicLabel` é inspecionada
- **THEN** não há parâmetro de cor, de `TextStyle`, de `maxLines` nem de campo associado
