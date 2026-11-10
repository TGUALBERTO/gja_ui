# Design: largura padrão do GjaPopover

## Context

- Hoje o painel do `GjaPopover` é `ConstrainedBox(minWidth: xxxl × 4, maxWidth: xxxl × 8) → IntrinsicWidth →
  GjaContainer`. Por isso a largura acompanha o conteúdo.
- O delegate de `GjaAnchoredOverlay` entrega ao conteúdo restrições frouxas, do tamanho da área menos as margens.
  Uma largura fixa maior que a área é reduzida a ela.
- O núcleo lê o retângulo da âncora no `overlayBuilder` (`_anchorRect`), por um `GlobalKey` no filho. O
  `overlayBuilder` só recebe o `BuildContext`, sem o tamanho da âncora.
- O helper de rastreabilidade (`test/support/traceability.dart`) aplica os requisitos ADDED e MODIFIED das changes
  ativas por cima da spec principal, mas ignora os REMOVED. Sem ajuste, ele continuaria exigindo o teste do cenário
  removido "Largura entre o mínimo e o máximo".

## Goals / Non-Goals

**Goals:**
- largura padrão do tema, igual entre popovers;
- exceção `wide`;
- largura mínima igual à da âncora;
- rastreabilidade correta com requisitos removidos.

**Non-Goals:**
- largura livre (`double`) ou que siga o conteúdo;
- mudanças no núcleo de sobreposições;
- a largura da lista do `GjaDropdown`, que será definida na change dele, sobre este comportamento.

## Decisions

### D1. API

```dart
enum GjaPopoverWidth { standard, wide }

const GjaPopover({..., this.width = GjaPopoverWidth.standard, ...});
```

- **Passos de `spacing.xxxl`:** `standard` = 8 (384 na referência, perto dos 24rem comuns no `contentWidth` do
  Fiori) e `wide` = 12 (576). São constantes privadas documentadas, no padrão do `GjaTooltip`.
- **Enum em vez de `double`:** mantém a restrição de não aceitar tamanhos literais. A largura acompanha a densidade e
  os tokens do tema.

### D2. Largura pela âncora

- O `GjaPopover` passa a ser `StatefulWidget` e envolve `child` em `KeyedSubtree(key: _anchorKey)`.
- No construtor do painel, a largura é `max(passos × xxxl, largura da âncora)`. A largura da âncora vem do
  `RenderBox` do `_anchorKey`, ou zero antes do primeiro layout.
- É o mesmo padrão que o núcleo usa para ler o retângulo da âncora. Evita mudar a assinatura de `overlayBuilder`, que
  o `GjaTooltip` também usa.

### D3. Estrutura

```
Semantics(...)
└─ SizedBox(width: max(passos × xxxl, âncora))   // reduzida pela área do núcleo
   └─ GjaContainer(...)
      └─ Column(min, stretch) ... (sem mudança)
```

- O `IntrinsicWidth` sai, o que também remove a passada extra de layout.
- O `OverflowBar` do rodapé continua: ele empilha as ações quando elas não cabem na largura.

### D4. Rastreabilidade com REMOVED

- `_requirements` passa a devolver também os nomes dos requisitos em `## REMOVED Requirements`.
- `scenarioNames` remove esses requisitos depois de aplicar cada delta. Assim, os nomes refletem a spec como ficará
  após o arquivamento, como já acontece com ADDED e MODIFIED.

### D5. Testes, goldens e galeria

- O teste "Largura entre o mínimo e o máximo" sai e entram:
  - "Largura padrão": "Ok" e o parágrafo têm 8 × xxxl, e o parágrafo quebra;
  - "Âncora mais larga que o popover": âncora de 10 × xxxl, popover da mesma largura;
  - "Popover largo": `wide`, com 12 × xxxl.
- Os testes do `[Comportamento]` passam a usar o nome do novo requisito, `[Comportamento] Posição, largura e
  rolagem`.
- O teste de rastreabilidade espera 22 cenários.
- Os goldens são regenerados. Os dois popovers ficam com 384 de largura, então a amostra passa a 960 × 400.
- Na galeria, os dois popovers ficam na largura padrão, sem mudança de código.

## Risks / Trade-offs

- [Popovers curtos ficam mais largos que o conteúdo] → É a consistência pedida. Conteúdos que precisam de mais espaço
  usam `wide`.
- [Âncora muito larga, como um campo de largura total, deixa o popover largo] → É o comportamento do `sap.m.Select` e
  do `ComboBox`, em que a lista acompanha o campo. Fica limitado pela área da sobreposição.
- [Telas estreitas] → O limite do núcleo reduz a largura à área menos as margens. A altura e a rolagem continuam
  valendo.

## Migration Plan

Usos existentes ficam com `standard`. Só a galeria usa o `GjaPopover`, e nada muda no código dela.
