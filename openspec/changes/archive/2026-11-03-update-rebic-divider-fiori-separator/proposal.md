# Proposal: Separador no modelo do SAPUI5 (`update-rebic-divider-fiori-separator`)

## Why

O `RebicDivider` segue o `Divider` do Material, que o projeto evita: o nome, o recuo `indent`/`endIndent`, o espaço
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

- **BREAKING** `RebicDivider` sai e dá lugar a `RebicSeparator`, como o `sap.m.ToolbarSeparator`:
  - `RebicSeparator()` é horizontal e ocupa a largura disponível; `RebicSeparator.vertical()` tem a altura
    `density.separatorHeight` e fica centrado no eixo cruzado de quem o contém;
  - sem propriedades além da orientação: saem `tone` (e `RebicDividerTone`), `spacing`, `indent` e `endIndent`; o
    espaço vem do contêiner, como no UI5;
  - a linha tem a espessura fina padrão e a cor `colors.separator`.
- Fundação de densidade: nova dimensão `separatorHeight`, 32 no cozy e 24 no compacto (2rem e 1,5rem do
  `sapMTBSeparator`), com o novo primitivo `size24`.
- Card, dropdown, menu e popover passam a citar `rebic/widgets/rebic-separator`; os textos de aparência do menu e do
  popover deixam de falar em divisor "sutil".
- A spec de governança troca o exemplo de widget sem foco de `RebicDivider` para `RebicSeparator`.
- A galeria troca a página "RebicDivider" por "RebicSeparator", com uma barra que usa o separador vertical.

Fora do escopo:
- a forma do separador dentro do menu "mais" do `sap.m.OverflowToolbar` (horizontal, com margem), que entra com o
  overflow da barra;
- `role="separator"`: o `SemanticsRole` do Flutter não tem esse papel (conferido no SDK local), e o separador
  continua fora da árvore de semântica, como hoje.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-separator`: `RebicSeparator`, o `sap.m.ToolbarSeparator` do Rebic.

### Modified Capabilities

- `rebic/widgets/rebic-divider`: retirada (`retire_capabilities`). Todos os requisitos passam a `rebic-separator`.
- `rebic/foundation/density`: dimensão `separatorHeight` e primitivo 24.
- `rebic/widgets/rebic-card`, `rebic/widgets/rebic-dropdown`: dependência `rebic/widgets/rebic-separator`.
- `rebic/widgets/rebic-menu`, `rebic/widgets/rebic-popover`: dependência e separadores de seção e de cabeçalho/rodapé.
- `rebic/spec-governance`: exemplo do cenário "Widget sem foco".

Há um único widget público novo. As demais specs mudam só por citarem o divisor, e a densidade ganha a dimensão de
que o separador vertical precisa, como a altura de barra entrou com o `RebicBar`.

## Impact

- `packages/rebic_foundation`: `size24` em `RebicDensityPrimitives`, `separatorHeight` em `RebicDensityTokens`
  (construtor, `dimensions`, `copyWith`, `lerp`, igualdade), testes e CHANGELOG.
- `packages/rebic_widgets`:
  - `fundacao_layout/divider/` sai; entra `fundacao_layout/separator/`, com a exportação;
  - card, option list (dropdown e menu) e popover passam a usar `RebicSeparator`, sem mudança visual;
  - testes e goldens do separador; testes de card, menu e popover que procuram `RebicDivider` ou o tom;
  - CHANGELOG com o de/para.
- `apps/rebic_gallery`: página "RebicSeparator" no lugar de "RebicDivider"; a página do card troca o divisor.
- `docs/catalog.yaml`: sai `rebic/widgets/rebic-divider`; entra `rebic/widgets/rebic-separator` (P0, fase 1); card,
  dropdown, menu e popover passam a depender dele.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
