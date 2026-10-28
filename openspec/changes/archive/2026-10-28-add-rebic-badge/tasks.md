# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-badge` (19 cenários).

## 1. Widget

- [x] 1.1 Criar `RebicBadge` (D1–D3) em `packages/rebic_widgets/lib/src/exibicao_dados/badge/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [x] 1.2 Adicionar o teste de contraste num arquivo sem a fonte Inter (D4). Verificação: teste "[Acessibilidade] Contraste — Contraste do contador".
- [x] 1.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do contador".
- [x] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do contador", com os 19 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "RebicBadge" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicBadge na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `exibicao_dados/badge`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-badge`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `RebicStatusIndicator`.
