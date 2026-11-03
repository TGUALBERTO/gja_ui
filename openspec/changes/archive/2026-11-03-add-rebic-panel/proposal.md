# Proposal: Painel (`add-rebic-panel`)

## Why

A Fase 6 pede um acordeão. O SAPUI5 não tem um controle `Accordion`: o padrão Fiori é empilhar `sap.m.Panel`
expansíveis. O modelo é o `sap.m.Panel` (conferido em `SAP/openui5`): `headerText`, `content`, `expandable`
(padrão `false`), `expanded` (padrão `false`), `expandAnimation`, `backgroundDesign` e o evento `expand` com o novo
estado. O Rebic ainda não tem um contêiner com cabeçalho que abre e fecha.

## What Changes

- Novo `RebicPanel`, controlado (`expanded` + `onExpand`), com `headerText`, `content`, `expandable` e
  `backgroundDesign` (`solid` e `transparent`). O conteúdo abre e fecha com a animação do tema e mantém o estado
  enquanto recolhido.
- O acordeão é documentado como uma pilha de `RebicPanel` expansíveis, como no Fiori; a galeria mostra os dois.
- Catálogo: novo item `rebic/widgets/rebic-panel`, `implemented`.
- ADR 0009: tamanho do título, recuo do cabeçalho e espaçamento do conteúdo.

Fora do escopo: `headerToolbar`, `infoToolbar`, `stickyHeader`, `width`/`height` e o fundo `Translucent`.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-panel`: `RebicPanel`.

### Modified Capabilities

Nenhuma.

## Impact

- `packages/rebic_widgets`: `fundacao_layout/panel/`, exportação, testes e goldens, CHANGELOG.
- `apps/rebic_gallery`: página "RebicPanel".
- `docs/catalog.yaml`, `docs/adr/0009-provisional-horizon-values.md`.
- Portal existente: nenhum impacto.
