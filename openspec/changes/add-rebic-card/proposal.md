# Proposal: RebicCard (`rebic/widgets/rebic-card`)

## Why

Painéis Fiori (Overview Page, páginas de objeto, dashboards) agrupam informações em cartões, como "Pedidos
pendentes", "Fornecedor" ou "Últimas notas". No SAPUI5, isso é o `sap.f.Card`, que tem:
- um cabeçalho (`sap.f.cards.Header`) com `title`, `subtitle`, `iconSrc` ou avatar e `statusText` (por exemplo,
  "3 de 5");
- o conteúdo;
- o evento `press` no cabeçalho, para navegar ao detalhe.

Hoje a galeria monta cartões à mão com `RebicContainer`. Cada tela repete superfície, borda, sombra, espaços e
cabeçalho. O design da Fase 0 previu `RebicCard` sobre `RebicContainer` e `RebicText`, fechando a etapa "Badge,
StatusIndicator, Avatar, Card".

## What Changes

- Widget `RebicCard` em `rebic_widgets` (categoria `fundacao-layout`):
  - `child` (o conteúdo) e `padded` (padrão `true`, com espaço `spacing.l`; `false` deixa o conteúdo na borda, para
    listas e tabelas);
  - **Cabeçalho opcional**, que aparece quando há `title`:
    - `leading` (por exemplo, um `RebicAvatar` ou `RebicIcon`);
    - `title` (variante `subtitle`, anunciada como cabeçalho, até 2 linhas, como o título menor dos cartões Fiori);
    - `subtitle` (tom `muted`, até 2 linhas);
    - `status` no fim (por exemplo, "3 de 5", variante `label` e tom `muted`);
    - um divisor sutil até o conteúdo;
  - `onHeaderPressed`: torna o cabeçalho acionável, com hover `hoverBackground`, foco pelo teclado, Enter e Espaço,
    e semântica de botão, como o `press` do cabeçalho do UI5. O cartão em si não é interativo.
  - **Superfície:** `RebicContainer` com fundo `base`, borda `separator`, raio `container` e sombra `card`, ocupando
    a largura disponível.
- Página "RebicCard" na galeria, com cartões numa `RebicGrid`.

Fora do escopo:
- Cabeçalho numérico (`NumericHeader`, com KPI e tendência).
- Cartões com manifesto ou extensões (`sap.ui.integration`).
- Rodapé de ações do cartão e menu de ações no cabeçalho.
- Cartão inteiro acionável. Só o cabeçalho é acionável, como no Fiori.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-card`: cartão com cabeçalho opcional (leading, título, subtítulo, status), conteúdo com ou
  sem margem e cabeçalho acionável.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/fundacao_layout/card/` e testes, com goldens.
- **Galeria:** nova página "RebicCard".
- **Catálogo:** `rebic/widgets/rebic-card` → `implemented`. Além de `rebic-container` e `rebic-text`, as dependências
  passam a incluir:
  - `rebic-divider` e `core/interaction`;
  - os fundamentos `color`, `spacing`, `radius`, `elevation`, `typography`, `interaction-states`, `theming` e
    `accessibility`.
- **Portal existente:** sem impacto.
