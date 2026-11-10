## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaIconButton` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `icon` | `IconData` | obrigatória |
| `tooltip` | `String` | obrigatória |
| `onPressed` | `VoidCallback?` | obrigatória (`null` desabilita) |
| `type` | `GjaButtonType` | `transparent` |

#### Scenario: Botão de ícone mínimo
- **WHEN** `GjaIconButton(icon: GjaIcons.edit, tooltip: 'Editar', onPressed: …)` é renderizado
- **THEN** ele é um quadrado de lado `density.controlHeight`, com as cores do normal da família `transparent` e o ícone de tamanho `icons.control` centralizado

### Requirement: [Responsividade] Direção
O botão SHALL ter tamanho fixo pela densidade. Em RTL, ícones direcionais (com espelhamento no catálogo) MUST ser espelhados.

#### Scenario: Ícone direcional em RTL
- **GIVEN** a direção do texto da direita para a esquerda
- **WHEN** um botão de ícone com `GjaIcons.navBack` é renderizado
- **THEN** o ícone é desenhado espelhado, apontando para a direita
