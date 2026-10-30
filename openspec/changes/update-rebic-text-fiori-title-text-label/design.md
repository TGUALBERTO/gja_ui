# Design: Título, texto e rótulo no modelo do SAPUI5

## Context

O `RebicText` atual (em `fundacao_layout/text/rebic_text.dart`) é um `Semantics(header:)` em volta de um `Text`. O
estilo vem de `RebicTextVariant` e a cor, de `RebicTextTone`, que inclui as cores de estado de valor. As variantes
`display`, `headline` e `title` são cabeçalho por padrão, e `heading` troca isso.

Usam as variantes, os tons ou `heading`:

| Widget | Uso atual | Destino (proposal.md) |
|---|---|---|
| `RebicPopover` | título `subtitle` + `heading: true` | `RebicTitle`, estilo H4 |
| `RebicScaffold` | título `title` | `RebicTitle`, estilo H3 |
| `RebicTooltip` | mensagem `label` | `RebicText` |
| `RebicStatusIndicator` | `'$title:'` com tom `muted` | `RebicLabel` com `showColon` |
| `RebicCard` | título `subtitle` + `heading` + `maxLines: 2`; subtítulo `muted` com `maxLines: 2`; status `label` + `muted` | `Text` com tokens |
| `RebicPage` | título `headline` + `maxLines: 2`; subtítulo `muted` + `maxLines: 1` | `Text` com tokens |
| `RebicBadge` | contador `caption` + tom do estado | `Text` com tokens |

Os dartdocs de `RebicRow`, `RebicColumn`, `RebicContainer`, `RebicDivider` e `RebicSpacing` têm exemplos com
variantes. Na galeria, 23 páginas usam `RebicText`.

O que a fundação já oferece:
- `RebicTypographyTokens` tem `header1`…`header6`, `base`, `baseSemibold`, `baseBold` e `small`;
- `RebicLocalizations.required` existe ("Obrigatório" / "Required");
- o `Semantics` do Flutter aceita `headingLevel` de 0 a 6, em que 0 é "sem nível";
- as escalas primitivas de cor são neutro, azul, verde, âmbar, vermelho e ciano, sem rosa ou magenta.

## Goals / Non-Goals

**Goals:**
- Três widgets pequenos e sem estado, cada um com um único caminho de estilo e cor, sem enum de tom.
- Rótulo com os sinais `:` e `*` sempre visíveis, como no `sap.m.Label`.
- Nenhuma mudança visual nos widgets migrados. Os goldens desses widgets não mudam.

**Non-Goals:**
- Um widget base comum aos três. Cada um tem menos de 100 linhas, e um base exporia parâmetros de estilo que as
  specs proíbem.
- Uma escala primitiva rosa para o `required`. Ver D5.
- Alias de compatibilidade para `RebicTextVariant` e `RebicTextTone`. A API é 0.x.

## Decisions

### D1. Arquivos e exportações

Cada widget tem a própria pasta em `fundacao_layout`, como os demais:
- `text/rebic_text.dart` (reescrito);
- `title/rebic_title.dart`, com `RebicTitle` e `RebicTitleLevel`;
- `label/rebic_label.dart`, com `RebicLabel` e `RebicLabelDesign`.

Os testes espelham as pastas. O barrel de `rebic_widgets` exporta os três. Os três ficam em `rebic_widgets`, e não
em `rebic_foundation`, porque o rótulo depende de `rebic_core` (localização).

### D2. `RebicText`

`Text(text, style: typography.base.copyWith(color: colors.text), textAlign:)`, sem `Semantics` próprio. As linhas:

| `wrapping` | `maxLines` | `maxLines` do `Text` | `overflow` |
|---|---|---|---|
| `true` | nulo | nulo | `clip` |
| `true` | n | n | `ellipsis` |
| `false` | ignorado | 1 | `ellipsis` |

O `assert` de `maxLines > 0` continua, com a mensagem citando `maxLines`. O texto completo chega ao leitor de tela
pelo próprio `Text`, que não trunca a semântica.

### D3. `RebicTitle` e o nível do cabeçalho

```dart
enum RebicTitleLevel { auto, h1, h2, h3, h4, h5, h6 }
```

O widget é `Semantics(header: true, headingLevel: level.index, child: Text(...))`. Com `auto` (índice 0), o
`headingLevel` fica 0, que o Flutter trata como "sem nível". O estilo vem de `titleStyle` por um `switch`, com
`auto` → `header5`. Sem `wrapping`, o `Text` tem `maxLines: 1` e reticências. Com `wrapping`, não tem limite.

Alternativa considerada: dois enums, um de nível e outro de estilo. Rejeitada porque o `sap.m.Title` usa o mesmo
`TitleLevel` nas duas propriedades.

### D4. `RebicLabel`: sinais visíveis e semântica

Os sinais não entram no texto truncado. Sem `wrapping`:

```text
Row(mainAxisSize: min, crossAxisAlignment: baseline)
├─ Flexible(Text(text, maxLines: 1, ellipsis))
├─ Text(':')        se showColon
└─ Text('*')        se required, com colors.required
```

Assim o `:` e o `*` ficam no fim mesmo quando o texto tem reticências, como o `::after` do `sap.m.Label`. Com
`wrapping`, um só `Text.rich` com três `TextSpan`, para que os sinais acompanhem a última linha.

O `textAlign` vale para o `Text` sem sinais. Com sinais e sem `wrapping`, a `Row` é alinhada por um `Align` com o
`AlignmentDirectional` correspondente ao `textAlign`.

A semântica é montada à mão: `Semantics(label: '$text${showColon ? ':' : ''}${required ? ', $obrigatório' : ''}',
excludeSemantics: true)`, em que `obrigatório` vem de `RebicLocalizations.of(context).required`. Com isso, o
asterisco não é lido como "asterisco", e o rótulo não é cabeçalho.

O asterisco tem o estilo do texto (`base` ou `baseBold`) com a cor `required`, e não o tamanho maior do Horizon. O
`sap.m.Label` posiciona o asterisco de forma absoluta, o que não cabe nas regras de layout do Rebic. Fica registrado
no ADR 0009.

Alternativa considerada: só `Text.rich` nos dois casos. Rejeitada porque as reticências cortariam também os sinais.

### D5. Papel `required`

Novo campo `required` em `RebicColorTokens`, em todos os pontos do contrato (`copyWith`, `lerp`, `==`, `hashCode`,
`debugFillProperties`) e no par de contraste de texto sobre `background`, `base` e `headerBackground`.

| Mapeamento | Primitivo | Contraste sobre `base` / `background` / `headerBackground` |
|---|---|---|
| Claro | `red600` | 7,21 / 6,79 / 6,32 |
| Escuro | `red300` | 6,16 / 6,89 / 4,79 |

No Horizon, `sapField_RequiredColor` é magenta, distinto do vermelho de erro. Não há escala magenta nos primitivos, e
criar uma para um único papel aumentaria o escopo da fundação. O vermelho fica como valor provisório no ADR 0009,
com a referência `sapField_RequiredColor`. Os números da tabela são conferidos pelo teste de contraste da fundação.

Alternativa considerada: nova escala `magenta`. Fica para quando outro papel precisar dela.

### D6. Widgets que desenham o texto com tokens

`RebicCard`, `RebicPage` e `RebicBadge` passam a usar `Text` com o estilo e a cor do tema, preservando o que fazem
hoje:
- o título do cartão: `Semantics(header: true)` com `header4`, `colors.text` e `maxLines: 2`;
- o título da página: `Semantics(header: true)` com `header2`, `colors.text` e `maxLines: 2`. A variante `headline`
  já era cabeçalho;
- o subtítulo e o status do cartão e o subtítulo da página: `base` com `colors.label`;
- o contador do selo: `small` com o `foreground` do estado.

Cada um ganha um comentário curto apontando a change futura do widget. O `_tone` do selo sai.

### D7. Migração da galeria

| Uso atual | Novo |
|---|---|
| `variant: title` / `subtitle` em títulos de seção | `RebicTitle` com `titleStyle` `h3` / `h4` e `level` `h2` / `h3` |
| `body`, `bodyStrong` | `RebicText` (o `bodyStrong` vira `RebicLabel` com `design: bold` quando é rótulo) |
| `label`, `caption`, tom `muted` | `RebicLabel` |
| tons de estado | `RebicStatusIndicator` |

O `caption` passa de `small` para `base` na galeria. É a única mudança visual da change, e só nas páginas da
galeria.

## Risks / Trade-offs

- [O `headingLevel` só é aplicado na web e em algumas plataformas] → os testes verificam o `SemanticsNode`
  (`headingLevel`), o que vale em todas as plataformas.
- [A `Row` do rótulo muda a largura intrínseca quando não há espaço] → o `Flexible` encolhe só o texto, e o teste
  "Sinais com texto truncado" cobre a largura mínima.
- [O `required` vermelho se confunde com o erro] → é provisório (ADR 0009). O asterisco nunca aparece sozinho como
  indicador de erro, que usa o estado de valor do campo.
- [Goldens de widgets migrados mudarem por engano] → a suíte `golden` de `rebic_widgets` roda antes de regerar
  qualquer imagem. Só os goldens de `RebicText`, `RebicTitle`, `RebicLabel` e da galeria podem mudar.
- [Muitos arquivos tocados na galeria] → a migração é mecânica, guiada pela tabela de D7, e o analisador acusa
  qualquer uso restante de `variant`, `tone` ou `heading`.

## Migration Plan

A change é **BREAKING** para quem usa `variant`, `tone` ou `heading` do `RebicText`. O CHANGELOG de `rebic_widgets`
traz o de/para do requisito removido "[Aparência] Tokens de componente" da spec de `rebic-text`. Não há código do
portal afetado. Reverter é reverter os commits da change.
