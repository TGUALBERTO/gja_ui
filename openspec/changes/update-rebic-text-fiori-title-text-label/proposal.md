# Proposal: Título, texto e rótulo no modelo do SAPUI5 (`update-rebic-text-fiori-title-text-label`)

## Why

O `RebicText` junta num só widget três controles distintos do SAPUI5:
- o `sap.m.Title` (variantes `display`, `headline`, `title` e `subtitle`);
- o `sap.m.Text` (`body` e `bodyStrong`);
- o `sap.m.Label` (`label` e o tom `muted`).

Ele também tem um tamanho que o `sap.m` não oferece (`caption`, `small`) e tons de estado de valor, que no SAPUI5 são do
`sap.m.ObjectStatus`, e não do texto. Os nomes `display`, `headline`, `body` e `caption` vêm da escala do Material, que
o projeto evita.

No SAPUI5, cada um dos três tem API e aparência próprias:
- o `Title` separa o nível semântico (`level`, H1 a H6) do estilo visual (`titleStyle`) e, sem quebra, termina com
  reticências;
- o `Text` tem cor e tamanho fixos, com `maxLines` e `wrapping`;
- o `Label` tem a cor `sapContent_LabelColor`, o negrito opcional (`design`), o asterisco de obrigatório (`required`)
  na cor `sapField_RequiredColor` e os dois-pontos (`showColon`).

Esta é a primeira change do bloco de layout do realinhamento ao SAPUI5.

## What Changes

- **BREAKING** `RebicText` passa a ser o `sap.m.Text`. Ele fica com `text` (posicional), `maxLines`, `wrapping`
  (padrão `true`) e `textAlign`, sempre com `typography.base` e `colors.text`. Saem:
  - `variant` e o enum `RebicTextVariant`;
  - `tone` e o enum `RebicTextTone`;
  - `heading`.

  Sem `wrapping`, o texto fica em uma linha com reticências.
- Novo `RebicTitle`, como o `sap.m.Title`, com estas propriedades:
  - `text` (posicional);
  - `level` (`RebicTitleLevel`: `auto`, `h1`…`h6`; padrão `auto`): só a semântica, sempre anunciado como cabeçalho
    e com o nível informado;
  - `titleStyle` (`RebicTitleLevel`; padrão `auto`, que é o estilo H5): só o estilo, mapeado para os estilos
    `header1`…`header6`;
  - `wrapping` (padrão `false`: uma linha com reticências);
  - `textAlign`.

  A cor é `colors.text`, que é o `sapTitleColor` do Horizon.
- Novo `RebicLabel`, como o `sap.m.Label`, com estas propriedades:
  - `text` (posicional);
  - `design` (`RebicLabelDesign`: `standard`, `bold`; padrão `standard`);
  - `required`: asterisco depois do texto, e "Obrigatório" no leitor de tela;
  - `showColon`: dois-pontos depois do texto e antes do asterisco;
  - `wrapping` (padrão `false`);
  - `textAlign`.

  O texto usa `typography.base` (ou `baseBold`) com `colors.label`.
- Fundação de cor: novo papel `required` (`sapField_RequiredColor`), para o asterisco do rótulo, com contraste
  ≥ 4,5:1 sobre `background`, `base` e `headerBackground`. O valor entra como provisório no ADR 0009.
- Os widgets passam aos três controles, sem mudança visual:
  - `RebicPopover`: o título passa a `RebicTitle` com estilo H4;
  - `RebicScaffold`: o título passa a `RebicTitle` com estilo H3;
  - `RebicTooltip`: a mensagem passa a `RebicText`;
  - `RebicStatusIndicator`: o título passa a `RebicLabel` com `showColon`, como o título do `sap.m.ObjectStatus`;
  - `RebicCard`, `RebicPage` e `RebicBadge` desenham o título, o subtítulo e o texto do cabeçalho com os tokens do
    tema, como fazem os controles do SAPUI5 com estilos internos. Os motivos:
    - o título do cartão e o da página quebram em até duas linhas, o que o `sap.m.Title` não oferece;
    - o selo usa o tamanho `small`.

    Esses três serão revistos nas changes de cartão, página e selo.
- A galeria troca a página "RebicText" por três páginas: "RebicTitle", "RebicText" e "RebicLabel". As demais páginas
  passam aos três controles:
  - os títulos de seção usam `RebicTitle` com níveis explícitos e o mesmo estilo de antes;
  - as legendas e os textos secundários usam `RebicLabel`.

  Os goldens afetados são regerados.

Fora do escopo:
- `labelFor` do `Label`, que associa o rótulo a um campo. Ele entra com os campos de entrada.
- `wrappingType` (hifenização), `renderWhitespace`, `emptyIndicatorMode` e `width`.
- Rever o título do cartão e da página e o texto do selo no modelo do SAPUI5. Isso fica para as changes desses
  widgets.

## Capabilities

### New Capabilities

- `rebic/widgets/rebic-title`: `RebicTitle`, o `sap.m.Title` do Rebic.
- `rebic/widgets/rebic-label`: `RebicLabel`, o `sap.m.Label` do Rebic.

### Modified Capabilities

- `rebic/widgets/rebic-text`: passa a ser só o `sap.m.Text`, sem variantes, tons nem cabeçalho, e com `wrapping`.
- `rebic/foundation/color`: papel `required` e o par de contraste dele.
- `rebic/widgets/rebic-popover` e `rebic/widgets/rebic-scaffold`: dependem de `rebic-title` em vez de `rebic-text`.
- `rebic/widgets/rebic-status-indicator`: título com `RebicLabel` e dois-pontos, e dependência de `rebic-label` em vez
  de `rebic-text`.
- `rebic/widgets/rebic-tooltip`: texto da dica com `RebicText`.
- `rebic/widgets/rebic-page`, `rebic/widgets/rebic-dropdown` e `rebic/widgets/rebic-menu`: a aparência é descrita
  pelos estilos e cores do tema, e não mais pelas variantes e tons que deixam de existir.

O título, o texto e o rótulo formam uma unidade inseparável, como pede `rebic/spec-governance` para uma change com até
três specs de widget. As três specs substituem juntas o `RebicText` atual. Nenhuma pode ser arquivada sozinha:
- um `RebicText` sem variantes, sem os outros dois, deixa os títulos e rótulos dos widgets sem widget;
- o `RebicTitle` ou o `RebicLabel` sozinho duplica o que o `RebicText` atual ainda faz.

A change toca também sete specs de outros widgets, acima do limite. A exceção se justifica como nas changes de
tipografia, sombras e raios: remover as variantes e os tons quebra as referências a eles. Nenhum desses widgets muda
de API.

## Impact

- `packages/rebic_foundation`: papel `required` em `RebicColorTokens` (claro e escuro), `copyWith`, `lerp`, contraste
  e testes.
- `packages/rebic_widgets`:
  - `rebic_text.dart` reescrito, e novos `rebic_title.dart` e `rebic_label.dart` em `fundacao_layout`, com
    exportações;
  - migração de card, page, scaffold, popover, tooltip, status indicator e badge;
  - exemplos de dartdoc de row, column, container, divider e spacing;
  - testes e goldens.
- `apps/rebic_gallery`: páginas "RebicTitle", "RebicText" e "RebicLabel", migração das demais páginas e testes.
- `docs/catalog.yaml`: entradas `rebic/widgets/rebic-title` e `rebic/widgets/rebic-label`, e as dependências dos
  widgets migrados.
- `docs/adr/0009-provisional-horizon-values.md`: valor de `required`.
- CHANGELOGs de `rebic_foundation` e `rebic_widgets`.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
