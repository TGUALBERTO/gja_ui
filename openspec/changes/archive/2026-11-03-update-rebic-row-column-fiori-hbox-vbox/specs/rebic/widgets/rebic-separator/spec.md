# Spec Delta

## MODIFIED Requirements

### Requirement: [Comportamento] Orientação
`RebicSeparator()` SHALL ocupar toda a largura disponível, com a altura da linha fina. `RebicSeparator.vertical()` SHALL ter a largura da linha fina e a altura `density.separatorHeight`, como o `sapMTBSeparator`, sem esticar até a altura de quem o contém. Nenhum dos dois MUST ter espaço próprio em volta da linha.

#### Scenario: Separador vertical numa barra
- **GIVEN** um `RebicBar` com dois `RebicButton` separados por `RebicSeparator.vertical()`
- **WHEN** a barra é renderizada
- **THEN** o separador tem a largura da linha fina e a altura `density.separatorHeight`, menor que `density.barHeight`, e fica centrado na altura da barra

#### Scenario: Separador vertical numa linha esticada
- **GIVEN** um `RebicHBox` de 80 de altura com `alignItems` `stretch` e `RebicSeparator.vertical()` entre dois textos
- **WHEN** a linha é renderizada
- **THEN** o separador continua com a altura `density.separatorHeight`

