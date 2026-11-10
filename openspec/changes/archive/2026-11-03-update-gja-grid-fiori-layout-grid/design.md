# Design: Grade no modelo do SAPUI5

## Context

- `fundacao_layout/grid/gja_grid.dart` tem `GjaGridCell` (classe de dados com `child` e `span`), `GjaGrid(children:)`
  e `GjaGrid.cells(cells:)`, `gap`, `runGap`, `basis` (`GjaLayoutBasis`, de `gja-responsive-layout`, padrão
  `container`) e `standardSpan` `small: 12, medium: 6, large: 4, extraLarge: 3`.
- O layout é um `LayoutBuilder` que reparte os itens em linhas e monta `Column` de `Row`s com `SizedBox` na largura do
  span. Com `basis: screen`, a classe vem de `GjaResponsive.screenSizeClassOf`.
- Usos: galeria ("GjaGrid" e "GjaCard"), testes da grade e um teste do cartão.

Veja proposal.md para o `sap.ui.layout.Grid` conferido.

## Goals / Non-Goals

**Goals:**
- `defaultSpan`, nomes e base de medida do UI5.

**Non-Goals:**
- Margem externa da grade do UI5, `indent`, `visible`, `linebreak`, `position` (ver proposal.md).

## Decisions

### D1. `GjaGridData` como widget envolvente

```dart
class GjaGridData extends StatelessWidget {
  const GjaGridData({required this.span, required this.child, super.key});
  final GjaResponsiveValue<int> span;
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}
```

O UI5 liga o `GridData` ao item por `layoutData`; no Flutter, o equivalente idiomático é envolver o item, como
`Expanded` num `Flex`. A grade lê o span de cada item de `content` com `item is GjaGridData ? item.span : null`, sem
`ParentDataWidget`: a grade já monta cada item dentro do seu próprio `SizedBox`.

Com isso há um só construtor, `GjaGrid({required content, ...})`, que pode ser `const`. `GjaGridCell` e
`GjaGrid.cells` saem.

Alternativa considerada: manter `GjaGridCell` como dado e renomear. Rejeitada porque obriga dois construtores, ou
uma lista de configurações em vez de widgets, onde o UI5 tem uma só agregação `content`.

### D2. `containerQuery`

`containerQuery: false` usa `GjaResponsive.screenSizeClassOf(context)`; `true` usa
`theme.breakpoints.classify(constraints.maxWidth)`, como hoje com `basis`. A asserção de largura finita continua, porque
a largura de coluna depende da largura da grade em qualquer caso.

Os testes que medem a grade dentro de uma área (`_area(width, ...)`) passam `containerQuery: true` ou ajustam o
tamanho da tela de teste, conforme o cenário.

### D3. `defaultSpan` padrão

`standardSpan` passa a `small: 12, medium: 6, large: 3, extraLarge: 3`. Com a herança da classe menor, `extraLarge`
poderia ser omitido; fica explícito para espelhar o `XL3 L3 M6 S12`.

### D4. Galeria

A página "GjaGrid" troca para `content` e um `GjaGridData` de destaque (`small: 12, large: 6`), e a página do
cartão troca `children` por `content`. Na janela de 1200 do teste da galeria, a grade mostra quatro cartões por linha.

## Risks / Trade-offs

- **[Telas de L passam de três para quatro itens por linha]** → é o padrão do UI5; quem precisar de três passa
  `defaultSpan` com `large: 4`.
- **[Classe pela tela num painel estreito]** → uma grade dentro de um conteúdo lateral ou de um cartão usa a classe da
  tela, como no UI5; o dartdoc indica `containerQuery: true` para esses casos.
