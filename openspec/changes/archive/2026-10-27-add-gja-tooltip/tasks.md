# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-tooltip` (21 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaTooltip` (D1–D5) em `packages/gja_widgets/lib/src/exibicao_dados/tooltip/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado`, a semântica, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 1.2 Adicionar o teste de contraste num arquivo sem a fonte Inter. Verificação: teste "[Acessibilidade] Semântica e contraste — Contraste da dica".
- [x] 1.3 Gerar os goldens (D6) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens da dica".
- [x] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade da dica", com os 21 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "GjaTooltip" (D6). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaTooltip na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, com a pasta `exibicao_dados/tooltip`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-tooltip`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `GjaButton`.
