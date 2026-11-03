# rebic/widgets/rebic-grid Specification

## Purpose

`RebicGrid` organiza itens numa grade de 12 colunas, como o `sap.ui.layout.Grid` do SAPUI5: cada item ocupa um número de colunas por classe de tamanho, com herança da classe menor e span próprio opcional, e os itens fluem em linhas com espaço nomeado do tema entre colunas e linhas.

## Requirements

### Requirement: [API] Propriedades
`RebicGrid` SHALL expor, como o `sap.ui.layout.Grid`:

| Prop | Tipo | Padrão |
|---|---|---|
| `content` | `List<Widget>` | obrigatória |
| `defaultSpan` | `RebicResponsiveValue<int>` | `small: 12, medium: 6, large: 3, extraLarge: 3` |
| `hSpacing` | `RebicSpace` | `l` |
| `vSpacing` | `RebicSpace` | `l` |
| `containerQuery` | `bool` | `false` |

`RebicGridData`, como o `GridData`, SHALL ser um widget com `child` e `span` (`RebicResponsiveValue<int>`), que envolve um item de `content`.

#### Scenario: Grade mínima
- **GIVEN** uma árvore com `RebicApp` e uma tela de 1200 de largura (classe `large`)
- **WHEN** `RebicGrid(content:)` recebe seis itens
- **THEN** eles ficam numa linha de quatro e numa de dois, cada um com três das 12 colunas

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
Um item com span `n` SHALL ocupar `n` colunas mais os `n − 1` espaços entre elas, com a largura de coluna `(L − 11 × hSpacing) / 12`, em que `L` é a largura da grade.

#### Scenario: Larguras de span 4 e 8
- **GIVEN** uma grade de 1200 de largura com `hSpacing` `l` e dois itens com spans 4 e 8 na classe atual
- **WHEN** a grade é renderizada
- **THEN** os itens ficam na mesma linha, separados por `spacing.l`, e o segundo termina na borda final da grade

### Requirement: [Comportamento] Fluxo em linhas
Os itens SHALL ocupar as linhas na ordem dada. Um item cujo span não cabe nas colunas restantes da linha MUST começar a linha seguinte. As linhas SHALL ser separadas por `vSpacing`.

#### Scenario: Quebra quando não cabe
- **GIVEN** três itens com spans 6, 4 e 6 na classe atual
- **WHEN** a grade é renderizada
- **THEN** os dois primeiros ficam na primeira linha, e o terceiro começa a segunda linha, a `spacing.<vSpacing>` da primeira

### Requirement: [Comportamento] Span por classe e por item
O span de um item SHALL ser o da classe atual no `span` do seu `RebicGridData` ou, sem ele, no `defaultSpan`, com herança da classe menor nos dois casos.

#### Scenario: Item com span próprio
- **GIVEN** uma grade na classe `large` com `defaultSpan` padrão e um item envolto em `RebicGridData` com `span` `small: 12, large: 6`
- **WHEN** a grade é renderizada
- **THEN** esse item ocupa 6 colunas, e os demais ocupam 3

#### Scenario: Grade em cada classe
- **GIVEN** oito itens com o `defaultSpan` padrão
- **WHEN** a grade é renderizada em larguras das classes `small`, `medium`, `large` e `extraLarge`
- **THEN** há 1, 2, 4 e 4 itens por linha, respectivamente

### Requirement: [Aparência] Tokens de componente
`RebicGrid` SHALL obter `hSpacing` e `vSpacing` de `spacing.<valor>` e os limiares de `breakpoints`, do tema ativo, sem valores literais, e SHALL NOT pintar nada. A grade SHALL NOT ter margem externa nem espaço depois da última linha: a margem vem da página.

#### Scenario: Espaço da densidade compacta
- **GIVEN** uma grade com `hSpacing` `l` numa subárvore compacta
- **WHEN** dois itens ficam na mesma linha
- **THEN** a distância entre eles é o `l` compacto

#### Scenario: Grade sem margem externa
- **GIVEN** uma grade de 1200 de largura com dois itens de span 6
- **WHEN** a grade é renderizada
- **THEN** o primeiro item começa na borda inicial, o segundo termina na borda final, e a altura da grade é a da linha

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
Com `containerQuery` `false`, a classe SHALL vir da largura da tela, como no UI5; com `true`, da largura disponível para a grade. Em RTL, a primeira coluna MUST ficar à direita.

#### Scenario: Classe pela tela
- **GIVEN** uma tela de 1200 de largura (classe `large`) e uma grade de 500 de largura com quatro itens
- **WHEN** a grade é renderizada com `containerQuery` `false` e depois com `true`
- **THEN** há quatro itens por linha no primeiro caso e um por linha no segundo

#### Scenario: Grade em RTL
- **GIVEN** a direção do texto da direita para a esquerda e dois itens de span 6
- **WHEN** a grade é renderizada
- **THEN** o primeiro item fica na metade direita

### Requirement: [Integração] Dependências
`RebicGrid` SHALL depender somente de `rebic/core/responsive`, `rebic/widgets/rebic-spacing`, `rebic/foundation/breakpoints`, `rebic/foundation/spacing`, `rebic/foundation/density` e `rebic/foundation/theming`.

#### Scenario: Grade sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** uma grade com itens simples e com `RebicGridData` é renderizada
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino

### Requirement: [Testes] Cobertura exigida
`RebicGrid` MUST ter um teste de widget por cenário. Por não pintar nada, os goldens e a bateria de contraste e alvo de toque de `rebic/foundation/accessibility` não se aplicam, e SHALL NOT ser exigidos.

#### Scenario: Rastreabilidade da grade
- **WHEN** a revisão compara os cenários desta spec com a suíte de testes
- **THEN** cada cenário tem um teste nomeado "<requisito> — <cenário>"

### Requirement: [Documentação] Exemplos mínimos
`RebicGrid` SHALL ter dartdoc em toda API pública e uma página "RebicGrid" na galeria com cartões no `defaultSpan` padrão e um item de destaque com `RebicGridData`.

#### Scenario: Página RebicGrid na galeria
- **GIVEN** a galeria numa janela de 1200
- **WHEN** a página "RebicGrid" é aberta e a janela passa a 500
- **THEN** os cartões passam de quatro para um por linha

### Requirement: [Restrições] Fora do escopo
`RebicGrid` SHALL NOT aceitar larguras ou espaços literais, número de colunas diferente de 12, recuo de colunas (`indent`), ocultar itens por classe (`visible`), quebra forçada (`linebreak`) nem posição da grade (`position`).

#### Scenario: Grade sem valor literal
- **WHEN** a API pública de `RebicGrid` e de `RebicGridData` é inspecionada
- **THEN** não há parâmetro do tipo `double` nem de número de colunas

