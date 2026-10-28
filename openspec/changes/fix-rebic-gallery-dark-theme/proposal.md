# Proposal: Galeria no tema escuro (`fix-rebic-gallery-dark-theme`)

## Why

Ao escolher o tema escuro no índice da galeria e abrir as páginas dos fundamentos, elas aparecem inteiras no tema
claro. Isso foi reportado pelo usuário em 2026-10-28.

A causa está nas 11 páginas criadas na fase dos fundamentos, antes de existir o `RebicTheme`:
- Acessibilidade, Breakpoints, Cor, Densidade, Elevação, Ícones, Raio, Espaçamento, Estados, Tipografia e Tokens.

Elas pintam com tokens fixos (`RebicColorTokens.light()`, `RebicSpacingTokens.fallback()`, `RebicThemeData.light()`)
em vez do tema ativo. Por isso ignoram o modo escuro e também a densidade compacta. As páginas dos widgets, que usam
`RebicPage` e os widgets do Rebic, seguem o tema corretamente.

O nome segue o pedido do usuário. Pela convenção do projeto, seria `update-rebic-gallery-theme`.

## What Changes

- As 11 páginas passam a obter cores, espaçamentos, tipografia e demais tokens do tema ativo
  (`RebicThemeData.of(context)`): o fundo, o texto, os cabeçalhos, os rótulos e as amostras de escala (espaçamento,
  raio, tipografia, elevação, ícones, breakpoints, movimento).
- As comparações intencionais ficam em painéis rotulados, com tokens fixos:
  - os painéis "Claro" e "Escuro" das páginas "Cor" e "Estados";
  - as colunas confortável e compacta da página "Densidade";
  - a prévia configurável da página "Tema".

  O que está em volta deles, como o fundo da página e os títulos, segue o tema ativo.
- `rebic/widgets/rebic-app`: o requisito "[Documentação] Exemplos mínimos" passa a exigir que toda página da galeria
  siga o tema e a densidade escolhidos, com o cenário "Páginas da galeria no tema escuro".
- Um teste da galeria abre todas as páginas no tema escuro e verifica o fundo e o texto delas.

Fora do escopo:
- Redesenhar as páginas dos fundamentos com os widgets do Rebic (`RebicPage`, `RebicText`). Esta change só troca a
  origem dos tokens.
- Mudanças nos widgets ou nos fundamentos do framework.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/widgets/rebic-app`: "[Documentação] Exemplos mínimos" exige que as páginas da galeria sigam o tema e a
  densidade, com um cenário novo.

## Impact

- **Código:**
  - `apps/rebic_gallery/lib/pages/` (as 11 páginas) e os testes delas que comparam com tokens fixos;
  - um teste novo na galeria;
  - o teste de rastreabilidade do `RebicApp` em `rebic_widgets`, que passa de 20 para 21 cenários.
- **Framework:** nenhuma mudança de código.
- **Catálogo:** sem mudança.
- **Portal existente:** sem impacto.
