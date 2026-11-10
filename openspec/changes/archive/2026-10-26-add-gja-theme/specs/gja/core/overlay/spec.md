## MODIFIED Requirements

### Requirement: Modal com camada de bloqueio
O núcleo SHALL abrir um conteúdo modal acima da tela, sobre uma camada de bloqueio que cobre toda a tela com a cor recebida ou, sem ela, com o `blockLayer` do tema ativo de `gja/foundation/theming`. Enquanto o modal está aberto, o conteúdo abaixo MUST NOT receber toques nem ser exposto à árvore de semântica. O modal MUST devolver a quem o abriu o resultado informado ao fechar, ou nulo quando é dispensado.

#### Scenario: Interação bloqueada
- **GIVEN** um modal aberto sobre uma tela com um botão
- **WHEN** o ponto do botão é tocado
- **THEN** a ação do botão não é chamada, e o botão não aparece na árvore de semântica

#### Scenario: Resultado ao fechar
- **WHEN** o modal é fechado com o resultado "ok" e, em outra abertura, é dispensado
- **THEN** quem o abriu recebe "ok" na primeira vez e nulo na segunda

## ADDED Requirements

### Requirement: Valores do tema ativo nas sobreposições
Sem valores recebidos, a camada do modal MUST usar o `blockLayer` do tema ativo, e a sobreposição ancorada MUST usar o espaçamento `xs` como afastamento e `s` como margem. Um valor recebido MUST ter precedência sobre o do tema.

#### Scenario: Camada no tema escuro
- **GIVEN** o tema escuro ativo
- **WHEN** um modal é aberto sem cor de camada
- **THEN** a camada tem o `blockLayer` do tema escuro

#### Scenario: Espaçamentos da densidade compacta
- **GIVEN** um tema ativo compacto
- **WHEN** uma sobreposição ancorada abaixo da âncora é aberta sem afastamento
- **THEN** o topo do conteúdo fica abaixo da base da âncora à distância `xs` do espaçamento compacto
