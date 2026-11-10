## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaTooltip` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `message` | `String` | obrigatória |
| `child` | `Widget` | obrigatória |
| `placement` | `GjaPlacement` | `bottom` |
| `excludeFromSemantics` | `bool` | `false` |

#### Scenario: Tooltip mínimo
- **GIVEN** um `GjaTooltip` com `message` "Editar pedido" em volta de um ícone
- **WHEN** o ponteiro fica sobre o ícone além do atraso de abertura
- **THEN** a dica "Editar pedido" aparece abaixo do ícone, centralizada nele e afastada `spacing.xs`
