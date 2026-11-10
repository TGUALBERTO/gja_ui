## Purpose

`GjaColumn` empilha filhos na vertical, como o `sap.m.VBox` do SAPUI5: aplica um espaço nomeado do tema só entre os filhos, alinha nos dois eixos e pode ocupar só o necessário, sem números literais.

## ADDED Requirements

### Requirement: [API] Propriedades
`GjaColumn` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `children` | `List<Widget>` | obrigatória |
| `gap` | `GjaSpace` | `stackGap` |
| `mainAlignment` | `GjaMainAlignment` | `start` |
| `crossAlignment` | `GjaCrossAlignment` | `start` |
| `shrinkWrap` | `bool` | `false` |

#### Scenario: Coluna mínima
- **GIVEN** uma árvore com `GjaApp` na densidade confortável
- **WHEN** `GjaColumn(children: [a, b])` é criado com dois quadrados de 20
- **THEN** eles ficam empilhados, separados por `spacing.stackGap`, alinhados ao topo e ao início

### Requirement: [API] Callbacks e controlador
`GjaColumn` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Coluna sem ação
- **GIVEN** `GjaColumn` com dois filhos
- **WHEN** o espaço entre eles é tocado
- **THEN** nada é executado pelo `GjaColumn`

### Requirement: [Comportamento] Espaço entre filhos
`GjaColumn` SHALL inserir `gap` somente entre filhos consecutivos, nunca antes do primeiro nem depois do último. Com um único filho ou nenhum, MUST NOT haver espaço.

#### Scenario: Espaço só entre filhos da coluna
- **GIVEN** três quadrados de 20 num `GjaColumn` com `gap` `l` e `shrinkWrap`
- **WHEN** a coluna é renderizada
- **THEN** a altura da coluna é 60 + 2 × `spacing.l`, e o primeiro quadrado começa no topo da coluna

### Requirement: [Comportamento] Alinhamento
`GjaColumn` SHALL alinhar os filhos no eixo vertical por `mainAlignment` (`start`, `center`, `end`, `spaceBetween`) e no horizontal por `crossAlignment` (`start`, `center`, `end`, `stretch`). Em `spaceBetween`, o espaço livre MUST ser distribuído entre os filhos, além de `gap`.

#### Scenario: Alinhamento principal da coluna
- **GIVEN** dois quadrados de 20 num `GjaColumn` de 200 de altura com `mainAlignment` `spaceBetween`
- **WHEN** a coluna é renderizada
- **THEN** o primeiro quadrado começa no topo e o segundo termina na base da coluna

#### Scenario: Alinhamento cruzado da coluna
- **GIVEN** um quadrado de 20 num `GjaColumn` de 200 de largura com `crossAlignment` `stretch`
- **WHEN** a coluna é renderizada
- **THEN** o quadrado passa a ter 200 de largura

### Requirement: [Comportamento] Filhos expansíveis
Em `GjaColumn`, um filho `Expanded` ou `Flexible` SHALL ocupar o espaço vertical livre, mantido o `gap` entre os filhos.

#### Scenario: Filho expandido na coluna
- **GIVEN** um quadrado de 20 e um `Expanded` num `GjaColumn` de 200 de altura com `gap` `m`
- **WHEN** a coluna é renderizada
- **THEN** o filho expandido mede 200 − 20 − `spacing.m` de altura

### Requirement: [Aparência] Tokens de componente
`GjaColumn` SHALL obter `gap` de `spacing.<valor>` do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Troca de densidade da coluna
- **GIVEN** `GjaColumn` com `gap` `l` na densidade confortável
- **WHEN** o tema ativo passa para a densidade compacta
- **THEN** o espaço entre os filhos passa ao `l` compacto, sem recriar o widget com outros parâmetros

### Requirement: [Estados] Sem estados visuais
`GjaColumn` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Coluna não recebe foco
- **GIVEN** um `GjaColumn` com dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no próprio `GjaColumn`

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco dos filhos de `GjaColumn` SHALL seguir a ordem visual, de cima para baixo.

#### Scenario: Ordem de foco na coluna
- **GIVEN** três elementos focáveis num `GjaColumn`
- **WHEN** Tab é pressionado duas vezes a partir do primeiro
- **THEN** o foco passa pelo segundo e pelo terceiro, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`GjaColumn` SHALL NOT acrescentar nós à árvore de semântica. O `gap` MUST NOT depender da escala de texto.

#### Scenario: Semântica da coluna inalterada
- **WHEN** a árvore de semântica de dois textos é comparada dentro de `GjaColumn` e de uma `Column` nativa
- **THEN** as duas árvores têm os mesmos rótulos, na mesma ordem

### Requirement: [Responsividade] Direção e densidade
O alinhamento cruzado de `GjaColumn` SHALL seguir a direção do texto: em RTL, `start` é à direita. O `gap` SHALL usar o espaçamento da densidade ativa.

#### Scenario: Coluna em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um `GjaColumn` de 200 de largura com um quadrado é renderizado com `crossAlignment` `start`
- **THEN** o quadrado fica na borda direita

#### Scenario: Densidade compacta na coluna
- **GIVEN** um `GjaColumn` com `gap` `l`, dentro e fora de uma subárvore compacta
- **WHEN** os dois são renderizados
- **THEN** o espaço é o `l` compacto dentro e o `l` confortável fora

### Requirement: [Integração] Dependências
`GjaColumn` SHALL depender somente de `gja/widgets/gja-spacing`, `gja/foundation/spacing`, `gja/foundation/density` e `gja/foundation/theming`, e do widget nativo `Flex`.

#### Scenario: Coluna sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** `GjaColumn` é renderizado
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`GjaColumn` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `gja/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos; as medidas são verificadas por valor.

#### Scenario: Rastreabilidade da coluna
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`GjaColumn` SHALL ter dartdoc em toda API pública e aparecer na página "GjaRow e GjaColumn" da galeria, com os alinhamentos e um filho expandido.

#### Scenario: Página GjaColumn na galeria
- **WHEN** a página "GjaRow e GjaColumn" é aberta
- **THEN** ela exibe colunas com os quatro alinhamentos cruzados e uma coluna com filho expandido

### Requirement: [Restrições] Fora do escopo
`GjaColumn` SHALL NOT aceitar espaço literal, rolar, quebrar em colunas nem desenhar divisores.

#### Scenario: Coluna sem valor literal
- **WHEN** a API pública de `GjaColumn` é inspecionada
- **THEN** nenhum construtor tem parâmetro do tipo `double` ou `EdgeInsets`
