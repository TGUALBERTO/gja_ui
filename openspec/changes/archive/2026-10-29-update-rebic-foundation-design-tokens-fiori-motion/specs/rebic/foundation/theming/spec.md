## MODIFIED Requirements

### Requirement: Tema centralizado
O tema SHALL ser um objeto imutável com o brilho, o modo de animação (`full` por padrão) e um conjunto de cada fundamento: `rebic/foundation/color`, `rebic/foundation/typography`, `rebic/foundation/density` (com o espaçamento de `rebic/foundation/spacing`), `rebic/foundation/radius`, `rebic/foundation/shadows`, o movimento de `rebic/foundation/design-tokens`, `rebic/foundation/iconography`, `rebic/foundation/interaction-states` e `rebic/foundation/breakpoints`.

#### Scenario: Tema completo
- **WHEN** o tema claro de referência é inspecionado
- **THEN** ele expõe brilho, modo de animação `full`, cores, tipografia, densidade, espaçamento, raios, sombras, movimento, ícones, estados de interação e breakpoints, e o espaçamento é o da densidade

### Requirement: Movimento reduzido no tema
O tema SHALL oferecer a resolução para o contexto da plataforma. O modo efetivo MUST ser o do tema ou, com animações desligadas na plataforma, `none`. O resultado MUST ter esse modo e o movimento resolvido para ele, conforme `rebic/foundation/accessibility`. Com o modo efetivo igual ao do tema e sem redução, o resultado MUST ser o próprio tema.

#### Scenario: Tema resolvido com redução
- **WHEN** o tema claro é resolvido com animações desligadas na plataforma
- **THEN** o modo é `none`, as durações de movimento valem zero, e todos os outros conjuntos são iguais

#### Scenario: Modo do tema sem pedido da plataforma
- **GIVEN** o tema claro com modo de animação `minimal`
- **WHEN** ele é resolvido sem animações desligadas na plataforma
- **THEN** o modo continua `minimal`, e as durações de movimento valem zero

#### Scenario: Tema sem redução
- **WHEN** o tema claro, com modo `full`, é resolvido sem animações desligadas na plataforma
- **THEN** o resultado é o próprio tema

### Requirement: Tema na árvore de widgets
O fundamento SHALL fornecer um escopo herdado que publica um tema para a subárvore e a leitura do tema ativo a partir de um contexto. A leitura MUST retornar o tema do escopo mais próximo e, sem escopo, o tema claro de referência, sempre resolvido para a plataforma pela regra de "Movimento reduzido no tema". Quem lê MUST ser reconstruído quando o tema do escopo muda.

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
- **THEN** todas as durações de movimento dele valem zero, e o modo de animação é `none`

#### Scenario: Animações desligadas pelo tema
- **GIVEN** um escopo com o tema claro com modo de animação `none` e o sistema com animações ligadas
- **WHEN** o tema ativo é lido
- **THEN** todas as durações de movimento dele valem zero

#### Scenario: Reconstrução na troca
- **GIVEN** um widget que leu o tema ativo
- **WHEN** o escopo passa a publicar outro tema
- **THEN** o widget é reconstruído e lê o novo tema
