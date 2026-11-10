# Design: GjaTheme

## Context

`GjaThemeData` (foundation) já tem `light()`/`dark()`, `withDensity`, `resolve(disableAnimations:)`, `lerp`
contínuo e `copyWith`, e o atalho `spacing`, que vem da densidade. Ainda não há nada que o publique na árvore.

No núcleo, os valores visuais entram por parâmetro, com padrões fixos do mapeamento claro:
- `GjaInteractable`: `minTargetSize` (padrão `GjaAccessibility.defaultMinTargetSize`), `interactionTokens`
  (padrão `fallback()`), `focusColor` (nulo → `focus` do claro) e `focusRingBorderRadius` (padrão `zero`);
- `GjaModal.show`: `barrierColor` (nulo → `blockLayer` do claro);
- `GjaAnchoredOverlay`: `gap` e `margin` (nulos → `xs`/`s` do `fallback()`);
- responsividade: `breakpoints` (padrão `fallback()`) em `screenSizeClassOf`, `GjaScreenSizeScope` e
  `GjaResponsiveBuilder`.

A direção das camadas é `foundation` ← `core` ← `widgets`. O `gja_core` não pode ler um widget de
`gja_widgets`, e por isso a consulta ao tema fica na `foundation`, onde a arquitetura já põe o tema.

`gja_widgets` ainda não tem nenhum widget. O catálogo põe `GjaTheme` na categoria `fundacao-layout`, e a pasta
esperada pelo `gja_checks catalog` é `packages/gja_widgets/lib/src/fundacao_layout/theme/`.

No SAPUI5, o tema é global da aplicação, e a densidade é uma classe CSS num contêiner, que vale para a subárvore.

## Goals / Non-Goals

**Goals:**
- tema ativo na árvore, lido por widgets e pelo núcleo;
- troca animada;
- densidade por subárvore;
- texto e ícone padrão;
- núcleo sem valores fixos quando há tema.

**Non-Goals:**
- `GjaApp`;
- seguir o brilho do sistema;
- tokens de componente de widgets futuros;
- golden do próprio `GjaTheme`, que não tem aparência.

## Decisions

### D1. Escopo e leitura na foundation

```dart
// gja_foundation/lib/src/theming/theme_scope.dart
class GjaThemeScope extends InheritedWidget {
  const GjaThemeScope({required this.data, required super.child, super.key});
  final GjaThemeData data;
  @override bool updateShouldNotify(GjaThemeScope old) => data != old.data;
}

// em GjaThemeData
static GjaThemeData of(BuildContext context);
static GjaThemeData? maybeOf(BuildContext context); // sem reserva
```

`of` faz três coisas:
1. lê o escopo mais próximo (`dependOnInheritedWidgetOfExactType`), ou usa uma instância estática de `light()`
   criada uma vez, para não gerar igualdade nova a cada leitura;
2. aplica `resolve(disableAnimations: MediaQuery.maybeDisableAnimationsOf(context) ?? false)`;
3. retorna o tema resolvido.

`resolve` retorna a própria instância quando não há redução, então o custo é nulo no caso comum.

`GjaThemeScope` é público, mas de baixo nível: o dartdoc indica `GjaTheme` para aplicações. Ele é coberto pelo
requisito "Tema na árvore de widgets" da spec `theming`, e não por uma spec de widget. Não é um componente visual.

**Alternativa:** pôr o `InheritedWidget` em `gja_core`. A foundation é o lugar do tema, e o núcleo e os widgets já
dependem dela.

### D2. `GjaTheme`

```dart
class GjaTheme extends StatelessWidget {
  const GjaTheme({required GjaThemeData data, required Widget child, Duration? duration, super.key});
  const GjaTheme.density({required GjaDensity density, required Widget child, super.key});
  static GjaThemeData of(BuildContext context) => GjaThemeData.of(context);
}
```

O `build` resolve o tema de destino:
- com `data`, é o próprio `data`;
- em `.density`, é `GjaThemeData.of(context).withDensity(density)`.

A duração é zero quando `MediaQuery.maybeDisableAnimationsOf` é verdadeiro. Fora isso, é `duration`, ou a
`motion.medium` do tema de destino quando `duration` é nulo.

O `build` entrega o tema a `_AnimatedGjaTheme`, um `ImplicitlyAnimatedWidget` com um `Tween<GjaThemeData>` que usa
`GjaThemeData.lerp` e a curva `motion.standard`. O estado constrói, nesta ordem:
- `GjaThemeScope(data: tema interpolado)`;
- `DefaultTextStyle.merge(style: typography.body.copyWith(color: colors.text))`;
- `IconTheme.merge(data: IconThemeData(color: colors.text, size: icons.control))`;
- `child`.

Com duração zero, o `ImplicitlyAnimatedWidget` salta para o destino no quadro seguinte.

`GjaTheme` não cria `Focus`, `Semantics` nem pintura, e por isso a ordem de foco e a semântica não mudam.

### D3. Núcleo lê o tema

Os parâmetros visuais passam a ser anuláveis, e o padrão é resolvido no `build` com `GjaThemeData.of(context)`:

| Componente | Parâmetro | Sem valor |
|---|---|---|
| `GjaInteractable` | `minTargetSize` | `theme.density.minTargetSize` |
| | `interactionTokens` | `theme.interaction` |
| | `focusColor` | `theme.colors.focus` |
| | `focusRingBorderRadius` | `BorderRadius.circular(theme.radius.control)` |
| `GjaModal.show` | `barrierColor` | `theme.colors.blockLayer` |
| `GjaAnchoredOverlay` | `gap` / `margin` | `theme.spacing.xs` / `theme.spacing.s` |
| `GjaScreenSizeScope`, `screenSizeClassOf`, `GjaResponsiveBuilder` | `breakpoints` | `theme.breakpoints` |

Para quem chama, a mudança é compatível, porque o código que passava valores continua igual. Sem tema na árvore, o
resultado só muda no raio do anel de foco, que deixa de ser `zero` e passa ao raio `control` do claro, porque o padrão
atual é um provisório sem significado. `screenSizeClassOf` compara os limiares efetivos (recebidos ou do tema) com os
do escopo.

`GjaAccessibility.defaultMinTargetSize` continua existindo, como valor de referência.

### D4. Galeria

- `main.dart` envolve as rotas em `GjaTheme(data: GjaThemeData.light())`, dentro do `builder` do `WidgetsApp`, junto
  do `GjaScreenSizeScope`.
- As páginas de interação, localização, responsividade e sobreposições trocam `GjaThemeData.light()` por
  `GjaTheme.of(context)` e deixam de passar os valores visuais ao núcleo.
- A nova página "GjaTheme" tem:
  - alternância claro/escuro, com `GjaTheme` local e a troca animada;
  - uma prévia com a cor `base`, sob chave, para o teste;
  - duas colunas lado a lado, uma confortável e outra com `GjaTheme.density(compact)`, cada uma com um
    `GjaInteractable` cuja altura mínima mostra o alvo da densidade.

### D5. Catálogo

`gja/widgets/gja-theme` passa a `implemented`, com as dependências do `[Integração]`: `theming`, `typography`,
`iconography`, `density` e `accessibility`, todas P0 da fase 1.

## Risks / Trade-offs

- [`GjaThemeScope` público pode ser usado no lugar de `GjaTheme`] → O dartdoc orienta usar `GjaTheme`. O escopo
  continua útil para testes e para o núcleo.
- [Interpolar o tema inteiro a cada quadro da transição reconstrói toda a subárvore] → Dura só a transição, que é curta
  (`medium`), e é o mesmo custo do `AnimatedTheme` do Flutter.
- [`GjaTheme.density` com animação herda a duração do tema] → Na troca de densidade, a interpolação dos tamanhos é
  aceitável e respeita o movimento reduzido.

## Migration Plan

Sem migração para quem usa o núcleo. A galeria é atualizada na própria change.
