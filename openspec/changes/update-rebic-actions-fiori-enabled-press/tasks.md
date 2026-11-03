# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs da change.

## 1. Widgets

- [x] 1.1 `RebicLink` com `enabled` e `onPress` (D1). Verificação: os cenários de `rebic-link`.
- [x] 1.2 `RebicMenuItem` com `text`, `enabled`, `onPress` e `shortcutText` (D1). Verificação: os cenários de
  `rebic-menu`.
- [x] 1.3 `RebicAvatar` e `RebicStatusIndicator` com `onPress` (D2), e `RebicShellBar`. Verificação: os cenários de
  `rebic-avatar`, `rebic-status-indicator` e `rebic-shell-bar`.

## 2. Migração e documentação

- [x] 2.1 Migrar testes e galeria (D3); CHANGELOG de `rebic_widgets` com o de/para. Verificação: `dart analyze` sem
  erros e `flutter test -j 2` em `packages/rebic_widgets` e `apps/rebic_gallery`.

## 3. Verificação final

- [x] 3.1 Executar as etapas de `tool/ci` (com `flutter test -j 2`) e `flutter test -j 2 --tags golden` em
  `packages/rebic_widgets`. Verificação: código de saída 0 em todas, sem mudança de golden.

## Workflow follow-up

- Arquivar a change após a revisão.
