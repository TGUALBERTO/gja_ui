## MODIFIED Requirements

### Requirement: [API] Posição e largura
`GjaPopover` SHALL expor `side` (`GjaOverlaySide`, padrão `below`), `alignment` (`GjaOverlayAlignment`, padrão `start`) e `width` (`GjaPopoverWidth`, padrão `standard`). `GjaPopoverWidth` SHALL ter `anchor` (6 passos `spacing.xxxl`, para listas na largura da âncora), `standard` (8 passos) e `wide` (12 passos), para conteúdos largos como tabelas.

#### Scenario: Popover largo
- **GIVEN** `width` `wide` e uma âncora estreita, numa tela larga
- **WHEN** o popover é aberto
- **THEN** o popover tem 12 passos `spacing.xxxl` de largura

#### Scenario: Popover na largura da âncora
- **GIVEN** `width` `anchor`, numa tela larga
- **WHEN** o popover é aberto sob uma âncora de 10 passos `spacing.xxxl` e, em outra abertura, sob uma âncora de 1 passo
- **THEN** o popover tem 10 passos na primeira vez e 6 passos na segunda
