# Proposal: Barra de abas (`add-gja-icon-tab-bar`)

## Why

A Fase 4 pede as abas. O modelo é o `sap.m.IconTabBar` com `sap.m.IconTabFilter` (conferidos em `SAP/openui5`):
`items` (filtros com `key`, `text`, `icon`, `count`, `enabled` e `content`), `selectedKey`, `applyContentPadding` e o
evento `select`; a aba escolhida tem o texto e o traço na cor da marca, e o teclado move o foco pelas setas e
escolhe com Enter ou Espaço.

## What Changes

- Novo `GjaIconTabBar<T>`, controlado (`selectedKey` + `onSelect`), com `items` de `GjaIconTabFilter<T>` e
  `applyContentPadding`; o cabeçalho rola na horizontal quando as abas não cabem.
- Catálogo: `gja/widgets/gja-tabs` passa a `gja/widgets/gja-icon-tab-bar` (o nome do UI5).
- ADR 0009: altura do traço da aba escolhida.

Fora do escopo: abas aninhadas, menu de abas que não cabem, reordenação, `expandable`, `headerMode` `Inline` e
`iconColor`.

## Capabilities

### New Capabilities

- `gja/widgets/gja-icon-tab-bar`: `GjaIconTabBar`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `acoes_navegacao/icon_tab_bar/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaIconTabBar".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
