# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-progress-indicator` (19 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaProgressIndicator` com `linear` e `circular` (D1), a pintura (D2), a animação e o movimento reduzido (D3) e a semântica (D4), em `packages/gja_widgets/lib/src/exibicao_dados/progress_indicator/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade]`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 1.2 Gerar os goldens (D5) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do indicador".
- [x] 1.3 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do indicador", com os 19 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "GjaProgressIndicator" (D5). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaProgressIndicator na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, com a pasta `exibicao_dados/progress_indicator`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-progress-indicator`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `GjaTooltip`.
