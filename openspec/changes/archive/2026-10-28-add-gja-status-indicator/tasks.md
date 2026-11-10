# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `gja/widgets/gja-status-indicator` (18 cenários).

## 1. Widget

- [x] 1.1 Criar `GjaStatusIndicator` (D1–D3) em `packages/gja_widgets/lib/src/exibicao_dados/status_indicator/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `gja_checks tokens` passa.
- [x] 1.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D4). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do status".
- [x] 1.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do status".
- [x] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do status", com os 18 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "GjaStatusIndicator" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página GjaStatusIndicator na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `gja_widgets`. Verificação: `dart run gja_checks catalog` passa, com a pasta `exibicao_dados/status_indicator`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-gja-status-indicator`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `GjaAvatar`.
