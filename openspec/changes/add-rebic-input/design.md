# Design: Campo de texto

## Decisions

### D1. Edição sem Material

`StatefulWidget` com um `TextEditingController` interno e o `FocusNode` recebido (ou interno). Em
`didUpdateWidget`, quando `value` difere do texto do controlador, o texto é trocado (cursor no fim). O campo é um
`EditableText` com o estilo `typography.base`, `cursorColor` `colors.brand`, `obscureText` para `password`,
`keyboardType` por tipo e `LengthLimitingTextInputFormatter(maxLength)` quando `maxLength` é maior que zero.
`readOnly` vem de `!editable`; desabilitado, o campo fica dentro de `IgnorePointer` e `ExcludeFocus`.

`onChanged` do `EditableText` chama `onLiveChange`; `onSubmitted` chama `onSubmit` e, se o texto mudou desde o último
aviso, `onChange`; a perda de foco também chama `onChange` nessa condição.

### D2. Moldura e estados

Um `MouseRegion` registra o hover; o foco vem do `FocusNode`. A moldura é um `DecoratedBox` (`radius.field`, borda
fina) com `Padding` horizontal `spacing.s` e altura mínima `controlHeight`, em volta de uma `Row` com o texto (e o
espaço reservado num `Stack`, fora da semântica) e o ícone de limpar (`Icon` `decline` com `GestureDetector` e `RebicTooltip`, fora do foco e da semântica, como no UI5, para não aumentar a altura da moldura com o alvo de um botão). A
borda é `brand` em hover ou foco, a do estado de valor quando há estado, senão `fieldBorder`. Com foco, a moldura fica
num `RebicFocusRing` visível.

| Situação | Fundo | Borda |
|---|---|---|
| normal | `base` | `fieldBorder` |
| hover / foco | `base` | `brand` |
| estado de valor | `stateColors.background` | `stateColors.border` (`brand` com foco) |
| somente leitura | `headerBackground` | `fieldBorder` |

### D3. Semântica e alvo

Um `MergeSemantics` com `Semantics(textField: true, label: semanticLabel ?? placeholder, hint: valueStateText,
readOnly: !editable)` envolve tudo, num só nó com o valor do `EditableText`. Esse nó fica num `ConstrainedBox` com a
altura mínima `density.minTargetSize`, com a moldura de `controlHeight` centrada, como o alvo do `RebicButton`. O
espaço reservado e o ícone de limpar ficam em `ExcludeSemantics`.
