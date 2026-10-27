## Purpose

`RebicGrid` organiza itens numa grade de 12 colunas, como o `sap.ui.layout.Grid` do SAPUI5: cada item ocupa um número de colunas por classe de tamanho, com herança da classe menor e span próprio opcional, e os itens fluem em linhas com espaço nomeado do tema entre colunas e linhas.

## ADDED Requirements

### Requirement: [API] Propriedades
`RebicGrid` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `children` / `cells` | `List<Widget>` / `List<RebicGridCell>` | obrigatória |
| `defaultSpan` | `RebicResponsiveValue<int>` | `small: 12, medium: 6, large: 4, extraLarge: 3` |
| `gap` | `RebicSpace` | `l` |
| `runGap` | `RebicSpace` | `l` |
| `basis` | `RebicLayoutBasis` | `container` |

`RebicGridCell` SHALL ter `child` e `span` opcional (`RebicResponsiveValue<int>?`).

#### Scenario: Grade mínima
- **GIVEN** uma árvore com `RebicApp` e uma área de 1200 de largura (classe `large`)
- **WHEN** `RebicGrid(children:)` recebe seis itens
- **THEN** eles ficam em duas linhas de três, cada um com quatro das 12 colunas

### Requirement: [API] Span válido
Cada span MUST estar entre 1 e 12, em todas as classes. Um span fora do intervalo MUST falhar em modo debug com mensagem que cita o span.

#### Scenario: Span inválido
- **WHEN** `RebicGrid` recebe um `defaultSpan` com `small` igual a 13
- **THEN** a renderização falha em modo debug com mensagem que cita o span

### Requirement: [API] Callbacks e controlador
`RebicGrid` SHALL NOT ter callbacks nem controlador: é um widget de layout.

#### Scenario: Grade sem ação
- **GIVEN** `RebicGrid` com itens
- **WHEN** o espaço entre dois itens é tocado
- **THEN** nada é executado pelo `RebicGrid`

### Requirement: [Comportamento] Largura das colunas
Um item com span `n` SHALL ocupar `n` colunas mais os `n − 1` espaços entre elas, com a largura de coluna `(L − 11 × gap) / 12`, em que `L` é a largura da grade.

#### Scenario: Larguras de span 4 e 8
- **GIVEN** uma grade de 1200 de largura com `gap` `l` e dois itens com spans 4 e 8 na classe atual
- **WHEN** a grade é renderizada
- **THEN** os itens ficam na mesma linha, separados por `spacing.l`, e o segundo termina na borda final da grade

### Requirement: [Comportamento] Fluxo em linhas
Os itens SHALL ocupar as linhas na ordem dada. Um item cujo span não cabe nas colunas restantes da linha MUST começar a linha seguinte. As linhas SHALL ser separadas por `runGap`.

#### Scenario: Quebra quando não cabe
- **GIVEN** três itens com spans 6, 4 e 6 na classe atual
- **WHEN** a grade é renderizada
- **THEN** os dois primeiros ficam na primeira linha, e o terceiro começa a segunda linha, a `spacing.<runGap>` da primeira

### Requirement: [Comportamento] Span por classe e por item
O span de um item SHALL ser o da classe atual no `span` da sua `RebicGridCell` ou, sem ele, no `defaultSpan`, com herança da classe menor nos dois casos.

#### Scenario: Item com span próprio
- **GIVEN** uma grade na classe `large` com `defaultSpan` padrão e uma célula com `span` `small: 12, large: 8`
- **WHEN** a grade é renderizada
- **THEN** a célula ocupa 8 colunas, e as demais ocupam 4

#### Scenario: Grade em cada classe
- **GIVEN** oito itens com o `defaultSpan` padrão
- **WHEN** a grade é renderizada em larguras das classes `small`, `medium`, `large` e `extraLarge`
- **THEN** há 1, 2, 3 e 4 itens por linha, respectivamente

### Requirement: [Aparência] Tokens de componente
`RebicGrid` SHALL obter `gap` e `runGap` de `spacing.<valor>` e os limiares de `breakpoints`, do tema ativo, sem valores literais, e SHALL NOT pintar nada.

#### Scenario: Espaço da densidade compacta
- **GIVEN** uma grade com `gap` `l` numa subárvore compacta
- **WHEN** dois itens ficam na mesma linha
- **THEN** a distância entre eles é o `l` compacto

### Requirement: [Estados] Sem estados de interação
`RebicGrid` SHALL NOT apresentar estados de interação, porque não é interativo.

#### Scenario: Grade não recebe foco
- **GIVEN** uma grade com dois itens focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada na própria grade

### Requirement: [Acessibilidade] Teclado e foco
A ordem de foco SHALL seguir a ordem dos itens: linha a linha, do início ao fim de cada linha.

#### Scenario: Ordem de foco na grade
- **GIVEN** quatro itens focáveis numa grade de duas colunas por linha
- **WHEN** Tab é pressionado três vezes a partir do primeiro
- **THEN** o foco passa pelo segundo, terceiro e quarto, nessa ordem

### Requirement: [Acessibilidade] Semântica e escala
`RebicGrid` SHALL NOT acrescentar nós à árvore de semântica. A escala de texto MUST NOT alterar os spans, que dependem só da largura.

#### Scenario: Semântica da grade inalterada
- **WHEN** a árvore de semântica de três textos é comparada dentro de `RebicGrid` e de uma `Column` nativa
- **THEN** os rótulos aparecem na mesma ordem

### Requirement: [Responsividade] Base e direção
A classe SHALL vir da largura disponível (`container`) ou da tela (`screen`), conforme `basis`. Em RTL, a primeira coluna MUST ficar à direita.

#### Scenario: Grade em RTL
- **GIVEN** a direção do texto da direita para a esquerda e dois itens de span 6
- **WHEN** a grade é renderizada
- **THEN** o primeiro item fica na metade direita

### Requirement: [Integração] Dependências
`RebicGrid` SHALL depender somente de `rebic/core/responsive`, `rebic/widgets/rebic-spacing`, `rebic/widgets/rebic-responsive-layout`, `rebic/foundation/breakpoints`, `rebic/foundation/spacing`, `rebic/foundation/density` e `rebic/foundation/theming`.

#### Scenario: Grade sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** os dois construtores de `RebicGrid` são renderizados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicGrid` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `rebic/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos.

#### Scenario: Rastreabilidade da grade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicGrid` SHALL ter dartdoc em toda API pública e uma página "RebicGrid" na galeria com cartões no `defaultSpan` padrão e uma célula de destaque com span próprio.

#### Scenario: Página RebicGrid na galeria
- **GIVEN** a galeria numa janela de 1200
- **WHEN** a página "RebicGrid" é aberta e a janela passa a 500
- **THEN** os cartões passam de três para um por linha

### Requirement: [Restrições] Fora do escopo
`RebicGrid` SHALL NOT aceitar larguras ou espaços literais, número de colunas diferente de 12, recuo de colunas nem ocultar itens por classe.

#### Scenario: Grade sem valor literal
- **WHEN** a API pública de `RebicGrid` e de `RebicGridCell` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem de número de colunas
