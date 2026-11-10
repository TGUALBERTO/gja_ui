## ADDED Requirements

### Requirement: Tema na árvore de widgets
O fundamento SHALL fornecer um escopo herdado que publica um tema para a subárvore e a leitura do tema ativo a partir de um contexto. A leitura MUST retornar o tema do escopo mais próximo e, sem escopo, o tema claro de referência. Quando o sistema pede animações desligadas, a leitura MUST retornar o tema resolvido com movimento reduzido. Quem lê MUST ser reconstruído quando o tema do escopo muda.

#### Scenario: Tema mais próximo
- **GIVEN** um escopo com o tema escuro dentro de um escopo com o tema claro
- **WHEN** um widget dentro dos dois lê o tema ativo
- **THEN** recebe o tema escuro

#### Scenario: Árvore sem tema
- **WHEN** um widget sem escopo acima lê o tema ativo
- **THEN** recebe um tema igual ao claro de referência

#### Scenario: Animações desligadas pelo sistema
- **GIVEN** um escopo com o tema claro e o sistema com animações desligadas
- **WHEN** o tema ativo é lido
- **THEN** todas as durações de movimento dele valem zero

#### Scenario: Reconstrução na troca
- **GIVEN** um widget que leu o tema ativo
- **WHEN** o escopo passa a publicar outro tema
- **THEN** o widget é reconstruído e lê o novo tema
