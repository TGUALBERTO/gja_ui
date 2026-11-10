# Proposal: Barra de ferramentas (`add-gja-toolbar`)

## Why

A Fase 4 pede a barra de ferramentas. O modelo é o `sap.m.Toolbar` (conferido em `SAP/openui5`, `sap.m/Toolbar.js` e
`themes/base/Toolbar.less`): `content`, `design` (Auto, Transparent, Solid, Info), `style` (Standard, Clear),
`active`/`enabled` com o evento `press`; altura de 3rem (2rem no compacto), fundo `sapToolbar_Background`, barra de
informação `sapInfobar_Background` e borda inferior no estilo padrão. O `ToolbarSeparator` já é o
`GjaSeparator.vertical`.

## What Changes

- Novo `GjaToolbar`: `content`, `design` (`GjaToolbarDesign`), `style` (`GjaToolbarStyle`), `onPress`,
  `enabled` e `semanticLabel`; `Spacer` do Flutter faz o papel do `ToolbarSpacer`.
- Catálogo: `gja/widgets/gja-toolbar` passa a `implemented`, sem depender de botão e menu, que são só conteúdo.
- ADR 0009: borda do estilo padrão em `colors.separator` e fundo da barra de informação em `stateColors(information)`.

Fora do escopo: o menu "mais" do `sap.m.OverflowToolbar`, `ariaHasPopup` e alturas livres.

## Capabilities

### New Capabilities

- `gja/widgets/gja-toolbar`: `GjaToolbar`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/gja_widgets`: `acoes_navegacao/toolbar/`, exportação, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaToolbar".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
