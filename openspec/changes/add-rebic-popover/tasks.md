# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-popover` (20 cenários).

## 1. Widget

- [ ] 1.1 Criar `RebicPopoverController` e `RebicPopover` (D1, D2) em `packages/rebic_widgets/lib/src/feedback_sobreposicoes/popover/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado` e `Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [ ] 1.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D3). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do popover".
- [ ] 1.3 Gerar os goldens (D3) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do popover".
- [ ] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do popover", com os 20 cenários.

## 2. Galeria

- [ ] 2.1 Adicionar a página "RebicPopover" (D3). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicPopover na galeria"; o teste de tema escuro da galeria continua passando.

## 3. Catálogo, changelog e verificação final

- [ ] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `feedback_sobreposicoes/popover`.
- [ ] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-popover`) após a revisão.
- Changes futuras para a seta: `update-rebic-core-overlay` (lado resolvido) e `update-rebic-popover-arrow`.
- Próximo widget, pela ordem do design da Fase 0: `RebicDropdown`.
