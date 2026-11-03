# Proposal: Barra de ferramentas (`add-rebic-toolbar`)

## Why

A Fase 4 pede a barra de ferramentas. O modelo é o `sap.m.Toolbar` (conferido em `SAP/openui5`, `sap.m/Toolbar.js` e
`themes/base/Toolbar.less`): `content`, `design` (Auto, Transparent, Solid, Info), `style` (Standard, Clear),
`active`/`enabled` com o evento `press`; altura de 3rem (2rem no compacto), fundo `sapToolbar_Background`, barra de
informação `sapInfobar_Background` e borda inferior no estilo padrão. O `ToolbarSeparator` já é o
`RebicSeparator.vertical`.

## What Changes

- Novo `RebicToolbar`: `content`, `design` (`RebicToolbarDesign`), `style` (`RebicToolbarStyle`), `onPress`,
  `enabled` e `semanticLabel`; `Spacer` do Flutter faz o papel do `ToolbarSpacer`.
- Catálogo: `rebic/widgets/rebic-toolbar` passa a `implemented`, sem depender de botão e menu, que são só conteúdo.
- ADR 0009: borda do estilo padrão em `colors.separator` e fundo da barra de informação em `stateColors(information)`.

Fora do escopo: o menu "mais" do `sap.m.OverflowToolbar`, `ariaHasPopup` e alturas livres.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-toolbar`: `RebicToolbar`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `acoes_navegacao/toolbar/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicToolbar".
- `docs/catalog.yaml`, `docs/adr/0009-…`.
- Portal existente: nenhum impacto.
