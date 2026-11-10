# Spec Delta

## Purpose

Define o tema centralizado do GJA: um único objeto que reúne todos os fundamentos, os temas de referência claro e escuro, a densidade, a personalização controlada, o movimento reduzido, os tokens de componente e a interpolação entre temas.

## ADDED Requirements

### Requirement: Tema centralizado
O fundamento SHALL fornecer um objeto de tema imutável que reúna o brilho e um conjunto de cada fundamento: `gja/foundation/color`, `gja/foundation/typography`, `gja/foundation/density` (com o espaçamento de `gja/foundation/spacing`), `gja/foundation/radius`, `gja/foundation/elevation`, o movimento de `gja/foundation/design-tokens`, `gja/foundation/iconography`, `gja/foundation/interaction-states` e `gja/foundation/breakpoints`.

#### Scenario: Tema completo
- **WHEN** o tema claro de referência é inspecionado
- **THEN** ele expõe brilho, cores, tipografia, densidade, espaçamento, raios, elevação, movimento, ícones, estados de interação e breakpoints, e o espaçamento é o da densidade

### Requirement: Temas de referência claro e escuro
O fundamento SHALL fornecer os temas de referência claro e escuro. Eles MUST usar os mapeamentos de cor claro e escuro, respectivamente, e MUST ter os mesmos valores em todos os outros conjuntos. Ambos MUST aceitar a densidade, sendo `comfortable` o padrão.

#### Scenario: Claro e escuro diferem só na cor
- **WHEN** os temas claro e escuro de referência são comparados
- **THEN** brilho e cores diferem, e tipografia, densidade, raios, elevação, movimento, ícones, estados e breakpoints são iguais

#### Scenario: Densidade no tema
- **WHEN** o tema claro é criado com densidade `compact`
- **THEN** a densidade e o espaçamento são os compactos, e os demais conjuntos são iguais aos do tema confortável

### Requirement: Troca de densidade
O tema SHALL oferecer a troca de densidade, que retorna um tema igual ao original exceto pela densidade e pelo espaçamento dela.

#### Scenario: Tema compacto a partir do confortável
- **WHEN** a densidade de um tema confortável é trocada para `compact`
- **THEN** o resultado é igual ao tema criado diretamente com `compact`

### Requirement: Personalização controlada
O tema SHALL permitir substituir qualquer conjunto por `copyWith`, sem alterar o código do framework. O tema MUST oferecer uma verificação de acessibilidade, conforme `gja/foundation/accessibility`, que lista os pares de contraste abaixo do mínimo e o alvo de interação abaixo de 24. Os temas de referência MUST passar sem problemas.

#### Scenario: Tema de marca válido
- **GIVEN** um tema derivado do claro com `primary` trocado por um azul-escuro da escala primitiva
- **WHEN** a verificação de acessibilidade é aplicada
- **THEN** nenhum problema é listado, e só a cor `primary` difere do tema claro

#### Scenario: Tema de marca inválido
- **GIVEN** um tema derivado do claro com `onPrimary` igual a `primary`
- **WHEN** a verificação de acessibilidade é aplicada
- **THEN** o par `onPrimary`/`primary` é listado com a razão encontrada e o mínimo exigido

### Requirement: Movimento reduzido no tema
O tema SHALL oferecer a resolução para o contexto da plataforma: com redução de animações, o resultado MUST ter todas as durações de movimento zeradas. Sem ela, o resultado MUST ser o próprio tema.

#### Scenario: Tema resolvido com redução
- **WHEN** o tema claro é resolvido com redução de animações
- **THEN** as durações de movimento valem zero, e todos os outros conjuntos são iguais

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
- **THEN** os extremos são iguais aos temas de origem e destino, e em `0.5` a cor `surface` é a interpolação das duas e o brilho é escuro

#### Scenario: Contrato verificado
- **GIVEN** os temas claro e escuro de referência
- **WHEN** o contrato dos conjuntos de tokens é verificado entre eles
- **THEN** `copyWith()` é igual ao original, `lerp` em 0 e em 1 retorna a origem e o destino, e temas com os mesmos valores são iguais

### Requirement: Testes e documentação do tema
Cada cenário desta spec MUST ter um teste automatizado com o nome `<requisito> — <cenário>`. Toda API pública do fundamento MUST ter dartdoc com a linha de nível. A galeria SHALL ter uma página "Tema" com controles de brilho, densidade e marca de exemplo, que montam uma prévia usando só o tema escolhido.

#### Scenario: Página na galeria
- **WHEN** a página "Tema" é aberta e o brilho é trocado para escuro
- **THEN** a prévia passa a usar a cor `surface` do tema escuro, sem recriar a página com parâmetros visuais diferentes
