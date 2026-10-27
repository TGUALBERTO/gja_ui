# Proposal: RebicDivider (`rebic/widgets/rebic-divider`)

## Why

Listas, formulários, cabeçalhos, barras de ferramentas e cartões separam grupos de conteúdo com uma linha fina. Hoje
não há um widget para isso. A galeria usa a borda de um `RebicContainer`, e qualquer linha avulsa exigiria uma
espessura literal, que a verificação de tokens bloqueia.

No SAPUI5, essas linhas vêm de parâmetros de tema:
- `sapList_BorderColor` e `sapGroup_TitleBorderColor`;
- o `sap.m.ToolbarSeparator`, para separar ações numa barra.

`RebicDivider` é o equivalente:
- a cor é um papel do tema: `separator`, sutil e decorativo, ou `fieldBorder`, mais forte, com contraste ≥ 3:1;
- a espessura é a linha fina padrão;
- o espaço em volta e o recuo nas pontas são passos de espaçamento.

## What Changes

- Widget `RebicDivider` em `rebic_widgets`:
  - `RebicDivider()`: linha horizontal que ocupa a largura disponível;
  - `RebicDivider.vertical()`: linha vertical que ocupa a altura disponível, para barras e linhas;
  - `tone` (`RebicDividerTone`): `subtle` (`separator`, padrão) ou `strong` (`fieldBorder`);
  - `spacing` (`RebicSpace`): espaço antes e depois da linha, no eixo cruzado (padrão `none`);
  - `indent` e `endIndent` (`RebicSpace?`): recuo nas pontas da linha, com início e fim pela direção do texto;
  - fica fora da árvore de semântica, porque é decorativo.
- Goldens das duas orientações e dos dois tons, em claro e escuro e nas duas densidades.
- Página "RebicDivider" na galeria.

Fora do escopo:
- Divisores automáticos entre filhos de `RebicRow`/`RebicColumn`.
- Linha tracejada.
- Texto no meio da linha.
- Espessuras maiores.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-divider`: linha separadora horizontal ou vertical, com cor de papel, espaço em volta e recuo
  direcional nomeados pelo tema.

### Modified Capabilities

Nenhuma.

## Impact

- **Código:** `packages/rebic_widgets/lib/src/fundacao_layout/divider/`, testes e goldens.
- **Galeria:** nova página "RebicDivider".
- **Catálogo:** `rebic/widgets/rebic-divider` → `implemented`. A dependência existente (`color`) ganha `theming`,
  `spacing`, `density`, `accessibility` e `rebic/widgets/rebic-spacing`.
- **Portal existente:** sem impacto.
