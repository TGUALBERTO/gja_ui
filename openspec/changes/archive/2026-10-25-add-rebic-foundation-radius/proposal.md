# Proposal: Fundamento de raios de borda (`rebic/foundation/radius`)

## Why

Botões, campos, cartões, diálogos e indicadores precisam de cantos arredondados consistentes, vindos do design
system. `rebic_checks tokens` já rejeita `BorderRadius.circular(4)` e `Radius.circular(2.5)` nos widgets, mas
ainda não existe o conjunto que os substitui. `RebicContainer` e os primeiros widgets de ação dependem deste item.

## What Changes

- Escala primitiva de raios em pixels lógicos (`RebicRadiusPrimitives`: 0, 2, 4, 6, 8, 12, 16 e `full`, para
  formato de pílula), em `rebic_primitives.dart`.
- Conjunto semântico `RebicRadiusTokens`, com dois grupos:
  - passos `none`, `xs`, `s`, `m`, `l`, `xl` e `full`;
  - papéis `control` (botões, campos, caixas de seleção) e `container` (cartões, diálogos, menus).

  O mapeamento de referência é `fallback()`.
- Página "Raios" na galeria, com uma amostra de cada passo e papel.

Fora do escopo:
- Raio do anel de foco (`add-rebic-core-interaction`).
- Raios assimétricos por canto. Os widgets que precisarem deles combinam os valores do conjunto.
- Densidade: os raios não mudam entre confortável e compacto.

## Capabilities

### New Capabilities

- `rebic/foundation/radius`: escala primitiva de raios, passos e papéis semânticos, formato de pílula,
  mapeamento de referência e uso sem literais nos widgets.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_foundation/lib/src/radius/`, exportações em `rebic_foundation.dart` e em
  `rebic_primitives.dart`, e testes em `packages/rebic_foundation/test/radius/`.
- **Ferramentas:** dois testes em `tool/rebic_checks/test/tokens_test.dart` com os nomes dos cenários de uso.
  Nenhuma regra nova.
- **Galeria:** nova página "Raios".
- **Catálogo:** `rebic/foundation/radius` → `implemented`.
- **Dependências:** apenas `rebic/foundation/design-tokens` (já é spec principal), P0 e fase 1, coerente com o
  catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto.
