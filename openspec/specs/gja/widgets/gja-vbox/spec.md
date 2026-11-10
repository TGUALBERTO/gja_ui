# gja/widgets/gja-vbox Specification

## Purpose

`GjaVBox` empilha itens na vertical, como o `sap.m.VBox` do SAPUI5: aplica um espaço nomeado do tema só entre os itens, alinha nos dois eixos por `justifyContent` e `alignItems` e pode ocupar só o necessário (`displayInline`), sem números literais.

## Requirements

### Requirement: [API] Propriedades
`GjaVBox` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `items` | `List<Widget>` | obrigatória |
| `gap` | `GjaSpace` | `stackGap` |
| `justifyContent` | `GjaFlexJustifyContent` | `start` |
| `alignItems` | `GjaFlexAlignItems` | `start` |
| `displayInline` | `bool` | `false` |

Os enums SHALL ser os de `gja/widgets/gja-hbox`.

#### Scenario: Caixa vertical mínima
- **GIVEN** uma árvore com `GjaApp` na densidade cozy
- **WHEN** `GjaVBox(items: [a, b])` é criado com dois quadrados de 20
- **THEN** eles ficam empilhados, separados por `spacing.stackGap`, alinhados ao topo e ao início

### Requirement: [API] Callbacks e controlador
`GjaVBox` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Caixa vertical sem ação
- **GIVEN** `GjaVBox` com dois itens
- **WHEN** o espaço entre eles é tocado
- **THEN** nada é executado pelo `GjaVBox`

### Requirement: [Comportamento] Espaço entre itens
`GjaVBox` SHALL inserir `gap` somente entre itens consecutivos, nunca antes do primeiro nem depois do último. Com um único item ou nenhum, MUST NOT haver espaço.

#### Scenario: Espaço só entre itens da caixa vertical
- **GIVEN** três quadrados de 20 num `GjaVBox` com `gap` `l` e `displayInline`
- **WHEN** a caixa é renderizada
- **THEN** a altura da caixa é 60 + 2 × `spacing.l`, e o primeiro quadrado começa no topo da caixa

### Requirement: [Comportamento] Alinhamento
`GjaVBox` SHALL alinhar os itens no eixo vertical por `justifyContent` e no horizontal por `alignItems`, com `spaceBetween` e `spaceAround` como em `gja/widgets/gja-hbox`. Como no CSS de uma coluna, `baseline` MUST valer como `start`.

#### Scenario: Alinhamento principal da caixa vertical
- **GIVEN** dois quadrados de 20 num `GjaVBox` de 200 de altura com `justifyContent` `spaceBetween`
- **WHEN** a caixa é renderizada
- **THEN** o primeiro quadrado começa no topo e o segundo termina na base da caixa

#### Scenario: Alinhamento cruzado da caixa vertical
- **GIVEN** um quadrado de 20 num `GjaVBox` de 200 de largura com `alignItems` `stretch`
- **WHEN** a caixa é renderizada
- **THEN** o quadrado passa a ter 200 de largura

#### Scenario: Linha de base na caixa vertical
- **GIVEN** um quadrado de 20 num `GjaVBox` de 200 de largura com `alignItems` `baseline`
- **WHEN** a caixa é renderizada
- **THEN** o quadrado fica no início, como em `start`

### Requirement: [Comportamento] Itens expansíveis
Em `GjaVBox`, um item `Expanded` ou `Flexible` SHALL ocupar o espaço vertical livre, mantido o `gap` entre os itens.

#### Scenario: Item expandido na caixa vertical
- **GIVEN** um quadrado de 20 e um `Expanded` num `GjaVBox` de 200 de altura com `gap` `m`
- **WHEN** a caixa é renderizada
- **THEN** o item expandido mede 200 − 20 − `spacing.m` de altura

### Requirement: [Aparência] Tokens de componente
`GjaVBox` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de tema da caixa vertical
- **GIVEN** `GjaVBox` com `gap` `l` na densidade cozy
- **WHEN** o tema ativo passa para a densidade compacta e, depois, para um tema com `l` de 24
- **THEN** o espaço entre os itens continua o `l` de referência na compacta e passa a 24 no último tema, sem recriar o widget com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`GjaVBox` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Caixa vertical não recebe foco
- **GIVEN** um `GjaVBox` com dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio `GjaVBox`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco dos itens de `GjaVBox` SHALL seguir a ordem visual, de cima para baixo.

#### Scenario: Ordem de foco na caixa vertical
- **GIVEN** três elementos focáveis num `GjaVBox`
- **WHEN** Tab é pressionado duas vezes a partir do primeiro
- **THEN** o foco passa pelo segundo e pelo terceiro, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`GjaVBox` SHALL NOT acrescentar nós à árvore de semântica. O `gap` MUST NOT depender da escala de texto.

#### Scenario: Semântica da caixa vertical inalterada
- **WHEN** a árvore de semântica de dois textos é comparada dentro de `GjaVBox` e de uma `Column` nativa
- **THEN** as duas árvores têm os mesmos rótulos, na mesma ordem

### Requirement: [Responsividade] Direção e densidade
O alinhamento cruzado de `GjaVBox` SHALL seguir a direção do texto: em RTL, `start` é à direita. O `gap` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `gja/foundation/density`.

#### Scenario: Caixa vertical em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um `GjaVBox` de 200 de largura com um quadrado é renderizado com `alignItems` `start`
- **THEN** o quadrado fica na borda direita

#### Scenario: Densidade compacta na caixa vertical
- **GIVEN** um `GjaVBox` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o mesmo `l` dentro e fora

### Requirement: [Integração] Dependências
`GjaVBox` SHALL depender somente de `gja/widgets/gja-hbox` (os enums), `gja/widgets/gja-spacing`, `gja/foundation/spacing`, `gja/foundation/density` e `gja/foundation/theming`, e do widget nativo `Flex`.

#### Scenario: Caixa vertical sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaVBox` é renderizado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaVBox` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `gja/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade da caixa vertical
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaVBox` SHALL ter dartdoc em toda API pública e aparecer na página "GjaHBox e GjaVBox" da galeria, com os alinhamentos e um item expandido.

#### Scenario: Página GjaVBox na galeria
- **WHEN** a página "GjaHBox e GjaVBox" é aberta
- **THEN** ela exibe caixas verticais com os quatro valores de `alignItems` que não são `baseline` e uma caixa vertical com item expandido

### Requirement: [Restrições] Fora do escopo
`GjaVBox` SHALL NOT aceitar espaço ou tamanho literal, rolar, quebrar em colunas, inverter a direção nem desenhar separadores ou fundo.

#### Scenario: Caixa vertical sem valor literal
- **WHEN** a API pública de `GjaVBox` é inspecionada
- **THEN** o construtor não tem parâmetro do tipo `double` ou `EdgeInsets`
