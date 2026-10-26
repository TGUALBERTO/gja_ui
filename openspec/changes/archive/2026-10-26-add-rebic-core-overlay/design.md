# Design: Sobreposições

## Context

O `rebic_core` já tem três peças:
- `RebicInteractable`: ativação por toque e teclado, anel de foco;
- `RebicLocalizations`: inclui o texto `close`;
- a responsividade.

A cor `blockLayer` existe em `RebicColorTokens`, e as sombras `popover`/`dialog` existem em `RebicElevationTokens`. A
galeria é um `WidgetsApp` com `Navigator`, `Overlay` e os atalhos padrão (Esc → `DismissIntent`, Tab →
`NextFocusIntent`).

O Flutter 3.32 oferece, no pacote `widgets`, sem Material:
- `RawDialogRoute`, um `PopupRoute` com camada, `barrierDismissible`, `barrierLabel`, foco preso no `FocusScope` da
  rota, restauração do foco ao fechar e semântica bloqueada abaixo. A ação de `DismissIntent` da `ModalRoute` só está
  habilitada quando `barrierDismissible` é verdadeiro;
- `OverlayPortal` com `OverlayPortalController`, que renderiza o conteúdo no `Overlay` mais próximo, acima da entrada
  dona e abaixo das entradas posteriores;
- `TapRegion` (`groupId`, `onTapOutside`), `FocusScope`, `Shortcuts`/`Actions` e `CustomSingleChildLayout`.

O modelo do SAPUI5 é o `sap.ui.core.Popup`:
- *BlockLayer* nos modais;
- `autoClose` para fechar ao clicar fora;
- `escapeHandler`;
- posicionamento `my`/`at`/`of` com `collision: flip`;
- foco inicial e restauração do foco.

## Goals / Non-Goals

**Goals:**
- modal e sobreposição ancorada com regras de foco, dispensa e empilhamento iguais para todos os widgets;
- uso dos mecanismos nativos.

**Non-Goals:**
- aparência dos widgets;
- animações;
- mensagens temporárias não ancoradas;
- arrastar ou redimensionar sobreposições.

## Decisions

### D1. Modal: `RebicModal.show` sobre `RawDialogRoute`

```dart
abstract final class RebicModal {
  static Future<T?> show<T>(BuildContext context, {
    required WidgetBuilder builder,
    bool dismissible = true,
    Color barrierColor = <blockLayer do mapeamento claro>,
    bool useRootNavigator = true,
  });
}
```

`show` empurra um `RawDialogRoute<T>` com:
- `barrierDismissible: dismissible`;
- `barrierColor`;
- `barrierLabel: RebicLocalizations.of(context).close`.

O `pageBuilder` envolve o conteúdo em `SafeArea` e `Center` e o entrega ao `builder`. O resultado vem de
`Navigator.pop(context, valor)`, e a dispensa devolve nulo. O foco inicial é o do primeiro elemento com `autofocus`.
Sem nenhum, o `FocusScope` da rota recebe o foco, e o primeiro Tab vai ao primeiro elemento do modal.

O teste "Tab preso no modal" confirma o percurso esperado. Se o comportamento nativo divergir da spec, o modal envolve
o conteúdo num `FocusTraversalGroup` e pede o foco do primeiro filho ao abrir. Esse é um ajuste interno, sem mudança
de API.

A transição tem duração zero, conforme os Non-Goals.

A `ModalBarrier` nativa só expõe a camada a leitores de tela em Android, iOS e macOS. Em Windows, Linux e Fuchsia, a
camada fica fora da semântica mesmo quando é dispensável, por convenção do Flutter. A spec segue esse comportamento:
o rótulo `close` é exigido só onde a camada é exposta.

**Alternativa:** um `OverlayEntry` próprio para o modal. Ela foi rejeitada porque reimplementaria a camada, a
semântica, o foco preso, a restauração do foco e a integração com o botão voltar, que a rota já faz.

### D2. Sobreposição ancorada: `RebicAnchoredOverlay`

```dart
enum RebicOverlaySide { below, above, start, end }
enum RebicOverlayAlignment { start, center, end }

class RebicAnchoredOverlay extends StatefulWidget {
  const RebicAnchoredOverlay({
    required OverlayPortalController controller,
    required Widget child,                  // a âncora
    required WidgetBuilder overlayBuilder,  // o conteúdo
    RebicOverlaySide side = RebicOverlaySide.below,
    RebicOverlayAlignment alignment = RebicOverlayAlignment.start,
    double gap = 4, double margin = 8,      // espaçamentos de referência
    bool autoClose = true,
    bool focusOnShow = true,
    VoidCallback? onDismiss,
  });
}
```

A âncora fica num `OverlayPortal`. O `overlayChildBuilder` calcula o retângulo da âncora nas coordenadas do `Overlay`
(`localToGlobal` com o `Overlay` como ancestral) e monta um `CustomSingleChildLayout` do tamanho do `Overlay`, com um
`_AnchoredLayoutDelegate` que:
1. posiciona no lado preferido, com `gap` e o alinhamento resolvido pela `Directionality` (`start`/`end`);
2. inverte para o lado oposto se o conteúdo não cabe no preferido e cabe no oposto;
3. limita a posição para que o conteúdo fique a pelo menos `margin` das bordas.

Para acompanhar a rolagem, o widget ouve as `ScrollPosition` dos `Scrollable` ancestrais da âncora. A posição da
âncora só é atualizada no layout que segue a rolagem, e por isso a reconstrução é agendada para logo depois dele
(*post-frame*). O conteúdo segue a âncora com um quadro de atraso, imperceptível na prática. Mudanças de tamanho da
janela reconstroem pela `MediaQuery`.

**Alternativa:** o `relayout` do delegate com a rolagem. Ela foi descartada porque, durante o layout, o deslocamento
do viewport ainda não está atualizado, e ler o tamanho de outro `RenderBox` nessa fase dispara asserções.

### D3. Fechamento automático, Esc e foco

- O conteúdo e a âncora ficam no mesmo grupo de `TapRegion`. O `onTapOutside` do conteúdo, com `autoClose`, chama
  `controller.hide()` e `onDismiss`. Assim, o toque na âncora não é "fora", e a âncora decide se alterna.
- O conteúdo é envolvido em `Shortcuts`/`Actions` com uma ação de `DismissIntent` que fecha a sobreposição. Ela fica
  abaixo do `FocusScope` do conteúdo e, por isso, recebe o Esc antes da rota (D4).
- Com `focusOnShow`:
  - o conteúdo fica num `FocusScope` com `autofocus`;
  - antes de abrir, o elemento com foco é guardado;
  - ao fechar, por qualquer caminho, o foco volta a ele, se ainda estiver montado.

  A detecção de "abriu" e "fechou" usa um `OverlayPortalController` observado pelo próprio widget, que compara
  `isShowing` a cada build. Para evitar observar um controlador externo sem aviso, o widget expõe `show`/`hide` por
  um `RebicAnchoredOverlayController`, que estende `OverlayPortalController` e notifica as mudanças.

**Ajuste de API decorrente:** o parâmetro `controller` é do tipo `RebicAnchoredOverlayController`.

### D4. Empilhamento

O empilhamento vem do Flutter:
- **Ordem visual:** o `OverlayPortal` de uma âncora dentro do modal renderiza acima da entrada da rota do modal.
- **Ordem do Esc:** o foco está no conteúdo ancorado, e a ação de `DismissIntent` mais próxima do foco vence. Ela
  fecha só a sobreposição ancorada. O próximo Esc, já com o foco no modal, chega à ação da rota.
- **Fechar o modal:** desmonta a âncora, e o `OverlayPortal` remove o conteúdo junto.

### D5. Valores padrão

- `barrierColor` padrão: `const RebicColorTokens.light().blockLayer`.
- `gap` e `margin` padrão: `RebicSpacingTokens.fallback().xs` e `.s` (4 e 8).

Esses valores entram por parâmetro até o tema existir, como em `RebicInteractable`. O código não usa literais
visuais, como pede a arquitetura. `rebic_checks tokens` só verifica `rebic_widgets`, então isso é garantido em revisão.

### D6. Galeria

A página "Sobreposições" tem:
- botão "Abrir modal": modal dispensável com dois botões ("Confirmar" fecha com resultado, "Cancelar" dispensa), e
  o último resultado exibido na página;
- botão "Abrir modal obrigatório": não dispensável, fecha só por "Concluir";
- âncora "Abrir popover", com escolha do lado (abaixo/acima/início/fim) e um conteúdo com dois itens focáveis.

Os botões usam `RebicInteractable`.

### D7. Catálogo

As dependências de `rebic/core/overlay` passam a ser `rebic/core/interaction`, `rebic/core/localization` e
`rebic/foundation/color`.

## Risks / Trade-offs

- [Percurso de foco nativo do modal pode exigir um Tab extra para entrar no primeiro elemento] → O teste do cenário
  detecta. O ajuste interno está descrito em D1.
- [`OverlayPortal` dentro de rotas não modais pode ficar abaixo de rotas posteriores] → É o comportamento correto: a
  sobreposição pertence à sua rota.
- [Reposicionar a cada rolagem custa um rebuild do conteúdo por quadro, com um quadro de atraso] → O conteúdo das
  sobreposições é pequeno, e o atraso é imperceptível.

## Migration Plan

Capacidade nova; nada a migrar.
