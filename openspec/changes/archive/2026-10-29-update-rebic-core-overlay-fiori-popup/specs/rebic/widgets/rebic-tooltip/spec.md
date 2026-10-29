## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicTooltip` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `message` | `String` | obrigatória |
| `child` | `Widget` | obrigatória |
| `placement` | `RebicPlacement` | `bottom` |
| `excludeFromSemantics` | `bool` | `false` |

#### Scenario: Tooltip mínimo
- **GIVEN** um `RebicTooltip` com `message` "Editar pedido" em volta de um ícone
- **WHEN** o ponteiro fica sobre o ícone além do atraso de abertura
- **THEN** a dica "Editar pedido" aparece abaixo do ícone, centralizada nele e afastada `spacing.xs`
