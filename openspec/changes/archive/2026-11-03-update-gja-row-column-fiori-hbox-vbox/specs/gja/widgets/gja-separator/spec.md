# Spec Delta

## MODIFIED Requirements

### Requirement: [Comportamento] Orientação
`GjaSeparator()` SHALL ocupar toda a largura disponível, com a altura da linha fina. `GjaSeparator.vertical()` SHALL ter a largura da linha fina e a altura `density.separatorHeight`, como o `sapMTBSeparator`, sem esticar até a altura de quem o contém. Nenhum dos dois MUST ter espaço próprio em volta da linha.

#### Scenario: Separador vertical numa barra
- **GIVEN** um `GjaBar` com dois `GjaButton` separados por `GjaSeparator.vertical()`
- **WHEN** a barra é renderizada
- **THEN** o separador tem a largura da linha fina e a altura `density.separatorHeight`, menor que `density.barHeight`, e fica centrado na altura da barra

#### Scenario: Separador vertical numa linha esticada
- **GIVEN** um `GjaHBox` de 80 de altura com `alignItems` `stretch` e `GjaSeparator.vertical()` entre dois textos
- **WHEN** a linha é renderizada
- **THEN** o separador continua com a altura `density.separatorHeight`

