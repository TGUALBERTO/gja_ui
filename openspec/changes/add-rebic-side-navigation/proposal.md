# Proposal: Navegação lateral (`add-rebic-side-navigation`)

## Why

A Fase 4 pede a navegação lateral. O modelo é o `sap.tnt.SideNavigation` com `sap.tnt.NavigationListItem`
(conferidos em `SAP/openui5`): `item` e `fixedItem` (listas de itens com `key`, `text`, `icon`, `enabled`,
`selectable` e subitens), `selectedKey`, `expanded` (recolhida só com ícones), `ariaLabel` e o evento `itemSelect`;
a largura expandida é `sapTntSideNavigation_ExpandedWidth`. O `RebicToolPage` já recebe um conteúdo lateral, que até
aqui a aplicação montava sozinha.

## What Changes

- Novo `RebicSideNavigation<T>`, controlado (`selectedKey` + `onItemSelect`), com `items` e `fixedItems` de
  `RebicNavigationListItem<T>`, `expanded` e `semanticLabel`; subitens que abrem e fecham, teclado pelas setas e modo
  recolhido com dicas.
- Catálogo: `rebic/widgets/rebic-side-navigation` passa a `implemented`.

Fora do escopo: `href`, o popover de subitens no modo recolhido, o desenho `Decorated` e os itens de ação.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-side-navigation`: `RebicSideNavigation`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `acoes_navegacao/side_navigation/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicSideNavigation".
- `docs/catalog.yaml`.
- Portal existente: nenhum impacto.
