# Design: RebicDropdown

## Context

- **`RebicPopover`** já resolve várias partes do dropdown:
  - âncora, posição e inversão;
  - largura `max(passos × xxxl, âncora)`, com o limite de tela;
  - rolagem do conteúdo;
  - fechamento por toque fora e por Esc (`onDismiss`), com o foco devolvido à âncora;
  - rota nomeada para leitores de tela;
  - foco inicial pelo `RebicInitialFocus` do núcleo, que respeita um `autofocus` já presente no conteúdo.

  Os valores de `RebicPopoverWidth` são `standard` (8 passos) e `wide` (12).
- **`RebicInteractable`** (`rebic/core/interaction`) dá os estados, a ativação por toque, Enter e Espaço, o anel de
  foco, o alvo mínimo, `selected` e `autofocus`.
- **`RebicControlColors.of(RebicControlFamily.list, colors).resolve(states)`** dá o fundo, a borda e o texto da
  família `list` em cada estado: hover `hoverBackground`, ativo `highlight`, selecionado `selectionBackground` e
  selecionado com hover `selectionHoverBackground`. É o mesmo caminho do `RebicButton`.
- **`density.controlHeight`** é a altura de controle da densidade, que os botões usam como altura mínima.
- No `sap.m.Select` Horizon, a lista:
  - fica num popover sem seta na largura do campo;
  - tem itens na altura de controle, com ícone, texto e `additionalText` no fim;
  - mostra o item atual com o fundo de seleção;
  - aceita navegação por setas, Home, End e digitação.

## Goals / Non-Goals

**Goals:**
- lista de itens com ícone, rótulo e texto adicional;
- item selecionado e itens desabilitados;
- escolha por toque e pelo teclado;
- navegação pelas setas, Home, End e primeira letra;
- largura da âncora, com mínimo;
- semântica de seleção.

**Non-Goals:**
- o campo `RebicSelect`;
- seleção múltipla, grupos e separadores;
- filtro por texto;
- itens livres;
- rolagem virtualizada para listas muito longas (fica para `RebicList` e `core/data-source`).

## Decisions

### D1. API

```dart
class RebicDropdownItem<T> {
  const RebicDropdownItem({required this.value, required this.label, this.icon, this.additionalText,
      this.enabled = true});
}

class RebicDropdown<T> extends StatefulWidget {
  const RebicDropdown({required this.controller, required this.items, required this.onSelected,
      required this.semanticLabel, required this.child, this.selected, this.side = RebicOverlaySide.below,
      this.onDismiss, super.key});
}
```

- **Itens como dados:** os itens são dados (`RebicDropdownItem`), não widgets, como os `sap.ui.core.Item` do
  `Select`. Assim, o dropdown controla a aparência, a navegação e a semântica de forma uniforme.
- **Mesmo controlador do popover:** o dropdown usa o `RebicPopoverController`. `RebicSelect` e `RebicMenu` abrem a
  lista com `toggle()` na âncora.
- **Asserts:** `items` não vazia, valores distintos, rótulos e `semanticLabel` não vazios.

### D2. Largura `anchor` no popover

- Entra `RebicPopoverWidth.anchor(4)`. A regra de largura do popover não muda: o resultado é `max(4 × xxxl, âncora)`.
  A lista fica na largura da âncora, e âncoras estreitas, como um botão de ícone "…" de um futuro `RebicMenu`, ainda
  dão uma lista de 192 na referência.
- É a exceção prevista pela preferência de larguras consistentes: listas acompanham o campo, e os popovers de conteúdo
  continuam em `standard`.

### D3. Estrutura

```
RebicPopover(controller, semanticLabel, width: anchor, padded: false, side, onDismiss, child: âncora)
└─ content: Focus(onKeyEvent: setas, Home, End, letra)
   └─ Column(min, stretch)
      └─ [para cada item] RebicInteractable(
            focusNode: _nodes[i], autofocus: i == inicial,
            selected: item.value == selected,
            onPressed: item.enabled ? () => _choose(item) : null,
            semanticLabel: additionalText == null ? label : '$label, $additionalText',
            builder: (context, states) => ColoredBox(list.resolve(states).background)
              → ConstrainedBox(minHeight: density.controlHeight)
              → Padding(horizontal: spacing.m)
              → Row(spacing: spacing.s, [Icon?, Expanded(Text(label, 1 linha, reticências)), Text(additionalText)?])
                (Text e Icon na cor `text` resolvida; texto adicional no tom `muted`)
         )
```

- **`_choose`:** chama `controller.close()` e depois `onSelected(value)`. O núcleo devolve o foco à âncora ao fechar.
  `onDismiss` não é chamado, porque não é dispensa.
- **Foco inicial:** o item selecionado e habilitado, ou o primeiro habilitado, recebe `autofocus`. O
  `RebicInitialFocus` do núcleo não o sobrepõe.
- **Teclado:**
  - O `Focus` em volta da lista trata as setas para cima e para baixo: próximo item habilitado na direção, sem dar a
    volta.
  - Home e End vão ao primeiro e ao último habilitado.
  - Um caractere imprimível vai ao próximo item habilitado, depois do atual, cujo rótulo começa com ele, ignorando
    maiúsculas. A busca dá a volta.
  - Cada movimento chama `requestFocus` no `FocusNode` do item e `Scrollable.ensureVisible`, para que o item fique
    visível na lista rolada pelo popover.
  - Enter e Espaço ficam com o `RebicInteractable`.
- **Tab:** segue o popover e circula pelos itens.
- **Desabilitado:** o item fica com `onPressed: null`. O `RebicInteractable` aplica a aparência desabilitada, tira o
  item do percurso de foco e o anuncia como não habilitado.

### D4. Testes, galeria e catálogo

- **Posições e larguras:** por `getRect` dos itens, dos ícones e dos textos adicionais.
- **Cores:** pelo `ColoredBox` de cada item, comparado com `RebicControlColors` da família `list`.
- **Teclado:** pelo `FocusNode.hasPrimaryFocus` de cada item, achado pelo `Focus` ancestral do rótulo, e por
  `sendKeyEvent`.
- **Semântica:** por `getSemantics` dos rótulos, com `isSelected`, `isButton` e `isEnabled`.
- **Acessibilidade:** um arquivo sem a Inter, com contraste, alvo rotulado e alvo mínimo nos temas claro e escuro e
  nas duas densidades, sobre `background`.
- **Goldens:** 720 × 480, com um dropdown aberto sob uma âncora de 6 passos `spacing.xxxl`. Os itens são "Em aberto"
  (ícone), "Aprovado" (selecionado, "12"), "Arquivado" (desabilitado) e "Rejeitado". São gerados nos temas claro e
  escuro × confortável e compacto.
- **Galeria:** página "RebicDropdown" (`rebic_dropdown_page.dart`), com `RebicPage`:
  - um `RebicButton` "Status: <situação>" que alterna um dropdown de situações e passa a mostrar a escolhida;
  - um `RebicIconButton` "Mais ações" (`moreHorizontal`) que abre um dropdown de ações, mostrando a largura mínima.

  O cenário se chama "Página RebicDropdown na galeria".
- **Popover:** o cenário novo "Popover na largura da âncora" vai para os testes do popover, e a rastreabilidade do
  popover passa a 23 cenários.
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

## Risks / Trade-offs

- [`RebicPopover` modificado na change de outro widget] → É só um valor de enum, sem mudar a regra de largura, e
  existe para o dropdown. Separar a mudança numa change própria dobraria o ciclo sem ganho de revisão.
- [Listas longas sem virtualização] → A lista usa `Column` dentro da rolagem do popover. Bastam as dezenas de itens de
  um `Select`. Listas grandes ficam para `RebicList` e `core/data-source`.
- [Busca só pela primeira letra] → O `Select` do UI5 acumula letras digitadas em sequência. A busca de uma letra cobre
  o caso comum. A acumulação pode vir com o `RebicSelect`, se necessário.
- [Itens de uma linha] → Rótulos longos ficam com reticências, como no `Select` com `wrapItemsText` desligado. O
  rótulo inteiro continua na semântica.

## Migration Plan

Widget novo e valor novo de enum; nada a migrar.
