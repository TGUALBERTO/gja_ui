## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicMenu` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `RebicPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `items` | `List<RebicMenuItem>` | obrigatória |
| `semanticLabel` | `String` | obrigatória |
| `placement` | `RebicPlacement` | `bottom` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Menu com itens
- **GIVEN** os itens "Editar" (ícone e atalho "Ctrl+E"), "Copiar" e "Exportar", em LTR
- **WHEN** o menu é aberto
- **THEN** os itens aparecem nessa ordem, um abaixo do outro, o ícone antes do rótulo e "Ctrl+E" junto da borda final do item

#### Scenario: Separador de seção
- **GIVEN** os itens "Editar", "Copiar" e "Excluir", este com `startsSection`
- **WHEN** o menu é aberto
- **THEN** há um único divisor, entre "Copiar" e "Excluir"
