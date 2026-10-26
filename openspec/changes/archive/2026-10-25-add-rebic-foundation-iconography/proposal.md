# Proposal: Fundamento de ícones (`rebic/foundation/iconography`)

## Why

Botões, campos, navegação, mensagens e tabelas precisam de um conjunto de ícones único, licenciado e independente
do Material: `Icons` vem de `package:flutter/material.dart`, que a ADR 0004 proíbe na API pública. O widget
`RebicIcon` e boa parte dos widgets P0/P1 dependem deste item. O design da Fase 0 deixou a biblioteca em aberto
(questão 4: Lucide ou Phosphor), e o responsável aceitou a **Lucide** como escolha provisória do protótipo.

## What Changes

- Fonte de ícones **Lucide 1.61.0** (`lucide-static`, licença ISC) empacotada em `rebic_foundation`, com o arquivo de
  licença e o mapa oficial de códigos (`codepoints.json`). Não é um conjunto de ícones SAP.
- Primitivos (`RebicIconPrimitives`) em `rebic_primitives.dart`: família e pacote da fonte e a escala de tamanhos
  (12 a 48). Com eles, uma aplicação pode usar qualquer outro ícone Lucide.
- Catálogo semântico `RebicIcons`, com cerca de 40 ícones `const` nomeados pelo significado (`add`, `close`, `delete`,
  `warning`…, e não `plus`, `x` ou `trash`). Ícones direcionais são espelhados em idiomas da direita para a esquerda.
- Conjunto semântico de tamanhos `RebicIconTokens` (`small`, `medium`, `large` e `xLarge`, e os papéis `inline` e
  `control`), com o mapeamento de referência `fallback()`.
- Página "Ícones" na galeria, com todos os ícones do catálogo.

Fora do escopo:
- O widget `RebicIcon`: rótulo semântico, ícone decorativo e cor (`add-rebic-icon`).
- Ícones por estado de valor, que os widgets de status escolhem no catálogo.
- Tamanhos por densidade (`add-rebic-foundation-density`).

## Capabilities

### New Capabilities

- `rebic/foundation/iconography`: fonte de ícones empacotada e licenciada, catálogo semântico de ícones, espelhamento
  de ícones direcionais, escalas e papéis de tamanho, e mapeamento de referência.

### Modified Capabilities

Nenhuma.

## Impact

- **Código e assets:**
  - `packages/rebic_foundation/lib/src/iconography/`;
  - `packages/rebic_foundation/fonts/lucide/`: `lucide.ttf` (cerca de 0,9 MB), `LICENSE` e `codepoints.json`;
  - a família `Lucide` na seção `flutter: fonts:`;
  - as exportações e os testes.
- **Distribuição:** em builds de release, o *tree shaking* de ícones do Flutter reduz a fonte aos glifos usados por
  `IconData` constantes, então o impacto real no bundle é pequeno. Em debug, a fonte vai inteira.
- **Galeria:** nova página "Ícones".
- **Catálogo:** `rebic/foundation/iconography` → `implemented`.
- **Dependências:** apenas `rebic/foundation/design-tokens` (já é spec principal), P0 e fase 1, coerente com o
  catálogo. Nenhum pacote Dart novo.
- **Portal existente:** sem impacto.
