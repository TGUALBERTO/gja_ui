# Proposal: Ícones no modelo do IconPool (`update-gja-foundation-iconography-fiori-iconpool`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou dois desvios nos ícones:
- **Nomes.** O catálogo usa nomes próprios do GJA (`close`, `check`, `chevronDown`, `arrowLeft`, `user`, `menu`…).
  No SAPUI5, os ícones são referidos pelos nomes do IconPool (`sap-icon://decline`, `accept`, `slim-arrow-down`,
  `nav-back`, `person-placeholder`, `menu2`…). Quem conhece o SAPUI5 procura por esses nomes.
- **Tamanho.** O ícone dentro de controles mede 20. No Horizon, ele segue `sapContent_IconHeight` (1rem, 16).

Os desenhos continuam os da fonte Lucide empacotada (decisão provisória do protótipo, sem assets da SAP). Mudam o nome
e o tamanho.

Esta é a oitava change da série de realinhamento da fundação.

## What Changes

- **BREAKING** `GjaIcons` passa aos nomes do IconPool em camelCase:

  | Antes | Agora (`sap-icon://…`) | | Antes | Agora (`sap-icon://…`) |
  |---|---|---|---|---|
  | `add` | `add` | | `calendar` | `calendar` |
  | `close` | `decline` | | `clock` | `pending` |
  | `search` | `search` | | `user` | `personPlaceholder` (`person-placeholder`) |
  | `check` | `accept` | | `filter` | `filter` |
  | `chevronUp` | `slimArrowUp` | | `sort` | `sort` |
  | `chevronDown` | `slimArrowDown` | | `upload` | `upload` |
  | `chevronLeft` | `slimArrowLeft` | | `download` | `download` |
  | `chevronRight` | `slimArrowRight` | | `refresh` | `refresh` |
  | `arrowLeft` | `navBack` | | `settings` | `actionSettings` |
  | `arrowRight` | `navigationRightArrow` | | `home` | `home` |
  | `menu` | `menu2` | | `externalLink` | `popupWindow` |
  | `moreHorizontal` | `overflow` | | `visibility` | `show` |
  | `moreVertical` | removido | | `visibilityOff` | `hide` |
  | `edit` | `edit` | | `copy` | `copy` |
  | `delete` | `delete` | | `logout` | `log` |
  | `info` | `information` | | `notification` | `bell` |
  | `warning` | `warning` | | `file` | `document` |
  | `error` | `error` | | `folder` | `folderBlank` |
  | `success` | `sysEnter2` | | | |
  | `help` | `sysHelp` | | | |

  `moreVertical` sai porque o IconPool não tem reticências verticais (o Fiori usa só `overflow`) e o GJA não o usa.
  Os ícones direcionais espelhados em RTL passam a ser `slimArrowLeft`, `slimArrowRight`, `navBack`,
  `navigationRightArrow`, `log` e `popupWindow`.
- `GjaIcons.iconPoolNames` (nome do catálogo → nome do IconPool em kebab-case) passa a documentar e testar a
  correspondência. O dartdoc de cada ícone cita o `sap-icon://` dele.
- **BREAKING (visual)** `GjaIconTokens.control` passa de 20 a 16 (`sapContent_IconHeight`). Os demais tamanhos não
  mudam.
- Os widgets, a galeria e os testes passam aos nomes novos, e os goldens com ícones de controle são regerados.
- ADR 0009 ganha estas linhas provisórias:
  - os nomes escolhidos onde o IconPool tem mais de uma opção (`menu2`, `pending`, `popupWindow`, `sysEnter2`);
  - o tamanho do ícone de controle.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/iconography`: catálogo com nomes do IconPool, espelhamento com os nomes novos e `control` de 16.
- `gja/widgets/gja-avatar`: ícone padrão `personPlaceholder`.
- `gja/widgets/gja-icon`: exemplos com `slimArrowRight` e `accept`.
- `gja/widgets/gja-icon-button`: exemplo de RTL com `navBack`.
- `gja/widgets/gja-scaffold`: ícone de navegação `menu2`.

A change toca quatro specs de widget, acima do limite de `gja/spec-governance`. A exceção se justifica como nas
changes anteriores da série: renomear o catálogo quebra todas as referências a ele. Só os nomes citados mudam, sem
mudança de API além do catálogo.

## Impact

- `packages/gja_foundation`:
  - `GjaIcons` (nomes, `lucideNames` com chaves novas, `iconPoolNames`, `all`);
  - `GjaIconTokens.control`;
  - testes e CHANGELOG.
- `packages/gja_widgets`: `GjaScaffold` (`menu2`), `GjaPage` (`navBack`), `GjaDropdown` (`slimArrowDown`),
  `GjaAvatar` (`personPlaceholder`), testes, goldens e CHANGELOG.
- `apps/gja_gallery`: página "Ícones" e cerca de 60 usos de `GjaIcons` nas páginas, com os testes.
- `docs/adr/0009-provisional-horizon-values.md`.
- Sem efeito em `gja_core`, no catálogo de widgets e no portal.
