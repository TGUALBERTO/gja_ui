# Tasks

Os testes seguem o nome `<requisito> — <cenário>` da spec `rebic/widgets/rebic-responsive-layout` (14 cenários).

## 1. Widget

- [x] 1.1 Criar `RebicLayoutBasis` e `RebicResponsiveLayout` (D1, D2) em `packages/rebic_widgets/lib/src/fundacao_layout/responsive_layout/`, com dartdoc e exportados. Verificação: os testes da spec, menos a página da galeria.
- [x] 1.2 Adicionar o teste "[Testes] Cobertura exigida — Rastreabilidade do layout responsivo", com os 14 cenários.

## 2. Galeria

- [x] 2.1 Adicionar a página "RebicResponsiveLayout" (D4). Verificação: teste "[Documentação] Exemplos mínimos — Página RebicResponsiveLayout na galeria".

## 3. Catálogo, changelog e verificação final

- [x] 3.1 Atualizar `docs/catalog.yaml` (D4) e o `CHANGELOG.md` de `rebic_widgets`. Verificação: `dart run rebic_checks catalog` passa, com a pasta `fundacao_layout/responsive_layout`.
- [x] 3.2 Executar `tool/ci`. Verificação: código de saída 0.

## Workflow follow-up

- Arquivar a change (`/opsx:archive add-rebic-responsive-layout`) após a revisão.
- Próximo widget, pela ordem do design da Fase 0: `RebicGrid`.
