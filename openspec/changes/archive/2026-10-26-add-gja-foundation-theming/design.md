# Design: Fundamento de tema

## Context

- Conjuntos existentes, todos com `copyWith`, `lerp` e igualdade:
  - `GjaColorTokens` (`light()`/`dark()`), `GjaTypographyTokens`, `GjaDensityTokens` (com `GjaSpacingTokens`);
  - `GjaRadiusTokens`, `GjaElevationTokens`, `GjaMotionTokens`, `GjaIconTokens`;
  - `GjaInteractionStateTokens`, `GjaBreakpointTokens` e `GjaTokenExtensions`.
- `GjaAccessibility.resolveMotion` e `gjaCheckContrast` já existem.
- O catálogo já lista os onze fundamentos como dependências de `theming`, incluindo `iconography` e `accessibility`.

## Goals / Non-Goals

**Goals:**

- Um único objeto de tema, imutável e interpolável, que é tudo o que `GjaTheme` precisa propagar.
- Uma identidade de marca que se monta só com `copyWith` e primitivos, e uma verificação de acessibilidade que avisa quando a personalização quebra uma garantia.

**Non-Goals:**

- `InheritedWidget`, `of(context)` e animação implícita de tema (`add-gja-theme`).
- Ler `MediaQuery` (brilho e movimento reduzido da plataforma). O tema recebe esses valores como parâmetros.

## Decisions

### D1. `GjaThemeData`

```dart
@immutable
class GjaThemeData extends GjaTokenSet<GjaThemeData> {
  final Brightness brightness;              // dart:ui
  final GjaColorTokens colors;
  final GjaTypographyTokens typography;
  final GjaDensityTokens density;         // inclui spacing
  final GjaRadiusTokens radius;
  final GjaElevationTokens elevation;
  final GjaMotionTokens motion;
  final GjaIconTokens icons;
  final GjaInteractionStateTokens interaction;
  final GjaBreakpointTokens breakpoints;
  final GjaTokenExtensions components;
  final GjaTokenExtensions extensions;
  GjaSpacingTokens get spacing => density.spacing;

  factory GjaThemeData.light({GjaDensity density = GjaDensity.comfortable});
  factory GjaThemeData.dark({GjaDensity density = GjaDensity.comfortable});
  GjaThemeData withDensity(GjaDensity density);
  GjaThemeData resolve({required bool disableAnimations});
  List<String> accessibilityIssues();
}
```

`light`/`dark` são `factory` porque `GjaDensityTokens.of` não é constante. Há também um construtor `const` com
todos os campos, para temas personalizados constantes. O `spacing` é derivado da densidade, e não um campo separado,
para que tema e densidade nunca discordem.

- **Alternativa:** campos `spacing` e `density` independentes. Foi rejeitada porque permitiria um tema compacto com
  espaçamento confortável sem querer.

### D2. Tokens de componente em coleção

`components` é um `GjaTokenExtensions`. O widget busca com `theme.components.get<GjaButtonTokens>()` e, se for
nulo, usa `GjaButtonTokens.fallback(theme)`, derivado dos semânticos. Assim, cada widget novo registra os próprios
tokens sem alterar esta spec. Os testes usam um conjunto de componente de teste.

- **Alternativa:** um campo por widget em `GjaThemeData`. Foi rejeitada porque cerca de 60 widgets alterariam este
  fundamento, um por um.

### D3. Acessibilidade do tema

- `accessibilityIssues()` concatena:
  - `gjaCheckContrast(colors)` formatado (`'onPrimary/primary: 1.00 < 4.5'`);
  - `minTargetSize < GjaAccessibility.minTargetSizeFloor`.

  É uma verificação, e não um `assert`, porque uma aplicação pode querer inspecionar a própria marca em teste ou em
  debug sem travar a execução.
- `resolve(disableAnimations: true)` devolve `copyWith(motion: GjaAccessibility.resolveMotion(motion, disableAnimations: true))`.
  Com `false`, devolve `this`.

### D4. Interpolação

Cada conjunto é interpolado pelo próprio `lerp`, e as coleções por `GjaTokenExtensions.lerp`. O brilho troca em
0,5 (`lerpDiscrete`). A densidade tem `lerp` próprio, que troca o modo em 0,5 e interpola as medidas. O espaçamento
segue a densidade.

Nos extremos (`t = 0` e `t = 1`), `lerp` devolve exatamente a origem ou o destino. `GjaTokenExtensions.lerp` mantém
as extensões presentes em só uma das coleções, como pede a spec de design tokens. Sem esse atalho, interpolar até um
tema sem `components` resultaria, em `t = 1`, num tema diferente do destino, o que quebra o contrato.

### D5. Catálogo

As dependências de `gja/foundation/theming` no catálogo já incluem os onze fundamentos e não mudam. A spec cita
todos os onze, como o `gja_checks catalog` exige.

### D6. Galeria

A página "Tema" (`pages/theme_page.dart`) tem três controles simples (`GestureDetector` com rótulo): claro/escuro,
confortável/compacto e padrão/marca. A "marca de exemplo" troca `primary`, `focus` e `primaryContainer` por tons da
escala de ciano, que passam na verificação. A prévia é um cartão com título, texto, um "botão" simulado e um campo
simulado, montado só a partir do `GjaThemeData` escolhido. Quando a escolha muda, a prévia é reconstruída com o
novo tema. A página mostra também o resultado de `accessibilityIssues()` (vazio).

## Risks / Trade-offs

- [`GjaThemeData` grande com `==` manual] → `expectTokenSetContract` e um teste que altera cada campo isoladamente.
- [Marca de exemplo com contraste insuficiente] → A verificação de acessibilidade roda no teste da página e no teste "Tema de marca válido".

## Migration Plan

Não há consumidores. A galeria continua sem `GjaTheme` até `add-gja-theme`. O rollback é reverter a change.
