# rebic/widgets/rebic-row Specification

## Purpose

`RebicRow` organiza filhos lado a lado, como o `sap.m.HBox` do SAPUI5: aplica um espaço nomeado do tema só entre os filhos, alinha nos dois eixos, pode ocupar só o necessário e pode quebrar em várias linhas, sem números literais.

## Requirements

### Requirement: [API] Propriedades
`RebicRow` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `children` | `List<Widget>` | obrigatória |
| `gap` | `RebicSpace` | `inlineGap` |
| `mainAlignment` | `RebicMainAlignment` | `start` |
| `crossAlignment` | `RebicCrossAlignment` | `center` |
| `shrinkWrap` | `bool` | `false` |

O construtor `RebicRow.wrap` SHALL aceitar `children`, `gap` e `mainAlignment` e quebrar em linhas.

#### Scenario: Linha mínima
- **GIVEN** uma árvore com `RebicApp` na densidade confortável
- **WHEN** `RebicRow(children: [a, b])` é criado com dois quadrados de 20
- **THEN** eles ficam lado a lado, separados por `spacing.inlineGap`, alinhados ao início e centralizados na vertical

### Requirement: [API] Callbacks e controlador
`RebicRow` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Linha sem ação
- **GIVEN** `RebicRow` com dois filhos
- **WHEN** o espaço entre eles é tocado
- **THEN** nada é executado pelo `RebicRow`

### Requirement: [Comportamento] Espaço entre filhos
`RebicRow` SHALL inserir `gap` somente entre filhos consecutivos, nunca antes do primeiro nem depois do último. Com um único filho ou nenhum, MUST NOT haver espaço.

#### Scenario: Espaço só entre filhos da linha
- **GIVEN** três quadrados de 20 num `RebicRow` com `gap` `l` e `shrinkWrap`
- **WHEN** a linha é renderizada
- **THEN** a largura da linha é 60 + 2 × `spacing.l`, e o primeiro quadrado começa na borda da linha

### Requirement: [Comportamento] Alinhamento
`RebicRow` SHALL alinhar os filhos no eixo horizontal por `mainAlignment` (`start`, `center`, `end`, `spaceBetween`) e no vertical por `crossAlignment` (`start`, `center`, `end`, `stretch`). Em `spaceBetween`, o espaço livre MUST ser distribuído entre os filhos, além de `gap`.

#### Scenario: Alinhamento principal da linha
- **GIVEN** dois quadrados de 20 num `RebicRow` de 200 de largura com `mainAlignment` `end`
- **WHEN** a linha é renderizada
- **THEN** o segundo quadrado termina na borda final da linha

#### Scenario: Alinhamento cruzado da linha
- **GIVEN** um quadrado de 20 num `RebicRow` de 60 de altura com `crossAlignment` `stretch`
- **WHEN** a linha é renderizada
- **THEN** o quadrado passa a ter 60 de altura, a altura da linha

### Requirement: [Comportamento] Quebra de linha
`RebicRow.wrap` SHALL levar para a linha seguinte os filhos que não cabem na largura disponível, com `gap` entre filhos da mesma linha e entre as linhas.

#### Scenario: Linha com quebra
- **GIVEN** cinco quadrados de 40 num `RebicRow.wrap` de 120 de largura com `gap` `s`
- **WHEN** a linha é renderizada
- **THEN** os quadrados ocupam mais de uma linha, e a distância vertical entre as linhas é `spacing.s`

### Requirement: [Comportamento] Filhos expansíveis
Em `RebicRow` sem quebra, um filho `Expanded` ou `Flexible` SHALL ocupar o espaço livre, mantido o `gap` entre os filhos.

#### Scenario: Filho expandido na linha
- **GIVEN** um quadrado de 20 e um `Expanded` num `RebicRow` de 200 de largura com `gap` `m`
- **WHEN** a linha é renderizada
- **THEN** o filho expandido mede 200 − 20 − `spacing.m` de largura

### Requirement: [Aparência] Tokens de componente
`RebicRow` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de densidade da linha
- **GIVEN** `RebicRow` com `gap` `l` na densidade cozy
- **WHEN** o tema ativo passa para a densidade compacta e, depois, para um tema com `l` de 24
- **THEN** o espaço entre os filhos continua o `l` de referência na compacta e passa a 24 no último tema, sem recriar o widget com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`RebicRow` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Linha não recebe foco
- **GIVEN** um `RebicRow` com dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio `RebicRow`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco dos filhos de `RebicRow` SHALL seguir a ordem visual, inclusive em RTL.

#### Scenario: Ordem de foco na linha
- **GIVEN** três elementos focáveis num `RebicRow`
- **WHEN** Tab é pressionado duas vezes a partir do primeiro
- **THEN** o foco passa pelo segundo e pelo terceiro, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`RebicRow` SHALL NOT acrescentar nós à árvore de semântica. O `gap` MUST NOT depender da escala de texto.

#### Scenario: Semântica da linha inalterada
- **WHEN** a árvore de semântica de dois textos é comparada dentro de `RebicRow` e de uma `Row` nativa
- **THEN** as duas árvores têm os mesmos rótulos, na mesma ordem

### Requirement: [Responsividade] Direção e densidade
`RebicRow` SHALL seguir a direção do texto: em RTL, o início é à direita. O `gap` SHALL usar o espaçamento do tema ativo, que é o mesmo nas densidades cozy e compacta, conforme `rebic/foundation/density`. Para larguras pequenas, `RebicRow.wrap` é a forma de evitar estouro.

#### Scenario: Linha em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** `RebicRow` com dois quadrados é renderizado com `mainAlignment` `start`
- **THEN** o primeiro quadrado fica na borda direita

#### Scenario: Densidade compacta na linha
- **GIVEN** um `RebicRow` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o mesmo `l` dentro e fora

### Requirement: [Integração] Dependências
`RebicRow` SHALL depender somente de `rebic/widgets/rebic-spacing`, `rebic/foundation/spacing`, `rebic/foundation/density` e `rebic/foundation/theming`, e dos widgets nativos `Flex` e `Wrap`.

#### Scenario: Linha sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicRow` e `RebicRow.wrap` são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicRow` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `rebic/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade da linha
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicRow` SHALL ter dartdoc em toda API pública e aparecer na página "RebicRow e RebicColumn" da galeria, com os alinhamentos, um filho expandido e a quebra.

#### Scenario: Página RebicRow na galeria
- **WHEN** a página "RebicRow e RebicColumn" é aberta
- **THEN** ela exibe linhas com os quatro alinhamentos principais, um filho expandido e uma linha com quebra

### Requirement: [Restrições] Fora do escopo
`RebicRow` SHALL NOT aceitar espaço literal, rolar nem desenhar divisores. `RebicRow.wrap` MUST NOT aceitar filhos `Expanded` ou `Flexible`.

#### Scenario: Linha sem valor literal
- **WHEN** a API pública de `RebicRow` é inspecionada
- **THEN** nenhum construtor tem parâmetro do tipo `double` ou `EdgeInsets`
