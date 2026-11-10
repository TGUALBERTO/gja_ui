# Proposal: Interação e foco (`gja/core/interaction`)

## Why

Todo widget interativo do framework (botões, links, campos, abas, itens de lista, navegação) precisa detectar hover,
pressionado e foco, responder a toque e teclado, mostrar o anel de foco só para quem navega por teclado, ter área
mínima de toque e expor a semântica certa. Os fundamentos já definem os valores (`interaction-states`) e as regras
(`accessibility`). Falta a infraestrutura que os aplica de forma igual, para que cada widget não reimplemente
`FocusNode`, `MouseRegion`, atalhos e semântica do zero. Este é o primeiro item do núcleo, e `core/overlay`,
`GjaApp` e todos os widgets de ação dependem dele.

## What Changes

- Widget de infraestrutura `GjaInteractable` em `gja_core`, com:
  - detecção dos estados (`hovered`, `focused`, `pressed`, `disabled`, mais o `selected` recebido) e exposição ao `builder` do widget que o usa;
  - ativação por toque e por teclado (Enter, Enter numérico e Espaço), via os atalhos nativos do `WidgetsApp`;
  - estado desabilitado quando não há `onPressed`: sem foco, sem eventos e com semântica de desabilitado;
  - área de interação mínima, que vem do alvo da densidade;
  - semântica de botão (rótulo, habilitado, selecionado) e cursor de clique.
- Widget `GjaFocusRing`, que desenha o anel de foco com a espessura, o afastamento e a cor dos tokens, só quando o
  foco vem do teclado (modo de destaque tradicional).
- Os valores visuais (estados, cor de foco e alvo mínimo) entram por parâmetro, com o mapeamento de referência como
  padrão, até `add-gja-theme` passar a fornecê-los pelo tema.
- Página "Interação" na galeria, com uma superfície interativa que mostra os estados ativos.

Fora do escopo:
- Atalhos de aplicação, *focus trap* e dispensa por Esc (`add-gja-core-overlay`).
- Pressão longa, arrasto e menus de contexto (específicos de widget).
- Ler os tokens do tema (`add-gja-theme`).

## Capabilities

### New Capabilities

- `gja/core/interaction`: detecção de estados, ativação por toque e teclado, desabilitado, foco e visibilidade do
  anel, ordem de foco, área mínima de interação, semântica e cursor dos elementos interativos.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_core/lib/src/interaction/` (primeiro código do pacote), exportação em `gja_core.dart`
  e testes em `packages/gja_core/test/interaction/`.
- **Galeria:** nova página "Interação".
- **Catálogo:** `gja/core/interaction` → `implemented`.
- **Dependências:** `gja/foundation/interaction-states` e `gja/foundation/accessibility` (já são specs
  principais), P0 e fase 1, coerente com o catálogo. Nenhum pacote novo. Só `package:flutter/widgets.dart`, sem Material.
- **Portal existente:** sem impacto.
