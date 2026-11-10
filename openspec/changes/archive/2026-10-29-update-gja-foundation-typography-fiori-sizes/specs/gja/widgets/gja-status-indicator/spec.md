## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaStatusIndicator` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String?` | `null` |
| `icon` | `IconData?` | `null` |
| `title` | `String?` | `null` |
| `state` | `GjaValueState` | `none` |
| `inverted` | `bool` | `false` |
| `onPressed` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Status mínimo
- **WHEN** `GjaStatusIndicator(text: 'Aprovado', state: GjaValueState.success)` é renderizado
- **THEN** "Aprovado" aparece na cor de frente do estado `success`, no estilo `typography.base`, sem fundo

#### Scenario: Status com título e ícone
- **GIVEN** `title` "Situação", `icon` e `text` "Aprovado", em LTR
- **WHEN** o status é renderizado
- **THEN** aparecem, do início ao fim, "Situação:" no tom `muted`, o ícone e "Aprovado"

### Requirement: [Aparência] Tokens de componente
O texto SHALL usar `typography.base`, o ícone `icons.inline`, o espaço entre título, ícone e texto `spacing.xs`, sem valores literais.

#### Scenario: Ícone acompanha a escala de texto
- **GIVEN** a escala de texto 2,0
- **WHEN** um status com ícone é renderizado
- **THEN** o ícone é maior que `icons.inline`, e não há estouro
