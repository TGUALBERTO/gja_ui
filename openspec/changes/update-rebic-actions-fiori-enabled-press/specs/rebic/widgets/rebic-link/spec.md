# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicLink` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `text` | `String` | obrigatória |
| `enabled` | `bool` | `true` |
| `onPress` | `VoidCallback?` | `null` |
| `emphasized` | `bool` | `false` |
| `subtle` | `bool` | `false` |
| `wrapping` | `bool` | `false` |

#### Scenario: Link mínimo
- **WHEN** `RebicLink(text: 'Ver pedido', onPress: …)` é renderizado
- **THEN** o texto "Ver pedido" aparece numa linha, na cor `colors.link`, com o estilo `typography.base` e sem sublinhado

### Requirement: [API] Callbacks e controlador
O link SHALL chamar `onPress` uma vez por ativação por toque, Enter ou Espaço, como o evento `press` do `sap.m.Link`. Com `enabled` `false`, MUST ficar desabilitado: sem ativação, fora da ordem de foco e com a opacidade de desabilitado. Com `onPress` nulo e `enabled` `true`, SHALL continuar habilitado, sem ação. `RebicLink` SHALL NOT ter controlador.

#### Scenario: Acionar o link
- **WHEN** o link é tocado e, com o foco nele, Enter é pressionado
- **THEN** `onPress` é chamado duas vezes

#### Scenario: Link desabilitado
- **GIVEN** um link com `enabled` `false` e um `onPress`
- **WHEN** ele é tocado
- **THEN** `onPress` não é chamado, e o texto tem a opacidade `interaction.disabledOpacity`
