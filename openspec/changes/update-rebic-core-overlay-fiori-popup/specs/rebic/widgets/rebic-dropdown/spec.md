## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicDropdown<T>` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `RebicPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `items` | `List<RebicDropdownItem<T>>` | obrigatória |
| `onSelected` | `ValueChanged<T>` | obrigatória |
| `semanticLabel` | `String` | obrigatória |
| `selected` | `T?` | `null` |
| `placement` | `RebicPlacement` | `bottom` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Dropdown com itens
- **GIVEN** os itens "Em aberto" (com ícone), "Aprovado" (com o texto adicional "12") e "Rejeitado", em LTR
- **WHEN** o dropdown é aberto
- **THEN** os itens aparecem nessa ordem, um abaixo do outro, o ícone antes do rótulo e "12" junto da borda final do item

#### Scenario: Item selecionado
- **GIVEN** `selected` igual ao valor de "Aprovado"
- **WHEN** o dropdown é aberto
- **THEN** só o item "Aprovado" está no estado selecionado
