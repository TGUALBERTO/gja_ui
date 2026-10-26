# Design: Fundamento de estados visuais de interação

## Context

- O fundamento de cor já define `focus` (≥ 3:1 sobre as superfícies), `onSurfaceDisabled` e `surfaceDisabled`, além
  de `rebicContrastRatio`/`rebicContrastRatioOver`. A elevação já define os níveis 0 a 4.
- Este fundamento só define valores e regras puras. Detectar estados e desenhar o anel de foco é tarefa de `core/interaction`.
- Cálculo feito durante esta proposta, de texto sobre a superfície coberta pela própria cor do texto:

| Par | 16% | 20% | 28% |
|---|---|---|---|
| claro `onPrimary`/`primary` | 4,85 | 4,47 | 3,73 |
| escuro `onPrimary`/`primary` | 5,10 | 4,79 | 4,14 |
| escuro `onPrimaryContainer`/`primaryContainer` | 6,31 | 5,67 | 4,60 |
| pior caso de `onSurface` (escuro, `surface`) | — | — | 6,31 |

  O par limitante é `onPrimary` sobre `primary` no modo claro. A camada máxima segura é 16%.

## Goals / Non-Goals

**Goals:**

- Uma única regra de combinação de estados, testável sem widgets.
- Contraste de texto garantido em qualquer combinação de estados, nos mapeamentos de referência.

**Non-Goals:**

- Estados que dependem do componente (carregando, erro, somente leitura). São definidos na spec de cada widget.
- Camadas de estado com cores diferentes da cor de conteúdo (por exemplo, `primary` em hover sobre `surface`).
  Se algum widget precisar, ele define isso nos próprios tokens de componente.

## Decisions

### D1. Camada de estado com a cor de conteúdo

A camada usa a cor de conteúdo da superfície ("on") com uma opacidade baixa, pintada por cima. Isso funciona em
qualquer superfície e modo sem tokens extras, porque escurece o fundo claro e clareia o fundo escuro.

- **Alternativa:** cores fixas de hover e pressionado por superfície. Foi rejeitada porque multiplica papéis (um por
  superfície × estado × modo) e não escala para tokens de componente.

### D2. Combinação com teto

`overlayOpacity(states)` funciona assim:

- `disabled` → 0;
- senão, `min(maxOverlayOpacity, (selected ? selected : 0) + max(hovered ? hover : 0, pressed ? pressed : 0, dragged ? dragged : 0))`.

Com o teto de 0,16, selecionado + hover (0,16) continua distinguível de só selecionado (0,12), e o contraste se mantém (tabela acima).

- **Alternativa:** a soma livre. Foi rejeitada porque chega a 0,28 e derruba o texto sobre `primary` para 3,73:1.
- **Alternativa:** só o máximo entre os estados. Foi rejeitada porque selecionado + hover ficaria igual a selecionado, sem retorno visual do hover.

### D3. API

```dart
enum RebicInteractionState { hovered, focused, pressed, selected, dragged, disabled }

class RebicInteractionStateTokens extends RebicTokenSet<RebicInteractionStateTokens> {
  final double hover, pressed, selected, dragged, maxOverlayOpacity;
  final double disabledContentOpacity, focusRingWidth, focusRingOffset;
  final int hoverElevationStep, draggedElevationStep;
  const RebicInteractionStateTokens.fallback();
  double overlayOpacity(Set<RebicInteractionState> states);
  Color overlayColor(Color content, Set<RebicInteractionState> states);
  bool showsFocusRing(Set<RebicInteractionState> states);
  int elevationLevel(int base, Set<RebicInteractionState> states);
}
```

O `lerp` interpola os `double` e troca os `int` em 0,5 (`lerpDiscrete`). O `copyWith` faz `assert` de:

- opacidades em [0, 1];
- `hover`, `pressed`, `selected` e `dragged` ≤ `maxOverlayOpacity`;
- `focusRingWidth` ≥ 2 e `focusRingOffset` ≥ 0, finitos;
- passos de elevação entre 0 e 4.

As mensagens nomeiam o campo.

### D4. Primitivos

`RebicInteractionPrimitives` (`lib/src/interaction_states/primitives/interaction_primitives.dart`):

- opacidades `opacity0`, `opacity4`, `opacity8`, `opacity12`, `opacity16`, `opacity24`, `opacity38`, `opacity50` e
  `opacity100` (valor = número ÷ 100), com o mapa ordenado `opacities`;
- espessuras de traço `stroke1`, `stroke2` e `stroke3`, com o mapa `strokes`.

Mapeamento `fallback()`: hover `opacity8`, pressed `opacity12`, selected `opacity12`, dragged `opacity16`,
`maxOverlayOpacity` `opacity16`, `disabledContentOpacity` `opacity38`, `focusRingWidth` `stroke2`, `focusRingOffset`
`stroke2`, `hoverElevationStep` 1 e `draggedElevationStep` 2.

### D5. Testes

- O teste de contraste usa `RebicColorTokens.light()/dark()` e
  `rebicContrastRatio(text, Color.alphaBlend(text.withValues(alpha: max), surface))` nos cinco pares da spec.
- As regras de combinação usam tabelas de casos (conjunto de estados → resultado esperado), e cada tabela é um cenário da spec.

### D6. Galeria

A página "Estados" (`pages/states_page.dart`) tem duas faixas, claro e escuro. Cada faixa tem oito amostras: normal,
hover, pressionado, selecionado, selecionado + hover, arrastado, foco e desabilitado. Cada amostra é uma superfície
com a camada de `overlayColor`, a sombra de `elevationLevel` (base 1, via `RebicElevationTokens`), o anel de foco
(borda `focus` com a espessura e o afastamento dos tokens) quando `showsFocusRing` é verdadeiro e as cores
desabilitadas no estado desabilitado.

## Risks / Trade-offs

- [O teto de 16% pode ficar sutil demais em monitores de baixo contraste] → É o máximo seguro para a paleta atual. Uma paleta de marca com `primary` mais escuro permite subir o teto. O teste de contraste protege a mudança.
- [`dragged` e `hover` com a mesma opacidade combinada sob seleção] → É aceitável: o arrasto também se distingue pela elevação maior (+2).

## Migration Plan

Não há consumidores. O rollback é reverter a change.
