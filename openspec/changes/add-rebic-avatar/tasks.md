# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-avatar` (18 cenários).

## 1. Widget

- [ ] 1.1 Criar `RebicAvatarSize`, `RebicAvatarShape` e `RebicAvatar` (D1–D3) em `packages/rebic_widgets/lib/src/exibicao_dados/avatar/`, com dartdoc e exportados. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [ ] 1.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D4). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do avatar".
- [ ] 1.3 Gerar os goldens (D4) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do avatar".
- [ ] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do avatar", com os 18 cenários.

## 2. Galeria

- [ ] 2.1 Adicionar a página "RebicAvatar" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicAvatar na galeria".

## 3. Catálogo, changelog e verificação final

- [ ] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `exibicao_dados/avatar`.
- [ ] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-avatar`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `RebicCard`.
