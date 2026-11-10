# Proposal: Estados de interação no modelo Fiori (`update-gja-foundation-interaction-states-fiori-alignment`)

## Why

A auditoria de fidelidade ao SAPUI5 de 2026-10-28 achou três heranças do Material nos estados de interação:
- o estado `dragged`, que no Material é um estado de "state layer" e não existe como estado de cor no Fiori;
- as opacidades primitivas 4, 8, 12, 16, 24 e 50%, que são as opacidades de "state layer" do Material 3 e não têm
  uso;
- as famílias `accept`, `reject` e `attention`, que usam o cinza neutro no hover e o azul `highlight` no ativo.

No Horizon, um botão Accept, Reject ou Attention continua na própria cor em todos os estados
(`sapButton_Accept_Hover_Background`, `sapButton_Accept_Active_Background` etc.). Esta é a segunda change da série
de realinhamento da fundação, depois da tipografia.

## What Changes

- **BREAKING** `GjaInteractionState` perde `dragged`. No Fiori, o arraste aparece pela sombra `dragged`, que
  continua em `gja/foundation/elevation`, e pelo indicador de soltura, que fica para o futuro arrastar e soltar.
  Fica a precedência `disabled` > `pressed` > `selected` + `hovered` > `selected` > `hovered`.
- **BREAKING** `GjaInteractionPrimitives` perde `opacity0`, `opacity4`, `opacity8`, `opacity12`, `opacity16`,
  `opacity24`, `opacity50` e `opacity100`. Fica só `opacity40` (`sapContent_DisabledOpacity`). As espessuras de
  traço não mudam.
- **BREAKING** `GjaValueStateColors` ganha o papel `hoverBackground`, o fundo de hover do estado, como
  `sapButton_Accept_Hover_Background`. Ele é definido para os cinco estados de valor, nos mapeamentos claro e
  escuro: um tom acima do `background` do estado na mesma escala primitiva.
- Famílias `accept`, `reject` e `attention`:
  - o hover passa a (`hoverBackground` do estado, borda do estado, `foreground` do estado);
  - o ativo, o selecionado e o selecionado com hover passam ao inverso do normal: (`foreground` do estado,
    `foreground` do estado, `background` do estado).
- A página "Estados" da galeria passa a mostrar as sete famílias, incluindo Accept, Reject e Attention.
- Os valores do Horizon não confirmados (tons de hover e cores do ativo das ações semânticas) entram como provisórios
  na ADR 0009.

Fora do escopo:
- O arrastar e soltar (indicador `sapContent_DragAndDropActiveColor`), que fica para um widget ou change de núcleo
  próprio.
- O foco em contraste sobre fundos de marca (`sapContent_ContrastFocusColor`).
- As cores de ativo das famílias `standard`, `emphasized`, `transparent` e `list`, que já seguem os parâmetros
  `sapButton_*` e `sapList_*` desde `update-gja-foundation-color-fiori-parameters`.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `gja/foundation/interaction-states`: conjunto de estados sem `dragged`, precedência de resolução, cores das
  famílias `accept`, `reject` e `attention`, e página "Estados" com as sete famílias.
- `gja/foundation/color`: o estado de valor ganha o papel `hoverBackground`, e a verificação de contraste passa a
  incluir o `foreground` de cada estado sobre esse fundo.

As duas specs mudam juntas porque a família semântica deriva suas cores do estado de valor. Sem o papel novo na spec
de cor, a spec de estados citaria um papel inexistente. Nenhum widget muda de spec: `GjaButton` já descreve o
hover e o ativo como os "da família do tipo".

## Impact

- `packages/gja_foundation`:
  - estados de interação, primitivos de interação, famílias de controle;
  - cores dos estados de valor e verificação de contraste;
  - testes correspondentes e CHANGELOG.
- `packages/gja_widgets`: nenhuma mudança de código. Os goldens de `GjaButton` com Accept, Reject ou Attention em
  hover ou ativo, se houver, são regerados, e o CHANGELOG registra a mudança visual.
- `apps/gja_gallery`: página "Estados" e seu teste.
- `docs/adr/0009-provisional-horizon-values.md`: novas linhas de valores provisórios.
- Sem efeito em `gja_core` (ele não usa `dragged`), no catálogo (os itens continuam `implemented`) e no portal.
