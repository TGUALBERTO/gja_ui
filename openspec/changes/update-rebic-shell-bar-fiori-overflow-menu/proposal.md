# Proposal: Barra de shell com menu "mais" e menu no título (`update-rebic-shell-bar-fiori-overflow-menu`)

## Why

Duas partes do `sap.f.ShellBar` (conferido em `SAP/openui5`) ficaram de fora da barra do Rebic:

- o fim da barra é um `OverflowToolbar`: em telas estreitas, as notificações e o conteúdo adicional vão para um menu
  "mais", e a barra não perde ações;
- a agregação `menu`: com ela, o título vira um botão que abre um menu (o "MegaMenu"), para trocar de área da
  aplicação.

## What Changes

- `RebicShellBar` passa a `StatefulWidget` e ganha `menu` (`List<RebicMenuItem>`).
- Na classe de largura S, notificações e `RebicButton`s de `additionalContent` vão para o menu "mais".
- Galeria, goldens e CHANGELOG.

Fora do escopo: o campo de pesquisa (`searchManager`, que pede um `sap.m.SearchField`; o botão de pesquisa com o
evento já existe), Joule (`showCopilot`, um serviço da SAP) e a medição exata do espaço do `OverflowToolbar` (o
Rebic usa a classe de largura).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-shell-bar`: menu "mais" e menu no título.

## Impact

- `packages/rebic_widgets`: barra, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicShellBar".
- `docs/catalog.yaml`: dependências do menu e do popover.
- Portal existente: nenhum impacto.
