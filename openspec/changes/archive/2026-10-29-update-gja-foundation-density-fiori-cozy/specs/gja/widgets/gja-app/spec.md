## MODIFIED Requirements

### Requirement: [Comportamento] Densidade da aplicação
`GjaApp` SHALL aplicar `density` ao tema publicado ou, sem ela, a densidade recomendada pela plataforma de `gja/core/responsive`. A densidade MUST valer igualmente para `theme` e `darkTheme`.

#### Scenario: Densidade recomendada
- **GIVEN** a plataforma Windows e `GjaApp` sem `density`
- **WHEN** uma página lê o tema
- **THEN** a densidade é compacta; com a plataforma Android, é `cozy`

#### Scenario: Densidade informada
- **GIVEN** a plataforma Windows
- **WHEN** `GjaApp` é criado com `density` `cozy`
- **THEN** a densidade publicada é `cozy`
