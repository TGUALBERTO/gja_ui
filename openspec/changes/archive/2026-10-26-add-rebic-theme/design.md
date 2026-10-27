# Design: RebicTheme

## Context

`RebicThemeData` (foundation) já tem `light()`/`dark()`, `withDensity`, `resolve(disableAnimations:)`, `lerp`
contínuo e `copyWith`, e o atalho `spacing`, que vem da densidade. Ainda não há nada que o publique na árvore.

No núcleo, os valores visuais entram por parâmetro, com padrões fixos do mapeamento claro:
- `RebicInteractable`: `minTargetSize` (padrão `RebicAccessibility.defaultMinTargetSize`), `interactionTokens`
  (padrão `fallback()`), `focusColor` (nulo → `focus` do claro) e `focusRingBorderRadius` (padrão `zero`);
- `RebicModal.show`: `barrierColor` (nulo → `blockLayer` do claro);
- `RebicAnchoredOverlay`: `gap` e `margin` (nulos → `xs`/`s` do `fallback()`);
- responsividade: `breakpoints` (padrão `fallback()`) em `screenSizeClassOf`, `RebicScreenSizeScope` e
  `RebicResponsiveBuilder`.

A direção das camadas é `foundation` ← `core` ← `widgets`. O `rebic_core` não pode ler um widget de
`rebic_widgets`, e por isso a consulta ao tema fica na `foundation`, onde a arquitetura já põe o tema.

`rebic_widgets` ainda não tem nenhum widget. O catálogo põe `RebicTheme` na categoria `fundacao-layout`, e a pasta
esperada pelo `rebic_checks catalog` é `packages/rebic_widgets/lib/src/fundacao_layout/theme/`.

No SAPUI5, o tema é global da aplicação, e a densidade é uma classe CSS num contêiner, que vale para a subárvore.

## Goals / Non-Goals

**Goals:**
- tema ativo na árvore, lido por widgets e pelo núcleo;
- troca animada;
- densidade por subárvore;
- texto e ícone padrão;
- núcleo sem valores fixos quando há tema.

**Non-Goals:**
- `RebicApp`;
- seguir o brilho do sistema;
- tokens de componente de widgets futuros;
- golden do próprio `RebicTheme`, que não tem aparência.

## Decisions

### D1. Escopo e leitura na foundation

```dart
// rebic_foundation/lib/src/theming/theme_scope.dart
class RebicThemeScope extends InheritedWidget {
  const RebicThemeScope({required this.data, required super.child, super.key});
  final RebicThemeData data;
  @override bool updateShouldNotify(RebicThemeScope old) => data != old.data;
}

// em RebicThemeData
static RebicThemeData of(BuildContext context);
static RebicThemeData? maybeOf(BuildContext context); // sem reserva
```

`of` faz três coisas:
1. lê o escopo mais próximo (`dependOnInheritedWidgetOfExactType`), ou usa uma instância estática de `light()`
   criada uma vez, para não gerar igualdade nova a cada leitura;
2. aplica `resolve(disableAnimations: MediaQuery.maybeDisableAnimationsOf(context) ?? false)`;
3. retorna o tema resolvido.

`resolve` retorna a própria instância quando não há redução, então o custo é nulo no caso comum.

`RebicThemeScope` é público, mas de baixo nível: o dartdoc indica `RebicTheme` para aplicações. Ele é coberto pelo
requisito "Tema na árvore de widgets" da spec `theming`, e não por uma spec de widget. Não é um componente visual.

**Alternativa:** pôr o `InheritedWidget` em `rebic_core`. A foundation é o lugar do tema, e o núcleo e os widgets já
dependem dela.

### D2. `RebicTheme`

```dart
class RebicTheme extends StatelessWidget {
  const RebicTheme({required RebicThemeData data, required Widget child, Duration? duration, super.key});
  const RebicTheme.density({required RebicDensity density, required Widget child, super.key});
  static RebicThemeData of(BuildContext context) => RebicThemeData.of(context);
}
```

O `build` resolve o tema de destino:
- com `data`, é o próprio `data`;
- em `.density`, é `RebicThemeData.of(context).withDensity(density)`.

A duração é zero quando `MediaQuery.maybeDisableAnimationsOf` é verdadeiro. Fora isso, é `duration`, ou a
`motion.medium` do tema de destino quando `duration` é nulo.

O `build` entrega o tema a `_AnimatedRebicTheme`, um `ImplicitlyAnimatedWidget` com um `Tween<RebicThemeData>` que usa
`RebicThemeData.lerp` e a curva `motion.standard`. O estado constrói, nesta ordem:
- `RebicThemeScope(data: tema interpolado)`;
- `DefaultTextStyle.merge(style: typography.body.copyWith(color: colors.text))`;
- `IconTheme.merge(data: IconThemeData(color: colors.text, size: icons.control))`;
- `child`.

Com duração zero, o `ImplicitlyAnimatedWidget` salta para o destino no quadro seguinte.

`RebicTheme` não cria `Focus`, `Semantics` nem pintura, e por isso a ordem de foco e a semântica não mudam.

### D3. Núcleo lê o tema

Os parâmetros visuais passam a ser anuláveis, e o padrão é resolvido no `build` com `RebicThemeData.of(context)`:

| Componente | Parâmetro | Sem valor |
|---|---|---|
| `RebicInteractable` | `minTargetSize` | `theme.density.minTargetSize` |
| | `interactionTokens` | `theme.interaction` |
| | `focusColor` | `theme.colors.focus` |
| | `focusRingBorderRadius` | `BorderRadius.circular(theme.radius.control)` |
| `RebicModal.show` | `barrierColor` | `theme.colors.blockLayer` |
| `RebicAnchoredOverlay` | `gap` / `margin` | `theme.spacing.xs` / `theme.spacing.s` |
| `RebicScreenSizeScope`, `screenSizeClassOf`, `RebicResponsiveBuilder` | `breakpoints` | `theme.breakpoints` |

Para quem chama, a mudança é compatível, porque o código que passava valores continua igual. Sem tema na árvore, o
resultado só muda no raio do anel de foco, que deixa de ser `zero` e passa ao raio `control` do claro, porque o padrão
atual é um provisório sem significado. `screenSizeClassOf` compara os limiares efetivos (recebidos ou do tema) com os
do escopo.

`RebicAccessibility.defaultMinTargetSize` continua existindo, como valor de referência.

### D4. Galeria

- `main.dart` envolve as rotas em `RebicTheme(data: RebicThemeData.light())`, dentro do `builder` do `WidgetsApp`, junto
  do `RebicScreenSizeScope`.
- As páginas de interação, localização, responsividade e sobreposições trocam `RebicThemeData.light()` por
  `RebicTheme.of(context)` e deixam de passar os valores visuais ao núcleo.
- A nova página "RebicTheme" tem:
  - alternância claro/escuro, com `RebicTheme` local e a troca animada;
  - uma prévia com a cor `base`, sob chave, para o teste;
  - duas colunas lado a lado, uma confortável e outra com `RebicTheme.density(compact)`, cada uma com um
    `RebicInteractable` cuja altura mínima mostra o alvo da densidade.

### D5. Catálogo

`rebic/widgets/rebic-theme` passa a `implemented`, com as dependências do `[Integração]`: `theming`, `typography`,
`iconography`, `density` e `accessibility`, todas P0 da fase 1.

## Risks / Trade-offs

- [`RebicThemeScope` público pode ser usado no lugar de `RebicTheme`] → O dartdoc orienta usar `RebicTheme`. O escopo
  continua útil para testes e para o núcleo.
- [Interpolar o tema inteiro a cada quadro da transição reconstrói toda a subárvore] → Dura só a transição, que é curta
  (`medium`), e é o mesmo custo do `AnimatedTheme` do Flutter.
- [`RebicTheme.density` com animação herda a duração do tema] → Na troca de densidade, a interpolação dos tamanhos é
  aceitável e respeita o movimento reduzido.

## Migration Plan

Sem migração para quem usa o núcleo. A galeria é atualizada na própria change.
