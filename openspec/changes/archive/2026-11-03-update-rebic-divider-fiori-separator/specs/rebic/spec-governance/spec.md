# Spec Delta

## MODIFIED Requirements

### Requirement: Aspectos não aplicáveis declarados explicitamente
Quando uma seção não se aplica ao widget, a spec MUST conter um requisito com a etiqueta da seção que declare a decisão de forma verificável (por exemplo, "SHALL NOT receber foco"), com cenário próprio. Omitir silenciosamente a seção MUST NOT ser aceito.

#### Scenario: Widget sem foco
- **GIVEN** a spec de `RebicSeparator`
- **WHEN** a seção de acessibilidade é lida
- **THEN** existe um requisito `[Acessibilidade]` declarando que o separador não recebe foco e é ignorado por leitores de tela, com cenário verificável
