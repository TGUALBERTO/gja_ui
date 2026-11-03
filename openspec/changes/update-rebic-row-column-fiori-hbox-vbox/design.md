# Design: HBox e VBox no modelo do SAPUI5

## Context

- `fundacao_layout/flex/rebic_flex_alignment.dart` define `RebicMainAlignment` (`start`, `center`, `end`,
  `spaceBetween`) e `RebicCrossAlignment` (`start`, `center`, `end`, `stretch`).
- `fundacao_layout/flex/rebic_flex_layout.dart` (interno) monta um `Flex` com `spacing` e um `Wrap` com `spacing` e
  `runSpacing`; o `Wrap` usa o `crossAxisAlignment` padrão (`start`) e afirma que não há filhos `Flexible`.
- `RebicRow` tem o construtor `.wrap`; `RebicColumn` não quebra.
- Nenhum widget do framework usa `RebicRow`/`RebicColumn` no código, só no dartdoc (layout responsivo, separador).
  Os usos estão nos testes (cerca de 55) e na galeria (cerca de 70).

Veja proposal.md para a API do `sap.m.FlexBox` conferida.

## Goals / Non-Goals

**Goals:**
- Nomes de widget, propriedades e enums do `sap.m.HBox`/`VBox`/`FlexBox`.
- `spaceAround` e `baseline`.
- Nenhuma mudança de layout nos usos atuais.

**Non-Goals:**
- `RebicFlexBox` genérico, direção reversa, `alignContent`, `rowGap`/`columnGap`, `FlexItemData` (ver proposal.md).

## Decisions

### D1. Arquivos e nomes

- `fundacao_layout/flex/rebic_flex_alignment.dart` passa a `fundacao_layout/flex/rebic_flex_enums.dart`, com
  `RebicFlexJustifyContent`, `RebicFlexAlignItems` e `RebicFlexWrap`.
- `fundacao_layout/row/rebic_row.dart` → `fundacao_layout/hbox/rebic_hbox.dart`; `fundacao_layout/column/
  rebic_column.dart` → `fundacao_layout/vbox/rebic_vbox.dart`. Os testes seguem o mesmo caminho.
- As exportações de `rebic_widgets.dart` trocam na mesma posição.

Sem typedefs de compatibilidade: o Rebic é um protótipo, e todos os usos mudam na mesma change.

### D2. Mapeamento para o Flutter

| Rebic | `Flex` | `Wrap` |
|---|---|---|
| `justifyContent` `spaceAround` | `MainAxisAlignment.spaceAround` | `WrapAlignment.spaceAround` |
| `alignItems` `baseline` (HBox) | `CrossAxisAlignment.baseline` com `TextBaseline.alphabetic` | asserção |
| `alignItems` `baseline` (VBox) | `CrossAxisAlignment.start` | — |
| `alignItems` `stretch` | `CrossAxisAlignment.stretch` | asserção |
| `alignItems` `start`/`center`/`end` | o correspondente | `WrapCrossAlignment` correspondente |
| `displayInline` | `MainAxisSize.min` | — |

O `Flex` aplica `spacing` antes de distribuir o espaço livre, então `spaceBetween` e `spaceAround` somam ao `gap`,
como o `gap` do CSS com `justify-content`. No VBox, `baseline` vira `start` antes de chegar ao `Flex`, como no CSS de
uma coluna, em que `align-items: baseline` cai em `flex-start`.

`buildRebicWrap` passa a receber `alignItems` e afirma (`assert`) que não é `stretch` nem `baseline`, além da
asserção de filhos `Flexible` que já existe.

### D3. Padrões

`gap` continua `inlineGap`/`stackGap`, e `alignItems`, `center`/`start`. O UI5 usa `gap` vazio e `Stretch`: no
Rebic o espaço vem do tema, e `stretch` num eixo sem limite falha no Flutter (`BoxConstraints` infinitas). A
diferença fica no dartdoc dos dois widgets.

### D4. Migração dos usos

A troca é mecânica e guiada pelo analisador:
- `RebicRow(` → `RebicHBox(` e `RebicColumn(` → `RebicVBox(`, trocando só o argumento nomeado `children:` do
  próprio construtor por `items:` (um script que casa parênteses, para não tocar `children:` de widgets aninhados);
- `RebicRow.wrap(` → `RebicHBox(wrap: RebicFlexWrap.wrap, alignItems: RebicFlexAlignItems.start, ` — o `start`
  explícito preserva o alinhamento atual do `Wrap`;
- `mainAlignment:`, `crossAlignment:` e `shrinkWrap:` nesses construtores → `justifyContent:`, `alignItems:` e
  `displayInline:`; `RebicMainAlignment.` → `RebicFlexJustifyContent.`, `RebicCrossAlignment.` →
  `RebicFlexAlignItems.`.

`dart analyze` sem erros e os goldens sem diferença confirmam a migração.

### D5. Galeria

`RebicRowColumnPage` passa a `RebicHBoxVBoxPage` ("RebicHBox e RebicVBox", rota `/rebic-hbox-vbox`), com o novo
`spaceAround` e uma caixa com `baseline` (um `RebicTitle` e um `RebicText`).

## Risks / Trade-offs

- **[Quebra de API em cerca de 125 usos]** → todos no repositório (o portal não adota o Rebic); o CHANGELOG traz o
  de/para.
- **[Um `children:` aninhado trocado por engano]** → o analisador acusa o argumento desconhecido; os goldens acusam
  layout alterado.
- **[Baseline com itens sem texto]** → o `Flex` do Flutter usa a base da caixa para itens sem linha de base, como o
  CSS; não há tratamento especial.
