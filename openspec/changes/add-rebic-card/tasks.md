# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-card` (19 cenários).

## 1. Widget

- [ ] 1.1 Criar `RebicCard` (D1, D2) em `packages/rebic_widgets/lib/src/fundacao_layout/card/`, com dartdoc e exportado. Verificação: os testes de `[API]`, `[Comportamento]`, `[Aparência]`, `[Estados]`, `[Acessibilidade] Teclado` e `Semântica`, `[Responsividade]`, `[Integração]` e `[Restrições]`; `rebic_checks tokens` passa.
- [ ] 1.2 Adicionar os testes de contraste e alvo num arquivo sem a fonte Inter (D3). Verificação: teste "[Acessibilidade] Contraste e alvo — Contraste e alvo do cartão".
- [ ] 1.3 Gerar os goldens (D3) nos temas claro e escuro × confortável e compacto, com a tag `golden`. Verificação: teste "[Testes] Cobertura exigida — Goldens do cartão".
- [ ] 1.4 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do cartão", com os 19 cenários.

## 2. Galeria

- [ ] 2.1 Adicionar a página "RebicCard" (D3). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicCard na galeria"; o teste de tema escuro da galeria continua passando.

## 3. Catálogo, changelog e verificação final

- [ ] 3.1 Atualizar `docs/catalog.yaml` (`implemented`, com as dependências do `[Integração]`) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `fundacao_layout/card`.
- [ ] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-card`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `RebicPopover`.
