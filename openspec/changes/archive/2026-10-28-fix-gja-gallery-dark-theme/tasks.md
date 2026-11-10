# Tasks

O teste segue o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-app` (cenário novo "Páginas da galeria
no tema escuro").

## 1. Páginas

- [x] 1.1 Trocar os tokens fixos pelo tema ativo (D1) nas páginas Acessibilidade, Breakpoints, Design tokens, Elevação, Ícones, Raio, Espaçamento e Tipografia. Verificação: os testes dessas páginas passam.
- [x] 1.2 Nas páginas Cor, Estados, Densidade e Tema, fazer o cromo seguir o tema ativo e marcar os painéis de comparação com `GalleryComparison` (D2). Verificação: os testes dessas páginas passam, com os painéis "Claro"/"Escuro" e "Confortável"/"Compacto" preservados.

## 2. Teste de regressão

- [x] 2.1 Adicionar `apps/gja_gallery/test/gallery_dark_theme_test.dart` com o teste "[Documentação] Exemplos mínimos — Páginas da galeria no tema escuro" (D3), e atualizar a rastreabilidade do `GjaApp` para 21 cenários. Verificação: o teste passa para todas as páginas de `galleryPages`.

## 3. Changelog e verificação final

- [x] 3.1 Registrar a correção no `CHANGELOG.md` da galeria, se houver, ou no de `gja_widgets`, na seção da galeria. Verificação: `gja_checks all` passa.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive fix-gja-gallery-dark-theme`) após a revisão. A spec `gja/widgets/gja-app` recebe um MODIFIED: mesclar o requisito, não copiar.
- Próximo widget, pela ordem do design da Fase 0: `GjaCard`.
