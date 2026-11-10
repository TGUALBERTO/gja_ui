# Proposal: GjaDropdown (`gja/widgets/gja-dropdown`)

## Why

No SAPUI5, escolher um valor numa lista acontece em vários controles:
- o `sap.m.Select` abre uma lista de itens (`sap.ui.core.Item`, com `text`, `icon`, `additionalText` e `enabled`) num
  popover sob o campo;
- o item atual aparece selecionado, e o foco abre nele;
- setas, Home, End e a digitação da primeira letra navegam pelos itens;
- Enter ou toque escolhe o item e fecha a lista, e Esc fecha sem escolher;
- a lista tem a largura do campo.

O mesmo comportamento aparece no `ComboBox`, nas sugestões do `SearchField` e, com outra semântica, no `Menu`.

O design da Fase 0 previu `GjaDropdown` como essa lista ancorada, sobre o `GjaPopover`. Ele é a base de
`GjaSelect`, `GjaSearchField` e `GjaMenu`. Sem ele, cada um repetiria a lista, a navegação pelo teclado e a
semântica de seleção.

## What Changes

- Widget `GjaDropdown<T>` em `gja_widgets` (categoria `feedback-sobreposicoes`):
  - `controller` (`GjaPopoverController`), `child` (a âncora) e `semanticLabel` (nome da lista para leitores de
    tela);
  - `items` (`List<GjaDropdownItem<T>>`), cada item com `value`, `label`, `icon` opcional, `additionalText`
    opcional (no fim, tom `muted`) e `enabled`;
  - `selected` (`T?`): o item com esse valor aparece selecionado e recebe o foco ao abrir;
  - `onSelected` (`ValueChanged<T>`): é chamado ao escolher um item, e a lista fecha;
  - `side` e `onDismiss`, repassados ao popover.
- **Itens:**
  - usam a família de controle `list`, com hover, ativo, selecionado e selecionado com hover;
  - têm a altura `density.controlHeight` e o texto em uma linha com reticências;
  - itens desabilitados ficam com a aparência desabilitada, não recebem foco e não são escolhidos.
- **Teclado:**
  - ao abrir, o foco vai ao item selecionado ou ao primeiro item habilitado;
  - setas para cima e para baixo movem entre itens habilitados, sem dar a volta;
  - Home e End vão ao primeiro e ao último;
  - digitar uma letra vai ao próximo item cujo rótulo começa com ela;
  - Enter e Espaço escolhem, e Esc fecha (pelo popover).
- **Semântica:** cada item é exposto como botão com o estado de selecionado, dentro da rota nomeada do popover.
- **Largura:** novo valor `GjaPopoverWidth.anchor` no `GjaPopover`, com o mínimo de 4 passos `spacing.xxxl` (192
  na referência), que segue a âncora quando ela é mais larga. O dropdown usa esse valor, então a lista fica na largura
  da âncora, como no `sap.m.Select`. Âncoras estreitas, como botões de ícone, ainda dão uma lista legível.
- Página "GjaDropdown" na galeria.

Fora do escopo:
- O campo de seleção com rótulo e estado de valor (`GjaSelect`, change própria).
- Seleção múltipla, agrupamento e separadores de itens.
- Filtro por texto digitado em campo (`ComboBox`, `SearchField`).
- Itens com conteúdo livre ou duas linhas.

## Capabilities

### New Capabilities

- `gja/widgets/gja-dropdown`: lista de itens selecionáveis num popover ancorado, com item selecionado, itens
  desabilitados, navegação pelo teclado com busca pela primeira letra e semântica de seleção.

### Modified Capabilities

- `gja/widgets/gja-popover`: novo valor `GjaPopoverWidth.anchor`, com o mínimo de 4 passos `spacing.xxxl`, que
  segue a âncora. É uma mudança que habilita o dropdown, sem nova API pública além do valor do enum.

## Impact

- **Código:**
  - `packages/gja_widgets/lib/src/feedback_sobreposicoes/dropdown/` e testes, com goldens;
  - mais um valor do enum em `gja_popover.dart`, com um teste.
- **Galeria:** nova página "GjaDropdown".
- **Catálogo:** `gja/widgets/gja-dropdown` → `implemented`. Além de `gja-popover`, as dependências passam a
  incluir:
  - `gja-text`, `gja-icon` e `core/interaction`;
  - os fundamentos `color`, `spacing`, `density`, `typography`, `interaction-states`, `theming` e `accessibility`.
- **Portal existente:** sem impacto.
