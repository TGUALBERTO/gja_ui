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
| `onPress` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Status mínimo
- **WHEN** `RebicStatusIndicator(text: 'Aprovado', state: RebicValueState.success)` é renderizado
- **THEN** "Aprovado" aparece na cor de frente do estado `success`, no estilo `typography.base`, sem fundo

#### Scenario: Status com título e ícone
- **GIVEN** `title` "Situação", `icon` e `text` "Aprovado", em LTR
- **WHEN** o status é renderizado
- **THEN** aparecem, do início ao fim, "Situação:" no `RebicLabel` com `showColon`, o ícone e "Aprovado"

### Requirement: [API] Callbacks e controlador
Com `onPress`, o status SHALL ser ativo e chamar `onPress` uma vez por ativação por toque, Enter ou Espaço, como o evento `press` do SAPUI5. Sem `onPress`, não há ação, e o status MUST NOT receber o foco nem reagir ao ponteiro. `RebicStatusIndicator` SHALL NOT ter controlador.

#### Scenario: Status ativo
- **WHEN** um status com `onPress` é tocado e, com o foco nele, Enter é pressionado
- **THEN** `onPress` é chamado duas vezes

#### Scenario: Status inativo
- **GIVEN** um status sem `onPress` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no status
