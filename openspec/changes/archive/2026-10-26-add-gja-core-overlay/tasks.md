# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/core/overlay`. É infraestrutura do núcleo; a
galeria demonstra o comportamento.

## 1. Modal

- [x] 1.1 Criar `GjaModal.show` (D1, D5) em `packages/gja_core/lib/src/overlay/`, com dartdoc, exportado em `gja_core.dart`. Verificação: testes "Modal com camada de bloqueio — Interação bloqueada" e "— Resultado ao fechar", "Foco no modal — Tab preso no modal" e "— Foco devolvido", e "Dispensa do modal — Dispensa por Esc e pela camada" e "— Modal não dispensável", além de um teste do rótulo `close` da camada.

## 2. Sobreposição ancorada

- [x] 2.1 Criar `GjaOverlaySide`, `GjaOverlayAlignment`, `GjaAnchoredOverlayController` e `GjaAnchoredOverlay` com o posicionamento (D2, D5). Verificação: testes "Sobreposição ancorada — Posição preferida", "— Inversão por falta de espaço", "— Dentro da tela" e "— Acompanha a rolagem", além de um teste de `start`/`end` em `TextDirection.rtl`.
- [x] 2.2 Implementar o fechamento automático, Esc e foco (D3). Verificação: testes "Fechamento automático da sobreposição ancorada — Toque fora e Esc", "— Toque na âncora" e "— Foco da âncora restaurado".
- [x] 2.3 Verificar o empilhamento (D4). Verificação: teste "Empilhamento — Popover dentro de modal".

## 3. Galeria

- [x] 3.1 Adicionar a página "Sobreposições" (D6). Verificação: teste "Testes e documentação das sobreposições — Página na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`gja/core/overlay` → `implemented`, dependências de D7) e o `CHANGELOG.md` de `gja_core`. Verificação: `dart run gja_checks catalog` passa.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-core-overlay`) após a revisão.
- Próxima change: `add-gja-theme` (widget `GjaTheme`), que fecha o núcleo da Fase 1.
