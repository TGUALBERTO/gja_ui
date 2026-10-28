# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-popover`, que passa a ter 22 cenários.

## 1. Rastreabilidade

- [ ] 1.1 Fazer `scenarioNames` em `packages/rebic_widgets/test/support/traceability.dart` descartar os requisitos listados em `## REMOVED Requirements` das changes ativas (D4). Verificação: o teste de rastreabilidade do popover não exige mais "Largura entre o mínimo e o máximo"; os demais testes de rastreabilidade continuam passando.

## 2. Widget

- [ ] 2.1 Adicionar `RebicPopoverWidth` e a propriedade `width`, e calcular a largura como a maior entre os passos de `width` e a largura da âncora (D1–D3), com dartdoc. Verificação: os testes "[API] Posição e largura — Popover largo" e "[Comportamento] Posição, largura e rolagem — Largura padrão", "Âncora mais larga que o popover", "Popover abaixo da âncora" e "Conteúdo rolável", com os testes antigos do `[Comportamento]` renomeados; `rebic_checks tokens` passa.
- [ ] 2.2 Regenerar os goldens (D5) nos temas claro e escuro × confortável e compacto. Verificação: teste "[Testes] Cobertura exigida — Goldens do popover".
- [ ] 2.3 Atualizar o teste de rastreabilidade para 22 cenários. Verificação: teste "[Testes] Cobertura exigida — Rastreabilidade do popover".

## 3. Galeria, changelog e verificação final

- [ ] 3.1 Conferir a página "RebicPopover" com os dois popovers na largura padrão. Verificação: teste "[Documentação] Exemplos mínimos — Página RebicPopover na galeria" e o de tema escuro da galeria.
- [ ] 3.2 Atualizar o `CHANGELOG.md` de `rebic_widgets` (largura padrão, `wide` e largura mínima da âncora). Verificação: `dart run rebic_checks catalog` passa, sem mudança no catálogo.
- [ ] 3.3 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive update-rebic-popover-width`) após a revisão.
- Próximo widget: `RebicDropdown`, com a lista no mínimo da largura do campo.
