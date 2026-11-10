# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-popover`, que passa a ter 22 cenários.

## 1. Rastreabilidade

- [x] 1.1 Fazer `scenarioNames` em `packages/gja_widgets/test/support/traceability.dart` descartar os requisitos listados em `## REMOVED Requirements` das changes ativas (D4). Verificação: o teste de rastreabilidade do popover não exige mais "Largura entre o mínimo e o máximo"; os demais testes de rastreabilidade continuam passando.

## 2. Widget

- [x] 2.1 Adicionar `GjaPopoverWidth` e a propriedade `width`, e calcular a largura como a maior entre os passos de `width` e a largura da âncora (D1–D3), com dartdoc. Verificação: os testes "[API] Posição e largura — Popover largo" e "[Comportamento] Posição, largura e rolagem — Largura padrão", "Âncora mais larga que o popover", "Popover abaixo da âncora" e "Conteúdo rolável", com os testes antigos do `[Comportamento]` renomeados; `gja_checks tokens` passa.
- [x] 2.2 Regenerar os goldens (D5) nos temas claro e escuro × confortável e compacto. Verificação: teste "[Testes] Cobertura exigida — Goldens do popover".
- [x] 2.3 Atualizar o teste de rastreabilidade para 22 cenários. Verificação: teste "[Testes] Cobertura exigida — Rastreabilidade do popover".

## 3. Galeria, changelog e verificação final

- [x] 3.1 Conferir a página "GjaPopover" com os dois popovers na largura padrão. Verificação: teste "[Documentação] Exemplos mínimos — Página GjaPopover na galeria" e o de tema escuro da galeria.
- [x] 3.2 Atualizar o `CHANGELOG.md` de `gja_widgets` (largura padrão, `wide` e largura mínima da âncora). Verificação: `dart run gja_checks catalog` passa, sem mudança no catálogo.
- [x] 3.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-gja-popover-width`) após a revisão.
- Próximo widget: `GjaDropdown`, com a lista no mínimo da largura do campo.
