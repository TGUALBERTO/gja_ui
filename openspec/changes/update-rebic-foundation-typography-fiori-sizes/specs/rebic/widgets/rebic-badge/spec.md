## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicBadge` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `count` | `int` | obrigatória |
| `max` | `int` | `999` |
| `state` | `RebicValueState` | `error` |
| `child` | `Widget?` | `null` |
| `semanticLabel` | `String?` | `null` (o número) |

#### Scenario: Contador avulso
- **WHEN** `RebicBadge(count: 5)` é renderizado
- **THEN** ele mostra "5" no estilo `typography.small`, com o fundo e a borda do estado `error`

#### Scenario: Contador sobre um elemento
- **GIVEN** um elemento de 40 × 40
- **WHEN** `RebicBadge(count: 3, child: elemento)` é renderizado, em LTR
- **THEN** o widget mede 40 × 40, como o elemento, e o centro do contador fica no canto superior direito do elemento

### Requirement: [Aparência] Tokens de componente
O contador SHALL ser uma pílula com raio `radius.full`, texto `typography.small`, espaço horizontal `spacing.xs`, borda fina e lado mínimo `icons.small`, sem valores literais. Um único dígito MUST formar um círculo.

#### Scenario: Forma do contador
- **WHEN** contadores com "7" e "128" são renderizados
- **THEN** o de "7" é um círculo de lado ao menos `icons.small`, e o de "128" é mais largo que alto
