# Design: RebicCard

## Context

- **`RebicContainer`** já dá a superfície (`surface`), a borda `separator` (`border: true`), o raio (`RebicRadius`) e a
  sombra (`RebicElevation.card`), com `clip` dos cantos.
- **`RebicText`** tem as variantes `title`, `body` e `label`, o tom `muted` e `maxLines` com reticências. A variante
  `title` já é anunciada como cabeçalho.
- **`RebicDivider`** sutil faz a separação entre cabeçalho e conteúdo.
- **`RebicInteractable`** dá os estados, a ativação, o alvo, o anel de foco e a semântica de botão. O `MergeSemantics`
  junta o nó interno de foco e toque ao rotulado, como nos botões.
- Os cartões costumam ficar em `RebicGrid`, que dá a largura de cada célula.

## Goals / Non-Goals

**Goals:**
- superfície do cartão;
- cabeçalho com `leading`, título, subtítulo e status;
- conteúdo com ou sem margem;
- cabeçalho acionável;
- RTL e escala.

**Non-Goals:**
- cabeçalho numérico;
- manifesto;
- rodapé ou menu de ações;
- cartão inteiro acionável.

## Decisions

### D1. API

```dart
class RebicCard extends StatelessWidget {
  const RebicCard({required this.child, this.title, this.subtitle, this.status, this.leading, this.padded = true,
      this.onHeaderPressed, super.key})
    : assert(title != null || (subtitle == null && status == null && leading == null && onHeaderPressed == null),
             'subtitle, status, leading e onHeaderPressed exigem title');
}
```

O cabeçalho é configurado por propriedades, e não por um widget `RebicCardHeader`. Assim, uma spec cobre um widget
público, e o cabeçalho segue o modelo único do `sap.f.cards.Header`.

### D2. Estrutura

```
RebicContainer(surface: base, border: true, radius: container, elevation: card)
└─ Column(stretch, min)
   ├─ [title] cabeçalho
   ├─ [title] RebicDivider()
   └─ padded ? Padding(all: spacing.l, child) : child
```

O cabeçalho é:

```
Padding(all: spacing.l) → Row(start, spacing: spacing.m)
├─ leading?
├─ Expanded(Column(min, start, spacing: xxs,
│     [RebicText(title, variant: title, maxLines: 2), RebicText(subtitle, tone: muted, maxLines: 2)]))
└─ status? → RebicText(status, variant: label, tone: muted, maxLines: 1)
```

- **Cabeçalho acionável:** com `onHeaderPressed`, ele fica dentro de
  `MergeSemantics → RebicInteractable(semanticLabel: '$title, $subtitle' ou título, onPressed,
  focusRingBorderRadius: radius.container)`. O `builder` pinta `ColoredBox(hoverBackground)` no hover e transparente
  nos demais estados. O conteúdo do cabeçalho fica em `ExcludeSemantics`, porque o rótulo já vem do botão.
- **Cabeçalho não acionável:** os `RebicText` mantêm a semântica, e o título é o cabeçalho.

### D3. Testes, galeria e catálogo

- **Ordem e posições:** por `getRect` do `leading`, do título, do status e do divisor.
- **Superfície:** pelo `RebicContainer` (surface, border, radius, elevation) e pela `BoxDecoration` resolvida.
- **Hover:** pelo `ColoredBox` do cabeçalho.
- **Acessibilidade:** um arquivo sem a Inter, com contraste, alvo rotulado e alvo mínimo nos temas claro e escuro e
  nas duas densidades, sobre `background`.
- **Goldens:** 640 × 420, com três cartões numa linha:
  - cabeçalho completo (avatar "MB", título, subtítulo, status, texto);
  - sem cabeçalho;
  - sem margem, com uma coluna de linhas separadas por divisores.

  São gerados nos temas claro e escuro × confortável e compacto.
- **Galeria:** página "RebicCard" (`rebic_card_page.dart`), com `RebicPage` e uma `RebicGrid` de cartões:
  - "Pedidos pendentes", com cabeçalho acionável que mostra "Abrindo pedidos pendentes";
  - "Fornecedor", com um avatar;
  - um cartão sem margem com uma lista simples.

  O cenário se chama "Página RebicCard na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [O cabeçalho acionável esconde a semântica individual dos textos do cabeçalho] → O rótulo do botão reúne título e
  subtítulo. O status, quando houver, fica fora do rótulo, como no UI5, que o anuncia à parte. Ele continua visível.
- [Sem rodapé de ações] → Ações ficam no conteúdo até existir `RebicToolbar`.

## Migration Plan

Widget novo; nada a migrar.
