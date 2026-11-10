# Proposal: GjaPopover (`gja/widgets/gja-popover`)

## Why

Telas Fiori abrem painéis leves junto de um botão ou link, como filtros rápidos, detalhes de um registro ou uma
confirmação curta, sem sair da página. No SAPUI5, isso é o `sap.m.Popover`, que tem:
- `openBy(controle)` e `close()`, com fechamento automático por toque fora ou Esc (`afterClose`);
- `placement` (abaixo, acima, à esquerda, à direita) com inversão quando falta espaço;
- um cabeçalho com `title`, alinhado ao início no tema Horizon;
- o conteúdo, que rola quando passa da altura disponível;
- um rodapé com ações (por exemplo, "Aplicar" e "Cancelar");
- semântica de diálogo e foco circulando dentro dele.

O núcleo já tem a sobreposição ancorada (`GjaAnchoredOverlay`), mas ela só posiciona um conteúdo cru. Cada tela
teria de repetir superfície, sombra, cabeçalho, rodapé, rolagem e semântica. O design da Fase 0 previu `GjaPopover`
sobre `core/overlay` e `GjaContainer`, abrindo a etapa "Popover → Dropdown → Menu".

## What Changes

- Widget `GjaPopover` em `gja_widgets` (categoria `feedback-sobreposicoes`):
  - `child` (a âncora), `content` e `padded` (padrão `true`, com espaço `spacing.l`; `false` deixa o conteúdo na
    borda, para listas);
  - `controller` (`GjaPopoverController`), com `open()`, `close()`, `toggle()` e `isOpen`, como o
    `openBy`/`close` do UI5;
  - `side` e `alignment` (padrão abaixo, alinhado ao início), com a inversão e o limite de tela do núcleo;
  - **Cabeçalho opcional**, com `title` (variante `subtitle`, anunciado como cabeçalho, uma linha com reticências) e
    um divisor sutil até o conteúdo;
  - **Rodapé opcional**, com `actions` alinhadas ao fim, separado por um divisor;
  - `onDismiss`, chamado quando o popover fecha por toque fora ou Esc, como o `afterClose` do UI5;
  - `semanticLabel`, obrigatório quando não há `title`.
- **Superfície:** `GjaContainer` com fundo `base`, raio `container` e sombra `popover`, sem borda, como o popover
  Horizon.
- **Largura:** segue o conteúdo, entre um mínimo e um máximo derivados de `spacing.xxxl`.
- **Altura:** limitada à área da sobreposição; só o conteúdo rola, e cabeçalho e rodapé ficam fixos.
- **Foco e semântica:** o foco vai ao primeiro elemento focável ao abrir, circula dentro do popover com Tab e volta à
  âncora ao fechar. O popover é exposto como uma rota nomeada pelo título, como o `role="dialog"` do UI5.
- Página "GjaPopover" na galeria.

Fora do escopo:
- Seta apontando para a âncora (`showArrow`). Ela exige que o núcleo informe o lado resolvido após a inversão, e fica
  para uma change `update-gja-core-overlay` seguida de `update-gja-popover-arrow`.
- Popover modal (`modal: true`), com camada de bloqueio.
- Versão responsiva que vira diálogo em tela cheia no telefone (`sap.m.ResponsivePopover`), que depende de
  `GjaDialog`.
- Animação de abertura e fechamento.
- Cabeçalho personalizado e botões no cabeçalho (`beginButton`/`endButton`).

## Capabilities

### New Capabilities

- `gja/widgets/gja-popover`: painel ancorado com cabeçalho e rodapé opcionais, conteúdo rolável com ou sem
  margem, controlador, fechamento automático, foco e semântica de diálogo.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/feedback_sobreposicoes/popover/` e testes, com goldens.
- **Galeria:** nova página "GjaPopover".
- **Catálogo:** `gja/widgets/gja-popover` → `implemented`. Além de `core/overlay` e `gja-container`, as
  dependências passam a incluir:
  - `gja-text`, `gja-divider` e `core/interaction`;
  - os fundamentos `color`, `spacing`, `radius`, `elevation`, `typography`, `theming` e `accessibility`.
- **Portal existente:** sem impacto.
