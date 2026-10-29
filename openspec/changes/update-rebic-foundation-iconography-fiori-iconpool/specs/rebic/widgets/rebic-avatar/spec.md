## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicAvatar` SHALL expor:

| Prop | Tipo | Padrão |
|---|---|---|
| `image` | `ImageProvider?` | `null` |
| `initials` | `String?` | `null` |
| `icon` | `IconData?` | `null` (ícone `personPlaceholder`) |
| `size` | `RebicAvatarSize` | `s` |
| `shape` | `RebicAvatarShape` | `circle` |
| `semanticLabel` | `String?` | `null` (as iniciais) |
| `onPressed` | `VoidCallback?` | `null` (não interativo) |

#### Scenario: Avatar com iniciais
- **WHEN** `RebicAvatar(initials: 'mb')` é renderizado
- **THEN** ele é um círculo de lado 1,5 × `icons.xLarge`, com o fundo `colors.selectionBackground` e "MB" em `colors.brand`

#### Scenario: Avatar com imagem
- **GIVEN** uma imagem que carrega com sucesso
- **WHEN** `RebicAvatar(image: imagem, initials: 'MB')` é renderizado
- **THEN** a imagem preenche o círculo, recortada, e as iniciais não aparecem

### Requirement: [Comportamento] Ordem e fallback
O avatar SHALL mostrar, nesta ordem de preferência: a imagem, as iniciais, o `icon` e, sem nenhum deles, o ícone `personPlaceholder` do catálogo. Quando a imagem falha ao carregar, MUST mostrar as iniciais ou o ícone, como se não houvesse imagem.

#### Scenario: Imagem com erro mostra as iniciais
- **GIVEN** uma imagem que falha ao carregar e as iniciais "MB"
- **WHEN** o avatar é renderizado e a falha é notificada
- **THEN** "MB" aparece, e não há exceção

#### Scenario: Avatar sem conteúdo mostra o ícone padrão
- **WHEN** `RebicAvatar()` é renderizado
- **THEN** ele mostra o ícone `personPlaceholder` em `colors.brand`
