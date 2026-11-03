# Proposal: Barra de abas (`add-rebic-icon-tab-bar`)

## Why

A Fase 4 pede as abas. O modelo é o `sap.m.IconTabBar` com `sap.m.IconTabFilter` (conferidos em `SAP/openui5`):
`items` (filtros com `key`, `text`, `icon`, `count`, `enabled` e `content`), `selectedKey`, `applyContentPadding` e o
evento `select`; a aba escolhida tem o texto e o traço na cor da marca, e o teclado move o foco pelas setas e
escolhe com Enter ou Espaço.

## What Changes

- Novo `RebicIconTabBar<T>`, controlado (`selectedKey` + `onSelect`), com `items` de `RebicIconTabFilter<T>` e
  `applyContentPadding`; o cabeçalho rola na horizontal quando as abas não cabem.
- Catálogo: `rebic/widgets/rebic-tabs` passa a `rebic/widgets/rebic-icon-tab-bar` (o nome do UI5).
- ADR 0009: altura do traço da aba escolhida.

Fora do escopo: abas aninhadas, menu de abas que não cabem, reordenação, `expandable`, `headerMode` `Inline` e
`iconColor`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-icon-tab-bar`: `RebicIconTabBar`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `acoes_navegacao/icon_tab_bar/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicIconTabBar".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
