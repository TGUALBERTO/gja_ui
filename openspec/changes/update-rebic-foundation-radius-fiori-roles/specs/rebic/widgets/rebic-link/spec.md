## MODIFIED Requirements

### Requirement: [Aparência] Tokens de componente
A cor, o estilo e o raio do anel de foco SHALL vir do tema ativo (`colors`, `typography`, `radius.xs`), sem valores literais.

#### Scenario: Cor do link nos temas
- **WHEN** o link é renderizado nos temas claro e escuro
- **THEN** a cor do texto é o `colors.link` de cada tema
