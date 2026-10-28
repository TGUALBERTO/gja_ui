# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `rebic/widgets/rebic-dropdown` (22 cenários) e `rebic/widgets/rebic-popover` (23 cenários após esta change).

## 1. Popover

- [ ] 1.1 Adicionar `RebicPopoverWidth.anchor` (4 passos `spacing.xxxl`) com dartdoc (D2). Verificação: teste "[API] Posição e largura — Popover na largura da âncora"; o teste de rastreabilidade do popover passa a esperar 23 cenários.

## 2. Widget

- [ ] 2.1 Criar `RebicDropdownItem` e `RebicDropdown` (D1, D3) em `packages/rebic_widgets/lib/src/feedback_sobreposicoes/dropdown/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado` e `Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [ ] 2.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D4). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do dropdown".
- [ ] 2.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do dropdown".
- [ ] 2.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do dropdown", com os 22 cenários.

## 3. Galeria

- [ ] 3.1 Adicionar a página "RebicDropdown" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicDropdown na galeria"; o teste de tema escuro da galeria continua passando.

## 4. Catálogo, changelog e verificação final

- [ ] 4.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `rebic_widgets` (dropdown e `RebicPopoverWidth.anchor`). Verificação: `dart run rebic_checks catalog` passa, com a pasta `feedback_sobreposicoes/dropdown`.
- [ ] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-dropdown`) após a revisão.
- Pendentes da revisão de larguras: `update-rebic-grid-row-height` e `update-rebic-gallery-pages`.
- Próximo widget, pela ordem do design da Fase 0: `RebicMenu`.
