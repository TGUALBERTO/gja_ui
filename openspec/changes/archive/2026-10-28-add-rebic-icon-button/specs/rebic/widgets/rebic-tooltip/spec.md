## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicTooltip` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `message` | `String` | obrigatória |
| `child` | `Widget` | obrigatória |
| `side` | `RebicOverlaySide` | `below` |
| `excludeFromSemantics` | `bool` | `false` |

#### Scenario: Tooltip mínimo
- **GIVEN** um `RebicTooltip` com `message` "Editar pedido" em volta de um ícone
- **WHEN** o ponteiro fica sobre o ícone além do atraso de abertura
- **THEN** a dica "Editar pedido" aparece abaixo do ícone, centralizada nele e afastada `spacing.xs`

### Requirement: [Acessibilidade] Semântica e contraste
A mensagem SHALL ser exposta como a dica (`tooltip`) do nó do filho, exceto com `excludeFromSemantics`, quando o filho já anuncia a mensagem como rótulo. A sobreposição MUST NOT acrescentar outro nó com a mensagem. O texto da dica MUST manter o contraste sobre `colors.base`, conforme `rebic/foundation/accessibility`.

#### Scenario: Mensagem na semântica do filho
- **GIVEN** a dica aberta em volta de um botão com rótulo "Editar"
- **WHEN** a árvore de semântica é lida
- **THEN** o nó do botão tem a dica "Editar pedido", e nenhum outro nó tem esse texto

#### Scenario: Contraste da dica
- **WHEN** a diretriz de contraste de texto é aplicada à dica aberta, nos temas claro e escuro
- **THEN** a diretriz é atendida

#### Scenario: Dica fora da semântica
- **GIVEN** a dica com `excludeFromSemantics` em volta de um botão cujo rótulo é a própria mensagem
- **WHEN** a árvore de semântica é lida
- **THEN** o nó do botão não tem dica, e a mensagem aparece uma única vez, como rótulo
