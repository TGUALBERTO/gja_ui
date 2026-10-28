# Proposal: RebicAvatar (`rebic/widgets/rebic-avatar`)

## Why

Barras da aplicação, listas de pessoas, cabeçalhos de objeto e comentários mostram quem é o usuário ou o fornecedor:
uma foto, as iniciais ou um ícone. No SAPUI5, isso é o `sap.m.Avatar`, que tem:
- `src` (imagem), `initials` (até 3 letras) e `fallbackIcon`;
- `displayShape` (`Circle`/`Square`) e `displaySize` (XS 2rem, S 3rem, M 4rem, L 5rem, XL 7rem);
- `press`, para avatares clicáveis, como o perfil na `ShellBar`.

O Rebic não tem esse widget. `RebicListTile`, `RebicNotification` e o perfil da barra precisarão dele. O design da
Fase 0 o previu sobre `RebicIcon` e `RebicText`, na etapa "Badge, StatusIndicator, Avatar, Card".

## What Changes

- Widget `RebicAvatar` em `rebic_widgets` (categoria `exibicao-dados`):
  - `image` (`ImageProvider?`), `initials` (até 3 caracteres, mostrados em maiúsculas) e `icon`;
  - **Ordem de exibição:** imagem, iniciais, ícone ou, sem nenhum, o ícone `user`. Se a imagem falha ao carregar, o
    avatar mostra as iniciais ou o ícone;
  - `shape` (`RebicAvatarShape.circle`/`square`, padrão `circle`), com raio `radius.s` no quadrado;
  - `size` (`RebicAvatarSize.xs`…`xl`, padrão `s`): lados de 1×, 1,5×, 2×, 2,5× e 3,5× `icons.xLarge`, ou seja,
    32/48/64/80/112 nos tokens de referência, como os 2/3/4/5/7 rem do UI5;
  - **Cores:** fundo `colors.selectionBackground`, iniciais e ícone em `colors.brand`, como os avatares de acento
    claro do Fiori;
  - `onPressed`: com ele, o avatar fica ativo, com hover (`selectionHoverBackground`), foco pelo teclado, Enter e
    Espaço, e é anunciado como botão;
  - `semanticLabel` (por exemplo, o nome da pessoa). Sem ele, o leitor de tela recebe as iniciais.
- O tamanho do avatar é fixo pela escala da interface e não muda com a escala de texto, como no UI5. As iniciais se
  ajustam ao círculo.
- Página "RebicAvatar" na galeria.

Fora do escopo:
- Cores de acento por avatar (`Accent1`…`Accent10`, `Random`), que dependem de novos papéis de cor no fundamento.
- Badge de edição sobre o avatar (`showBorder`, `badgeIcon`) e grupos de avatares (`AvatarGroup`).
- Carregamento de imagem com placeholder animado.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-avatar`: representação de uma pessoa ou objeto por imagem, iniciais ou ícone, em forma
  circular ou quadrada, em cinco tamanhos, opcionalmente clicável.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/exibicao_dados/avatar/` e testes, com goldens.
- **Galeria:** nova página "RebicAvatar".
- **Catálogo:** `rebic/widgets/rebic-avatar` → `implemented`. Além de `rebic-icon` e `rebic-text`, as dependências
  passam a incluir:
  - `core/interaction`;
  - os fundamentos `color`, `typography`, `iconography`, `radius`, `interaction-states`, `theming` e
    `accessibility`.
- **Portal existente:** sem impacto.
