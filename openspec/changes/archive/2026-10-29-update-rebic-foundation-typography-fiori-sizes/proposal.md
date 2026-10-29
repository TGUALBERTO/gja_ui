# Proposal: Tipografia no modelo Fiori (`update-rebic-foundation-typography-fiori-sizes`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou na tipografia a herança mais visível do Material: os estilos
`display`, `headline`, `title`, `subtitle`, `body`, `label` e `caption` são os papéis da escala do Material 3. O
SAPUI5 nomeia a tipografia pelos parâmetros de tema `sapFontHeader1Size`…`sapFontHeader6Size`, `sapFontLargeSize`,
`sapFontSize` e `sapFontSmallSize`, com famílias separadas para semibold e bold. Esta é a primeira de uma série de
changes de realinhamento da fundação; as seguintes tratam estados, sombras, movimento, densidade, espaçamento, raios,
ícones e breakpoints, uma por fundamento, conforme `rebic/spec-governance`.

## What Changes

- **BREAKING** `RebicTypographyTokens`: os oito estilos viram onze, com nomes Fiori:
  - `header1`…`header6`, de 48 a 14, em negrito, como os títulos do Horizon;
  - `large` (16), `base` (14) e `small` (12), em peso regular;
  - `baseSemibold` e `baseBold` (14), para o texto de botões e os textos enfatizados.
- O antigo `label` (peso 500) some. Rótulos usam `base`, e a distinção vem da cor `colors.label`, como no
  `sap.m.Label`.
- Primitivos: entram `size48` e `lineHeight60`, para `header1`.
- Os widgets passam a usar os nomes novos:
  - `RebicButton` usa `baseSemibold`;
  - `RebicLink` usa `base`, e com `emphasized`, `baseBold`;
  - `RebicStatusIndicator` usa `base`;
  - `RebicBadge` usa `small`;
  - as iniciais de `RebicAvatar` usam `small`, `header4`, `header3`, `header2` e `header1`.
- `RebicText` mantém o enum `RebicTextVariant` nesta change e passa a mapear cada variante para um estilo Fiori. A
  troca do enum por `RebicTitle`/`RebicText`/`RebicLabel` fica para a change de realinhamento de `RebicText`.
- Valores do Horizon não confirmados (pesos e alturas de linha dos títulos) são provisórios e ficam registrados na
  ADR 0009, nova, que as próximas changes de realinhamento também usam.
- A página "Tipografia" da galeria e as demais páginas passam aos nomes novos; os goldens afetados são regerados.

Fora do escopo:
- A divisão de `RebicText` em `RebicTitle`, `RebicText` e `RebicLabel`.
- A fonte "72" e as famílias duplex: o Rebic continua com a Inter empacotada (decisão provisória do protótipo).

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `rebic/foundation/typography`: estilos semânticos com nomes Fiori, hierarquia, interpolação de exemplo e página
  da galeria.
- `rebic/widgets/rebic-text`: mapeamento de cada variante para um estilo Fiori.
- `rebic/widgets/rebic-button`, `rebic/widgets/rebic-link`, `rebic/widgets/rebic-status-indicator`,
  `rebic/widgets/rebic-badge` e `rebic/widgets/rebic-avatar`: os requisitos que citam estilos de tipografia passam
  aos nomes novos.

Esta change altera seis specs de widget, acima do limite de `rebic/spec-governance`. A exceção se justifica porque a
renomeação de um fundamento quebra todas as referências a ele: sem atualizar as specs na mesma change, elas citariam
tokens inexistentes. Nenhum widget ganha API ou comportamento novo; só os tokens citados mudam.

## Impact

- `packages/rebic_foundation`: primitivos e tokens de tipografia, testes de tipografia e de tema, CHANGELOG.
- `packages/rebic_widgets`: `RebicText`, `RebicButton`, `RebicLink`, `RebicStatusIndicator`, `RebicBadge`,
  `RebicAvatar`, `RebicTheme`, os testes que citam estilos e os goldens afetados, CHANGELOG.
- `apps/rebic_gallery`: página "Tipografia" e páginas que usam estilos pelo nome.
- `docs/adr`: ADR 0009 (valores provisórios do Horizon) e índice.
- Sem efeito em `rebic_core`, no catálogo (os itens continuam `implemented`) e no portal.
