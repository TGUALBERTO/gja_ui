## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicLink` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String` | obrigatória |
| `onPressed` | `VoidCallback?` | obrigatória (`null` desabilita) |
| `emphasized` | `bool` | `false` |
| `subtle` | `bool` | `false` |
| `wrapping` | `bool` | `false` |

#### Scenario: Link mínimo
- **WHEN** `RebicLink(text: 'Ver pedido', onPressed: …)` é renderizado
- **THEN** o texto "Ver pedido" aparece numa linha, na cor `colors.link`, com o estilo `typography.base` e sem sublinhado

### Requirement: [Aparência] Variantes
O link SHALL usar `colors.link` e o estilo `typography.base`. Com `subtle`, a cor SHALL ser `colors.text`. Com `emphasized`, o estilo SHALL ser `typography.baseBold`. As duas indicações podem ser combinadas.

#### Scenario: Link sutil e enfatizado
- **WHEN** um link `subtle` e um `emphasized` são renderizados
- **THEN** o primeiro tem a cor `colors.text`, e o segundo tem a cor `colors.link` e o estilo `typography.baseBold`
