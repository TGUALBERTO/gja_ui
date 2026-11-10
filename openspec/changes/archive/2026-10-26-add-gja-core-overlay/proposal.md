# Proposal: Sobreposições (`gja/core/overlay`)

## Why

Diálogos, popovers, listas suspensas, menus, dicas e painéis laterais precisam aparecer acima do conteúdo. Cada um
tem regras próprias:
- **modal ou não:** se bloqueia o resto da tela;
- **posição:** perto de quem os abriu, sem sair da tela;
- **dispensa:** como fecham (Esc, toque fora);
- **foco:** para onde vai o foco ao abrir e para onde volta ao fechar;
- **empilhamento:** como se empilham, por exemplo um popover dentro de um diálogo.

No SAPUI5, essas regras são do `sap.ui.core.Popup`:
- *BlockLayer* para modais;
- `autoClose` para fechar ao clicar fora;
- `escapeHandler`;
- posicionamento `my`/`at`/`of`, com inversão em colisão;
- foco inicial e restauração do foco;
- ordem de camadas gerida pelo próprio Popup.

O GJA precisa dessa infraestrutura antes de `GjaApp` (que depende dela), `GjaPopover`, `GjaDialog`,
`GjaTooltip`, `GjaSnackbar` e `GjaDrawer`. Sem ela, cada widget repetiria posicionamento, foco e dispensa.

## What Changes

- **Modal em `gja_core`:**
  - abre um conteúdo modal sobre a tela, com a camada de bloqueio na cor `blockLayer`;
  - prende o foco no modal e devolve o foco a quem o abriu;
  - fecha por Esc e por toque na camada quando é dispensável;
  - devolve um resultado ao fechar.
- **Sobreposição ancorada:**
  - mostra um conteúdo junto de um elemento âncora, com posição preferida (abaixo, acima, início ou fim);
  - inverte o lado quando falta espaço e mantém o conteúdo dentro da tela, com margem;
  - acompanha a âncora na rolagem;
  - fecha automaticamente por toque fora e por Esc, e devolve o foco à âncora.
- **Empilhamento:** uma sobreposição aberta dentro de outra aparece acima dela, e Esc fecha só a do topo.
- **Valores visuais:** cor da camada, margem e afastamento entram por parâmetro, com o mapeamento de referência como
  padrão, até `add-gja-theme`.
- **Galeria:** página "Sobreposições".

Fora do escopo:
- **Widgets:** a aparência dos widgets (`GjaDialog`, `GjaPopover`, sombras, raios e cabeçalhos) fica nas specs
  de cada widget.
- **Mensagens não ancoradas:** mensagens temporárias, como *toast* e *snackbar*, entram com `GjaSnackbar`.
- **Animações** de entrada e saída.

## Capabilities

### New Capabilities

- `gja/core/overlay`: modal com camada de bloqueio, foco preso e restaurado, dispensa, sobreposição ancorada com
  posicionamento e inversão, fechamento automático e empilhamento.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_core/lib/src/overlay/`, exportação em `gja_core.dart` e testes em
  `packages/gja_core/test/overlay/`.
- **Galeria:** nova página "Sobreposições".
- **Catálogo:** `gja/core/overlay` → `implemented`. As dependências passam a incluir, além de
  `gja/core/interaction`, `gja/foundation/color` (camada `blockLayer`) e `gja/core/localization` (rótulo da
  camada para leitores de tela), que a spec referencia.
- **Dependências:** nenhum pacote novo; só `package:flutter/widgets.dart`, sem Material.
- **Portal existente:** sem impacto.
