# Proposal: GjaTooltip (`gja/widgets/gja-tooltip`)

## Why

`GjaIconButton` (a seguir na Fase 2) é um botão só de ícone e precisa explicar a ação ao passar o ponteiro ou
focar, como o `tooltip` dos controles do SAPUI5. Hoje o GJA não tem um widget para isso: a única dica disponível
seria o `Tooltip` do Material, que o framework não usa.

O design da Fase 0 previu `GjaTooltip` sobre `core/overlay` e `GjaText`, na mesma etapa do
`GjaProgressIndicator`.

## What Changes

- Widget `GjaTooltip` em `gja_widgets` (categoria `exibicao-dados`), com `message` (obrigatória) e `child`:
  - **Abertura:** com o ponteiro sobre o filho, após o atraso `motion.long`; com o foco do teclado no filho; e com um
    toque longo.
  - **Fechamento:** pela saída do ponteiro (após `motion.short`, para permitir mover o ponteiro até a dica), pela perda
    do foco, por Esc e por um toque fora.
  - **Permanência:** a dica permanece enquanto o ponteiro está sobre ela.

  Esse comportamento atende ao critério 1.4.13 da WCAG 2.2 (conteúdo em hover ou foco: dispensável, apontável e
  persistente).
- Posicionamento pela sobreposição ancorada do núcleo:
  - `side`, com padrão `below`, centralizada no filho;
  - afastamento `spacing.xs`;
  - inversão e limite de bordas do núcleo.
- Só uma dica aberta por vez.
- **Aparência:** superfície `base` com borda, raio `s`, sombra `popover` e texto `label`, com largura máxima derivada
  de `spacing.xxxl` e quebra de linha.
- **Semântica:** a mensagem é anunciada como a dica (`tooltip`) do filho, sem duplicar o nó da sobreposição.
- Página "GjaTooltip" na galeria.

Fora do escopo:
- Dicas com conteúdo rico (widgets, links): isso é o `GjaPopover`.
- Seta apontando para o filho.
- Atrasos configuráveis pela aplicação.

## Capabilities

### New Capabilities

- `gja/widgets/gja-tooltip`: dica textual de um elemento, aberta por ponteiro, foco ou toque longo, com
  fechamento por Esc, perda de foco e toque fora, uma por vez, e semântica no próprio elemento.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/exibicao_dados/tooltip/` e testes, com goldens.
- **Galeria:** nova página "GjaTooltip".
- **Catálogo:** `gja/widgets/gja-tooltip` → `implemented`. Além de `core/overlay` e `gja-text`, as
  dependências passam a incluir:
  - `gja/widgets/gja-container`;
  - os fundamentos `color`, `elevation`, `radius`, `spacing`, `design-tokens` (movimento), `theming` e
    `accessibility`.
- **Portal existente:** sem impacto.
