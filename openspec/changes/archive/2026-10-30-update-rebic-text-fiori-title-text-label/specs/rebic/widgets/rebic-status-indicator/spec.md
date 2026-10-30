# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicStatusIndicator` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String?` | `null` |
| `icon` | `IconData?` | `null` |
| `title` | `String?` | `null` |
| `state` | `RebicValueState` | `none` |
| `inverted` | `bool` | `false` |
| `onPressed` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Status mínimo
- **WHEN** `RebicStatusIndicator(text: 'Aprovado', state: RebicValueState.success)` é renderizado
- **THEN** "Aprovado" aparece na cor de frente do estado `success`, no estilo `typography.base`, sem fundo

#### Scenario: Status com título e ícone
- **GIVEN** `title` "Situação", `icon` e `text` "Aprovado", em LTR
- **WHEN** o status é renderizado
- **THEN** aparecem, do início ao fim, "Situação:" no `RebicLabel` com `showColon`, o ícone e "Aprovado"

### Requirement: [Integração] Dependências
`RebicStatusIndicator` SHALL depender somente de `rebic/widgets/rebic-icon`, `rebic/widgets/rebic-label`, `rebic/core/interaction`, `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/iconography`, `rebic/foundation/spacing`, `rebic/foundation/radius`, `rebic/foundation/interaction-states`, `rebic/foundation/theming` e `rebic/foundation/accessibility`.

#### Scenario: Status sem Material
- **GIVEN** uma árvore criada apenas com `RebicApp`
- **WHEN** status normais, invertidos e ativos são renderizados e tocados
- **THEN** não ocorrem exceções relacionadas a ancestrais Material ou Cupertino
