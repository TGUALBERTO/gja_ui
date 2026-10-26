# Proposal: Fundamento de espaçamentos (`rebic/foundation/spacing`)

## Why

Todo widget com padding, margem ou distância entre filhos precisa de valores vindos do design system. A spec
`rebic/framework-architecture` proíbe espaçamentos literais nos widgets, e `rebic_checks tokens` já rejeita
`EdgeInsets.all(8)` e `SizedBox(width: 8)`, mas ainda não existe o conjunto de tokens que os substitui.
A densidade (`rebic/foundation/density`) e os primeiros widgets de layout (`RebicSpacing`, `RebicContainer`,
`RebicRow`/`RebicColumn`) dependem deste item.

## What Changes

- Escala primitiva de espaçamento em pixels lógicos (`RebicSpacingPrimitives`, de 0 a 64, em múltiplos de 4 e com
  o passo fino de 2), na biblioteca `rebic_primitives.dart`.
- Conjunto semântico `RebicSpacingTokens`, com dois grupos:
  - passos relativos `none`, `xxs`, `xs`, `s`, `m`, `l`, `xl`, `xxl` e `xxxl`, em ordem não decrescente;
  - papéis de layout `inlineGap`, `stackGap`, `sectionGap` e `pageMargin`.

  O mapeamento de referência `fallback()` é o da densidade confortável. O compacto virá em `add-rebic-foundation-density`.
- Página "Espaçamentos" na galeria, com uma barra por papel.

Fora do escopo:
- Densidade compacta e a troca por subárvore (`add-rebic-foundation-density`).
- Margem de página por largura de tela (`add-rebic-foundation-breakpoints` e `core/responsive`).
- Alturas de controle e tamanhos de ícone, que são tokens de componente e de densidade.
- O widget `RebicSpacing` (`add-rebic-spacing`).

## Capabilities

### New Capabilities

- `rebic/foundation/spacing`: escala primitiva de espaçamento, passos semânticos, papéis de layout, mapeamento de
  referência e o uso de espaçamentos sem literais nos widgets.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/spacing/`, exportações em `rebic_foundation.dart` e em
  `rebic_primitives.dart`, e testes em `packages/rebic_foundation/test/spacing/`.
- **Ferramentas:** um teste a mais em `tool/rebic_checks/test/tokens_test.dart`, que nomeia o cenário de uso sem
  literal. Nenhuma regra nova.
- **Galeria:** nova página "Espaçamentos".
- **Catálogo:** `rebic/foundation/spacing` → `implemented`.
- **Dependências:** apenas `rebic/foundation/design-tokens` (já é spec principal), P0 e fase 1, coerente com o
  catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto.
