# Spec Delta

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
- **THEN** aparecem, do início ao fim, "Situação:" no `GjaLabel` com `showColon`, o ícone e "Aprovado"

### Requirement: [Integração] Dependências
`GjaStatusIndicator` SHALL depender somente de `gja/widgets/gja-icon`, `gja/widgets/gja-label`, `gja/core/interaction`, `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/iconography`, `gja/foundation/spacing`, `gja/foundation/radius`, `gja/foundation/interaction-states`, `gja/foundation/theming` e `gja/foundation/accessibility`.

#### Scenario: Status sem Material
- **GIVEN** uma árvore criada apenas com `GjaApp`
- **WHEN** status normais, invertidos e ativos são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
