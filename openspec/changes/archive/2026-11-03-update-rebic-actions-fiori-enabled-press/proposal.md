# Proposal: `enabled` e `onPress` nas ações do SAPUI5 (`update-rebic-actions-fiori-enabled-press`)

## Why

A change do botão revisou a regra de nomes de `rebic/framework-architecture`: callbacks com o nome do evento do SAPUI5
(`onPress`) e desabilitado por `enabled: false`. `RebicLink`, `RebicMenuItem`, `RebicAvatar` e `RebicStatusIndicator`
ainda usam `onPressed` e, no link e no item de menu, o desabilitado por callback nulo. No SAPUI5:

- `sap.m.Link` tem `text`, `enabled` (padrão `true`) e o evento `press`;
- `sap.m.MenuItem` tem `text`, `icon`, `enabled`, `shortcutText`, `startsSection` e o evento `press`;
- `sap.m.Avatar` e `sap.m.ObjectStatus` são interativos quando têm o tratador de `press`.

## What Changes

- **BREAKING** `RebicLink`: `onPressed` → `onPress`; novo `enabled` (padrão `true`); `onPress` nulo deixa o link
  habilitado, sem ação.
- **BREAKING** `RebicMenuItem`: `label` → `text`, `onPressed` → `onPress`, `shortcut` → `shortcutText`; novo `enabled`.
- **BREAKING** `RebicAvatar` e `RebicStatusIndicator`: `onPressed` → `onPress`; sem `onPress`, continuam não
  interativos, como no UI5.
- `RebicShellBar` passa o `onAvatarPressed` ao `onPress` do avatar; a galeria e os testes migram.

Fora do escopo: a propriedade `active` do `sap.m.ObjectStatus` (o status é ativo quando tem `onPress`).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-link`, `rebic/widgets/rebic-menu`, `rebic/widgets/rebic-avatar`,
  `rebic/widgets/rebic-status-indicator`: callbacks e `enabled` da regra de nomes revisada.

A mudança é a mesma convenção em quatro widgets já existentes, sem widget novo; separá-la deixaria o framework com
dois padrões de callback.

## Impact

- `packages/rebic_widgets`: link, menu (e a lista de opções que ele usa), avatar, status, ShellBar; testes; CHANGELOG.
- `apps/rebic_gallery`: usos e testes das páginas.
- Portal existente: nenhum impacto.
