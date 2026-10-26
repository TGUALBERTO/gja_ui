# Design: Fundamento de elevação e sombras

## Context

- `RebicColorTokens` já tem o papel `shadow`: preto com 16% de opacidade no modo claro e 40% no escuro, pela
  constante `blackAlpha16/40`. A cor muda entre os modos; a geometria não precisa mudar.
- `rebic_checks tokens` já cobre `blurRadius`, `spreadRadius`, `elevation` e `Color(` em `rebic_widgets/lib`.
- O padrão dos fundamentos anteriores continua valendo: primitivos em `abstract final class`, conjunto semântico com
  `fallback()` constante e teste de nível documentado.

## Goals / Non-Goals

**Goals:**

- Sombras em camadas (uma de contato, nítida, e uma de ambiente, difusa), que leem bem em fundos claros e escuros.
- Separação entre geometria (este fundamento) e cor (papel `shadow`): trocar o tema não exige redefinir as sombras.

**Non-Goals:**

- Elevação por cor de superfície no modo escuro (*surface tint*).
- Sombras internas (*inset*) ou coloridas por estado.

## Decisions

### D1. `RebicShadowLayer`

```dart
@immutable
class RebicShadowLayer {
  const RebicShadowLayer({required this.offsetY, required this.blurRadius,
                          this.spreadRadius = 0, this.opacity = 1});
  final double offsetY, blurRadius, spreadRadius, opacity;   // opacity ∈ [0, 1]
  static RebicShadowLayer lerp(RebicShadowLayer a, RebicShadowLayer b, double t);
  static const zero = RebicShadowLayer(offsetY: 0, blurRadius: 0, opacity: 0);
}
```

O deslocamento é só vertical: a luz vem de cima. `RebicShadowLayer` fica em `lib/src/elevation/shadow_layer.dart` e
é exportado por `rebic_foundation.dart`, porque os mapeamentos personalizados precisam dele. O dartdoc leva
`Nível: primitivo.`, já que é um valor bruto de geometria.

- **Alternativa:** usar `BoxShadow` diretamente nos tokens. Foi rejeitada porque `BoxShadow` exige cor, e isso
  amarraria a geometria a um modo.

### D2. Primitivos (valores em px lógicos)

| Nível | Camada de contato (y, desfoque, expansão, opacidade) | Camada de ambiente |
|---|---|---|
| 0 | — | — |
| 1 | (1, 2, 0, 1,0) | (1, 3, 1, 0,5) |
| 2 | (1, 2, 0, 1,0) | (2, 6, 2, 0,5) |
| 3 | (1, 3, 0, 1,0) | (4, 8, 3, 0,5) |
| 4 | (2, 3, 0, 1,0) | (6, 10, 4, 0,5) |

O maior desfoque cresce a cada nível (3, 6, 8, 10), e o maior deslocamento também (1, 2, 4, 6).
`RebicElevationPrimitives` expõe `elevation0`…`elevation4` (`List<RebicShadowLayer>` constantes) e o mapa ordenado `levels`.

### D3. `RebicElevationTokens`

São oito campos `List<RebicShadowLayer>`: `level0` a `level4`, `card`, `popover` e `dialog`. O `fallback()` usa
`card = level1`, `popover = level2` e `dialog = level3`.

O conjunto expõe:

- `List<BoxShadow> shadowsFor(List<RebicShadowLayer> level, Color shadowColor)`: cada camada vira
  `BoxShadow(color: shadowColor.withValues(alpha: shadowColor.a * layer.opacity), offset: Offset(0, offsetY), blurRadius, spreadRadius)`;
- igualdade com `listEquals`;
- `lerp`, que interpola camada a camada e completa a lista menor com `RebicShadowLayer.zero`, como `BoxShadow.lerpList`.
  Nos extremos (`t = 0` e `t = 1`), `RebicShadowLayer.lerpList` devolve exatamente a lista de origem ou a de destino,
  sem camadas de preenchimento. Sem isso, interpolar até `level0` em `t = 1` resultaria em `[zero]`, e não em `[]`,
  o que quebra o contrato de `lerp`.

`copyWith` faz `assert` de camadas válidas (opacidade em [0, 1], desfoque e expansão `>= 0`, valores finitos),
com o nome do campo na mensagem.

- **Alternativa:** ordenar a profundidade só por índice, com uma enum de níveis. Foi rejeitada porque os papéis
  precisam aceitar uma geometria própria nos mapeamentos personalizados.

### D4. Testes

- **"Sombra com a cor do modo":** gera as sombras de `card` com `RebicColorTokens.light().shadow` e com `.dark().shadow`.
  Compara offset, desfoque e expansão (iguais) e confere que `alpha = shadow.a × opacidade da camada`.
- **"Papéis do mapeamento de referência":** compara os papéis com `level1/2/3` por `listEquals`.
- **Uso sem literais:** dois testes em `tool/rebic_checks/test/tokens_test.dart`.

### D5. Galeria

A página "Elevação" (`pages/elevation_page.dart`) tem duas faixas, claro e escuro. Cada faixa usa o fundo `background`
do modo e mostra um cartão `surface` por nível e por papel, com `boxShadow: shadowsFor(nível, colors.shadow)` e o
nome do nível. O teste verifica que o `BoxDecoration` de cada cartão tem o número de sombras do nível.

## Risks / Trade-offs

- [Sombras pouco visíveis no modo escuro] → O papel `shadow` escuro já usa 40% de opacidade. Se for preciso, a solução é *surface tint*, numa change de cor.
- [Custo de desenho de sombras com desfoque em listas longas] → Os níveis têm no máximo duas camadas, e a tabela usa `level0` e `level1`. A medição fica para a Fase 5.

## Migration Plan

Não há consumidores. O rollback é reverter a change.
