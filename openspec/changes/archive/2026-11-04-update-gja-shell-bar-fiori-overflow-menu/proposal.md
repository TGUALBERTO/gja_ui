# Proposal: Barra de shell com menu "mais" e menu no título (`update-gja-shell-bar-fiori-overflow-menu`)

## Why

Duas partes do `sap.f.ShellBar` (conferido em `SAP/openui5`) ficaram de fora da barra do GJA:

- o fim da barra é um `OverflowToolbar`: em telas estreitas, as notificações e o conteúdo adicional vão para um menu
  "mais", e a barra não perde ações;
- a agregação `menu`: com ela, o título vira um botão que abre um menu (o "MegaMenu"), para trocar de área da
  aplicação.

## What Changes

- `GjaShellBar` ganha `menu` (`List<GjaMenuItem>`).
- Na classe de largura S, notificações e `GjaButton`s de `additionalContent` vão para o menu "mais".
- Galeria, goldens e CHANGELOG.

Fora do escopo: o campo de pesquisa (`searchManager`, que pede um `sap.m.SearchField`; o botão de pesquisa com o
evento já existe), Joule (`showCopilot`, um serviço da SAP) e a medição exata do espaço do `OverflowToolbar` (o
GJA usa a classe de largura).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-shell-bar`: menu "mais" e menu no título.

## Impact

- `packages/gja_widgets`: barra, testes e goldens, CHANGELOG.
- `apps/gja_gallery`: página "GjaShellBar".
- `docs/catalog.yaml`: dependências do menu e do popover.
- Portal existente: nenhum impacto.
