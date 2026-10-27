# rebic/widgets/rebic-column Specification

## Purpose

`RebicColumn` empilha filhos na vertical, como o `sap.m.VBox` do SAPUI5: aplica um espaço nomeado do tema só entre os filhos, alinha nos dois eixos e pode ocupar só o necessário, sem números literais.

## Requirements

### Requirement: [API] Propriedades
`RebicColumn` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `children` | `List<Widget>` | obrigatória |
| `gap` | `RebicSpace` | `stackGap` |
| `mainAlignment` | `RebicMainAlignment` | `start` |
| `crossAlignment` | `RebicCrossAlignment` | `start` |
| `shrinkWrap` | `bool` | `false` |

#### Scenario: Coluna mínima
- **GIVEN** uma árvore com `RebicApp` na densidade confortável
- **WHEN** `RebicColumn(children: [a, b])` é criado com dois quadrados de 20
- **THEN** eles ficam empilhados, separados por `spacing.stackGap`, alinhados ao topo e ao início

### Requirement: [API] Callbacks e controlador
`RebicColumn` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Coluna sem ação
- **GIVEN** `RebicColumn` com dois filhos
- **WHEN** o espaço entre eles é tocado
- **THEN** nada é executado pelo `RebicColumn`

### Requirement: [Comportamento] Espaço entre filhos
`RebicColumn` SHALL inserir `gap` somente entre filhos consecutivos, nunca antes do primeiro nem depois do último. Com um único filho ou nenhum, MUST NOT haver espaço.

#### Scenario: Espaço só entre filhos da coluna
- **GIVEN** três quadrados de 20 num `RebicColumn` com `gap` `l` e `shrinkWrap`
- **WHEN** a coluna é renderizada
- **THEN** a altura da coluna é 60 + 2 × `spacing.l`, e o primeiro quadrado começa no topo da coluna

### Requirement: [Comportamento] Alinhamento
`RebicColumn` SHALL alinhar os filhos no eixo vertical por `mainAlignment` (`start`, `center`, `end`, `spaceBetween`) e no horizontal por `crossAlignment` (`start`, `center`, `end`, `stretch`). Em `spaceBetween`, o espaço livre MUST ser distribuído entre os filhos, além de `gap`.

#### Scenario: Alinhamento principal da coluna
- **GIVEN** dois quadrados de 20 num `RebicColumn` de 200 de altura com `mainAlignment` `spaceBetween`
- **WHEN** a coluna é renderizada
- **THEN** o primeiro quadrado começa no topo e o segundo termina na base da coluna

#### Scenario: Alinhamento cruzado da coluna
- **GIVEN** um quadrado de 20 num `RebicColumn` de 200 de largura com `crossAlignment` `stretch`
- **WHEN** a coluna é renderizada
- **THEN** o quadrado passa a ter 200 de largura

### Requirement: [Comportamento] Filhos expansíveis
Em `RebicColumn`, um filho `Expanded` ou `Flexible` SHALL ocupar o espaço vertical livre, mantido o `gap` entre os filhos.

#### Scenario: Filho expandido na coluna
- **GIVEN** um quadrado de 20 e um `Expanded` num `RebicColumn` de 200 de altura com `gap` `m`
- **WHEN** a coluna é renderizada
- **THEN** o filho expandido mede 200 − 20 − `spacing.m` de altura

### Requirement: [Aparência] Tokens de componente
`RebicColumn` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de densidade da coluna
- **GIVEN** `RebicColumn` com `gap` `l` na densidade confortável
- **WHEN** o tema ativo passa para a densidade compacta
- **THEN** o espaço entre os filhos passa ao `l` compacto, sem recriar o widget com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`RebicColumn` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Coluna não recebe foco
- **GIVEN** um `RebicColumn` com dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio `RebicColumn`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco dos filhos de `RebicColumn` SHALL seguir a ordem visual, de cima para baixo.

#### Scenario: Ordem de foco na coluna
- **GIVEN** três elementos focáveis num `RebicColumn`
- **WHEN** Tab é pressionado duas vezes a partir do primeiro
- **THEN** o foco passa pelo segundo e pelo terceiro, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`RebicColumn` SHALL NOT acrescentar nós à árvore de semântica. O `gap` MUST NOT depender da escala de texto.

#### Scenario: Semântica da coluna inalterada
- **WHEN** a árvore de semântica de dois textos é comparada dentro de `RebicColumn` e de uma `Column` nativa
- **THEN** as duas árvores têm os mesmos rótulos, na mesma ordem

### Requirement: [Responsividade] Direção e densidade
O alinhamento cruzado de `RebicColumn` SHALL seguir a direção do texto: em RTL, `start` é à direita. O `gap` SHALL usar o espaçamento da densidade ativa.

#### Scenario: Coluna em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um `RebicColumn` de 200 de largura com um quadrado é renderizado com `crossAlignment` `start`
- **THEN** o quadrado fica na borda direita

#### Scenario: Densidade compacta na coluna
- **GIVEN** um `RebicColumn` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o `l` compacto dentro e o `l` confortável fora

### Requirement: [Integração] Dependências
`RebicColumn` SHALL depender somente de `rebic/widgets/rebic-spacing`, `rebic/foundation/spacing`, `rebic/foundation/density` e `rebic/foundation/theming`, e do widget nativo `Flex`.

#### Scenario: Coluna sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** `RebicColumn` é renderizado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicColumn` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `rebic/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade da coluna
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicColumn` SHALL ter dartdoc em toda API pública e aparecer na página "RebicRow e RebicColumn" da galeria, com os alinhamentos e um filho expandido.

#### Scenario: Página RebicColumn na galeria
- **WHEN** a página "RebicRow e RebicColumn" é aberta
- **THEN** ela exibe colunas com os quatro alinhamentos cruzados e uma coluna com filho expandido

### Requirement: [Restrições] Fora do escopo
`RebicColumn` SHALL NOT aceitar espaço literal, rolar, quebrar em colunas nem desenhar divisores.

#### Scenario: Coluna sem valor literal
- **WHEN** a API pública de `RebicColumn` é inspecionada
- **THEN** nenhum construtor tem parâmetro do tipo `double` ou `EdgeInsets`
