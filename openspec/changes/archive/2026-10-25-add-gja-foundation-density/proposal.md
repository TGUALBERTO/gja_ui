# Proposal: Fundamento de densidade (`gja/foundation/density`)

## Why

A spec `gja/framework-architecture` (requisito "Densidade de conteúdo") exige as densidades `comfortable` (toque)
e `compact` (ponteiro), e determina que os widgets interativos ajustem dimensões apenas por tokens de densidade.
Ainda não existem esses tokens. Sem eles, cada widget decidiria altura de controle, alvo de toque e espaçamento
compacto por conta própria. A acessibilidade (alvos mínimos), o tema, `GjaSpacing` e todos os controles dependem
deste item. Espaçamento e tipografia, que são as dependências dele, já estão prontos.

## What Changes

- Enum `GjaDensity` (`comfortable`, `compact`).
- Conjunto semântico `GjaDensityTokens`, um mapeamento por densidade, com:
  - altura de controle;
  - altura de item de lista;
  - tamanho mínimo de alvo de interação;
  - o conjunto de espaçamento da densidade.
- Mapeamentos de referência `comfortable()` (controle 40, item 48, alvo 48, espaçamento `fallback()`) e
  `compact()` (controle 32, item 32, alvo 24, espaçamento compacto).
- Mapeamento compacto de espaçamento, com passos e papéis reduzidos e derivados da mesma escala primitiva.
- Regras verificadas por teste:
  - a densidade não altera tamanhos de fonte;
  - a altura de controle comporta a linha do rótulo com respiro;
  - os alvos mínimos seguem o WCAG 2.2 (2.5.8, 24 px) e as diretrizes de toque (48 px).
- Página "Densidade" na galeria, com controles simulados nas duas densidades lado a lado.

Fora do escopo:
- Selecionar a densidade por tema ou subárvore e propagá-la pela árvore (`add-gja-foundation-theming` e `add-gja-theme`).
- Ampliar a área de toque dos controles até o alvo mínimo, que é implementação de cada widget e de `core/interaction`.
- Detectar automaticamente o tipo de entrada (toque ou ponteiro).

## Capabilities

### New Capabilities

- `gja/foundation/density`: modos de densidade, dimensões de controle e de alvo por densidade, mapeamento de
  espaçamento compacto, preservação da tipografia e mapeamentos de referência.

### Modified Capabilities

Nenhuma. O requisito "Densidade de conteúdo" de `gja/framework-architecture` não muda; esta change fornece os
tokens que ele exige.

## Impact

- **Código:** `packages/gja_foundation/lib/src/density/`, exportações em `gja_foundation.dart` e testes em
  `packages/gja_foundation/test/density/`. Nenhum primitivo novo: as dimensões vêm da escala de espaçamento
  (grade de 4 px).
- **Galeria:** nova página "Densidade".
- **Catálogo:** `gja/foundation/density` → `implemented`.
- **Dependências:** `gja/foundation/spacing` e `gja/foundation/typography` (ambas já são specs principais),
  P0 e fase 1, coerente com o catálogo. Nenhum pacote novo.
- **Portal existente:** sem impacto.
