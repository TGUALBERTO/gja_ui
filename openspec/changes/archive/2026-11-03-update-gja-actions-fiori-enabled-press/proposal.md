# Proposal: `enabled` e `onPress` nas ações do SAPUI5 (`update-gja-actions-fiori-enabled-press`)

## Why

A change do botão revisou a regra de nomes de `gja/framework-architecture`: callbacks com o nome do evento do SAPUI5
(`onPress`) e desabilitado por `enabled: false`. `GjaLink`, `GjaMenuItem`, `GjaAvatar` e `GjaStatusIndicator`
ainda usam `onPressed` e, no link e no item de menu, o desabilitado por callback nulo. No SAPUI5:

- `sap.m.Link` tem `text`, `enabled` (padrão `true`) e o evento `press`;
- `sap.m.MenuItem` tem `text`, `icon`, `enabled`, `shortcutText`, `startsSection` e o evento `press`;
- `sap.m.Avatar` e `sap.m.ObjectStatus` são interativos quando têm o tratador de `press`.

## What Changes

- **BREAKING** `GjaLink`: `onPressed` → `onPress`; novo `enabled` (padrão `true`); `onPress` nulo deixa o link
  habilitado, sem ação.
- **BREAKING** `GjaMenuItem`: `label` → `text`, `onPressed` → `onPress`, `shortcut` → `shortcutText`; novo `enabled`.
- **BREAKING** `GjaAvatar` e `GjaStatusIndicator`: `onPressed` → `onPress`; sem `onPress`, continuam não
  interativos, como no UI5.
- `GjaShellBar` passa o `onAvatarPressed` ao `onPress` do avatar; a galeria e os testes migram.

Fora do escopo: a propriedade `active` do `sap.m.ObjectStatus` (o status é ativo quando tem `onPress`).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/widgets/gja-link`, `gja/widgets/gja-menu`, `gja/widgets/gja-avatar`,
  `gja/widgets/gja-status-indicator`: callbacks e `enabled` da regra de nomes revisada.

A mudança é a mesma convenção em quatro widgets já existentes, sem widget novo; separá-la deixaria o framework com
dois padrões de callback.

## Impact

- `packages/gja_widgets`: link, menu (e a lista de opções que ele usa), avatar, status, ShellBar; testes; CHANGELOG.
- `apps/gja_gallery`: usos e testes das páginas.
- Portal existente: nenhum impacto.
