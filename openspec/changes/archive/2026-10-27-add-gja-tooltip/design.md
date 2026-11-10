# Design: GjaTooltip

## Context

`gja/core/overlay` oferece `GjaAnchoredOverlay` e `GjaAnchoredOverlayController`, com:
- `side`, `alignment`, `gap`, `margin` (padrão do tema);
- inversão de lado e limite de bordas;
- acompanhamento da rolagem;
- `autoClose`, para toque fora e Esc;
- `focusOnShow`;
- `onDismiss`.

O Esc do `autoClose` é tratado por `Actions` dentro do conteúdo da sobreposição, e por isso só funciona quando o
foco está nela. Uma dica não recebe foco, então o Esc precisa de tratamento próprio.

Outras peças disponíveis:
- `GjaContainer` (superfície, borda, raio e sombra) e `GjaText`, com a variante `label`;
- `motion.short` (100 ms) e `motion.long` (300 ms), zerados com movimento reduzido.

## Goals / Non-Goals

**Goals:**
- abertura por ponteiro (com atraso), foco e toque longo;
- fechamento por saída do ponteiro, perda de foco, Esc e toque fora;
- dica apontável;
- uma dica por vez;
- semântica no filho;
- movimento reduzido.

**Non-Goals:**
- conteúdo rico;
- seta;
- atrasos configuráveis.

## Decisions

### D1. API

```dart
class GjaTooltip extends StatefulWidget {
  const GjaTooltip({required this.message, required this.child, this.side = GjaOverlaySide.below, super.key})
    : assert(message != '', 'message não pode ser vazia');
}
```

O padrão `below` segue a posição usual das dicas nos navegadores e no UI5. `alignment` é sempre `center`, e `gap`
é `spacing.xs`.

### D2. Estrutura

```
Semantics(tooltip: message)
└─ GjaAnchoredOverlay(controller, autoClose: true, focusOnShow: false, onDismiss: _hide,
   │                    overlayBuilder: _bubble)
   └─ Focus(canRequestFocus: false, skipTraversal: true, onFocusChange: _focusChanged, onKeyEvent: _escape)
      └─ MouseRegion(onEnter: _scheduleShow, onExit: _scheduleHide)
         └─ GestureDetector(onLongPress: _showNow, behavior: translucent)
            └─ child
```

- **`Focus` externo:** não é focável. Ele só observa o foco dos descendentes (`onFocusChange` é chamado quando o
  foco entra ou sai da subárvore). A dica abre com foco só se `FocusManager.instance.highlightMode` é
  `traditional`, ou seja, foco vindo do teclado.
- **Esc:** com a dica aberta, o `onKeyEvent` do `Focus` externo trata Esc quando o foco está no filho. Para a dica
  aberta só pelo ponteiro (sem foco), um `HardwareKeyboard.instance.addHandler` fica ativo enquanto ela está
  aberta. O handler é removido ao fechar. Em nenhum caso o foco muda.
- **Toque longo:** o `GestureDetector` translúcido não consome o toque simples, e por isso o `onTap` do filho
  continua a funcionar. O toque longo compete na arena com o do filho; filhos com toque longo próprio são raros e
  ficam fora do escopo.
- **Toque fora:** é o `autoClose` do núcleo, que chama `onDismiss`.

### D3. Temporização

Há dois `Timer` no `State`:
- `_showTimer`: `motion.long`;
- `_hideTimer`: `motion.short`.

Quando a duração é zero (movimento reduzido), a ação é imediata, sem `Timer`. A bolha da dica fica num
`MouseRegion` próprio: `onEnter` cancela `_hideTimer`, e `onExit` agenda o fechamento. Isso torna a dica apontável.
Os timers são cancelados em `dispose`.

### D4. Uma dica por vez

`static _GjaTooltipState? _open` no arquivo. Ao abrir, a dica anterior, se houver e for outra, é fechada. Ao
fechar ou no `dispose`, o campo é limpo se aponta para a própria dica.

### D5. Bolha

`MouseRegion` com `ExcludeSemantics`, porque a mensagem já está no filho. Dentro dele:
- `ConstrainedBox(maxWidth: spacing.xxxl * _maxWidthSteps)`, em que `_maxWidthSteps` é 6: 288 nos tokens de
  referência, perto dos 18rem usuais de uma dica. É uma constante nomeada, não uma dimensão literal;
- `GjaContainer(surface: base, border: true, radius: s, elevation: popover)`;
- `GjaSpacing.padding(horizontal: s, vertical: xs)`;
- `GjaText(message, variant: label)`.

`IgnorePointer` não é usado, porque a bolha precisa de hover para ser apontável.

### D6. Testes, galeria e catálogo

- **Ponteiro:** com `tester.createGesture(kind: mouse)` e `pump` de durações parciais.
- **Foco:** com `GjaApp` e Tab. O `highlightMode` vira `traditional` com teclado.
- **Toque longo:** com `tester.longPress`.
- **Semântica:** `matchesSemantics`/`containsSemantics(tooltip: …)` no filho. `find.bySemanticsLabel` com a mensagem
  conta zero nós de rótulo.
- **Contraste:** num arquivo sem a fonte Inter, com a dica aberta pelo foco.
- **Goldens:** 480 × 240, com a dica curta aberta (abaixo de um ícone) e uma longa (quebrada), abertas por foco
  com movimento reduzido. São gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "GjaTooltip" (`gja_tooltip_page.dart`), com `GjaPage`, três `GjaIcon` com dicas
  (editar, excluir, baixar) e um texto com dica longa. O cenário se chama "Página GjaTooltip na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [Handler global de teclado enquanto a dica do ponteiro está aberta] → Ele só existe enquanto ela está aberta e só
  trata Esc, retornando `false` nas demais teclas.
- [Toque longo pode competir com o do filho] → Fica documentado no dartdoc. O caso comum, um botão com toque
  simples, não é afetado.
- [O fator 6 sobre `spacing.xxxl` não é um token] → Se o `GjaPopover` precisar de larguras, um token de largura
  de sobreposição entra nele.

## Migration Plan

Widget novo; nada a migrar.
