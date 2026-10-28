# Proposal: RebicTooltip (`rebic/widgets/rebic-tooltip`)

## Why

`RebicIconButton` (a seguir na Fase 2) é um botão só de ícone e precisa explicar a ação ao passar o ponteiro ou
focar, como o `tooltip` dos controles do SAPUI5. Hoje o Rebic não tem um widget para isso: a única dica disponível
seria o `Tooltip` do Material, que o framework não usa.

O design da Fase 0 previu `RebicTooltip` sobre `core/overlay` e `RebicText`, na mesma etapa do
`RebicProgressIndicator`.

## What Changes

- Widget `RebicTooltip` em `rebic_widgets` (categoria `exibicao-dados`), com `message` (obrigatória) e `child`:
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
- Página "RebicTooltip" na galeria.

Fora do escopo:
- Dicas com conteúdo rico (widgets, links): isso é o `RebicPopover`.
- Seta apontando para o filho.
- Atrasos configuráveis pela aplicação.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-tooltip`: dica textual de um elemento, aberta por ponteiro, foco ou toque longo, com
  fechamento por Esc, perda de foco e toque fora, uma por vez, e semântica no próprio elemento.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/exibicao_dados/tooltip/` e testes, com goldens.
- **Galeria:** nova página "RebicTooltip".
- **Catálogo:** `rebic/widgets/rebic-tooltip` → `implemented`. Além de `core/overlay` e `rebic-text`, as
  dependências passam a incluir:
  - `rebic/widgets/rebic-container`;
  - os fundamentos `color`, `elevation`, `radius`, `spacing`, `design-tokens` (movimento), `theming` e
    `accessibility`.
- **Portal existente:** sem impacto.
