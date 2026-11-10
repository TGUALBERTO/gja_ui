# Design: Interação e foco

## Context

- `gja_core` está vazio e depende só de `gja_foundation`.
- Os fundamentos já existem: `GjaInteractionState`, `GjaInteractionStateTokens` (`showsFocusRing`,
  `focusRingWidth`/`Offset`), `GjaColorTokens.focus`, `GjaDensityTokens.minTargetSize` e `GjaAccessibility`.
- Ainda não há propagação de tema (`GjaTheme` vem depois do núcleo).
- O `WidgetsApp` já mapeia Enter, Enter numérico e Espaço para `ActivateIntent` (e para `ButtonActivateIntent` na web).
  O `FocusableActionDetector` informa `onShowFocusHighlight`/`onShowHoverHighlight` seguindo `FocusManager.highlightMode`.

## Goals / Non-Goals

**Goals:**

- Um único bloco reutilizável que todos os widgets interativos compõem, com o comportamento igual em todos.
- Só mecanismos nativos do Flutter (`FocusableActionDetector`, `Actions`, `GestureDetector`, `Semantics`), sem
  `RenderObject` próprio.

**Non-Goals:**

- Valores visuais vindos do tema (`add-gja-theme`).
- Pintar a camada de estado. O widget que usa `GjaInteractable` pinta com `GjaInteractionStateTokens.overlayColor`,
  porque a cor de conteúdo depende de cada widget.

## Decisions

### D1. `GjaInteractable`

```dart
class GjaInteractable extends StatefulWidget {
  const GjaInteractable({
    required this.builder,                 // (context, Set<GjaInteractionState> states) => Widget
    this.onPressed,                        // null = desabilitado
    this.selected = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.minTargetSize = GjaAccessibility.defaultMinTargetSize, // 48, densidade confortável de referência
    this.interactionTokens = const GjaInteractionStateTokens.fallback(),
    this.focusColor,                       // null → GjaColorTokens.light().focus
  });
}
```

A estrutura, de fora para dentro, é:

1. `Semantics(button, label, enabled, selected, onTap)`;
2. `FocusableActionDetector(enabled, actions: {ActivateIntent, ButtonActivateIntent → onPressed}, mouseCursor, onShowFocusHighlight, onShowHoverHighlight, onFocusChange)`;
3. `GestureDetector(onTapDown/Up/Cancel, onTap)` com `HitTestBehavior.opaque`;
4. `ConstrainedBox(minWidth/minHeight: minTargetSize)` + `Center`;
5. `GjaFocusRing(visible, ...)` em volta do `builder`.

O estado `pressed` liga em `onTapDown` e desliga em `onTapUp`/`onTapCancel`. O `GestureDetector` cancela o toque
quando o ponteiro sai da área, o que cobre "Toque cancelado". `hovered` vem de um `MouseRegion` próprio (`onEnter`/`onExit`). O
`onShowHoverHighlight` do `FocusableActionDetector` não serve, porque só reporta hover no modo de destaque
tradicional, que só é ativado depois de um clique. `focused` vem de `onFocusChange`. A visibilidade do anel é `interactionTokens.showsFocusRing(states)`
combinada com `onShowFocusHighlight`, que só é verdadeiro no modo tradicional, de teclado.

- **Alternativa:** `Focus` + `MouseRegion` + `Shortcuts` montados à mão. Foi rejeitada porque
  `FocusableActionDetector` já faz isso, incluindo o modo de destaque.
- **Alternativa:** ampliar a área de toque sem mudar o layout, com um `RenderObject` próprio, como o
  `_InputPadding` do Material. Foi rejeitada por enquanto. O layout ocupa o alvo mínimo, o que é mais simples e
  verificável. Se um widget precisar do tamanho visual menor no layout, uma change futura justifica o `RenderObject` no design dela.

### D2. Alvo mínimo padrão

`GjaAccessibility` ganha a constante `defaultMinTargetSize`, igual ao `minTargetSize` da densidade confortável de
referência (48). É necessária porque um parâmetro padrão precisa ser constante, e
`GjaDensityTokens.comfortable().minTargetSize` não é expressão constante em todo contexto. É uma adição pequena
ao fundamento de acessibilidade, sem mudar requisitos. Um teste garante a igualdade com a densidade.

### D3. `GjaFocusRing`

`GjaFocusRing({visible, width, offset, color, borderRadius, child})`. Quando visível, ele usa
`CustomPaint(foregroundPainter: …)` para desenhar um `RRect` em volta do filho, expandido por `offset + width / 2` e
com traço `width`. O pintor desenha fora dos limites do filho, então o anel não muda o layout nem desloca o conteúdo
quando aparece.

- **Alternativa (versão inicial deste design):** `DecoratedBox` com `Padding`. Foi rejeitada na implementação porque
  o `Padding` aumenta o tamanho do conteúdo quando o anel aparece.

### D4. Testes

- Para os estados, um `builder` grava cada conjunto recebido.
- O hover é simulado com `TestGesture(kind: mouse)` e `moveTo`.
- O teclado usa `sendKeyEvent` (Enter, `numpadEnter`, Espaço) com o elemento focado, e o modo de destaque é
  forçado por `FocusManager.instance.highlightStrategy`.
- A ordem de foco usa três elementos em `Column` dentro de um `WidgetsApp` de teste.
- Os testes ficam em `packages/gja_core/test/interaction/`. O pacote precisa de `flutter_test`, que já está em `dev_dependencies`.

### D5. Galeria

A página "Interação" (`pages/interaction_page.dart`) tem um `GjaInteractable` cujo `builder` pinta a superfície
com `overlayColor`, mostra os estados ativos como texto ("estados: hovered, pressed") e um contador de ativações.
Um segundo elemento, desabilitado, aparece ao lado para comparação.

## Risks / Trade-offs

- [Mudar para o tema exigirá trocar padrões de parâmetro] → Esperado. `add-gja-theme` muda a resolução padrão
  (parâmetro ou tema ou referência) numa change `update-` desta spec.
- [Layout ampliado pelo alvo mínimo pode surpreender em listas densas] → A densidade compacta reduz o alvo para 24.
  Cada widget declara na spec como lida com isso.

## Migration Plan

Não há consumidores. O rollback é reverter a change.
