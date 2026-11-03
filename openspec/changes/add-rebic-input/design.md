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
espaço reservado num `Stack`, fora da semântica) e o botão de limpar (`RebicButton` só com ícone, `transparent`). A
borda é `brand` em hover ou foco, a do estado de valor quando há estado, senão `fieldBorder`. Com foco, a moldura fica
num `RebicFocusRing` visível.

| Situação | Fundo | Borda |
|---|---|---|
| normal | `base` | `fieldBorder` |
| hover / foco | `base` | `brand` |
| estado de valor | `stateColors.background` | `stateColors.border` (`brand` com foco) |
| somente leitura | `headerBackground` | `fieldBorder` |

### D3. Semântica

Um `Semantics(textField: true, label: semanticLabel ?? placeholder, hint: valueStateText, readOnly: !editable)`
envolve o `EditableText`, que fornece o valor; o espaço reservado fica em `ExcludeSemantics`.
