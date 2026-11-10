# Proposal: GjaGrid (`gja/widgets/gja-grid`)

## Why

Painéis, formulários e listas de cartões precisam de uma grade que reorganize os itens pela largura: quatro cartões
por linha no desktop, dois no tablet e um no celular. Com `GjaResponsiveLayout` isso exige um construtor por
classe, repetindo o mesmo conteúdo. Com `GjaRow.wrap`, as larguras não seguem colunas.

O design da Fase 0 previu `GjaGrid` com 12 colunas e os breakpoints dos fundamentos, no papel do
`sap.ui.layout.Grid` do SAPUI5:
- `defaultSpan="XL3 L4 M6 S12"` define quantas das 12 colunas cada item ocupa em cada faixa;
- `GridData` muda o span de um item específico.

## What Changes

- Widget `GjaGrid` em `gja_widgets`, com 12 colunas:
  - `GjaGrid(children:)`: todos os itens usam `defaultSpan`;
  - `GjaGrid.cells(cells:)`: cada `GjaGridCell` pode ter o próprio `span`.
- `defaultSpan` (`GjaResponsiveValue<int>`): padrão `small: 12, medium: 6, large: 4, extraLarge: 3`, como o padrão
  do UI5. O span de cada classe herda da classe menor.
- Os itens fluem em linhas; um item que não cabe no restante da linha vai para a seguinte.
- `gap` (entre colunas) e `runGap` (entre linhas) são `GjaSpace`, com padrão `l`.
- A classe vem do contêiner (padrão) ou da tela (`GjaLayoutBasis`), com os limiares do tema.
- Os itens seguem a direção do texto: em RTL, a primeira coluna fica à direita.
- Classe de dados `GjaGridCell(child:, span:)`. É uma configuração, não um widget, e por isso fica na mesma spec.
- Página "GjaGrid" na galeria.

Fora do escopo:
- Recuo de colunas (`indent`) e ocultar itens por classe (`visibleS`…).
- Altura igual entre itens de uma linha.
- Grade com número de colunas diferente de 12.
- Grade virtualizada para muitos itens.

## Capabilities

### New Capabilities

- `gja/widgets/gja-grid`: grade de 12 colunas com span por classe de tamanho, herança da classe menor, span por
  item, espaço nomeado entre colunas e linhas, e base contêiner ou tela.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/fundacao_layout/grid/` e testes.
- **Galeria:** nova página "GjaGrid".
- **Catálogo:** `gja/widgets/gja-grid` → `implemented`. As dependências (`core/responsive`, `gja-spacing`)
  ganham `gja/widgets/gja-responsive-layout` (`GjaLayoutBasis`), `foundation/breakpoints`, `foundation/spacing`,
  `foundation/density` e `foundation/theming`.
- **Portal existente:** sem impacto.
