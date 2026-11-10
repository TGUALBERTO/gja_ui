# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs alteradas.

## 1. Núcleo

- [x] 1.1 `GjaModal.show`: dispensa só por Esc, camada sem toque nem semântica, e `barrierColor` → `blockLayerColor` (D1). Verificação: "Dispensa do modal — Dispensa por Esc e pela camada", "— Modal não dispensável" e "— Camada sem semântica"; os cenários de "Modal com camada de bloqueio", "Foco no modal", "Empilhamento" e "Valores do tema ativo nas sobreposições" continuam passando.
- [x] 1.2 `GjaPlacement` no lugar de `GjaOverlaySide`, e `placement` no lugar de `side` em `GjaAnchoredOverlay` (D2). Verificação: os quatro cenários existentes de "Sobreposição ancorada" com os nomes novos.
- [x] 1.3 Acompanhar a âncora por pós-quadro (D3) e expor a posição efetiva por `GjaAnchoredOverlay.placementOf` (D4). Verificação: "Sobreposição ancorada — Acompanha a âncora que muda de tamanho"; "Posição efetiva da sobreposição ancorada — Posição informada após a inversão" e "— Posição sem inversão"; CHANGELOG de `gja_core`.

## 2. Widgets

- [x] 2.1 Renomear `side` para `placement` (`GjaPlacement`, padrão `bottom`) em `GjaPopover`, `GjaMenu`, `GjaDropdown`, `GjaTooltip` e `GjaOptionList`, com os testes. Verificação: os cenários de `[API] Propriedades` dos quatro widgets e "Popover abaixo da âncora"; `flutter test` em `packages/gja_widgets`, com e sem a tag `golden`, sem falhas e sem goldens alterados.

## 3. Galeria

- [x] 3.1 Página "Sobreposições" com a escolha de `placement` e o modal dispensável fechado por Esc (D5), com o teste. Verificação: "Testes e documentação das sobreposições — Página na galeria".

## 4. Documentação e verificação final

- [x] 4.1 Atualizar o CHANGELOG de `gja_widgets` com o de/para de `side` (**BREAKING**).
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-core-overlay-fiori-popup`) após a revisão.
- Próximo bloco: layout (`GjaText` → Title/Text/Label, ToolPage + ShellBar, Page, Card, Separator, FlexBox, Grid).
