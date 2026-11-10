# Proposal: Tipografia no modelo Fiori (`update-gja-foundation-typography-fiori-sizes`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou na tipografia a herança mais visível do Material: os estilos
`display`, `headline`, `title`, `subtitle`, `body`, `label` e `caption` são os papéis da escala do Material 3. O
SAPUI5 nomeia a tipografia pelos parâmetros de tema `sapFontHeader1Size`…`sapFontHeader6Size`, `sapFontLargeSize`,
`sapFontSize` e `sapFontSmallSize`, com famílias separadas para semibold e bold. Esta é a primeira de uma série de
changes de realinhamento da fundação; as seguintes tratam estados, sombras, movimento, densidade, espaçamento, raios,
ícones e breakpoints, uma por fundamento, conforme `gja/spec-governance`.

## What Changes

- **BREAKING** `GjaTypographyTokens`: os oito estilos viram onze, com nomes Fiori:
  - `header1`…`header6`, de 48 a 14, em negrito, como os títulos do Horizon;
  - `large` (16), `base` (14) e `small` (12), em peso regular;
  - `baseSemibold` e `baseBold` (14), para o texto de botões e os textos enfatizados.
- O antigo `label` (peso 500) some. Rótulos usam `base`, e a distinção vem da cor `colors.label`, como no
  `sap.m.Label`.
- Primitivos: entram `size48` e `lineHeight60`, para `header1`.
- Os widgets passam a usar os nomes novos:
  - `GjaButton` usa `baseSemibold`;
  - `GjaLink` usa `base`, e com `emphasized`, `baseBold`;
  - `GjaStatusIndicator` usa `base`;
  - `GjaBadge` usa `small`;
  - as iniciais de `GjaAvatar` usam `small`, `header4`, `header3`, `header2` e `header1`.
- `GjaText` mantém o enum `GjaTextVariant` nesta change e passa a mapear cada variante para um estilo Fiori. A
  troca do enum por `GjaTitle`/`GjaText`/`GjaLabel` fica para a change de realinhamento de `GjaText`.
- Valores do Horizon não confirmados (pesos e alturas de linha dos títulos) são provisórios e ficam registrados na
  ADR 0009, nova, que as próximas changes de realinhamento também usam.
- A página "Tipografia" da galeria e as demais páginas passam aos nomes novos; os goldens afetados são regerados.

Fora do escopo:
- A divisão de `GjaText` em `GjaTitle`, `GjaText` e `GjaLabel`.
- A fonte "72" e as famílias duplex: o GJA continua com a Inter empacotada (decisão provisória do protótipo).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/typography`: estilos semânticos com nomes Fiori, hierarquia, interpolação de exemplo e página
  da galeria.
- `gja/widgets/gja-text`: mapeamento de cada variante para um estilo Fiori.
- `gja/widgets/gja-button`, `gja/widgets/gja-link`, `gja/widgets/gja-status-indicator`,
  `gja/widgets/gja-badge` e `gja/widgets/gja-avatar`: os requisitos que citam estilos de tipografia passam
  aos nomes novos.

Esta change altera seis specs de widget, acima do limite de `gja/spec-governance`. A exceção se justifica porque a
renomeação de um fundamento quebra todas as referências a ele: sem atualizar as specs na mesma change, elas citariam
tokens inexistentes. Nenhum widget ganha API ou comportamento novo; só os tokens citados mudam.

## Impact

- `packages/gja_foundation`: primitivos e tokens de tipografia, testes de tipografia e de tema, CHANGELOG.
- `packages/gja_widgets`: `GjaText`, `GjaButton`, `GjaLink`, `GjaStatusIndicator`, `GjaBadge`,
  `GjaAvatar`, `GjaTheme`, os testes que citam estilos e os goldens afetados, CHANGELOG.
- `apps/gja_gallery`: página "Tipografia" e páginas que usam estilos pelo nome.
- `docs/adr`: ADR 0009 (valores provisórios do Horizon) e índice.
- Sem efeito em `gja_core`, no catálogo (os itens continuam `implemented`) e no portal.
