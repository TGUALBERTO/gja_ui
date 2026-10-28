# Tasks

Os testes seguem o nome `<requisito> — <cenário>` das specs `rebic/widgets/rebic-link` (19 cenários) e
`rebic/core/interaction` (cenário novo "Semântica de link").

## 1. Núcleo

- [x] 1.1 Adicionar `link` ao `RebicInteractable` (D1), com dartdoc, e o teste "Semântica e cursor — Semântica de link" em `rebic_core/test/interaction`. Verificação: os testes do núcleo passam, incluindo o de semântica de botão.

## 2. Widget

- [x] 2.1 Criar `RebicLink` (D2, D3) em `packages/rebic_widgets/lib/src/acoes_navegacao/link/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [x] 2.2 Adicionar os testes de acessibilidade num arquivo sem a fonte Inter (D4). Verificação: testes de `[Acessibilidade] Contraste, alvo e escala`.
- [x] 2.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do link".
- [x] 2.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do link", com os 19 cenários.

## 3. Galeria

- [x] 3.1 Adicionar a página "RebicLink" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicLink na galeria".

## 4. Catálogo, changelog e verificação final

- [x] 4.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e os `CHANGELOG.md` de `rebic_widgets` e `rebic_core`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `acoes_navegacao/link`.
- [x] 4.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-link`) após a revisão. A spec `rebic/core/interaction` recebe um MODIFIED: mesclar o requisito, não copiar.
- Próximo widget, pela ordem do design da Fase 0: `RebicBadge`.
