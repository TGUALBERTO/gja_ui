# Design: Fundamento de cores semânticas

## Context

- O contrato de tokens já existe (`GjaTokenSet<T>`, helpers internos `lerp.dart`, `gja_primitives.dart`,
  teste de nível no dartdoc e regra do `gja_checks` que isola primitivos). Ver `gja/foundation/design-tokens`.
- O projeto é protótipo (ADR 0001). A paleta oficial da marca não está disponível (questão em aberto 5 do design
  arquivado da Fase 0).
- A galeria usa `Color(0xFF0A6ED1)`, que é o azul do Fiori. O design da Fase 0 lista semelhança visual com o Fiori
  como risco de propriedade intelectual.

## Goals / Non-Goals

**Goals:**

- Papéis estáveis, que sobrevivem à troca de paleta. Uma marca nova muda só as escalas e o mapeamento.
- Contraste AA garantido por teste em ambos os modos, e não só por revisão.
- O estado semântico de valor definido uma vez, com cores, para todos os widgets de entrada e de status.

**Non-Goals:**

- Cores de estados de interação (hover, pressionado, selecionado). Serão derivadas dos papéis daqui, por
  sobreposição, em `interaction-states`.
- Seleção automática de claro ou escuro (`MediaQuery.platformBrightness`), que pertence a `theming`.
- Geração algorítmica de escalas (HCT/OKLCH). As escalas são tabelas fixas, verificadas por teste.

## Decisions

### D1. Escalas primitivas (provisórias)

Ficam em `GjaColorPrimitives` (`lib/src/color/primitives/color_primitives.dart`), reexportado por `gja_primitives.dart`.
O nome segue a regra da spec de tokens: matiz + posição.

| Escala | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 950 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | F7F8FA | EEF0F3 | DDE1E7 | C3C9D2 | 9AA3B0 | 737D8C | 586271 | 424B58 | 2C333D | 1B2027 | 11151A |
| blue | EEF4FF | D9E6FF | B3CCFF | 85ABFA | 5788EE | 3468D9 | 2453B8 | 1C4294 | 163370 | 10244F | — |
| green | EDF8F1 | D3EFDD | A6DEBB | 70C793 | 3FA96C | 258C52 | 1B7142 | 165A35 | 114428 | 0B2E1B | — |
| amber | FFF7E8 | FDEBC4 | F9D488 | F2B84A | DE9A1E | B87D10 | 94630C | 744D0A | 553808 | 392505 | — |
| red | FDF0F0 | FAD9D9 | F3B0B0 | EA8080 | DC5656 | C43939 | A12C2C | 7F2323 | 5E1A1A | 3F1111 | — |
| cyan | ECF8FB | CDEDF5 | 9DDAEA | 63C1DA | 2FA3C2 | 1A86A3 | 146B83 | 105467 | 0C3F4D | 082A34 | — |

Também há `white` (FFFFFF) e `black` (000000). Cada escala é exposta como `Map<String, Color>` ordenado, como
`GjaMotionPrimitives.durations`, para o teste de ordem de luminância.
Antes desta proposta, todos os pares da regra de contraste foram calculados com estes valores nos dois mapeamentos,
e todos passaram. O teste da spec é a referência: se um valor mudar e o teste falhar, o valor é ajustado.

- **Alternativa:** gerar as escalas por algoritmo (Material HCT). Foi rejeitada porque adiciona dependência
  (`material_color_utilities`) e torna a paleta menos auditável.

### D2. `GjaColorTokens` e os mapeamentos de referência

```
GjaColorTokens extends GjaTokenSet<GjaColorTokens>
  background, surface, surfaceVariant, onSurface, onSurfaceMuted, onSurfaceDisabled,
  surfaceDisabled, border, borderStrong, primary, onPrimary, primaryContainer,
  onPrimaryContainer, focus, shadow, scrim                      : Color
  none, success, warning, error, information                    : GjaValueStateColors
  GjaValueStateColors stateColors(GjaValueState state)      // switch exaustivo
  const GjaColorTokens.light() / .dark()
```

| Papel | Claro | Escuro |
|---|---|---|
| background | neutral50 | neutral950 |
| surface | white | neutral900 |
| surfaceVariant | neutral100 | neutral800 |
| onSurface | neutral900 | neutral50 |
| onSurfaceMuted | neutral600 | neutral300 |
| onSurfaceDisabled | neutral400 | neutral600 |
| surfaceDisabled | neutral100 | neutral800 |
| border | neutral200 | neutral700 |
| borderStrong | neutral500 | neutral400 |
| primary | blue600 | blue300 |
| onPrimary | white | blue900 |
| primaryContainer | blue50 | blue800 |
| onPrimaryContainer | blue800 | blue100 |
| focus | blue600 | blue300 |
| shadow | black, opacidade 0,16 | black, opacidade 0,40 |
| scrim | black, opacidade 0,40 | black, opacidade 0,60 |

Estados (`foreground`/`background`/`border`):

| Estado | Claro | Escuro |
|---|---|---|
| none | neutral700 / neutral100 / neutral500 | neutral300 / neutral800 / neutral400 |
| success | green700 / green50 / green600 | green300 / green900 / green400 |
| warning | amber700 / amber50 / amber600 | amber300 / amber900 / amber400 |
| error | red600 / red50 / red600 | red300 / red900 / red400 |
| information | cyan700 / cyan50 / cyan600 | cyan300 / cyan900 / cyan400 |

`shadow` e `scrim` usam `Color.withValues(alpha:)` sobre um primitivo, o que a spec admite. Como não são constantes,
`light()`/`dark()` não podem ser construtores `const` se calcularem a opacidade. Por isso, a biblioteca de primitivos
também expõe `blackAlpha16`, `blackAlpha40` e `blackAlpha60` como constantes (`Color(0x29000000)` etc.), e os
mapeamentos continuam `const`.

`GjaValueStateColors` também é um `GjaTokenSet`, com `foreground`, `background` e `border`. Isso dá `lerp`
e igualdade aninhados de graça.

- **Alternativa:** `Map<GjaValueState, GjaValueStateColors>`. Foi rejeitada porque não é `const` com igualdade
  por valor, e o `switch` exaustivo dá a garantia de "todo estado tem cores" em tempo de compilação.

### D3. `GjaValueState`

`enum GjaValueState { none, success, warning, error, information }` fica em `lib/src/color/value_state.dart`.
A mensagem associada é responsabilidade dos widgets (fora deste fundamento).

### D4. Contraste

Fica em `lib/src/color/contrast.dart`, exportado:

- `double gjaContrastRatio(Color a, Color b)`: luminância relativa WCAG 2.1 (sRGB linearizado). Com `assert`,
  as duas cores precisam ser opacas.
- `double gjaContrastRatioOver(Color foreground, Color background)`: compõe a cor translúcida (`Color.alphaBlend`)
  sobre o fundo opaco antes de calcular.
- `List<GjaContrastIssue> gjaCheckContrast(GjaColorTokens tokens)`: aplica a lista de pares da spec e retorna
  os pares abaixo do mínimo (`foreground`, `background`, razão e mínimo). A lista vazia significa conforme.
  Os testes e a página da galeria usam a mesma função, e a convenção de acessibilidade poderá reutilizá-la.

"A chamada falha" (cenário "Cor translúcida") é um `ArgumentError`, e não um `assert`, porque o resultado silencioso
estaria errado também em release.

### D5. Galeria

- `main.dart`: `color: const GjaColorTokens.light().primary`. Como o `WidgetsApp` exige cor, ela passa a vir do
  mapeamento. O `textStyle` também passa a usar `onSurface` do mapeamento claro.
- Página "Cores" (`pages/color_page.dart`): duas colunas (claro e escuro) com amostras de cada papel e de cada
  estado de valor, e a razão de contraste calculada por `gjaContrastRatio` ao lado de cada par de texto.
- O teste de widget procura os textos dos papéis e as razões formatadas.

## Risks / Trade-offs

- [Paleta provisória diferente da marca da empresa] → Os papéis isolam a mudança: trocar escalas e mapeamentos não muda a API. O teste de contraste protege a troca.
- [Âmbar com contraste baixo como texto no modo claro] → `warning.foreground` usa `amber700` (o par foi conferido). O `amber400` só aparece como borda no escuro.
- [`withValues`/`alphaBlend` diferem entre versões do Flutter] → Os primitivos translúcidos são constantes `0xAARRGGBB`, e a composição usa só `Color.alphaBlend`, estável no SDK da ADR 0001.
- [Muitos campos em `GjaColorTokens` deixam o `==`/`copyWith` manual propenso a erro] → `expectTokenSetContract` e um teste que altera cada campo isoladamente, igual ao do movimento.

## Migration Plan

Não há consumidores. A galeria troca o literal `0xFF0A6ED1` pelo papel `primary`. O rollback é reverter a change.

## Open Questions

- Paleta oficial da marca: quando for definida, uma change `update-gja-foundation-color-brand-palette` troca as
  escalas e os mapeamentos. Isso não altera a spec, a abordagem nem as tarefas desta change.
