# Spec Delta

## MODIFIED Requirements

### Requirement: [API] Propriedades
`GjaAvatar` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `image` | `ImageProvider?` | `null` |
| `initials` | `String?` | `null` |
| `icon` | `IconData?` | `null` (ícone `personPlaceholder`) |
| `size` | `GjaAvatarSize` | `s` |
| `shape` | `GjaAvatarShape` | `circle` |
| `semanticLabel` | `String?` | `null` (as iniciais) |
| `onPress` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Avatar com iniciais
- **WHEN** `GjaAvatar(initials: 'mb')` é renderizado
- **THEN** ele é um círculo de lado 1,5 × `icons.xLarge`, com o fundo `colors.selectionBackground` e "MB" em `colors.brand`

#### Scenario: Avatar com imagem
- **GIVEN** uma imagem que carrega com sucesso
- **WHEN** `GjaAvatar(image: imagem, initials: 'MB')` é renderizado
- **THEN** a imagem preenche o círculo, recortada, e as iniciais não aparecem

### Requirement: [API] Callbacks e controlador
Com `onPress`, o avatar SHALL ser ativo e chamar `onPress` uma vez por ativação por toque, Enter ou Espaço, como o evento `press` do SAPUI5. Sem `onPress`, não há ação, e o avatar MUST NOT receber o foco nem reagir ao ponteiro. `GjaAvatar` SHALL NOT ter controlador.

#### Scenario: Avatar ativo
- **WHEN** um avatar com `onPress` é tocado e, com o foco nele, Enter é pressionado
- **THEN** `onPress` é chamado duas vezes

#### Scenario: Avatar inativo
- **GIVEN** um avatar sem `onPress` entre dois elementos focáveis
- **WHEN** Tab é pressionado a partir do primeiro
- **THEN** o foco vai ao segundo, sem parada no avatar
