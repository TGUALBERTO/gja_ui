# Proposal: Navegação lateral (`add-gja-side-navigation`)

## Why

A Fase 4 pede a navegação lateral. O modelo é o `sap.tnt.SideNavigation` com `sap.tnt.NavigationListItem`
(conferidos em `SAP/openui5`): `item` e `fixedItem` (listas de itens com `key`, `text`, `icon`, `enabled`,
`selectable` e subitens), `selectedKey`, `expanded` (recolhida só com ícones), `ariaLabel` e o evento `itemSelect`;
a largura expandida é `sapTntSideNavigation_ExpandedWidth`. O `GjaToolPage` já recebe um conteúdo lateral, que até
aqui a aplicação montava sozinha.

## What Changes

- Novo `GjaSideNavigation<T>`, controlado (`selectedKey` + `onItemSelect`), com `items` e `fixedItems` de
  `GjaNavigationListItem<T>`, `expanded` e `semanticLabel`; subitens que abrem e fecham, teclado pelas setas e modo
  recolhido com dicas.
- Catálogo: `gja/widgets/gja-side-navigation` passa a `implemented`.

Fora do escopo: `href`, o popover de subitens no modo recolhido, o desenho `Decorated` e os itens de ação.

## Capabilities

### New Capabilities

- `gja/widgets/gja-side-navigation`: `GjaSideNavigation`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `acoes_navegacao/side_navigation/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaSideNavigation".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
