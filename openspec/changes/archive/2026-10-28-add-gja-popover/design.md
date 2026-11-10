# Design: GjaPopover

## Context

- **`GjaAnchoredOverlay`** (`gja/core/overlay`) já faz:
  - a posição por lado e alinhamento, a inversão, o afastamento `spacing.xs`, a margem `spacing.s` e o limite de tela;
  - o acompanhamento da rolagem;
  - o fechamento por toque fora e por Esc, com `onDismiss`, sem tratar o toque na âncora como toque fora;
  - o foco: `FocusScope` e `GjaInitialFocus` levam o foco ao primeiro elemento focável, o Tab circula dentro do
    escopo, e o foco volta a quem o tinha ao fechar.

  O delegate entrega ao conteúdo restrições frouxas, do tamanho da área menos as margens.
- **`GjaAnchoredOverlayController`** é um `OverlayPortalController` que avisa os ouvintes em `show`/`hide`.
- **`GjaTooltip`** já usa a sobreposição ancorada com `GjaContainer(base, radius, elevation: popover)` e limita a
  largura por `spacing.xxxl × 6`. O popover segue o mesmo padrão.
- **`GjaContainer`**, **`GjaText`** (variante `subtitle` com `heading`, como no `GjaCard`) e **`GjaDivider`**
  dão a superfície, o título e os separadores.
- No tema Horizon, o `sap.m.Popover`:
  - não tem borda, só a sombra;
  - alinha o título ao início (`titleAlignment` Auto → Start);
  - tem conteúdo sem margem por padrão, e os apps usam `sapUiContentPadding`. No GJA, `padded` vale `true` por
    padrão, como no `GjaCard`.

## Goals / Non-Goals

**Goals:**
- popover ancorado com superfície, cabeçalho, conteúdo rolável e rodapé de ações;
- controlador com `open`, `close`, `toggle` e `isOpen`;
- fechamento automático, foco preso e semântica de diálogo;
- largura entre um mínimo e um máximo por tokens;
- RTL e escala.

**Non-Goals:**
- seta (precisa do lado resolvido pelo núcleo; ver Risks);
- modal, versão responsiva em tela cheia e animação;
- cabeçalho personalizado e botões no cabeçalho.

## Decisions

### D1. API

```dart
class GjaPopoverController extends GjaAnchoredOverlayController {
  GjaPopoverController({super.debugLabel});
  bool get isOpen => isShowing;
  void open() => show();
  void close() => hide();
  void toggle() => isOpen ? close() : open();
}

class GjaPopover extends StatelessWidget {
  const GjaPopover({required this.controller, required this.content, required this.child, this.title,
      this.actions = const [], this.side = GjaOverlaySide.below, this.alignment = GjaOverlayAlignment.start,
      this.padded = true, this.semanticLabel, this.onDismiss, super.key})
    : assert((title ?? semanticLabel ?? '') != '', 'informe title ou semanticLabel');
}
```

- **Controlador próprio:** herdar de `GjaAnchoredOverlayController` permite passá-lo direto ao núcleo, sem cópia de
  estado. Os nomes `open`/`close` seguem o `openBy`/`close` do UI5. `show`/`hide` continuam disponíveis por herança.
- **`onDismiss`:** é o `onDismiss` do núcleo, que só é chamado na dispensa por toque fora ou Esc. Quem chama `close()`
  já sabe que fechou.
- **Sem `StatefulWidget`:** o estado de aberto fica no controlador. Quem cria o controlador o descarta.

### D2. Estrutura

```
GjaAnchoredOverlay(controller, side, alignment, onDismiss, focusOnShow: true, child: âncora)
└─ overlayBuilder:
   Semantics(scopesRoute, namesRoute, explicitChildNodes, label: title ?? semanticLabel)
   └─ ConstrainedBox(minWidth: xxxl × 4, maxWidth: xxxl × 8)
      └─ IntrinsicWidth
         └─ GjaContainer(surface: base, border: false, radius: container, elevation: popover)
            └─ Column(min, stretch)
               ├─ [title] Padding(all: l) → GjaText(title, variant: subtitle, heading: true, maxLines: 1)
               ├─ [title] GjaDivider()
               ├─ Flexible → SingleChildScrollView → padded ? Padding(all: l, content) : content
               ├─ [actions] GjaDivider()
               └─ [actions] Padding(all: s) → OverflowBar(alignment: end, overflowAlignment: end, spacing: xs, overflowSpacing: xs, actions)
```

- **Largura:** `IntrinsicWidth` faz o popover seguir o conteúdo. O `ConstrainedBox` dá o mínimo (192 nos tokens de
  referência) e o máximo (384), em passos de `spacing.xxxl`, como o `GjaTooltip`. O máximo continua sujeito ao
  limite de tela do núcleo, que é menor em telas estreitas. Os fatores 4 e 8 são constantes privadas documentadas.
- **Altura:** o `Column(min)` com o conteúdo em `Flexible` + `SingleChildScrollView` cabe na altura máxima dada pelo
  núcleo. Só o conteúdo rola.
- **Rodapé:** `OverflowBar` em vez de `Row`, para que as ações fiquem uma sobre a outra, alinhadas ao fim, quando não
  cabem lado a lado (escala 2,0), sem estouro. O `Wrap` foi descartado porque a largura intrínseca dele não conta o
  `spacing`, e o `IntrinsicWidth` do popover quebrava as ações mesmo com espaço. O alinhamento segue a direção do
  texto.
- **Semântica:** `scopesRoute` + `namesRoute` é o equivalente Flutter do `role="dialog"` com `aria-labelledby`. O
  título continua também como cabeçalho, porque o leitor de tela anuncia a rota e permite navegar por cabeçalhos.

### D3. Testes, galeria e catálogo

- **Posição e tamanho:** por `getRect` da âncora e do `GjaContainer` do popover.
- **Rolagem:** por `tester.drag` no conteúdo e `getRect` do título, da última linha e das ações.
- **Teclado:** pelo `primaryFocus` após Tab e Esc.
- **Semântica:** por `matchesSemantics(scopesRoute, namesRoute, label)` e `find.bySemanticsLabel`.
- **Acessibilidade:** um arquivo sem a Inter, com contraste, alvo rotulado e alvo mínimo nos temas claro e escuro e
  nas duas densidades, sobre `background`.
- **Goldens:** 720 × 400, com duas âncoras e dois popovers abertos:
  - "Filtros", com conteúdo e as ações "Aplicar" e "Cancelar";
  - só conteúdo, com `semanticLabel`.

  São gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "GjaPopover" (`gja_popover_page.dart`), com `GjaPage`:
  - um `GjaButton` "Filtrar" que alterna o popover "Filtros", com textos de filtro e as ações "Aplicar"
    (`emphasized`, fecha e mostra "Filtros aplicados") e "Cancelar" (`transparent`, só fecha);
  - um `GjaIconButton` de informação que abre um popover só com conteúdo ("Detalhes do pedido").

  O cenário se chama "Página GjaPopover na galeria". A página segue o tema escuro da galeria.
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [Sem seta] → O popover Horizon mostra uma seta para a âncora. Desenhá-la exige saber o lado depois da inversão, que
  o delegate do núcleo não expõe. Fica para `update-gja-core-overlay` (expor o lado resolvido) e
  `update-gja-popover-arrow`. Sem seta, o afastamento `spacing.xs` e a sombra ainda ligam o popover à âncora.
- [Sem borda no tema escuro] → A separação vem da sombra `popover` e do contraste entre `base` e `background`, como no
  Horizon escuro. O golden escuro confirma a leitura.
- [`IntrinsicWidth` custa uma passada extra de layout] → O popover tem poucos filhos e só existe aberto.
- [Rótulo duplicado: rota e cabeçalho] → É o mesmo que o UI5 faz com `aria-labelledby` apontando para o título.

## Migration Plan

Widget novo; nada a migrar.
