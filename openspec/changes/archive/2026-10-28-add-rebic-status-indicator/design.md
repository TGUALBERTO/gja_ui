# Design: RebicStatusIndicator

## Context

- **Tons existentes:** `RebicIcon` e `RebicText` têm os tons `success`, `warning`, `error`, `information`, `standard`
  e `muted`. Eles mapeiam para `stateColors(state).foreground`, `colors.text` e `colors.label`. O ícone pode usar
  `RebicIcon` com o tom do estado e o tamanho `inline`, que já acompanha a escala de texto.
- **Sublinhado:** o texto do status ativo precisa de sublinhado no hover, que `RebicText` não oferece. Como no
  `RebicLink`, o texto do valor é desenhado com `Text` e `typography.body`, na cor do estado. O título usa
  `RebicText` (`body`, tom `muted`).
- **Etiqueta:** `colors.stateColors(state)` dá fundo, borda e frente com contraste ≥ 4,5:1, o que basta para a
  etiqueta invertida.
- **Interação:** `RebicInteractable` dá estados, ativação, alvo e anel. O `MergeSemantics` junta o nó interno de foco
  e toque ao rotulado.

## Goals / Non-Goals

**Goals:**
- título, ícone e texto por estado;
- forma invertida;
- status ativo;
- quebra de texto;
- semântica num só nó;
- RTL;
- escala.

**Non-Goals:**
- cores de indicação;
- anúncio do texto de estado;
- indicador de vazio.

## Decisions

### D1. API

```dart
class RebicStatusIndicator extends StatelessWidget {
  const RebicStatusIndicator({this.text, this.icon, this.title, this.state = RebicValueState.none,
      this.inverted = false, this.onPressed, super.key})
    : assert((text != null && text != '') || icon != null, 'informe text ou icon');
}
```

O nome `onPressed` substitui o `active` + `press` do UI5: um callback não nulo torna o status ativo, como nos botões
do Rebic.

### D2. Conteúdo

```
Row(min, crossAxisAlignment: start, spacing: spacing.xs)
├─ [title] RebicText('$title:', tom muted)
├─ [icon]  Padding(top: (alturaDaLinha - icons.inline) / 2) → RebicIcon(icon, size: inline, tone: tom do estado,
│                                                                 semanticLabel: text == null ? title : null)
└─ [text]  Flexible(Text(text, style: body.copyWith(color: frente, decoration: sublinhado?), softWrap: true))
```

- O alinhamento ao topo, com o recuo do ícone pela diferença entre a altura da linha e o ícone, mantém o ícone e o
  título na primeira linha quando o texto quebra. A altura da linha é `typography.body`: tamanho × altura, na escala
  atual.
- Com `inverted`, o `Row` fica dentro de
  `DecoratedBox(st.background, Border.all(st.border, hairline), radius.s)` com
  `Padding(horizontal: spacing.xs)`.

### D3. Semântica e interação

- **Rótulo:** "`title`: `text`", só `text` ou, sem texto, `title`. Ele vai num
  `Semantics(container: true, label: …)`, e o conteúdo visual fica em `ExcludeSemantics`.
- **Ativo:** `MergeSemantics → RebicInteractable(semanticLabel: rótulo, onPressed,
  focusRingBorderRadius: radius.s)`. O sublinhado aparece com `hovered` ou `pressed`.
- **Inativo:** sem `RebicInteractable`, e por isso sem foco, cursor ou estados.

### D4. Testes, galeria e catálogo

- **Cores:** pelo `Text.style.color` e pelo tom do `RebicIcon`.
- **Invertido:** pela `BoxDecoration`.
- **Quebra:** pelo `RenderParagraph` (altura maior que uma linha) e pela posição vertical do ícone em relação à
  primeira linha.
- **Acessibilidade:** um arquivo sem a Inter, com:
  - contraste dos estados, normais e invertidos, sobre `background`;
  - alvo mínimo e alvo rotulado do ativo, nos temas claro e escuro e nas duas densidades.
- **Goldens:** 480 × 320, com uma linha por estado (normal e invertido, com ícone), um com título e um ativo. São
  gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "RebicStatusIndicator" (`rebic_status_indicator_page.dart`), com `RebicPage`:
  - status por estado;
  - invertidos;
  - um com título;
  - "3 pendências", ativo, que mostra "Abrindo pendências".

  O cenário se chama "Página RebicStatusIndicator na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [Status ativo inline aumenta a altura pelo alvo mínimo] → Isso é aceito pela acessibilidade, como no `RebicLink`.
- [Sem cores de indicação] → Situações sem estado de valor usam `none`. As cores de indicação entram com um
  fundamento próprio.

## Migration Plan

Widget novo; nada a migrar.
