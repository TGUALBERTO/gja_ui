# Proposal: Grade no modelo do SAPUI5 (`update-gja-grid-fiori-layout-grid`)

## Why

O `GjaGrid` segue a ideia do `sap.ui.layout.Grid`, mas diverge em valores e nomes (conferido em `SAP/openui5`,
`sap.ui.layout/Grid.js`, `GridData.js` e `themes/base/Grid.less`):

- o `defaultSpan` do UI5 é `XL3 L3 M6 S12`, quatro itens por linha já na classe L; o GJA usa `large: 4`, e o
  dartdoc de `standardSpan` afirma, por engano, que o UI5 usa `XL3 L4 M6 S12`;
- o UI5 mede a classe pela tela (`containerQuery` com padrão `false`); o GJA mede pela largura disponível
  (`basis: container`);
- os nomes são outros: `content` (os itens), `GridData` (o span por item, como `layoutData` do item), `hSpacing` e
  `vSpacing`; o GJA usa `children`/`cells`, `GjaGridCell`, `gap`, `runGap` e `basis`, e tem dois construtores.

É o último passo do bloco de layout do realinhamento ao SAPUI5.

## What Changes

- **BREAKING** Padrão `defaultSpan` `XL3 L3 M6 S12`: na classe `large`, quatro itens por linha em vez de três.
- **BREAKING** Nomes do UI5:
  - um só construtor, `GjaGrid(content: [...])`; `GjaGrid.cells` e `GjaGridCell` saem;
  - novo `GjaGridData(span: ..., child: ...)`, um widget que envolve o item, como o `layoutData` do UI5;
  - `gap` → `hSpacing` e `runGap` → `vSpacing` (`GjaSpace`, padrão `l`, o 1rem do UI5);
  - `basis` → `containerQuery` (`bool`, padrão `false`): por padrão a classe vem da tela, como no UI5; com `true`,
    da largura disponível.
- `GjaGrid` deixa de depender de `gja/widgets/gja-responsive-layout`, cujo `GjaLayoutBasis` não usa mais.
- A galeria passa a `content`/`GjaGridData`; a página "GjaGrid" mostra quatro cartões por linha numa janela de
  1200.

Diferente do UI5, de propósito: a grade não tem margem externa (o UI5 soma meio `hSpacing` de preenchimento e meio de
margem nas bordas), porque a página já aplica a margem de conteúdo; nem espaço depois da última linha.

Fora do escopo, como antes: `defaultIndent` e os `indent`, `visibleS/M/L/XL`, `linebreak` e `moveBackwards`/
`moveForward` do `GridData`, e `position`.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-grid`: API, padrão de span, classe pela tela, dependências, galeria e restrições.

## Impact

- `packages/gja_widgets`: `fundacao_layout/grid/gja_grid.dart` (`GjaGrid` e o novo `GjaGridData`), testes da
  grade e o teste do cartão que monta uma grade; CHANGELOG com o de/para.
- `apps/gja_gallery`: páginas "GjaGrid" e "GjaCard" e o teste da página da grade.
- `docs/catalog.yaml`: dependências de `gja/widgets/gja-grid` sem `gja/widgets/gja-responsive-layout`.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
