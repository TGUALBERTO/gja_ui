## MODIFIED Requirements

### Requirement: Specs próprias para fundamentos e núcleo
Cada fundamento compartilhado SHALL ter spec própria em `rebic/foundation/<fundamento>`, e cada infraestrutura compartilhada do núcleo SHALL ter spec própria em `rebic/core/<infraestrutura>`. Os fundamentos obrigatórios são: design-tokens, color, typography, spacing, radius, shadows, iconography, theming, density, interaction-states, breakpoints e accessibility.

#### Scenario: Fundamento especificado antes do consumidor
- **GIVEN** um widget que consome tokens de tipografia
- **WHEN** a change do widget é proposta
- **THEN** a spec `rebic/foundation/typography` já existe em `openspec/specs/` ou está incluída em change aplicada anteriormente
