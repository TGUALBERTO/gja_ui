# Design: Fundamento de tema

## Context

- Conjuntos existentes, todos com `copyWith`, `lerp` e igualdade:
  - `RebicColorTokens` (`light()`/`dark()`), `RebicTypographyTokens`, `RebicDensityTokens` (com `RebicSpacingTokens`);
  - `RebicRadiusTokens`, `RebicElevationTokens`, `RebicMotionTokens`, `RebicIconTokens`;
  - `RebicInteractionStateTokens`, `RebicBreakpointTokens` e `RebicTokenExtensions`.
- `RebicAccessibility.resolveMotion` e `rebicCheckContrast` já existem.
- O catálogo já lista os onze fundamentos como dependências de `theming`, incluindo `iconography` e `accessibility`.

## Goals / Non-Goals

**Goals:**

- Um único objeto de tema, imutável e interpolável, que é tudo o que `RebicTheme` precisa propagar.
- Uma identidade de marca que se monta só com `copyWith` e primitivos, e uma verificação de acessibilidade que avisa quando a personalização quebra uma garantia.

**Non-Goals:**

- `InheritedWidget`, `of(context)` e animação implícita de tema (`add-rebic-theme`).
- Ler `MediaQuery` (brilho e movimento reduzido da plataforma). O tema recebe esses valores como parâmetros.

## Decisions

### D1. `RebicThemeData`

```dart
@immutable
class RebicThemeData extends RebicTokenSet<RebicThemeData> {
  final Brightness brightness;              // dart:ui
  final RebicColorTokens colors;
  final RebicTypographyTokens typography;
  final RebicDensityTokens density;         // inclui spacing
  final RebicRadiusTokens radius;
  final RebicElevationTokens elevation;
  final RebicMotionTokens motion;
  final RebicIconTokens icons;
  final RebicInteractionStateTokens interaction;
  final RebicBreakpointTokens breakpoints;
  final RebicTokenExtensions components;
  final RebicTokenExtensions extensions;
  RebicSpacingTokens get spacing => density.spacing;

  factory RebicThemeData.light({RebicDensity density = RebicDensity.comfortable});
  factory RebicThemeData.dark({RebicDensity density = RebicDensity.comfortable});
  RebicThemeData withDensity(RebicDensity density);
  RebicThemeData resolve({required bool disableAnimations});
  List<String> accessibilityIssues();
}
```

`light`/`dark` são `factory` porque `RebicDensityTokens.of` não é constante. Há também um construtor `const` com
todos os campos, para temas personalizados constantes. O `spacing` é derivado da densidade, e não um campo separado,
para que tema e densidade nunca discordem.

- **Alternativa:** campos `spacing` e `density` independentes. Foi rejeitada porque permitiria um tema compacto com
  espaçamento confortável sem querer.

### D2. Tokens de componente em coleção

`components` é um `RebicTokenExtensions`. O widget busca com `theme.components.get<RebicButtonTokens>()` e, se for
nulo, usa `RebicButtonTokens.fallback(theme)`, derivado dos semânticos. Assim, cada widget novo registra os próprios
tokens sem alterar esta spec. Os testes usam um conjunto de componente de teste.

- **Alternativa:** um campo por widget em `RebicThemeData`. Foi rejeitada porque cerca de 60 widgets alterariam este
  fundamento, um por um.

### D3. Acessibilidade do tema

- `accessibilityIssues()` concatena:
  - `rebicCheckContrast(colors)` formatado (`'onPrimary/primary: 1.00 < 4.5'`);
  - `minTargetSize < RebicAccessibility.minTargetSizeFloor`.

  É uma verificação, e não um `assert`, porque uma aplicação pode querer inspecionar a própria marca em teste ou em
  debug sem travar a execução.
- `resolve(disableAnimations: true)` devolve `copyWith(motion: RebicAccessibility.resolveMotion(motion, disableAnimations: true))`.
  Com `false`, devolve `this`.

### D4. Interpolação

Cada conjunto é interpolado pelo próprio `lerp`, e as coleções por `RebicTokenExtensions.lerp`. O brilho troca em
0,5 (`lerpDiscrete`). A densidade tem `lerp` próprio, que troca o modo em 0,5 e interpola as medidas. O espaçamento
segue a densidade.

Nos extremos (`t = 0` e `t = 1`), `lerp` devolve exatamente a origem ou o destino. `RebicTokenExtensions.lerp` mantém
as extensões presentes em só uma das coleções, como pede a spec de design tokens. Sem esse atalho, interpolar até um
tema sem `components` resultaria, em `t = 1`, num tema diferente do destino, o que quebra o contrato.

### D5. Catálogo

As dependências de `rebic/foundation/theming` no catálogo já incluem os onze fundamentos e não mudam. A spec cita
todos os onze, como o `rebic_checks catalog` exige.

### D6. Galeria

A página "Tema" (`pages/theme_page.dart`) tem três controles simples (`GestureDetector` com rótulo): claro/escuro,
confortável/compacto e padrão/marca. A "marca de exemplo" troca `primary`, `focus` e `primaryContainer` por tons da
escala de ciano, que passam na verificação. A prévia é um cartão com título, texto, um "botão" simulado e um campo
simulado, montado só a partir do `RebicThemeData` escolhido. Quando a escolha muda, a prévia é reconstruída com o
novo tema. A página mostra também o resultado de `accessibilityIssues()` (vazio).

## Risks / Trade-offs

- [`RebicThemeData` grande com `==` manual] → `expectTokenSetContract` e um teste que altera cada campo isoladamente.
- [Marca de exemplo com contraste insuficiente] → A verificação de acessibilidade roda no teste da página e no teste "Tema de marca válido".

## Migration Plan

Não há consumidores. A galeria continua sem `RebicTheme` até `add-rebic-theme`. O rollback é reverter a change.
