# Design: GjaLink

## Context

- **`GjaInteractable`** (núcleo) cuida de:
  - estados, ativação por toque, Enter e Espaço;
  - alvo mínimo, anel de foco pelo teclado e cursor de clique.

  A semântica dele é sempre de botão: `Semantics(container: true, button: true, …)`. O `GjaButton` e o
  `GjaIconButton` o envolvem em `MergeSemantics`, para juntar o nó interno de foco e toque ao rotulado.
- **Cores e estilo:** `colors.link`, `colors.text`, `typography.body`, `typography.bodyStrong` e
  `interaction.opacity(states)`. O tema não tem cores próprias de link em hover ou ativo. No Fiori, o hover do link
  se distingue pelo sublinhado.
- **Rótulo:** o `GjaButton` desenha o rótulo com `Text` e os tokens de tipografia, na cor do estado, porque
  `GjaText` não aceita a cor de estados de interação. O link segue a mesma abordagem para poder sublinhar só em
  alguns estados.

## Goals / Non-Goals

**Goals:**
- link com texto, variantes `emphasized` e `subtle`, e quebra opcional;
- sublinhado no hover e no pressionado;
- semântica de link;
- acessibilidade completa.

**Non-Goals:**
- `href`/URL;
- texto rico;
- ícone;
- visitado.

## Decisions

### D1. Papel de link no núcleo

`GjaInteractable` ganha `final bool link` (padrão `false`). No `Semantics` interno:
- `button: !widget.link`;
- `link: widget.link`.

Com o padrão, a semântica é a mesma de hoje.

O teste "Semântica e cursor — Semântica de link" fica em `gja_core/test/interaction`.

**Alternativa:** um enum de papéis (`button`, `link`, `tab`…). Foi adiada até haver um terceiro papel. Um `bool` é
suficiente, e um enum pode substituí-lo de forma compatível depois.

### D2. API

```dart
class GjaLink extends StatelessWidget {
  const GjaLink({required this.text, required this.onPressed, this.emphasized = false, this.subtle = false,
      this.wrapping = false, super.key}) : assert(text != '', 'text não pode ser vazio');
}
```

Os nomes `emphasized`, `subtle` e `wrapping` seguem as propriedades do `sap.m.Link`.

### D3. Estrutura

```
MergeSemantics
└─ GjaInteractable(link: true, semanticLabel: text, onPressed, focusRingBorderRadius: radius.control)
   └─ builder → ExcludeSemantics → Opacity(interaction.opacity(states))
      └─ Text(text, style: (emphasized ? bodyStrong : body).copyWith(
             color: subtle ? colors.text : colors.link,
             decoration: hovered || pressed ? underline : none),
           maxLines: wrapping ? null : 1, overflow: wrapping ? null : ellipsis, softWrap: wrapping)
```

- **Cor e estado:** a cor não muda com o estado; o sublinhado indica o hover e o pressionado, como no Fiori.
  Desabilitado, o `GjaInteractable` não registra hover nem pressionado, e por isso não há sublinhado.
- **Alvo:** o alvo mínimo do `GjaInteractable` aumenta a área de toque sem mudar o tamanho do texto, que fica
  centralizado na altura do alvo.
- **Direção:** o `Text` segue a `Directionality`, e as reticências ficam no fim lógico.

### D4. Testes, galeria e catálogo

- **Estilo:** pelo `Text.style` (cor, peso pelo `TextStyle` dos tokens, `decoration`).
- **Quebra:** pelo `RenderParagraph`: `didExceedMaxLines` sem `wrapping`, e altura maior que uma linha com
  `wrapping`.
- **Acessibilidade:** um arquivo sem a Inter, com:
  - contraste, alvo rotulado e alvo mínimo, para links normal, sutil e enfatizado, nos temas claro e escuro e nas
    duas densidades, sobre `background`;
  - escala 2,0, comparando a altura do texto.
- **Goldens:** 480 × 240, com os links normal, sutil, enfatizado, desabilitado e um com quebra num espaço de 200. São
  gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "GjaLink" (`gja_link_page.dart`), com `GjaPage`:
  - as variantes;
  - um link com quebra;
  - "Ver pedido 4711", que mostra "Pedido 4711 aberto" num `GjaText` abaixo, por estado da página.

  O cenário se chama "Página GjaLink na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`, mantendo P1/Fase 2.

## Risks / Trade-offs

- [Alvo mínimo aumenta a altura do link] → Isso é intencional para a acessibilidade. Links dentro de parágrafos, se
  surgirem, entram numa change própria de texto rico.
- [Sem cor própria de hover] → O sublinhado é o indicador no modelo Fiori. Se um tema precisar de cor de hover,
  entram tokens de link numa change do fundamento de cor.

## Migration Plan

O widget é novo, e o parâmetro do núcleo é aditivo, com o padrão inalterado.
