# Spec Delta

## Purpose

`GjaHBox` organiza itens lado a lado, como o `sap.m.HBox` do SAPUI5: aplica um espaço nomeado do tema só entre os itens, alinha nos dois eixos por `justifyContent` e `alignItems`, pode ocupar só o necessário (`displayInline`) e pode quebrar em várias linhas (`wrap`), sem números literais.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaHBox` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `items` | `List<Widget>` | obrigatória |
| `gap` | `GjaSpace` | `inlineGap` |
| `justifyContent` | `GjaFlexJustifyContent` | `start` |
| `alignItems` | `GjaFlexAlignItems` | `center` |
| `wrap` | `GjaFlexWrap` | `noWrap` |
| `displayInline` | `bool` | `false` |


#### Scenario: Caixa horizontal mínima
- **GIVEN** uma árvore com `GjaApp` na densidade cozy
- **WHEN** `GjaHBox(items: [a, b])` é criado com dois quadrados de 20
- **THEN** eles ficam lado a lado, separados por `spacing.inlineGap`, alinhados ao início e centralizados na vertical

### Requirement: [API] Enums do FlexBox
`GjaFlexJustifyContent` SHALL ter `start`, `center`, `end`, `spaceBetween` e `spaceAround`; `GjaFlexAlignItems`, `start`, `center`, `end`, `baseline` e `stretch`; e `GjaFlexWrap`, `noWrap` e `wrap`, como o `FlexJustifyContent`, o `FlexAlignItems` e o `FlexWrap` do `sap.m`, sem `Inherit` nem `WrapReverse`.

#### Scenario: Valores dos enums do FlexBox
- **WHEN** os valores dos três enums são listados
- **THEN** são exatamente os desta exigência, nessa ordem

### Requirement: [API] Callbacks e controlador
`GjaHBox` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Caixa horizontal sem ação
- **GIVEN** `GjaHBox` com dois itens
- **WHEN** o espaço entre eles é tocado
- **THEN** nada é executado pelo `GjaHBox`

### Requirement: [Comportamento] Espaço entre itens
`GjaHBox` SHALL inserir `gap` somente entre itens consecutivos, nunca antes do primeiro nem depois do último. Com um único item ou nenhum, MUST NOT haver espaço.

#### Scenario: Espaço só entre itens da caixa horizontal
- **GIVEN** três quadrados de 20 num `GjaHBox` com `gap` `l` e `displayInline`
- **WHEN** a caixa é renderizada
- **THEN** a largura da caixa é 60 + 2 × `spacing.l`, e o primeiro quadrado começa na borda da caixa

### Requirement: [Comportamento] Alinhamento
`GjaHBox` SHALL alinhar os itens no eixo horizontal por `justifyContent` e no vertical por `alignItems`. Em `spaceBetween`, o espaço livre MUST ser distribuído entre os itens; em `spaceAround`, metade de cada parte livre MUST ficar antes e metade depois de cada item; nos dois casos, além de `gap`. Em `baseline`, os itens MUST se alinhar pela linha de base alfabética do texto.

#### Scenario: Alinhamento principal da caixa horizontal
- **GIVEN** dois quadrados de 20 num `GjaHBox` de 200 de largura com `justifyContent` `end`
- **WHEN** a caixa é renderizada
- **THEN** o segundo quadrado termina na borda final da caixa

#### Scenario: Espaço em volta na caixa horizontal
- **GIVEN** dois quadrados de 20 num `GjaHBox` de 200 de largura com `gap` `none` e `justifyContent` `spaceAround`
- **WHEN** a caixa é renderizada
- **THEN** o primeiro quadrado começa a 40 da borda inicial, e o segundo termina a 40 da borda final

#### Scenario: Alinhamento cruzado da caixa horizontal
- **GIVEN** um quadrado de 20 num `GjaHBox` de 60 de altura com `alignItems` `stretch`
- **WHEN** a caixa é renderizada
- **THEN** o quadrado passa a ter 60 de altura, a altura da caixa

#### Scenario: Linha de base na caixa horizontal
- **GIVEN** um `GjaHBox` com `alignItems` `baseline`, um `GjaTitle` com `titleStyle` `h2` e um `GjaText`
- **WHEN** a caixa é renderizada
- **THEN** o título e o texto têm a mesma linha de base

### Requirement: [Comportamento] Quebra de linha
Com `wrap` `wrap`, `GjaHBox` SHALL levar para a linha seguinte os itens que não cabem na largura disponível, com `gap` entre itens da mesma linha e entre as linhas, e `justifyContent` em cada linha. Nesse modo, `alignItems` SHALL alinhar os itens de cada linha por `start`, `center` ou `end`; `stretch` e `baseline` MUST NOT ser usados com `wrap`, e itens `Expanded` ou `Flexible` também não.

#### Scenario: Caixa horizontal com quebra
- **GIVEN** cinco quadrados de 40 num `GjaHBox` de 120 de largura com `wrap` `wrap` e `gap` `s`
- **WHEN** a caixa é renderizada
- **THEN** os quadrados ocupam mais de uma linha, e a distância vertical entre as linhas é `spacing.s`

#### Scenario: Quebra sem esticar
- **WHEN** um `GjaHBox` com `wrap` `wrap` e `alignItems` `stretch` é criado em modo debug
- **THEN** uma asserção indica que `stretch` e `baseline` não se aplicam à quebra

### Requirement: [Comportamento] Itens expansíveis
Em `GjaHBox` sem quebra, um item `Expanded` ou `Flexible` SHALL ocupar o espaço livre, mantido o `gap` entre os itens.

#### Scenario: Item expandido na caixa horizontal
- **GIVEN** um quadrado de 20 e um `Expanded` num `GjaHBox` de 200 de largura com `gap` `m`
- **WHEN** a caixa é renderizada
- **THEN** o item expandido mede 200 − 20 − `spacing.m` de largura

### Requirement: [Aparência] Tokens de componente
`GjaHBox` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de tema da caixa horizontal
- **GIVEN** `GjaHBox` com `gap` `l` na densidade cozy
- **WHEN** o tema ativo passa para a densidade compacta e, depois, para um tema com `l` de 24
- **THEN** o espaço entre os itens continua o `l` de referência na compacta e passa a 24 no último tema, sem recriar o widget com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`GjaHBox` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Caixa horizontal não recebe foco
- **GIVEN** um `GjaHBox` com dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio `GjaHBox`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco dos itens de `GjaHBox` SHALL seguir a ordem visual, inclusive em RTL.

#### Scenario: Ordem de foco na caixa horizontal
- **GIVEN** três elementos focáveis num `GjaHBox`
- **WHEN** Tab é pressionado duas vezes a partir do primeiro
- **THEN** o foco passa pelo segundo e pelo terceiro, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`GjaHBox` SHALL NOT acrescentar nós à árvore de semântica. O `gap` MUST NOT depender da escala de texto.

#### Scenario: Semântica da caixa horizontal inalterada
- **WHEN** a árvore de semântica de dois textos é comparada dentro de `GjaHBox` e de uma `Row` nativa
- **THEN** as duas árvores têm os mesmos rótulos, na mesma ordem

### Requirement: [Responsividade] Direção e densidade
`GjaHBox` SHALL seguir a direção do texto: em RTL, o início é à direita. O `gap` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `gja/foundation/density`. Para larguras pequenas, `wrap` é a forma de evitar estouro.

#### Scenario: Caixa horizontal em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** `GjaHBox` com dois quadrados é renderizado com `justifyContent` `start`
- **THEN** o primeiro quadrado fica na borda direita

#### Scenario: Densidade compacta na caixa horizontal
- **GIVEN** um `GjaHBox` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o mesmo `l` dentro e fora

### Requirement: [Integração] Dependências
`GjaHBox` SHALL depender somente de `gja/widgets/gja-spacing`, `gja/foundation/spacing`, `gja/foundation/density` e `gja/foundation/theming`, e dos widgets nativos `Flex` e `Wrap`.

#### Scenario: Caixa horizontal sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaHBox` é renderizado sem quebra e com quebra
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaHBox` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `gja/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade da caixa horizontal
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaHBox` SHALL ter dartdoc em toda API pública e aparecer na página "GjaHBox e GjaVBox" da galeria, com os alinhamentos, um item expandido e a quebra.

#### Scenario: Página GjaHBox na galeria
- **WHEN** a página "GjaHBox e GjaVBox" é aberta
- **THEN** ela exibe caixas horizontais com os cinco valores de `justifyContent`, uma com `alignItems` `baseline`, uma com item expandido e uma com quebra

### Requirement: [Restrições] Fora do escopo
`GjaHBox` SHALL NOT aceitar espaço ou tamanho literal, rolar, inverter a direção nem desenhar separadores ou fundo; `rowGap`, `columnGap`, `alignContent` e `FlexItemData` ficam fora.

#### Scenario: Caixa horizontal sem valor literal
- **WHEN** a API pública de `GjaHBox` é inspecionada
- **THEN** o construtor não tem parâmetro do tipo `double` ou `EdgeInsets`
