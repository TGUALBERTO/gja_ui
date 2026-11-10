# Spec Delta

## MODIFIED Requirements

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
