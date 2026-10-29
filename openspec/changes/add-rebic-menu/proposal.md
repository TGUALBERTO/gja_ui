# Proposal: RebicMenu (`rebic/widgets/rebic-menu`)

## Why

No SAPUI5, ações secundárias ficam em menus: o botão "Ações" de uma página de objeto, o "…" de uma linha de tabela,
o `sap.m.MenuButton`. O `sap.m.Menu` tem:
- itens (`sap.m.MenuItem`) com `text`, `icon`, `enabled` e `shortcutText`;
- `startsSection`, que desenha um separador antes do item;
- `itemSelected`, que dispara a ação e fecha o menu;
- abertura por `openBy(controle)`;
- `role="menu"` e `role="menuitem"` para leitores de tela.

O `RebicDropdown` já resolve a lista ancorada: largura da âncora, navegação pelo teclado, busca pela primeira letra e
foco. Mas ele é uma lista de seleção, com valor e item selecionado. O design da Fase 0 previu `RebicMenu` sobre o
`RebicDropdown`, para ações.

## What Changes

- Widget `RebicMenu` em `rebic_widgets` (categoria `acoes-navegacao`):
  - `controller` (`RebicPopoverController`), `child` (a âncora), `semanticLabel`, `side` e `onDismiss`, como no
    dropdown;
  - `items` (`List<RebicMenuItem>`), cada item com `label`, `onPressed` (nulo desabilita o item), `icon` opcional,
    `shortcut` opcional (texto no fim, tom `muted`, como o `shortcutText`; só exibe, não registra o atalho) e
    `startsSection`, que desenha um divisor sutil antes do item.
- **Acionar um item**, por toque, Enter ou Espaço, fecha o menu e chama o `onPressed` dele. O menu não tem item
  selecionado.
- **Teclado e largura:** os mesmos do dropdown.
  - O foco abre no primeiro item habilitado.
  - Setas, Home, End e a primeira letra navegam pelos itens.
  - A lista tem a largura da âncora, com o mínimo de 4 passos `spacing.xxxl`.
- **Semântica:** a lista é exposta com o papel `menu` e cada item com o papel `menuItem` (`SemanticsRole`), com rótulo
  e atalho, dentro da rota nomeada do popover.
- **Refatoração interna:** a lista do `RebicDropdown` (itens, cores da família `list`, teclado e foco inicial) passa
  para um widget interno compartilhado, não exportado. Ele ganha divisores de seção e o papel semântico da lista e dos
  itens. A API e o comportamento do dropdown não mudam.
- Página "RebicMenu" na galeria.

Fora do escopo:
- Submenus (`MenuItem.items`), que exigem sobreposições aninhadas ao lado do item.
- Itens marcáveis (`menuItemCheckbox` e `menuItemRadio`).
- Atalhos de teclado registrados pelo menu.
- O botão de menu com seta (`sap.m.MenuButton`) e a barra de menus.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-menu`: menu de ações ancorado, com ícones, atalhos exibidos, seções, itens desabilitados,
  navegação pelo teclado e semântica de menu.

### Modified Capabilities

Nenhuma. A refatoração da lista do dropdown é interna e coberta pelos testes atuais do `RebicDropdown`.

## Impact

- **Código:**
  - `packages/rebic_widgets/lib/src/acoes_navegacao/menu/` e testes, com goldens;
  - extração da lista do `RebicDropdown` para um arquivo interno em `feedback_sobreposicoes/dropdown/`.
- **Galeria:** nova página "RebicMenu".
- **Catálogo:** `rebic/widgets/rebic-menu` → `implemented`. Além de `rebic-dropdown` e `rebic-icon`, as dependências
  passam a incluir:
  - `rebic-popover`, `rebic-divider`, `rebic-text` e `core/interaction`;
  - os fundamentos `color`, `spacing`, `density`, `typography`, `interaction-states`, `theming` e `accessibility`.
- **Portal existente:** sem impacto.
