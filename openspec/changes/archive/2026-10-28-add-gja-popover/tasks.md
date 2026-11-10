# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-popover` (20 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaPopoverController` e `GjaPopover` (D1, D2) em `packages/gja_widgets/lib/src/feedback_sobreposicoes/popover/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado` e `Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 1.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D3). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do popover".
- [x] 1.3 Gerar os goldens (D3) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do popover".
- [x] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do popover", com os 20 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "GjaPopover" (D3). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaPopover na galeria"; o teste de tema escuro da galeria continua passando.

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, com a pasta `feedback_sobreposicoes/popover`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-popover`) após a revisão.
- Changes futuras para a seta: `update-gja-core-overlay` (lado resolvido) e `update-gja-popover-arrow`.
- Próximo widget, pela ordem do design da Fase 0: `GjaDropdown`.
