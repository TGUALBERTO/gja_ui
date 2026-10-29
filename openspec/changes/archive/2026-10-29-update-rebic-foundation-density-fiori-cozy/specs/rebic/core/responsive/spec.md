## MODIFIED Requirements

### Requirement: Densidade recomendada
O núcleo SHALL recomendar a densidade inicial pela plataforma: compacta em Windows, macOS e Linux (entrada por ponteiro), e cozy em Android, iOS e Fuchsia (entrada por toque). A recomendação MUST ser só um padrão: a aplicação escolhe a densidade que usa.

#### Scenario: Plataformas
- **WHEN** a densidade recomendada é pedida para cada plataforma
- **THEN** Windows, macOS e Linux recebem `compact`, e Android, iOS e Fuchsia recebem `cozy`
