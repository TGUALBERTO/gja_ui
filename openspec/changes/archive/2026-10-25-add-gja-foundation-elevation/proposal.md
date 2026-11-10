# Proposal: Fundamento de elevação e sombras (`gja/foundation/elevation`)

## Why

Cartões, menus, popovers, diálogos e painéis precisam indicar profundidade com sombras consistentes. A spec de cor
já define o papel `shadow` (a cor da sombra em cada modo), mas falta a geometria: deslocamento, desfoque e
expansão por nível. `gja_checks tokens` já rejeita `blurRadius: 8` e `elevation: 4` nos widgets. `GjaContainer`,
`GjaCard`, os estados de interação e as sobreposições dependem deste item.

## What Changes

- Escala primitiva de sombras (`GjaElevationPrimitives`), em `gja_primitives.dart`, com os níveis 0 a 4:
  - cada nível é uma lista de camadas (deslocamento vertical, desfoque, expansão e fator de opacidade);
  - o nível 0 não tem sombra.
- Tipo `GjaShadowLayer`: a geometria de uma camada, sem cor.
- Conjunto semântico `GjaElevationTokens`, com os níveis `level0` a `level4` e os papéis `card`, `popover` e `dialog`.
  O mapeamento de referência é `fallback()`.
- Conversão para `BoxShadow` com a cor do papel `shadow` do tema (`shadowsFor`). A geometria é a mesma nos modos claro
  e escuro; muda só a cor.
- Página "Elevação" na galeria, com uma superfície por nível nos dois modos.

Fora do escopo:
- Ordem de empilhamento das camadas (z-order) e véu (*scrim*) de sobreposições (`add-gja-core-overlay`).
- Mudança de elevação em hover e pressionado (`add-gja-foundation-interaction-states`).
- Clareamento de superfícies elevadas no modo escuro (*surface tint*). Se for necessário, entra numa change de cor.

## Capabilities

### New Capabilities

- `gja/foundation/elevation`: escala de sombras por nível, papéis de elevação, composição das sombras com a cor do
  tema e uso sem literais nos widgets.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_foundation/lib/src/elevation/`, exportações em `gja_foundation.dart` e em
  `gja_primitives.dart`, e testes em `packages/gja_foundation/test/elevation/`.
- **Ferramentas:** dois testes em `tool/gja_checks/test/tokens_test.dart`, nomeados pelos cenários de uso. Nenhuma regra nova.
- **Galeria:** nova página "Elevação".
- **Catálogo:** `gja/foundation/elevation` → `implemented`.
- **Dependências:** `gja/foundation/design-tokens` e `gja/foundation/color` (ambas já são specs principais),
  P0 e fase 1, coerente com o catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto.
