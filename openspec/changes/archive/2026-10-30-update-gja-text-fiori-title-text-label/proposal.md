# Proposal: Título, texto e rótulo no modelo do SAPUI5 (`update-gja-text-fiori-title-text-label`)

## Why

O `GjaText` junta num só widget três controles distintos do SAPUI5:
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

- **BREAKING** `GjaText` passa a ser o `sap.m.Text`. Ele fica com `text` (posicional), `maxLines`, `wrapping`
  (padrão `true`) e `textAlign`, sempre com `typography.base` e `colors.text`. Saem:
  - `variant` e o enum `GjaTextVariant`;
  - `tone` e o enum `GjaTextTone`;
  - `heading`.

  Sem `wrapping`, o texto fica em uma linha com reticências.
- Novo `GjaTitle`, como o `sap.m.Title`, com estas propriedades:
  - `text` (posicional);
  - `level` (`GjaTitleLevel`: `auto`, `h1`…`h6`; padrão `auto`): o nível anunciado do cabeçalho. Com `auto`, o
    nível é o do `titleStyle`, ou 2 se ele também for `auto`, como no `sap.m.Title`;
  - `titleStyle` (`GjaTitleLevel`; padrão `auto`, que é o estilo H5): só o estilo, mapeado para os estilos
    `header1`…`header6`;
  - `wrapping` (padrão `false`: uma linha com reticências);
  - `textAlign`.

  A cor é `colors.text`, que é o `sapTitleColor` do Horizon.
- Novo `GjaLabel`, como o `sap.m.Label`, com estas propriedades:
  - `text` (posicional);
  - `design` (`GjaLabelDesign`: `standard`, `bold`; padrão `standard`);
  - `required`: asterisco depois do texto, e "Obrigatório" no leitor de tela;
  - `showColon`: dois-pontos depois do texto e antes do asterisco;
  - `wrapping` (padrão `false`);
  - `textAlign`.

  O texto usa `typography.base` (ou `baseBold`) com `colors.label`.
- Fundação de cor: novo papel `required` (`sapField_RequiredColor`), para o asterisco do rótulo, com contraste
  ≥ 4,5:1 sobre `background`, `base` e `headerBackground`. O valor entra como provisório no ADR 0009.
- Os widgets passam aos três controles, sem mudança visual:
  - `GjaPopover`: o título passa a `GjaTitle` com estilo H4;
  - `GjaScaffold`: o título passa a `GjaTitle` com estilo H3;
  - `GjaTooltip`: a mensagem passa a `GjaText`;
  - `GjaStatusIndicator`: o título passa a `GjaLabel` com `showColon`, como o título do `sap.m.ObjectStatus`;
  - `GjaCard`, `GjaPage` e `GjaBadge` desenham o título, o subtítulo e o texto do cabeçalho com os tokens do
    tema, como fazem os controles do SAPUI5 com estilos internos. Os motivos:
    - o título do cartão e o da página quebram em até duas linhas, o que o `sap.m.Title` não oferece;
    - o selo usa o tamanho `small`.

    Esses três serão revistos nas changes de cartão, página e selo.
- A galeria troca a página "GjaText" por três páginas: "GjaTitle", "GjaText" e "GjaLabel". As demais páginas
  passam aos três controles:
  - os títulos de seção usam `GjaTitle` com níveis explícitos e o mesmo estilo de antes;
  - as legendas e os textos secundários usam `GjaLabel`.

  Os goldens afetados são regerados.

Fora do escopo:
- `labelFor` do `Label`, que associa o rótulo a um campo. Ele entra com os campos de entrada.
- `wrappingType` (hifenização), `renderWhitespace`, `emptyIndicatorMode` e `width`.
- Rever o título do cartão e da página e o texto do selo no modelo do SAPUI5. Isso fica para as changes desses
  widgets.

## Capabilities

### New Capabilities

- `gja/widgets/gja-title`: `GjaTitle`, o `sap.m.Title` do GJA.
- `gja/widgets/gja-label`: `GjaLabel`, o `sap.m.Label` do GJA.

### Modified Capabilities

- `gja/widgets/gja-text`: passa a ser só o `sap.m.Text`, sem variantes, tons nem cabeçalho, e com `wrapping`.
- `gja/foundation/color`: papel `required` e o par de contraste dele.
- `gja/widgets/gja-popover` e `gja/widgets/gja-scaffold`: dependem de `gja-title` em vez de `gja-text`.
- `gja/widgets/gja-status-indicator`: título com `GjaLabel` e dois-pontos, e dependência de `gja-label` em vez
  de `gja-text`.
- `gja/widgets/gja-tooltip`: texto da dica com `GjaText`.
- `gja/widgets/gja-page`, `gja/widgets/gja-dropdown` e `gja/widgets/gja-menu`: a aparência é descrita
  pelos estilos e cores do tema, e não mais pelas variantes e tons que deixam de existir.

O título, o texto e o rótulo formam uma unidade inseparável, como pede `gja/spec-governance` para uma change com até
três specs de widget. As três specs substituem juntas o `GjaText` atual. Nenhuma pode ser arquivada sozinha:
- um `GjaText` sem variantes, sem os outros dois, deixa os títulos e rótulos dos widgets sem widget;
- o `GjaTitle` ou o `GjaLabel` sozinho duplica o que o `GjaText` atual ainda faz.

A change toca também sete specs de outros widgets, acima do limite. A exceção se justifica como nas changes de
tipografia, sombras e raios: remover as variantes e os tons quebra as referências a eles. Nenhum desses widgets muda
de API.

## Impact

- `packages/gja_foundation`: papel `required` em `GjaColorTokens` (claro e escuro), `copyWith`, `lerp`, contraste
  e testes.
- `packages/gja_widgets`:
  - `gja_text.dart` reescrito, e novos `gja_title.dart` e `gja_label.dart` em `fundacao_layout`, com
    exportações;
  - migração de card, page, scaffold, popover, tooltip, status indicator e badge;
  - exemplos de dartdoc de row, column, container, divider e spacing;
  - testes e goldens.
- `apps/gja_gallery`: páginas "GjaTitle", "GjaText" e "GjaLabel", migração das demais páginas e testes.
- `docs/catalog.yaml`: entradas `gja/widgets/gja-title` e `gja/widgets/gja-label`, e as dependências dos
  widgets migrados.
- `docs/adr/0009-provisional-horizon-values.md`: valor de `required`.
- CHANGELOGs de `gja_foundation` e `gja_widgets`.
- Portal existente: nenhum impacto. A change é do framework e não altera o portal.
