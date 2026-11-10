# Design: Convenções de acessibilidade

## Context

- Os limites já existem em outros fundamentos:
  - `gjaTextContrastMinimum` (4,5) e `gjaNonTextContrastMinimum` (3) em `color`;
  - `GjaDensityTokens.minTargetSizeFloor` (24) e os alvos de referência (48/24) em `density`;
  - o anel de foco (≥ 2 px, cor `focus`) em `interaction-states`;
  - as durações de movimento em `GjaMotionTokens`.
- `flutter_test` expõe `textContrastGuideline`, `labeledTapTargetGuideline` e `MinimumTapTargetGuideline(size:, link:)`,
  todos públicos. Por isso não é preciso um pacote de testes próprio.
- O template de spec de widget já cita `gja/foundation/accessibility` no requisito `[Acessibilidade] Semântica e contraste`.

## Goals / Non-Goals

**Goals:**

- Um ponto único de referência para widgets e revisores, sem duplicar valores dos outros fundamentos.
- Uma bateria de testes de acessibilidade obrigatória e igual para todos os widgets.

**Non-Goals:**

- Tornar os limites de acessibilidade personalizáveis por tema. São requisitos normativos (WCAG), e não identidade visual.
- Um pacote `gja_test` com helpers. Pode ser reavaliado quando houver vários widgets repetindo o mesmo código de teste.

## Decisions

### D1. `GjaAccessibility` é uma API estática, não um conjunto de tokens

```dart
abstract final class GjaAccessibility {
  static const conformanceTarget = 'WCAG 2.2 AA';
  static const minTextContrast = gjaTextContrastMinimum;        // 4,5
  static const minNonTextContrast = gjaNonTextContrastMinimum;  // 3
  static const minSupportedTextScale = 2.0;
  static const minTargetSizeFloor = GjaDensityTokens.minTargetSizeFloor; // 24
  static double minTargetSize(GjaDensityTokens density) => density.minTargetSize;
  static GjaMotionTokens resolveMotion(GjaMotionTokens motion, {required bool disableAnimations});
}
```

Os valores são aliases das constantes de origem, sem nenhum número repetido. Os limites de acessibilidade não variam
por tema, então um `GjaTokenSet` com `lerp` não faz sentido aqui. Fica em `lib/src/accessibility/accessibility.dart`,
com dartdoc `Nível: semântico.` (convenções), e é exportado por `gja_foundation.dart`.

- **Alternativa:** `GjaAccessibilityTokens` no tema. Foi rejeitada porque permitiria a um tema rebaixar o contraste
  ou o alvo, o que violaria a meta.

### D2. Movimento reduzido

`resolveMotion` com `disableAnimations: true` retorna `motion.copyWith(...)` com as quatro durações em
`Duration.zero` e as curvas preservadas. A ordem fica válida, porque são todas zero. Com `false`, retorna a própria
instância. A leitura de `MediaQuery.disableAnimationsOf` fica com quem tem `BuildContext` (`theming`/`GjaTheme` e a
galeria). O fundamento continua puro.

### D3. Bateria mínima de testes (template)

O requisito `[Testes] Cobertura exigida` do template passa a listar:

- `textContrastGuideline` e `labeledTapTargetGuideline`;
- `MinimumTapTargetGuideline(size: Size.square(GjaAccessibility.minTargetSize(density)), link: …)` em `comfortable` e `compact`;
- render com `textScaler` 2,0 sem estouro;
- `matchesSemantics` (rótulo, papel, estado e valor);
- operação por teclado com `sendKeyEvent`.

O requisito `[Acessibilidade] Semântica e contraste` passa a citar rótulo, papel, estado e valor explicitamente.
O teste do cenário "Convenção no template de spec" lê o template e procura esses termos.

### D4. Teste da diretriz de alvo

Fica no próprio pacote, como teste de widget com `flutter_test`:

- `Semantics(button: true, label: 'alvo')` em torno de um `GestureDetector` com `SizedBox` de 48 × 48;
- `MinimumTapTargetGuideline` com 48 e com 24 deve passar;
- com 20 × 20, deve falhar com os dois.

Isso demonstra a receita que os widgets vão copiar.

### D5. Galeria

A página "Acessibilidade" (`pages/accessibility_page.dart`) mostra:

- a meta e os limites;
- duas colunas de durações de movimento (normal e com redução, via `resolveMotion`), e a indicação do valor atual da
  plataforma (`MediaQuery.disableAnimationsOf`);
- uma amostra de texto no estilo `body`, que acompanha a escala do sistema.

O teste do cenário "Conteúdo em 200%" usa `tester.platformDispatcher.textScaleFactorTestValue = 2` e uma janela de
400 px. Ele exige que não haja exceção de layout e que o `RenderParagraph` da amostra tenha `textScaler` linear 2,0.
Se o índice ou o cabeçalho da galeria estourarem nessa escala, eles são corrigidos nesta change, porque a galeria
também deve cumprir a convenção.

## Risks / Trade-offs

- [Escala 2,0 pode quebrar layouts densos, como tabelas, na Fase 3] → É exatamente o que a regra quer expor cedo. Cada widget declara na spec como cresce em `[Responsividade]`.
- [Sem pacote de helpers, os testes de acessibilidade se repetem entre widgets] → A receita é curta (D3, D4). O pacote pode ser criado quando a repetição justificar.

## Migration Plan

Não há consumidores. O template é atualizado para as próximas specs. O rollback é reverter a change.
