## Purpose

`GjaRow` organiza filhos lado a lado, como o `sap.m.HBox` do SAPUI5: aplica um espaço nomeado do tema só entre os filhos, alinha nos dois eixos, pode ocupar só o necessário e pode quebrar em várias linhas, sem números literais.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaRow` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `children` | `List<Widget>` | obrigatória |
| `gap` | `GjaSpace` | `inlineGap` |
| `mainAlignment` | `GjaMainAlignment` | `start` |
| `crossAlignment` | `GjaCrossAlignment` | `center` |
| `shrinkWrap` | `bool` | `false` |

O construtor `GjaRow.wrap` SHALL aceitar `children`, `gap` e `mainAlignment` e quebrar em linhas.

#### Scenario: Linha mínima
- **GIVEN** uma árvore com `GjaApp` na densidade confortável
- **WHEN** `GjaRow(children: [a, b])` é criado com dois quadrados de 20
- **THEN** eles ficam lado a lado, separados por `spacing.inlineGap`, alinhados ao início e centralizados na vertical

### Requirement: [API] Callbacks e controlador
`GjaRow` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Linha sem ação
- **GIVEN** `GjaRow` com dois filhos
- **WHEN** o espaço entre eles é tocado
- **THEN** nada é executado pelo `GjaRow`

### Requirement: [Comportamento] Espaço entre filhos
`GjaRow` SHALL inserir `gap` somente entre filhos consecutivos, nunca antes do primeiro nem depois do último. Com um único filho ou nenhum, MUST NOT haver espaço.

#### Scenario: Espaço só entre filhos da linha
- **GIVEN** três quadrados de 20 num `GjaRow` com `gap` `l` e `shrinkWrap`
- **WHEN** a linha é renderizada
- **THEN** a largura da linha é 60 + 2 × `spacing.l`, e o primeiro quadrado começa na borda da linha

### Requirement: [Comportamento] Alinhamento
`GjaRow` SHALL alinhar os filhos no eixo horizontal por `mainAlignment` (`start`, `center`, `end`, `spaceBetween`) e no vertical por `crossAlignment` (`start`, `center`, `end`, `stretch`). Em `spaceBetween`, o espaço livre MUST ser distribuído entre os filhos, além de `gap`.

#### Scenario: Alinhamento principal da linha
- **GIVEN** dois quadrados de 20 num `GjaRow` de 200 de largura com `mainAlignment` `end`
- **WHEN** a linha é renderizada
- **THEN** o segundo quadrado termina na borda final da linha

#### Scenario: Alinhamento cruzado da linha
- **GIVEN** um quadrado de 20 num `GjaRow` de 60 de altura com `crossAlignment` `stretch`
- **WHEN** a linha é renderizada
- **THEN** o quadrado passa a ter 60 de altura, a altura da linha

### Requirement: [Comportamento] Quebra de linha
`GjaRow.wrap` SHALL levar para a linha seguinte os filhos que não cabem na largura disponível, com `gap` entre filhos da mesma linha e entre as linhas.

#### Scenario: Linha com quebra
- **GIVEN** cinco quadrados de 40 num `GjaRow.wrap` de 120 de largura com `gap` `s`
- **WHEN** a linha é renderizada
- **THEN** os quadrados ocupam mais de uma linha, e a distância vertical entre as linhas é `spacing.s`

### Requirement: [Comportamento] Filhos expansíveis
Em `GjaRow` sem quebra, um filho `Expanded` ou `Flexible` SHALL ocupar o espaço livre, mantido o `gap` entre os filhos.

#### Scenario: Filho expandido na linha
- **GIVEN** um quadrado de 20 e um `Expanded` num `GjaRow` de 200 de largura com `gap` `m`
- **WHEN** a linha é renderizada
- **THEN** o filho expandido mede 200 − 20 − `spacing.m` de largura

### Requirement: [Aparência] Tokens de componente
`GjaRow` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de densidade da linha
- **GIVEN** `GjaRow` com `gap` `l` na densidade confortável
- **WHEN** o tema ativo passa para a densidade compacta
- **THEN** o espaço entre os filhos passa ao `l` compacto, sem recriar o widget com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`GjaRow` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Linha não recebe foco
- **GIVEN** um `GjaRow` com dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio `GjaRow`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco dos filhos de `GjaRow` SHALL seguir a ordem visual, inclusive em RTL.

#### Scenario: Ordem de foco na linha
- **GIVEN** três elementos focáveis num `GjaRow`
- **WHEN** Tab é pressionado duas vezes a partir do primeiro
- **THEN** o foco passa pelo segundo e pelo terceiro, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`GjaRow` SHALL NOT acrescentar nós à árvore de semântica. O `gap` MUST NOT depender da escala de texto.

#### Scenario: Semântica da linha inalterada
- **WHEN** a árvore de semântica de dois textos é comparada dentro de `GjaRow` e de uma `Row` nativa
- **THEN** as duas árvores têm os mesmos rótulos, na mesma ordem

### Requirement: [Responsividade] Direção e densidade
`GjaRow` SHALL seguir a direção do texto: em RTL, o início é à direita. O `gap` SHALL usar o espaçamento da densidade ativa. Para larguras pequenas, `GjaRow.wrap` é a forma de evitar estouro.

#### Scenario: Linha em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** `GjaRow` com dois quadrados é renderizado com `mainAlignment` `start`
- **THEN** o primeiro quadrado fica na borda direita

#### Scenario: Densidade compacta na linha
- **GIVEN** um `GjaRow` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o `l` compacto dentro e o `l` confortável fora

### Requirement: [Integração] Dependências
`GjaRow` SHALL depender somente de `gja/widgets/gja-spacing`, `gja/foundation/spacing`, `gja/foundation/density` e `gja/foundation/theming`, e dos widgets nativos `Flex` e `Wrap`.

#### Scenario: Linha sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaRow` e `GjaRow.wrap` são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaRow` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `gja/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade da linha
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaRow` SHALL ter dartdoc em toda API pública e aparecer na página "GjaRow e GjaColumn" da galeria, com os alinhamentos, um filho expandido e a quebra.

#### Scenario: Página GjaRow na galeria
- **WHEN** a página "GjaRow e GjaColumn" é aberta
- **THEN** ela exibe linhas com os quatro alinhamentos principais, um filho expandido e uma linha com quebra

### Requirement: [Restrições] Fora do escopo
`GjaRow` SHALL NOT aceitar espaço literal, rolar nem desenhar divisores. `GjaRow.wrap` MUST NOT aceitar filhos `Expanded` ou `Flexible`.

#### Scenario: Linha sem valor literal
- **WHEN** a API pública de `GjaRow` é inspecionada
- **THEN** nenhum construtor tem parâmetro do tipo `double` ou `EdgeInsets`
