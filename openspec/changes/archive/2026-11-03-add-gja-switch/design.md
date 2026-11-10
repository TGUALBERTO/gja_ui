# Design: Chave liga/desliga

## Decisions

### D1. Montagem

`MergeSemantics` + `GjaInteractable(toggled: state)` com um `AnimatedContainer` (o trilho) e um `AnimatedAlign`
(a alça, `AlignmentDirectional.centerStart`/`centerEnd`, que segue a direção do texto), com `motion.short` e
`motion.standard`. As durações vêm de `GjaThemeData.of`, que já zera o movimento quando ele é reduzido.

### D2. Medidas e cores

| Elemento | Adotado | Horizon |
|---|---|---|
| Trilho | `2 × icons.medium` por `icons.medium` (40 × 20), `radius.full` | `Switch.less` (não conferido no Horizon) |
| Alça | círculo `icons.control` (16), `colors.base` | `sapButton_Handle_Background` |
| Trilho desligado / hover | `fieldBorder` / `label` | `sapButton_Track_Background` / `_Hover_` |
| Trilho ligado / hover | `brand` / `brandHover` | `sapButton_Track_Selected_Background` / `_Hover_` |

As medidas e as cores de hover entram no ADR 0009.
