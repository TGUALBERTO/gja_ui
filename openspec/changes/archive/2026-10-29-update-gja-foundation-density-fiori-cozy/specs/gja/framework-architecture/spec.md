## MODIFIED Requirements

### Requirement: Densidade de conteúdo
O framework SHALL suportar as densidades de conteúdo do Fiori `cozy` (alvo de toque) e `compact` (alvo de ponteiro), selecionadas pelo tema ou por subárvore, e todos os widgets interativos MUST ajustar dimensões apenas via tokens de densidade.

#### Scenario: Subárvore compacta
- **GIVEN** uma tabela envolvida por configuração de densidade `compact` em uma aplicação `cozy`
- **WHEN** a tela é renderizada
- **THEN** apenas os widgets da subárvore usam as dimensões compactas
