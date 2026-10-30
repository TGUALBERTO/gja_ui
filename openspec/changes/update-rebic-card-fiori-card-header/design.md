# Design: Card e cabeçalho de cartão no modelo do SAPUI5

## Context

O `RebicCard` atual (`fundacao_layout/card/rebic_card.dart`, 173 linhas):
- é um `RebicContainer` (base, borda, raio `tile` e sombra `card`) com uma `Column`: cabeçalho, `RebicDivider` e
  conteúdo com margem `spacing.l` opcional;
- monta o cabeçalho com `leading`, título `header4` em duas linhas, subtítulo e status;
- com `onHeaderPressed`, usa um `RebicInteractable` com `MergeSemantics` e `ExcludeSemantics`. Por isso o título
  deixa de ser anunciado como cabeçalho quando o cabeçalho é acionável.

Ele só é usado na página "RebicCard" da galeria e nos próprios testes.

No OpenUI5 (código conferido):
- **`CardBase`:** `width` 100%, `height` auto e `headingLevel` H3.
- **`Card`:** `header`, `headerPosition` (`Top`/`Bottom`) e `content`.
- **`Card.less`:** a borda e a sombra do cartão; a linha `sapTile_SeparatorColor` entre o cabeçalho e o conteúdo
  (embaixo do cabeçalho, ou em cima com `Bottom`); e o conteúdo sem padding próprio.
- **`cards/Header`:** título com `titleMaxLines` 3, subtítulo com `subtitleMaxLines` 2, `statusText`, ícone
  (`iconSrc`, `iconInitials`, `iconDisplayShape`, `iconSize` S, `iconAlt`, `iconVisible`) e, via `BaseHeader`,
  `dataTimestamp`, `statusVisible`, `toolbar` e o evento `press`.
- **`CardHeaders.less`:** padding de 1rem; título com `sapFontHeader5Size` em negrito; subtítulo no tamanho base;
  status e data no tamanho pequeno; segunda linha com `margin-top: 0.5rem`; hover e pressionado com as cores de tile.

## Goals / Non-Goals

**Goals:**
- Cartão e cabeçalho com os nomes do UI5. O título passa a ser anunciado com o nível também no cabeçalho
  acionável, corrigindo a perda de semântica de hoje.

**Non-Goals:**
- O cabeçalho numérico e os conteúdos especializados, que terão changes próprias.

## Decisions

### D1. Arquivos e tipos

- `fundacao_layout/card/rebic_card.dart`: `RebicCard` e `RebicCardHeaderPosition`.
- `fundacao_layout/card_header/rebic_card_header.dart`: `RebicCardHeader` e o `RebicCardHeadingScope` interno, que
  leva o `headingLevel` do cartão ao cabeçalho. O escopo fica no arquivo do cabeçalho e não no do cartão, para que o
  cabeçalho não dependa do cartão (o cartão já depende dele). A exportação usa `hide RebicCardHeadingScope`, como o
  `RebicBarScope`.

### D2. Cartão

```text
RebicContainer(base, border, radius tile, shadow card, clip)
└─ Column(min, stretch)
   ├─ RebicCardHeadingScope(level: headingLevel, child: header)   (top)
   ├─ RebicDivider()                                              (entre header e content, se os dois existem)
   └─ content
```

Com `bottom`, a ordem é `content`, `RebicDivider` e `header`. Sem `header`, não há linha. O conteúdo não ganha
`Padding`.

### D3. Cabeçalho: disposição

```text
Padding(spacing.l)
└─ Row(start, gap m)
   ├─ RebicAvatar(size: iconSize, shape, image|initials|icon, semanticLabel: iconAlt)   se iconVisible e houver fonte
   ├─ Expanded(Column(min, gap s))
   │  ├─ Row: Expanded(título: Text header5, maxLines titleMaxLines) + status (Text small, 1 linha)
   │  └─ Row: Expanded(subtítulo: Text base, maxLines subtitleMaxLines) + data (Text small, 1 linha)
   └─ toolbar
```

A segunda linha só aparece com subtítulo ou data. O título é um `Text` com os tokens, e não um `RebicTitle`: o UI5
usa um `sap.m.Text` com limite de linhas, que o `RebicTitle` não oferece. A semântica de cabeçalho vem de um
`Semantics(header: true, headingLevel:)` em volta do título.

### D4. Cabeçalho acionável

O bloco ícone + textos fica num `RebicInteractable`. O `toolbar` fica fora dele, para que os toques no toolbar não
cheguem a `onPress`. O fundo vem de `RebicControlColors.of(RebicControlFamily.list, colors).resolve(states)`.

A semântica fica num só nó, com `MergeSemantics`:
- `semanticLabel` "título, subtítulo" e a ação de toque, vindos do `RebicInteractable`;
- o `Semantics(header: true, headingLevel:)` do título, sem `ExcludeSemantics`, para que o nó funda os sinalizadores
  de botão e de cabeçalho.

Os textos visíveis entram com `ExcludeSemantics`, exceto o status e a data, que são somados ao rótulo. Sem
`onPress`, não há `RebicInteractable`, e cada texto tem a própria semântica.

O nível vem de `RebicCardHeadingScope.levelOf(context)`, que é `h3` fora de um cartão. Com `auto`, vale 3, como o
`_getAriaLevel` do UI5 sem estilo.

### D5. Migração da galeria

A página "RebicCard" troca `title`/`subtitle`/`status`/`leading`/`onHeaderPressed` por
`header: RebicCardHeader(...)`, e `child` por `content`, envolvido em `RebicSpacing.padding(all: l)` onde havia
margem. Ela ganha um cartão com o cabeçalho embaixo e um cabeçalho com `toolbar`.

### D6. Valores provisórios (ADR 0009)

| Valor | Adotado | Referência |
|---|---|---|
| Hover e pressionado do cabeçalho acionável | família `list` | `sapTile_Hover_Background` e `sapTile_Active_Background` |
| Espaço entre o ícone e os textos | `spacing.m` | margem do ícone em `CardHeaders.less`, não conferida no Horizon |
| Cor do subtítulo, do status e da data | `colors.label` | `sapTile_TextColor` |

## Risks / Trade-offs

- **[Um nó que funde botão e cabeçalho]** → os testes de semântica verificam os dois sinalizadores e o nível no
  mesmo nó. Se o merge perder o `headingLevel`, o título fica fora do `MergeSemantics` com `explicitChildNodes`.
- **[O cartão perde a margem do conteúdo]** → é o comportamento do UI5. A galeria e o dartdoc mostram o conteúdo
  envolvido em `RebicSpacing.padding`.
- **[Quem usava `RebicCard(title:, child:)` quebra]** → o CHANGELOG traz o de/para, e a spec traz a migração.

## Migration Plan

**BREAKING** em `rebic_widgets`.

| Antes | Agora |
|---|---|
| `RebicCard(title:, subtitle:, status:, leading:, onHeaderPressed:, child:)` | `RebicCard(header: RebicCardHeader(title:, subtitle:, statusText:, iconInitials:/icon:, onPress:), content: RebicSpacing.padding(all: RebicSpace.l, child: …))` |
| `padded: false` | `content` sem `RebicSpacing.padding` |

Para reverter, revertem-se os commits.
