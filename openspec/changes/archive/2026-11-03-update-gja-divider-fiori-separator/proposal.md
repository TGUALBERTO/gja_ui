# Proposal: Separador no modelo do SAPUI5 (`update-gja-divider-fiori-separator`)

## Why

O `GjaDivider` segue o `Divider` do Material, que o projeto evita: o nome, o recuo `indent`/`endIndent`, o espaço
próprio em volta da linha e o tom forte não existem no SAPUI5. O controle de referência é o `sap.m.ToolbarSeparator`
(conferido em `SAP/openui5`, `sap.m/themes/base/ToolbarSeparator.less` e `ToolbarSeparatorRenderer.js`):

- não tem propriedades; o espaço em volta vem do contêiner (a barra, a lista, o menu);
- a linha tem a largura `sapElement_BorderWidth` (0,0625rem) e a cor `sapToolbar_SeparatorColor`;
- a linha vertical tem altura fixa por densidade, 2rem no cozy e 1,5rem no compacto, e não estica até a altura da
  barra;
- é renderizado com `role="separator"`.

As linhas do SAPUI5 (`sapToolbar_SeparatorColor`, `sapList_BorderColor`, `sapGroup_ContentBorderColor`) são todas
claras e decorativas; não há separador com a cor de borda de campo, que é o que o tom `strong` usa.

É o próximo passo do bloco de layout do realinhamento ao SAPUI5, depois de Card e do rótulo obrigatório.

## What Changes

- **BREAKING** `GjaDivider` sai e dá lugar a `GjaSeparator`, como o `sap.m.ToolbarSeparator`:
  - `GjaSeparator()` é horizontal e ocupa a largura disponível; `GjaSeparator.vertical()` tem a altura
    `density.separatorHeight` e fica centrado no eixo cruzado de quem o contém;
  - sem propriedades além da orientação: saem `tone` (e `GjaDividerTone`), `spacing`, `indent` e `endIndent`; o
    espaço vem do contêiner, como no UI5;
  - a linha tem a espessura fina padrão e a cor `colors.separator`.
- Fundação de densidade: nova dimensão `separatorHeight`, 32 no cozy e 24 no compacto (2rem e 1,5rem do
  `sapMTBSeparator`), com o novo primitivo `size24`.
- Card, dropdown, menu e popover passam a citar `gja/widgets/gja-separator`; os textos de aparência do menu e do
  popover deixam de falar em divisor "sutil".
- A spec de governança troca o exemplo de widget sem foco de `GjaDivider` para `GjaSeparator`.
- A galeria troca a página "GjaDivider" por "GjaSeparator", com uma barra que usa o separador vertical.

Fora do escopo:
- a forma do separador dentro do menu "mais" do `sap.m.OverflowToolbar` (horizontal, com margem), que entra com o
  overflow da barra;
- `role="separator"`: o `SemanticsRole` do Flutter não tem esse papel (conferido no SDK local), e o separador
  continua fora da árvore de semântica, como hoje.

## Capabilities

### New Capabilities

- `gja/widgets/gja-separator`: `GjaSeparator`, o `sap.m.ToolbarSeparator` do GJA.

### Modified Capabilities

- `gja/widgets/gja-divider`: retirada (`retire_capabilities`). Todos os requisitos passam a `gja-separator`.
- `gja/foundation/density`: dimensão `separatorHeight` e primitivo 24.
- `gja/widgets/gja-card`, `gja/widgets/gja-dropdown`: dependência `gja/widgets/gja-separator`.
- `gja/widgets/gja-menu`, `gja/widgets/gja-popover`: dependência e separadores de seção e de cabeçalho/rodapé.
- `gja/spec-governance`: exemplo do cenário "Widget sem foco".

Há um único widget público novo. As demais specs mudam só por citarem o divisor, e a densidade ganha a dimensão de
que o separador vertical precisa, como a altura de barra entrou com o `GjaBar`.

## Impact

- `packages/gja_foundation`: `size24` em `GjaDensityPrimitives`, `separatorHeight` em `GjaDensityTokens`
  (construtor, `dimensions`, `copyWith`, `lerp`, igualdade), testes e CHANGELOG.
- `packages/gja_widgets`:
  - `fundacao_layout/divider/` sai; entra `fundacao_layout/separator/`, com a exportação;
  - card, option list (dropdown e menu) e popover passam a usar `GjaSeparator`, sem mudança visual;
  - testes e goldens do separador; testes de card, menu e popover que procuram `GjaDivider` ou o tom;
  - CHANGELOG com o de/para.
- `apps/gja_gallery`: página "GjaSeparator" no lugar de "GjaDivider"; a página do card troca o divisor.
- `docs/catalog.yaml`: sai `gja/widgets/gja-divider`; entra `gja/widgets/gja-separator` (P0, fase 1); card,
  dropdown, menu e popover passam a depender dele.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
