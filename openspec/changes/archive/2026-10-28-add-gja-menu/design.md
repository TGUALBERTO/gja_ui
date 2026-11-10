# Design: GjaMenu

## Context

- **`GjaDropdown`** (`feedback_sobreposicoes/dropdown/gja_dropdown.dart`) monta a lista dentro de um
  `GjaPopover(width: anchor, padded: false)`. Os itens são `MergeSemantics → GjaInteractable(focusNode, selected,
  onPressed, semanticLabel)`, desenhados com a família `list` em `density.controlHeight`, com `spacing.m` e
  `spacing.s`. O estado privado guarda:
  - os `FocusNode` dos itens;
  - o tratador de teclado (setas, Home, End e letra), que faz `requestFocus` + `Scrollable.ensureVisible`;
  - o foco inicial pós-quadro (`_OnMount`), que roda depois do `GjaInitialFocus` do núcleo;
  - a escolha, que fecha o controlador e chama o callback.
- **`SemanticsRole`** (Flutter 3.32) tem `menu` e `menuItem`. No modo debug, um nó `menuItem` precisa ter um
  ancestral `menu`, e um `menu` não pode estar vazio.
- **`GjaDivider`** sutil já é o separador do cartão e do popover.
- No `sap.m.Menu` Horizon:
  - os itens têm ícone, texto e `shortcutText` no fim, num tom secundário;
  - `startsSection` desenha uma linha antes do item;
  - não há item selecionado;
  - o foco abre no primeiro item.

## Goals / Non-Goals

**Goals:**
- menu de ações com ícone, atalho exibido, seções e itens desabilitados;
- teclado e largura iguais aos do dropdown;
- papéis `menu` e `menuItem`;
- extrair a lista compartilhada sem mudar o dropdown.

**Non-Goals:**
- submenus e itens marcáveis;
- atalhos registrados;
- `MenuButton` e barra de menus.

## Decisions

### D1. API

```dart
class GjaMenuItem {
  const GjaMenuItem({required this.label, required this.onPressed, this.icon, this.shortcut,
      this.startsSection = false});
}

class GjaMenu extends StatelessWidget {
  const GjaMenu({required this.controller, required this.items, required this.semanticLabel,
      required this.child, this.side = GjaOverlaySide.below, this.onDismiss, super.key});
}
```

- **Ação por item:** cada item tem o próprio `onPressed`, que também o habilita ou desabilita, como nos botões do
  GJA. Num menu de ações, um valor e um callback único seriam indiretos.
- **`onPressed` obrigatório e anulável:** `required this.onPressed` força a decisão explícita (`null` = desabilitado),
  como no `GjaButton`.
- **Asserts:** `items` não vazia, rótulos e `semanticLabel` não vazios.

### D2. Lista compartilhada `GjaOptionList` (interna)

- Novo arquivo `feedback_sobreposicoes/dropdown/gja_option_list.dart`, não exportado.
- O widget `GjaOptionList` recebe:
  - `List<GjaOption>`: `label`, `icon`, `trailing` (o texto adicional ou o atalho), `selected`, `startsSection` e
    `onChosen` (nulo = desabilitado);
  - `controller`;
  - `listRole` e `itemRole` (`SemanticsRole?`).
- Ele contém o que hoje é privado no `_GjaDropdownState`:
  - os nós de foco;
  - o teclado;
  - o foco inicial (o primeiro selecionado habilitado, ou o primeiro habilitado);
  - os itens;
  - `close()` + `onChosen`.
- Os divisores entram antes de cada opção com `startsSection`, exceto a primeira.
- **`GjaDropdown`:** passa a mapear os itens para `GjaOption` (`selected` por valor, `onChosen` chama
  `onSelected(value)`), com `listRole: null` e `itemRole: null`. A árvore e a semântica ficam iguais às de hoje.
  Os testes atuais do dropdown são a verificação da extração.
- **`GjaMenu`:** mapeia para `GjaOption(selected: false, trailing: shortcut, onChosen: onPressed)`, com
  `listRole: SemanticsRole.menu` e `itemRole: SemanticsRole.menuItem`.

### D3. Semântica dos papéis

- A `Column` da lista fica num `Semantics(role: listRole, container: true, explicitChildNodes: true)` quando há papel.
- Cada item recebe `Semantics(role: itemRole)` dentro do `MergeSemantics`, junto do nó do `GjaInteractable`. O nó
  mesclado leva o papel, o rótulo, a ação e o estado habilitado.
- O teste de semântica confirma o papel no nó mesclado.
- Se o nó mesclado perder o papel, o papel vai para um `Semantics(container: true, role: itemRole)` em volta do
  `MergeSemantics`, e o design é atualizado.

### D4. Testes, galeria e catálogo

- **Posições, larguras e cores:** como nos testes do dropdown. O divisor de seção é verificado por `getRect` entre os
  itens e por `find.byType(GjaDivider)`.
- **Semântica:** `tester.getSemantics` do item, com `SemanticsNode.role` (`getSemanticsData().role`) e
  `containsSemantics(label, isEnabled, hasTapAction)`.
- **Teclado:** pelo `Focus.of` do rótulo, com `sendKeyEvent`.
- **Acessibilidade:** um arquivo sem a Inter, com `density` passado ao `GjaApp`, contraste, alvo rotulado e alvo
  mínimo nos temas claro e escuro e nas duas densidades.
- **Goldens:** 720 × 480, com o menu aberto sob um `GjaButton` "Ações", que fica mais estreito que o menu (exceção
  da largura mínima). Os itens são:
  - "Editar" (ícone e "Ctrl+E");
  - "Copiar" (ícone e "Ctrl+C");
  - "Exportar" (desabilitado);
  - "Excluir" (ícone e `startsSection`).

  São gerados nos temas claro e escuro × confortável e compacto. Depois de gerar, confere-se que os compactos diferem
  dos confortáveis.
- **Galeria:** página "GjaMenu" (`gja_menu_page.dart`), com `GjaPage`:
  - um `GjaButton` "Ações" que abre o menu acima e mostra "Última ação: <rótulo>";
  - um `GjaIconButton` "Mais ações" (`moreHorizontal`) com um menu curto.

  O cenário se chama "Página GjaMenu na galeria".
- **Catálogo:** `implemented`, com as dependências do `[Integração]`.

### D5. Mínimo das listas: 6 passos

- Os goldens compactos mostraram "Copiar  Ctrl+C" cortado como "Cop…". O mínimo de 4 passos dava 128 px, porque
  `spacing.xxxl` vale 32 no compacto.
- Por decisão do usuário, `GjaPopoverWidth.anchor` passa a 6 passos: 288 na referência e 192 no compacto.
- O dropdown e o menu herdam o valor. Os goldens do dropdown não mudam, porque a âncora deles já tem 6 passos.

## Risks / Trade-offs

- [Refatoração do dropdown na change do menu] → É só a extração da lista, sem mudança de API nem de comportamento. Os
  22 testes do dropdown e os goldens dele, que não mudam, provam a equivalência.
- [Papéis de semântica novos no Flutter] → `SemanticsRole.menu` e `menuItem` existem e são validados nesta versão. Nas
  plataformas sem suporte, o item continua anunciado como botão com rótulo.
- [Sem submenus] → Menus de dois níveis ficam para `update-gja-menu-submenu`. Esse trabalho precisará posicionar uma
  segunda sobreposição ao lado do item (`side: end`) e tratar a seta para a direita e para a esquerda.

## Migration Plan

Widget novo e refatoração interna; nada a migrar.
