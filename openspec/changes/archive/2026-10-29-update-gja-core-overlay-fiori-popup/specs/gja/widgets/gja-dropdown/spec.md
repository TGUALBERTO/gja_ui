## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaDropdown<T>` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `GjaPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `items` | `List<GjaDropdownItem<T>>` | obrigatória |
| `onSelected` | `ValueChanged<T>` | obrigatória |
| `semanticLabel` | `String` | obrigatória |
| `selected` | `T?` | `null` |
| `placement` | `GjaPlacement` | `bottom` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Dropdown com itens
- **GIVEN** os itens "Em aberto" (com ícone), "Aprovado" (com o texto adicional "12") e "Rejeitado", em LTR
- **WHEN** o dropdown é aberto
- **THEN** os itens aparecem nessa ordem, um abaixo do outro, o ícone antes do rótulo e "12" junto da borda final do item

#### Scenario: Item selecionado
- **GIVEN** `selected` igual ao valor de "Aprovado"
- **WHEN** o dropdown é aberto
- **THEN** só o item "Aprovado" está no estado selecionado
