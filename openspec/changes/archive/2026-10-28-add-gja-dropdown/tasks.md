# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `gja/widgets/gja-dropdown` (22 cenários) e `gja/widgets/gja-popover` (23 cenários após esta change).

## 1. Popover

- [x] 1.1 Adicionar `GjaPopoverWidth.anchor` (4 passos `spacing.xxxl`) com dartdoc (D2). Verificação: teste "[API] Posição e largura — Popover na largura da âncora"; o teste de rastreabilidade do popover passa a esperar 23 cenários.

## 2. Widget

- [x] 2.1 Criar `GjaDropdownItem` e `GjaDropdown` (D1, D3) em `packages/gja_widgets/lib/src/feedback_sobreposicoes/dropdown/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado` e `Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 2.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D4). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do dropdown".
- [x] 2.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do dropdown".
- [x] 2.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do dropdown", com os 22 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "GjaDropdown" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaDropdown na galeria"; o teste de tema escuro da galeria continua passando.

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `gja_widgets` (dropdown e `GjaPopoverWidth.anchor`). Verificação: `dart run gja_checks catalog` passa, com a pasta `feedback_sobreposicoes/dropdown`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-dropdown`) após a revisão.
- Pendentes da revisão de larguras: `update-gja-grid-row-height` e `update-gja-gallery-pages`.
- Próximo widget, pela ordem do design da Fase 0: `GjaMenu`.
