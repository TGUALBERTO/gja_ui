## MODIFIED Requirements

### Requirement: [API] Propriedades
`RebicPopover` SHALL expor, além de `side`, `alignment` e `width` (ver `[API] Posição e largura`):

| Prop | Tipo | Padrão |
|---|---|---|
| `controller` | `RebicPopoverController` | obrigatória |
| `child` (âncora) | `Widget` | obrigatória |
| `content` | `Widget` | obrigatória |
| `title` | `String?` | `null` |
| `actions` | `List<Widget>` | `[]` |
| `padded` | `bool` | `true` |
| `semanticLabel` | `String?` | `null` |
| `onDismiss` | `VoidCallback?` | `null` |

#### Scenario: Popover com cabeçalho e rodapé
- **GIVEN** `title` "Filtros", um conteúdo e as ações "Aplicar" e "Cancelar"
- **WHEN** o popover é aberto
- **THEN** de cima para baixo há o título, um divisor, o conteúdo, um divisor e o rodapé, com as ações juntas da borda final

#### Scenario: Popover só com conteúdo
- **WHEN** o popover é aberto só com `content` e `semanticLabel`
- **THEN** não há cabeçalho, rodapé nem divisores, e o conteúdo começa a `spacing.l` do topo do popover

## ADDED Requirements

### Requirement: [Comportamento] Posição, largura e rolagem
O popover SHALL abrir no lado e no alinhamento pedidos, com a inversão, o afastamento e o limite de tela de `rebic/core/overlay`. A largura SHALL ser a maior entre a de `width` e a da âncora, limitada pela área da sobreposição, e MUST NOT seguir o conteúdo. A altura MUST caber na área: só o conteúdo rola, e cabeçalho e rodapé ficam visíveis.

#### Scenario: Popover abaixo da âncora
- **GIVEN** uma âncora no alto da tela, `side` `below` e `alignment` `start`, em LTR
- **WHEN** o popover é aberto
- **THEN** o topo do popover fica a `spacing.xs` abaixo da base da âncora, e as bordas iniciais coincidem

#### Scenario: Largura padrão
- **WHEN** um popover com o conteúdo "Ok" e outro com um parágrafo longo são abertos numa tela larga, com âncoras estreitas
- **THEN** os dois têm a largura `standard`, e o parágrafo quebra em linhas

#### Scenario: Âncora mais larga que o popover
- **GIVEN** uma âncora mais larga que a largura `standard`, numa tela larga
- **WHEN** o popover é aberto abaixo dela
- **THEN** o popover tem a largura da âncora

#### Scenario: Conteúdo rolável
- **GIVEN** uma tela de 400 de altura e um popover com título, ações e um conteúdo de 30 linhas
- **WHEN** o popover é aberto e o conteúdo é rolado até o fim
- **THEN** não há estouro, o título e as ações continuam visíveis, e a última linha fica visível

### Requirement: [API] Posição e largura
`RebicPopover` SHALL expor `side` (`RebicOverlaySide`, padrão `below`), `alignment` (`RebicOverlayAlignment`, padrão `start`) e `width` (`RebicPopoverWidth`, padrão `standard`). `RebicPopoverWidth` SHALL ter `standard` (8 passos `spacing.xxxl`) e `wide` (12 passos), para conteúdos largos como tabelas.

#### Scenario: Popover largo
- **GIVEN** `width` `wide` e uma âncora estreita, numa tela larga
- **WHEN** o popover é aberto
- **THEN** o popover tem 12 passos `spacing.xxxl` de largura

## REMOVED Requirements

### Requirement: [Comportamento] Posição, tamanho e rolagem
**Reason**: A largura deixa de seguir o conteúdo entre um mínimo e um máximo; o cenário "Largura entre o mínimo e o máximo" não vale mais.
**Migration**: Substituído por `[Comportamento] Posição, largura e rolagem`, com a largura `width` ou a da âncora.
