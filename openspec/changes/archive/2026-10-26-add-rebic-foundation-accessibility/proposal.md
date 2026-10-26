# Proposal: Convenções de acessibilidade (`rebic/foundation/accessibility`)

## Why

O template de spec de widget já manda cada widget cumprir "contraste e área de toque conforme
`rebic/foundation/accessibility`", mas essa referência ainda não existe. Os valores já estão espalhados: contraste
em `color`, alvo mínimo em `density`, foco em `interaction-states`. Falta um lugar único que defina a meta de
conformidade, os limites que todo widget deve respeitar (contraste, escala de texto, alvo de interação, movimento
reduzido, semântica) e a bateria mínima de testes de acessibilidade. Sem isso, cada widget escolheria critérios
próprios. O tema e todos os widgets dependem deste item.

## What Changes

- API de convenções `RebicAccessibility`, com:
  - a meta de conformidade (WCAG 2.2 nível AA);
  - os mínimos de contraste (os mesmos de `color`, sem duplicar valores);
  - a escala de texto suportada (200%);
  - o alvo mínimo por densidade (o de `density`);
  - a resolução de movimento reduzido: `resolveMotion` zera as durações quando a plataforma pede menos animação.
- Convenção de semântica para widgets interativos: rótulo, papel, estado e valor expostos ao leitor de tela; ícones
  decorativos fora da árvore semântica; erros de valor anunciados junto com o rótulo.
- Bateria mínima de testes de acessibilidade por widget, registrada no template de spec de widget:
  - `textContrastGuideline` e `labeledTapTargetGuideline`;
  - `MinimumTapTargetGuideline` com o alvo da densidade;
  - render com escala de texto 2,0 sem estouro;
  - semântica e teclado.
- Página "Acessibilidade" na galeria: os limites, a demonstração de movimento reduzido e uma amostra de texto em 200%.

Fora do escopo:
- Implementar foco, teclado, atalhos e anel de foco (`add-rebic-core-interaction`).
- Textos e anúncios localizados (`add-rebic-core-localization`).
- Auditoria de acessibilidade consolidada da galeria (Fase 5).

## Capabilities

### New Capabilities

- `rebic/foundation/accessibility`: meta de conformidade, limites de contraste, escala de texto e alvo de interação,
  movimento reduzido, convenção de semântica e bateria mínima de testes de acessibilidade dos widgets.

### Modified Capabilities

Nenhuma. O template de spec de widget (`docs/specs/widget-spec-template.md`) é um documento e não uma spec, e passa a
listar a bateria de testes desta capacidade.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/accessibility/`, exportação em `rebic_foundation.dart` e testes em
  `packages/rebic_foundation/test/accessibility/`.
- **Documentação:** o requisito `[Testes]` de `docs/specs/widget-spec-template.md` passa a listar a bateria de acessibilidade.
- **Galeria:** nova página "Acessibilidade".
- **Catálogo:** `rebic/foundation/accessibility` → `implemented`.
- **Dependências:** `rebic/foundation/color`, `rebic/foundation/typography` e `rebic/foundation/density` (já são specs
  principais), P0 e fase 1, coerente com o catálogo. Nenhum pacote novo: os testes usam as diretrizes públicas do `flutter_test`.
- **Portal existente:** sem impacto.
