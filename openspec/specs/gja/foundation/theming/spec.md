# gja/foundation/theming Specification

## Purpose

Define o tema centralizado do GJA: um único objeto que reúne todos os fundamentos, os temas de referência claro e escuro, a densidade, a personalização controlada, o movimento reduzido, os tokens de componente e a interpolação entre temas.

## Requirements

### Requirement: Tema centralizado
O tema SHALL ser um objeto imutável com o brilho, o modo de animação (`full` por padrão) e um conjunto de cada fundamento: `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/density` (com o espaçamento de `gja/foundation/spacing`), `gja/foundation/radius`, `gja/foundation/shadows`, o movimento de `gja/foundation/design-tokens`, `gja/foundation/iconography`, `gja/foundation/interaction-states` e `gja/foundation/breakpoints`.

#### Scenario: Tema completo
- **WHEN** o tema claro de referência é inspecionado
- **THEN** ele expõe brilho, modo de animação `full`, cores, tipografia, densidade, espaçamento, raios, sombras, movimento, ícones, estados de interação e breakpoints, e o espaçamento é o da densidade

### Requirement: Temas de referência claro e escuro
O fundamento SHALL fornecer os temas de referência claro e escuro. Eles MUST usar os mapeamentos de cor claro e escuro, respectivamente, e MUST ter os mesmos valores em todos os outros conjuntos. Ambos MUST aceitar a densidade, sendo `cozy` o padrão.

#### Scenario: Claro e escuro diferem só na cor
- **WHEN** os temas claro e escuro de referência são comparados
- **THEN** brilho e cores diferem, e tipografia, densidade, raios, sombras, movimento, ícones, estados e breakpoints são iguais

#### Scenario: Densidade no tema
- **WHEN** o tema claro é criado com densidade `compact`
- **THEN** a densidade e o espaçamento são os compactos, e os demais conjuntos são iguais aos do tema confortável

#### Scenario: Densidade padrão
- **WHEN** o tema claro é criado sem densidade
- **THEN** a densidade é `cozy`

### Requirement: Troca de densidade
O tema SHALL oferecer a troca de densidade, que retorna um tema igual ao original exceto pela densidade e pelo espaçamento dela.

#### Scenario: Tema compacto a partir do confortável
- **WHEN** a densidade de um tema confortável é trocada para `compact`
- **THEN** o resultado é igual ao tema criado diretamente com `compact`

### Requirement: Personalização controlada
O tema SHALL permitir substituir qualquer conjunto por `copyWith`, sem alterar o código do framework. O tema MUST oferecer uma verificação de acessibilidade, conforme `gja/foundation/accessibility`, que lista os pares de contraste abaixo do mínimo, incluindo os estados das famílias de controle, e o alvo de interação abaixo de 24. Os temas de referência MUST passar sem problemas.

#### Scenario: Tema de marca válido
- **GIVEN** um tema derivado do claro com `brand` trocado por um azul-escuro da escala primitiva
- **WHEN** a verificação de acessibilidade é aplicada
- **THEN** nenhum problema é listado, e só a cor `brand` difere do tema claro

#### Scenario: Tema de marca inválido
- **GIVEN** um tema derivado do claro com `contrastText` igual a `brand`
- **WHEN** a verificação de acessibilidade é aplicada
- **THEN** o par `contrastText`/`brand` é listado com a razão encontrada e o mínimo exigido

### Requirement: Movimento reduzido no tema
O tema SHALL oferecer a resolução para o contexto da plataforma. O modo efetivo MUST ser o do tema ou, com animações desligadas na plataforma, `none`. O resultado MUST ter esse modo e o movimento resolvido para ele, conforme `gja/foundation/accessibility`. Com o modo efetivo igual ao do tema e sem redução, o resultado MUST ser o próprio tema.

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

### Requirement: Tokens de componente e extensões
O tema SHALL conter duas coleções tipadas: `components`, para os tokens de componente dos widgets do framework, e `extensions`, para os tokens da aplicação. Buscar um tipo registrado MUST retornar a instância, e um tipo ausente MUST retornar nulo, para que o widget use os tokens padrão derivados dos semânticos.

#### Scenario: Componente registrado e ausente
- **GIVEN** um tema com um conjunto de tokens de componente de teste registrado em `components`
- **WHEN** esse tipo e um tipo não registrado são buscados
- **THEN** o primeiro retorna a instância registrada, e o segundo retorna nulo

### Requirement: Interpolação entre temas
O tema MUST seguir o contrato dos conjuntos de tokens (imutável, `copyWith`, `lerp`, igualdade por valor e diagnóstico). A interpolação MUST interpolar cada conjunto pelo próprio `lerp`, incluindo as coleções, e trocar o brilho em `t = 0.5`.

#### Scenario: Troca animada de claro para escuro
- **WHEN** o tema claro é interpolado até o escuro em `t = 0`, `0.5` e `1`
- **THEN** os extremos são iguais aos temas de origem e destino, e em `0.5` a cor `base` é a interpolação das duas e o brilho é escuro

#### Scenario: Contrato verificado
- **GIVEN** os temas claro e escuro de referência
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e temas com os mesmos valores são iguais

### Requirement: Testes e documentação do tema
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível. A galeria SHALL ter uma página "Tema" com controles de brilho, densidade e marca de exemplo, que montam uma prévia usando só o tema escolhido.

#### Scenario: Página na galeria
- **WHEN** a página "Tema" é aberta e o brilho é trocado para escuro
- **THEN** a prévia passa a usar a cor `base` do tema escuro, sem recriar a página com parâmetros visuais diferentes

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
