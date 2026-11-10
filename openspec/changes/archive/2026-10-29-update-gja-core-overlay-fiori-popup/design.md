# Design: Sobreposições no modelo do Popup do SAPUI5

## Context

`GjaModal.show` (em `gja_core/lib/src/overlay/modal.dart`) empurra uma `RawDialogRoute` com:
- `barrierDismissible: dismissible`;
- `barrierColor`, recebida ou o `blockLayer` do tema;
- `barrierLabel: close`.

O `ModalRoute` do Flutter trata Esc (`DismissIntent`) e o toque na barreira só quando `barrierDismissible` é
verdadeiro.

`GjaAnchoredOverlay` (em `anchored_overlay.dart`) usa um `OverlayPortal`. O conteúdo é posicionado por um
`SingleChildLayoutDelegate` com o retângulo da âncora lido no build do conteúdo. O retângulo só é relido quando o
conteúdo é reconstruído: em mudanças do controlador e, pelos ouvintes de `ScrollPosition`, depois de cada rolagem. A
inversão é decidida dentro do delegate (`getPositionForChild`), e o lado efetivo não sai de lá.

Usam `GjaOverlaySide`:
- `GjaPopover`, `GjaMenu`, `GjaDropdown`, `GjaTooltip` e a lista interna `GjaOptionList`;
- a página "Sobreposições" e os testes.

## Goals / Non-Goals

**Goals:**
- Modal com o comportamento de dispensa do `sap.m.Dialog`.
- Nomes de posição do Popover do SAPUI5.
- Sobreposição presa à âncora em qualquer mudança de layout.
- Posição efetiva disponível ao conteúdo.

**Non-Goals:**
- A seta do popover e os padrões de posição de cada widget (ver proposal.md).
- As posições compostas do `sap.m.PlacementType` (`Vertical`, `Auto`, `PreferredTopOrFlip` etc.). As quatro posições
  com inversão já correspondem às `Preferred…OrFlip`.

## Decisions

### D1. Dispensa do modal

A rota passa a ter `barrierDismissible: false` e `barrierLabel: null`, sempre. Com isso, o toque e a semântica da
camada somem. Esc passa a ser tratado pelo próprio conteúdo:
- com `dismissible`, o conteúdo é envolvido em `Actions` com `DismissIntent → Navigator.pop()`;
- sem `dismissible`, ele recebe uma ação que consome o Esc sem fechar.

O empilhamento continua igual: o `DismissIntent` vai ao foco mais interno, então uma sobreposição ancorada aberta
dentro do modal fecha primeiro.

Alternativa considerada: manter `barrierDismissible` e interceptar só o toque. Rejeitada porque a semântica da
barreira continuaria exposta.

### D2. `GjaPlacement`

```dart
enum GjaPlacement { bottom, top, start, end }
```

O enum substitui `GjaOverlaySide`, com os mesmos significados (`start`/`end` seguem a direção do texto) e o dartdoc
citando o `placement` do Popover. A propriedade `side` passa a `placement` em `GjaAnchoredOverlay` e nos widgets.
Não há alias: a API é 0.x.

### D3. Acompanhar a âncora

Enquanto a sobreposição está aberta, um callback pós-quadro relê o retângulo da âncora e chama `setState` quando ele
mudou. O callback se registra de novo para o quadro seguinte. Ele não agenda quadros sozinho: só roda depois de
quadros que já iam acontecer. Ao fechar, o registro para. Os ouvintes de rolagem continuam, porque a rolagem pode não
mudar o layout da âncora antes do pós-quadro.

Alternativa considerada: `CompositedTransformFollower` (`LayerLink`). Rejeitada porque ele segue só a posição, e a
inversão e o limite de tela dependem do tamanho e do retângulo da âncora a cada mudança.

### D4. Posição efetiva

O cálculo da inversão sai do delegate para uma função pura, `_resolvePlacement(anchor, childSize, area, …)`. Ela é
usada:
- pelo delegate, para posicionar;
- por um `_PlacementScope` (`InheritedWidget`) em volta do conteúdo, que expõe a posição efetiva por
  `GjaAnchoredOverlay.placementOf(context)`.

Como a posição depende do tamanho do conteúdo, o conteúdo é medido no primeiro layout. Um pós-quadro atualiza o
escopo quando a posição efetiva difere da preferida. O escopo começa com a posição preferida, e no quadro seguinte
passa à efetiva. O teste confere o valor depois de um `pump`.

### D5. Galeria e testes

- "Sobreposições": a escolha de "lado" passa a "posição" com `GjaPlacement.values`. O modal dispensável é fechado
  com Esc no teste.
- Testes do núcleo:
  - renomeação;
  - cenários novos: camada sem semântica, âncora que muda de tamanho e posição efetiva;
  - o cenário "Dispensa por Esc e pela camada" passa a esperar que o toque na camada mantenha o modal aberto.

## Risks / Trade-offs

- **[Um quadro de atraso]** A sobreposição acompanha a âncora no quadro seguinte à mudança, como já acontece na
  rolagem. → É imperceptível, e os testes conferem depois de um `pump`.
- **[Mudança de comportamento do modal]** Quem fechava modais tocando fora perde esse gesto. → É o comportamento do
  `sap.m.Dialog`. O CHANGELOG registra.
- **[Quebra de API 0.x]** `GjaOverlaySide`, `side` e `barrierColor` mudam. → O CHANGELOG traz o de/para.
