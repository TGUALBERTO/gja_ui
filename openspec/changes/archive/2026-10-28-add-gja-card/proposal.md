# Proposal: GjaCard (`gja/widgets/gja-card`)

## Why

Painéis Fiori (Overview Page, páginas de objeto, dashboards) agrupam informações em cartões, como "Pedidos
pendentes", "Fornecedor" ou "Últimas notas". No SAPUI5, isso é o `sap.f.Card`, que tem:
- um cabeçalho (`sap.f.cards.Header`) com `title`, `subtitle`, `iconSrc` ou avatar e `statusText` (por exemplo,
  "3 de 5");
- o conteúdo;
- o evento `press` no cabeçalho, para navegar ao detalhe.

Hoje a galeria monta cartões à mão com `GjaContainer`. Cada tela repete superfície, borda, sombra, espaços e
cabeçalho. O design da Fase 0 previu `GjaCard` sobre `GjaContainer` e `GjaText`, fechando a etapa "Badge,
StatusIndicator, Avatar, Card".

## What Changes

- Widget `GjaCard` em `gja_widgets` (categoria `fundacao-layout`):
  - `child` (o conteúdo) e `padded` (padrão `true`, com espaço `spacing.l`; `false` deixa o conteúdo na borda, para
    listas e tabelas);
  - **Cabeçalho opcional**, que aparece quando há `title`:
    - `leading` (por exemplo, um `GjaAvatar` ou `GjaIcon`);
    - `title` (variante `subtitle`, anunciada como cabeçalho, até 2 linhas, como o título menor dos cartões Fiori);
    - `subtitle` (tom `muted`, até 2 linhas);
    - `status` no fim (por exemplo, "3 de 5", variante `label` e tom `muted`);
    - um divisor sutil até o conteúdo;
  - `onHeaderPressed`: torna o cabeçalho acionável, com hover `hoverBackground`, foco pelo teclado, Enter e Espaço,
    e semântica de botão, como o `press` do cabeçalho do UI5. O cartão em si não é interativo.
  - **Superfície:** `GjaContainer` com fundo `base`, borda `separator`, raio `container` e sombra `card`, ocupando
    a largura disponível.
- Página "GjaCard" na galeria, com cartões numa `GjaGrid`.

Fora do escopo:
- Cabeçalho numérico (`NumericHeader`, com KPI e tendência).
- Cartões com manifesto ou extensões (`sap.ui.integration`).
- Rodapé de ações do cartão e menu de ações no cabeçalho.
- Cartão inteiro acionável. Só o cabeçalho é acionável, como no Fiori.

## Capabilities

### New Capabilities

- `gja/widgets/gja-card`: cartão com cabeçalho opcional (leading, título, subtítulo, status), conteúdo com ou
  sem margem e cabeçalho acionável.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/gja_widgets/lib/src/fundacao_layout/card/` e testes, com goldens.
- **Galeria:** nova página "GjaCard".
- **Catálogo:** `gja/widgets/gja-card` → `implemented`. Além de `gja-container` e `gja-text`, as dependências
  passam a incluir:
  - `gja-divider` e `core/interaction`;
  - os fundamentos `color`, `spacing`, `radius`, `elevation`, `typography`, `interaction-states`, `theming` e
    `accessibility`.
- **Portal existente:** sem impacto.
