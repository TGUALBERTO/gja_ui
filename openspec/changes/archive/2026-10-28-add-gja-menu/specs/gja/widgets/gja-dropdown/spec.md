## MODIFIED Requirements

### Requirement: [Comportamento] Largura e texto
O dropdown SHALL usar o popover com `width` `anchor`, sem título, sem ações e sem margem. A lista fica na largura da âncora, com o mínimo do popover. Cada rótulo SHALL ficar em uma linha, com reticências, e o texto adicional MUST continuar visível.

#### Scenario: Lista na largura da âncora
- **GIVEN** uma âncora de 300 de largura numa tela larga
- **WHEN** o dropdown é aberto
- **THEN** a lista e cada item têm 300 de largura

#### Scenario: Âncora estreita
- **GIVEN** uma âncora de 40 de largura numa tela larga
- **WHEN** o dropdown é aberto
- **THEN** a lista tem 6 passos `spacing.xxxl` de largura

#### Scenario: Rótulo longo
- **GIVEN** um item com rótulo muito maior que a lista e o texto adicional "12"
- **WHEN** o dropdown é aberto
- **THEN** o rótulo fica em uma linha com reticências, "12" está visível, e não há estouro
